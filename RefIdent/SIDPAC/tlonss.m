function [y,x,A,B,C,D] = tlonss(p,u,t,x0,c)
%
%  function [y,x,A,B,C,D] = tlonss(p,u,t,x0,c)
%
%  Usage: [y,x,A,B,C,D] = tlonss(p,u,t,x0,c);
%
%  Description:
%
%    Matlab m-file for longitudinal state space
%    dynamic model in the time domain. 
%
%  Input:
%
%    p = parameter vector.
%    u = input vector or matrix.
%    t = time vector, sec.
%   x0 = initial state vector.
%    c = vector of constants.
%
%  Output:
%
%         y = model output vector or matrix time history.
%         x = model state vector or matrix time history.
%   A,B,C,D = system matrices.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      11 May 1995 - Created and debugged, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%

%
%  Longitudinal short period approximation.
%
A=[p(1),p(2);...
   p(5),p(6)];
B=[p(3),p(4);...
   p(7),p(8)];
[ns,ni]=size(B);
C=eye(2,2);
[no,ns]=size(C);
D=zeros(no,ni);
%
%  Add vertical accelerometer output.
%
vtg=c(1)/32.174;
C=[C;[p(1),p(2)-1]*vtg];
D=[D;[p(3)*vtg,p(9)]];
[y,x]=lsim(A,B,C,D,u,t,x0);
return
