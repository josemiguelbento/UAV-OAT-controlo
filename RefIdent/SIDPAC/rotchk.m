function [phi,the,psi] = rotchk(fdata)
%
%  function [phi,the,psi] = rotchk(fdata)
%
%  Usage: [phi,the,psi] = rotchk(fdata);
%
%  Description:
%
%    Integrates body-axis rotational kinematic equations
%    to obtain Euler angle time histories.  This routine 
%    is used to assess the compatibility of the data from
%    sensors for rigid body rotational motion.  
%
%  Input:
%    
%    fdata = flight test data array in standard configuration.
%
%  Output:
%
%    phi = Euler roll angle time history, deg.
%    the = Euler pitch angle time history, deg.
%    psi = Euler yaw angle time history, deg.
%

%
%    Calls:
%      rk4.m
%      roteom.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Nov 1996 - Created and debugged, EAM.
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
[npts,n]=size(fdata);
t=fdata(:,1);
t=t-t(1)*ones(npts,1);
dt=t(2)-t(1);
dtr=pi/180;
u=fdata(:,[5:7])*dtr;
x0=fdata(1,[8:10])'*dtr;
c=0.0;
x=rk4('roteom',u,t,x0,c);
phi=x(:,1)/dtr;
the=x(:,2)/dtr;
psi=x(:,3)/dtr;
return
