function [crb,crbo] = colores(dsname,p,u,t,x0,c,z,del)
%
%  function [crb,crbo] = colores(dsname,p,u,t,x0,c,z,del)
%
%  Usage: [crb,crbo] = colores(dsname,p,u,t,x0,c,z,del);
%
%  Description:
%
%    Computes the Cramer-Rao bounds for maximum likelihood
%    estimation both conventionally and accounting for 
%    the actual frequency content of the residuals.  
%    The dynamic system is specified in the m-file named dsname.  
%    Input del is optional.  
%
%  Input:
%    
%    dsname = name of the m-file that computes the system outputs.
%         p = vector of parameter values.
%         u = control vector time history.
%         t = time vector.
%        x0 = state vector initial condition.
%         c = vector of constants passed to dsname.
%         z = measured output vector time history.
%       del = vector of parameter perturbations in fraction of nominal value.
%
%  Output:
%
%    crb  = corrected Cramer-Rao bounds accounting for colored residuals.
%    crbo = conventional Cramer-Rao bounds.
%

%
%    Calls:
%      estrr.m
%      senest.m
%      misvd.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Oct 1997 - Created and debugged, EAM.
%
%  Copyright (C) 2000  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
[npts,no]=size(z);
np=length(p);
if nargin < 8
  del=0.01*ones(np,1);
end
y=eval([dsname,'(p,u,t,x0,c)']);
rr=estrr(y,z);
vv=inv(rr);
ifd=1;
dydp=senest(dsname,p,u,t,x0,c,del,no,ifd);
senmat=zeros(no,np*npts);
sen=zeros(no,np);
infomat=zeros(np,np);
v=z-y;
%
%  Compute an unbiased estimate of the residual autocorrelation.
%  Keep only positive lags, since the autocorrelation is an even function.  
%
rvv=xcorr(v,'unbiased');
rvv=rvv([npts:2*npts-1],:);
rvvmat=zeros(no,no*npts);
%
%  Arrange the data as a sequence of matrices and compute the 
%  conventional Cramer-Rao bounds.
%
for i=1:npts,
  ip=np*(i-1);
  for j=1:np,
    jo=no*(j-1);
    senmat(:,ip+j)=dydp(i,[jo+1:jo+no])';
  end
  sen=senmat(:,[ip+1:ip+np]);
  senmat(:,[ip+1:ip+np])=vv*senmat(:,[ip+1:ip+np]);
  infomat=infomat + sen'*vv*sen;
  io=no*(i-1);
  for j=1:no
    jo=no*(j-1);
    rvvmat(j,[io+1:io+no])=rvv(i,[jo+1:jo+no]);
%
%  Keep only diagonal elements, to be consistent with
%  the uncorrelated noise processes assumption.
%
%    rvvmat(j,io+j)=rvv(i,jo+j);
  end
end
crbo=misvd(infomat);
%
%  Corrected Cramer-Rao bound calculation outer loop.
%
crbsum=zeros(np,np);
for i=1:npts,
  ip=np*(i-1);
%
%  Inner loop sum.
%
  sumat=zeros(no,np);
  for j=1:npts,
    ijo=no*abs((i-j));
    jp=np*(j-1);
    sumat=sumat + rvvmat(:,[ijo+1:ijo+no])*senmat(:,[jp+1:jp+np]);
  end
  crbsum=crbsum + senmat(:,[ip+1:ip+np])'*sumat;
end
crb=crbo'*crbsum*crbo;
return
