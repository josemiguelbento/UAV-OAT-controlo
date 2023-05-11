function y = dcmp_out(p,u,x,c)
%
%  function y = dcmp_out(p,u,x,c)
%
%  Usage: y = dcmp_out(p,u,x,c);
%
%  Description:
%
%    Computes the output vector time history 
%    for data compatibility analysis.  
%
%  Input:
%    
%      p = vector of parameter values.
%      u = input vector time history = [ax,ay,az,p,q,r,u,v,w,phi,the,psi].
%      x = state vector time history = [u,v,w,phi,the,psi].
%      c = cell structure:
%          c{1} = p0c = vector of initial parameter values.
%          c{2} = ipc = index vector to select estimated parameters.
%          c{3} = ims = index vector to select measured states.
%          c{4} = imo = index vector to select model outputs.
%
%  Output:
%
%    y = model output vector time history = [vt,beta,alpha,phi,the,psi].
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Oct 2000 - Created and debugged, EAM.
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
[npts,n]=size(x);
y=zeros(npts,n);
p0c=c{1};
ipc=c{2};
ims=c{3};
imo=c{4};
%
%  Assign the estimated parameter vector 
%  elements in p to the proper data compatibility 
%  parameter vector elements in pc.  
%
pc=p0c;
pcindx=find(ipc==1);
np=length(pcindx);
if np > 0
  pc(pcindx)=p;
end
%
%  Substitute measured values for states 
%  as indicated by ims.
%
msindx=find(ims==1);
nms=length(msindx);
if nms > 0
  x(:,msindx)=u(:,6+msindx);
end
%
%
%  Output equations.
%
%  Longitudinal outputs.
%
%  Airspeed.
%
vt0=sqrt(x(1,1)*x(1,1) + x(1,2)*x(1,2) + x(1,3)*x(1,3));
y(:,1)=(1+pc(7))*(sqrt(x(:,1).^2 + x(:,2).^2 + x(:,3).^2) - vt0*ones(npts,1)) ...
                + vt0*ones(npts,1);
%
%  Angle of attack.
%
alf0=atan2(x(1,3),x(1,1));
y(:,3)=(1.0+pc(9))*(atan2(x(:,3),x(:,1)) - alf0*ones(npts,1)) ...
                  + alf0*ones(npts,1);
%y(:,3)=(1.0+pc(9))*atan2(x(:,3),x(:,1));
%
%  Euler pitch angle.
%
the0=x(1,5);
y(:,5)=(1.0+pc(11))*(x(:,5)-the0*ones(npts,1)) + the0*ones(npts,1);
%y(:,5)=(1.0+pc(11))*x(:,5);
%
%
%  Lateral / Directional outputs.
%
%  Sideslip angle.
%
beta0=asin(x(1,2)/sqrt(x(1,1)^2 + x(1,2)^2+ x(1,3)^2));
y(:,2)=(1.0+pc(8))*(asin(x(:,2)./...
                  sqrt(x(:,1).^2 + x(:,2).^2 + x(:,3).^2)) ...
                  - beta0*ones(npts,1)) + beta0*ones(npts,1);
%y(:,2)=(1.0+pc(8))*(asin(x(:,2)./...
%                    sqrt(x(:,1).^2 + x(:,2).^2 + x(:,3).^2));
%
%  Euler roll angle.
%
phi0=x(1,4);
y(:,4)=(1.0+pc(10))*(x(:,4)-phi0*ones(npts,1)) + phi0*ones(npts,1);
%y(:,4)=(1.0+pc(10))*x(:,4);
%
%  Euler yaw angle.
%
psi0=x(1,6);
y(:,6)=(1.0+pc(12))*(x(:,6)-psi0*ones(npts,1)) + psi0*ones(npts,1);
%  y(:,6)=(1.0+pc(12))*x(:,6);
%
%  Include only the selected model outputs. 
%
y=y(:,find(imo==1));
return
