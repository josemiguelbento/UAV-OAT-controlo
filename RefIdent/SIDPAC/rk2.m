function x = rk2(deqname,u,t,x0,c)
%
%  function x = rk2(deqname,u,t,x0,c)
%
%  Usage: x = rk2(deqname,u,t,x0,c);
%
%  Description:
%
%    Integrates the differential equations specified in the 
%    m-file named deqname, using second order Runge-Kutta integration
%    with input interpolation.  
%
%  Input:
%    
%    deqname = name of the m-file that computes the state derivatives.
%          u = control vector time history.
%          t = time vector, sec.
%         x0 = state vector initial condition.
%          c = vector of constants.
%
%  Output:
%
%          x = state vector time history.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      25 Jan 1995 - Created and debugged, EAM.
%
%
%  Copyright (C) 2000  Eugene A. Morelli
%
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
npts=length(t);
dt=t(2)-t(1);
n=length(x0);
x=zeros(npts,n);
x(1,:)=x0';
xint=x0;
xd1=zeros(n,1);
xd2=zeros(n,1);
for i=1:npts-1,
  xi=x(i,:)';
  uint=u(i,:)';
  xd1=eval([deqname,'(uint,xi,c)']);
  xint=xi + dt*xd1/2;
  uint=(u(i,:)' + u(i+1,:)')/2;
  xd2=eval([deqname,'(uint,xint,c)']);
  x(i+1,:)=(xi + dt*xd2)';
end
return
