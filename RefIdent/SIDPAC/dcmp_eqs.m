function xd = dcmp_eqs(p,u,x,c)
%
%  function xd = dcmp_eqs(p,u,x,c)
%
%  Usage: xd = dcmp_eqs(p,u,x,c);
%
%  Description:
%
%    Computes the state vector derivatives 
%    for data compatibility analysis.  
%
%  Input:
%    
%      p = vector of parameter values.
%      u = input vector = [ax,ay,az,p,q,r]'.
%      x = state vector = [u,v,w,phi,the,psi]'.
%      c = cell structure:
%          c{1} = p0c = vector of initial parameter values.
%          c{2} = ipc = index vector to select estimated parameters.
%          c{3} = ims = index vector to select measured states.
%          c{4} = imo = index vector to select model outputs.
%
%  Output:
%
%     xd = time derivative of the state vector.
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
xd=zeros(length(x),1);
g=32.174;
p0c=c{1};
ipc=c{2};
ims=c{3};
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
  x(msindx)=u(6+msindx);
end
%
%  Kinematic equations for data compatibility analysis.
%
%  u equation.
xd(1)=(u(6)+pc(6))*x(2) - (u(5)+pc(5))*x(3) - g*sin(x(5)) + u(1) + pc(1);
%  v equation.
xd(2)=-(u(6)+pc(6))*x(1) + (u(4)+pc(4))*x(3) + g*cos(x(5))*sin(x(4)) + u(2) + pc(2);
%  w equation.
xd(3)=(u(5)+pc(5))*x(1) - (u(4)+pc(4))*x(2) + g*cos(x(5))*cos(x(4)) + u(3) + pc(3);
%  psi equation.
xd(6)=(sin(x(4))*(u(5)+pc(5)) + cos(x(4))*(u(6)+pc(6)))/cos(x(5));
%  phi equation.
xd(4)=(u(4)+pc(4)) + sin(x(5))*xd(6);
%  the equation.
xd(5)=cos(x(4))*(u(5)+pc(5)) - sin(x(4))*(u(6)+pc(6));
return
