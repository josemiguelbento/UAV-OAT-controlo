function [cost,y,p] = simplex(dsname,pi,u,t,x0,c,del,z,rr,fid,p0,crb0)
%
%  function [cost,y,p] = simplex(dsname,pi,u,t,x0,c,del,z,rr,fid,p0,crb0)
%
%  Usage: [cost,y,p] = simplex(dsname,pi,u,t,x0,c,del,z,rr,fid,p0,crb0);
%
%  Description:
%
%    Minimizes a cost function using the simplex method.  
%    This routine is designed for maximum likelihood estimation.  
%    The dynamic system is specified in the m-file named dsname.  
%    Inputs p0 and crb0 are optional.  
%
%  Input:
%
%    dsname = name of the m-file that computes the system outputs.
%        pi = initial vector of parameter values.
%         u = control vector time history.
%         t = time vector.
%        x0 = state vector initial condition.
%         c = vector of constants passed to dsname.
%       del = vector of parameter perturbations in percent of nominal value.
%         z = measured output vector time history.
%        rr = discrete measurement noise covariance matrix estimate. 
%       fid = integer file identifier for printed output.
%        p0 = vector of a priori parameter values (optional).
%      crb0 = a priori parameter covariance matrix (optional).
%
%  Output:
%
%    cost = cost function.
%       y = model output vector time history.
%       p = vector of parameter values.
%

%
%    Calls:
%      compcost.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      14 Jan 1997 - Created and debugged, EAM.
%      28 Oct 2001 - Added p0 and crb0, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
[npts,no]=size(z);
np=length(pi);
if nargin < 12 | isempty(crb0)
  crb0=zeros(np,np);
end
if nargin < 11 | isempty(p0)
  p0=zeros(np,1);
end
rc=1.0;
rxc=2.0;
cc=0.5;
tol=1.0e-08;
maxiter=50;
iter=0;
converg=0;
cpt=zeros(np+1,1);
pt=zeros(np,np+1);
%
%  Find cost at the center and vertices of the simplex.
%
pt(:,1)=pi;
[cpt(1),y]=compcost(dsname,pi,u,t,x0,c,z,rr,p0,crb0);
del=abs(del);
for j=1:np,
  pt(:,j+1)=pi;
  if abs(pi(j))~=0.0
    dp=del(j)*pi(j);
  else
    dp=del(j);
  end
  pt(j,j+1)=pi(j) + dp;
  [cpt(j+1),y]=compcost(dsname,pt(:,j+1),u,t,x0,c,z,rr,p0,crb0);
end
[maxcost,ihi]=max(cpt);
[mincost,ilo]=min(cpt);
fprintf(fid,'\n\n LOWEST COST AT ITERATION %4.0f = %13.6e \n',iter,mincost);
fprintf(1,'\n\n LOWEST COST AT ITERATION %4.0f = %13.6e \n',iter,mincost);
%
%  Move the simplex until the maximum number of iterations
%  is reached or to convergence.
%
while (iter<maxiter)&(converg~=1),
%
%  Find the center of the face of the simplex opposite the highest cost.
%
  pavg=(sum(pt')'-pt(:,ihi))/np;
%
%  Reflect the high point through the face opposite the highest cost.
%
  ptr=pavg - rc*(pt(:,ihi)-pavg);
  [cptr,y]=compcost(dsname,ptr,u,t,x0,c,z,rr,p0,crb0);
%
%  If the reflection gives the lowest cost yet, try an extension.
%
  if cptr < cpt(ilo)
    ptrx=pavg + rxc*(ptr-pavg);
    [cptrx,y]=compcost(dsname,ptrx,u,t,x0,c,z,rr,p0,crb0);
%
%  Replace the high cost point with the best reflected point.
%
    if cptrx < cptr
      pt(:,ihi)=ptrx;
      cpt(ihi)=cptrx;
    else
      pt(:,ihi)=ptr;
      cpt(ihi)=cptr;
    end
  else
%
%  Reflected point lower than the highest point?
%
    if cptr < cpt(ihi)
%
%  If so, replace the highest point with the reflected point.
%
      pt(:,ihi)=ptr;
      cpt(ihi)=cptr;
    else
%
%  Otherwise shrink the simplex along the line from the
%  highest point to the opposing face.
%
      ptrx=pavg + cc*(pt(:,ihi)-pavg);
      [cptrx,y]=compcost(dsname,ptrx,u,t,x0,c,z,rr,p0,crb0);
%
%  If the contraction gives an improvement, accept it.
%
      if cptrx < cpt(ihi)
        pt(:,ihi)=ptrx;
        cpt(ihi)=cptrx;
      else
%
%  Can't get rid of the high point, 
%  so contract the simplex about the low point.
%
        for j=1:np+1,
          if j~=ilo
            pt(:,j)=pt(:,ilo) + cc*(pt(:,j)-pt(:,ilo))
            [cpt(j),y]=compcost(dsname,pt(:,j),u,t,x0,c,z,rr,p0,crb0);
          end
        end
      end
    end
  end
  iter=iter + 1;
%
%  Find new minimum and maximum cost points.
%
  [maxcost,ihi]=max(cpt);
  [mincost,ilo]=min(cpt);
  if mod(iter,10)==0
    fprintf(fid,'\n LOWEST COST AT ITERATION %4.0f = %13.6e \n',iter,mincost);
    fprintf(1,'\n LOWEST COST AT ITERATION %4.0f = %13.6e \n',iter,mincost);
  end
%
%  Compute fractional range from highest to lowest cost
%  and set the convergence flag if satisfactory.  
%
  rtol=2*abs(cpt(ihi)-cpt(ilo))/(abs(cpt(ihi))+abs(cpt(ilo)));
  if rtol < tol
    converg=1;
  end
end
p=pt(:,ilo);
[cost,y]=compcost(dsname,p,u,t,x0,c,z,rr,p0,crb0);
return
