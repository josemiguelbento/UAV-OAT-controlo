function [y,x] = lssim(A,B,C,D,u,t,x0,c)
%
%  function [y,x] = lssim(A,B,C,D,u,t,x0,c)
%
%  Usage: [y,x] = lssim(A,B,C,D,u,t,x0,c);
%
%  Description:
%
%    Integrates the differential equations:
%
%      dx/dt = A*x + B*u
%
%    and computes the outputs y from:
%
%      y=C*x + D*u
%
%    using 2nd order Runge-Kutta.  
%
%  Input:
%    
%    A,B,C,D = system matrices.
%          u = control vector time history.
%          t = time vector, sec.
%         x0 = state vector initial condition.
%          c = vector of inertia constants.
%
%  Output:
%
%    y = output vector time history.
%    x = state vector time history.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 June 1999 - Created and debugged, EAM.
%      27 July 1999 - Corrected error in output vector
%                     calculation, EAM.  
%      16 July 2002 - Vectorized two commands and corrected
%                     an error in the output vector calculation, EAM.
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
npts=length(t);
dt=1/round(2/(t(3)-t(1)));
n=length(x0);
x=zeros(npts,n);
x(1,:)=x0';
uint=(u([1:npts-1],:)+u([2:npts],:))/2;
for i=2:npts,
  xi=x(i-1,:)';
  ui=u(i-1,:)';
  xd1=A*xi + B*ui;
  xint=xi+dt*xd1/2;
  xd2=A*xint + B*uint(i-1,:)';
  x(i,:)=(xi + dt*xd2)';
end
y=(C*x' + D*u')';
return
