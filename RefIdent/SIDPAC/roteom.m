function xd = roteom(u,x,c)
%
%  function xd = roteom(u,x,c)
%
%  Usage: xd = roteom(u,x,c);
%
%  Description:
%
%    Computes the Euler angle time derivatives 
%    using body-axis angular rates. 
%
%  Input:
%    
%    x  = Euler angle vector, [phi,the,psi]', rad.
%    u  = body-axis angular rate vector [p,q,r]', rad/sec.
%    c  = vector of constants (dummy).
%
%  Output:
%
%    xd = Euler angle time derivative vector, [phid,thed,psid]', rad/sec.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Nov 1996 - Created and debugged, EAM.
%      22 May 2001 - Repaired call line inconsistency, EAM.
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
thed=u(2)*cos(x(1)) - u(3)*sin(x(1));
psid=u(2)*sin(x(1))/cos(x(2)) + u(3)*cos(x(1))/cos(x(2));
phid=u(1) + psid*sin(x(2));
xd=[phid,thed,psid]';
return
