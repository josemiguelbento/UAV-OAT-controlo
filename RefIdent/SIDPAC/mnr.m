function [infomat,djdp,cost] = mnr(dsname,p,u,t,x0,c,del,y,z,rr)
%
%  function [infomat,djdp,cost] = mnr(dsname,p,u,t,x0,c,del,y,z,rr)
%
%  Usage: [infomat,djdp,cost] = mnr(dsname,p,u,t,x0,c,del,y,z,rr);
%
%  Description:
%
%    Computes the information matrix and the gradient of  
%    the cost with respect to the parameter vector for 
%    Modified Newton-Raphson (mnr) optimization.  
%    The dynamic system is specified in the m-file
%    named dsname.  
%
%  Input:
%    
%    dsname = name of the m-file that computes the system outputs.
%         p = vector of parameter values.
%         u = control vector time history.
%         t = time vector.
%        x0 = state vector initial condition.
%         c = vector of constants passed to dsname.
%       del = vector of parameter perturbations in percent of nominal value.
%         y = model output vector time history.
%         z = measured output vector time history.
%        rr = discrete measurement noise covariance matrix estimate. 
%
%  Output:
%
%    infomat = information matrix.
%       djdp = cost gradient with respect to the parameter vector.
%       cost = cost function value.
%

%
%    Calls:
%      senest.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      20 Jan 1997 - Created and debugged, EAM.
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
np=length(p);
vv=inv(rr);
ifd=1;
dydp=senest(dsname,p,u,t,x0,c,del,no,ifd);
infomat=zeros(np,np);
djdp=zeros(np,1);
cost=0.0;
v=z-y;
sen=zeros(no,np);
for i=1:npts,
  for j=1:np,
    jo=no*(j-1);
    sen(:,j)=dydp(i,[jo+1:jo+no]).';
  end
  infomat=infomat + sen'*vv*sen;
  djdp=djdp + sen'*vv*v(i,:).';
  cost=cost + conj(v(i,:))*vv*v(i,:).';
end
infomat=real(infomat);
djdp=real(djdp);
cost=0.5*real(cost);
return
