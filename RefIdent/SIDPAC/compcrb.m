function [crb,infomat] = compcrb(dsname,p,u,t,x0,c,rr,del)
%
%  function [crb,infomat] = compcrb(dsname,p,u,t,x0,c,rr,del)
%
%  Usage: [crb,infomat] = compcrb(dsname,p,u,t,x0,c,rr,del);
%
%  Description:
%
%    Computes Cramer-Rao lower bounds and the information matrix.  
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
%        rr = discrete measurement noise covariance matrix estimate. 
%       del = vector of parameter perturbations in fraction of nominal value.
%
%  Output:
%
%    crb     = Cramer-Rao lower bound matrix.
%    infomat = information matrix.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 July 1996 - Created and debugged, EAM.
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
npts=length(t);
[no,m]=size(rr);
np=length(p);
if nargin < 8
  del=0.01*ones(np,1);
end
vv=inv(rr);
ifd=1;
dydp=senest(dsname,p,u,t,x0,c,del,no,ifd);
infomat=zeros(np,np);
sen=zeros(no,np);
for i=1:npts,
  for j=1:np,
    jo=no*(j-1);
    sen(:,j)=dydp(i,[jo+1:jo+no])';
  end
  infomat=infomat + sen'*vv*sen;
end
crb=inv(infomat);
return
