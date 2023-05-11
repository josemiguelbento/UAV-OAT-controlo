function [vt,beta,alfa,u,v,w] = airchk(fdata)
%
%  function [vt,beta,alfa,u,v,w] = airchk(fdata)
%
%  Usage: [vt,beta,alfa,u,v,w] = airchk(fdata);
%
%  Description:
%
%    Integrates body-axis translational kinematic equations
%    to obtain air data time histories.  This routine 
%    is used to assess the compatibility of the data from
%    sensors for rigid body translational motion.  
%
%  Input:
%    
%    fdata = flight test data array in standard configuration.
%
%  Output:
%
%      vt = airspeed time history, ft/sec.
%    beta = sideslip time history, deg.
%    alfa = angle of attack time history, deg.
%       u = x body-axis velocity component, ft/sec.
%       v = y body-axis velocity component, ft/sec.
%       w = z body-axis velocity component, ft/sec.
%

%
%    Calls:
%      rk4.m
%      aireom.m
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
[npts,n]=size(fdata);
t=fdata(:,1);
t=t-t(1)*ones(npts,1);
dt=t(2)-t(1);
dtr=pi/180;
g=32.174;
uf=[fdata(:,[11:13])*g,fdata(:,[5:10])*dtr];
beta0=fdata(1,3)*pi/180;
alfa0=fdata(1,4)*pi/180;
x0=fdata(1,2)*[cos(alfa0)*cos(beta0),sin(beta0),sin(alfa0)*cos(beta0)]';
c=0.0;
x=rk4('aireom',uf,t,x0,c);
u=x(:,1);
v=x(:,2);
w=x(:,3);
vt=sqrt(u.^2 + v.^2 + w.^2);
beta=asin(v./vt);
alfa=atan(w./u);
return
