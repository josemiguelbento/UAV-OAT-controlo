function xd = aireom(u,x,c)
%
%  function xd = aireom(u,x,c)
%
%  Usage: xd = aireom(u,x,c);
%
%  Description:
%
%    Computes the body-axis velocity component
%    time derivatives using body-axis translational 
%    accelerations, body-axis angular rates, 
%    and Euler angles. 
%
%  Input:
%
%    x  = state vector, [u,v,w]', ft/sec.
%    u  = input vector, [ax,ay,az,p,q,r,phi,the,psi]'.
%    c  = vector of constants (dummy).
%
%  Output:
%
%    xd = velocity component time derivative vector, [ud,vd,wd]', ft/sec.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 June 2001 - Created and debugged, EAM.
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
g=32.174;
%  u equation.
ud=u(6)*x(2) - u(5)*x(3) - g*sin(u(8)) + u(1);
%  v equation.
vd=-u(6)*x(1) + u(4)*x(3) + g*cos(u(8))*sin(u(7)) + u(2);
%  w equation.
wd=u(5)*x(1) - u(4)*x(2) + g*cos(u(8))*cos(u(7)) + u(3);
xd=[ud,vd,wd]';
return
