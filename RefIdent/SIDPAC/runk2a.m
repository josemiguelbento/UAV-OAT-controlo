function [x,accel] = runk2a(deqname,p,u,t,x0,c)
%
%  function [x,accel] = runk2a(deqname,p,u,t,x0,c)
%
%  Usage: [x,accel] = runk2a(deqname,p,u,t,x0,c);
%
%  Description:
%
%    Integrates the differential equations specified in the 
%    m-file named deqname, using second order Runge-Kutta integration
%    with input interpolation.  This routine is the same as 
%    runk2.m, except that this routine also outputs 
%    linear and rotational accelerations in accel.  The m-file named
%    deqname must also produce the accel outputs.
%
%  Input:
%    
%    deqname = name of the m-file that computes the state derivatives.
%          p = parameter vector.
%          u = control vector time history.
%          t = time vector, sec.
%         x0 = state vector initial condition.
%          c = vector of constants.
%
%  Output:
%
%          x = state vector time history.
%      accel = acceleration time history = [ax,ay,az,pdot,qdot,rdot].
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      23 July 2002 - Created and debugged, EAM.
%
%
%  Copyright (C) 2002  Eugene A. Morelli
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
accel=zeros(npts,6);
x(1,:)=x0';
xint=x0;
xd1=zeros(n,1);
xd2=zeros(n,1);
a=zeros(6,1);
for i=1:npts-1,
  xi=x(i,:)';
  uint=u(i,:)';
  [xd1,a]=eval([deqname,'(p,uint,xi,c)']);
  accel(i,:)=a';
  xint=xi + dt*xd1/2;
  uint=(u(i,:)' + u(i+1,:)')/2;
  xd2=eval([deqname,'(p,uint,xint,c)']);
  x(i+1,:)=(xi + dt*xd2)';
end
[xd2,a]=eval([deqname,'(p,u(npts,:)'',x(npts,:)'',c)']);
accel(npts,:)=a';
return
