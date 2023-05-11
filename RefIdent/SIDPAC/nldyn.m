function [y,x,accel] = nldyn(p,u,t,x0,c)
%
%  function [y,x,accel] = nldyn(p,u,t,x0,c)
%
%  Usage: [y,x,accel] = nldyn(p,u,t,x0,c);
%
%  Description:
%
%    Computes the output vector time history 
%    using full nonlinear aircraft dynamics 
%    for output error parameter estimation.  
%    The numerical integration is 2nd order Runge-Kutta.
%
%  Input:
%
%      p = vector of parameter values.
%      u = input vector time history.
%      t = time vector.
%     x0 = initial state vector.
%      c = cell structure:
%          c{1} = p0oe  = vector of initial parameter values.
%          c{2} = ipoe  = index vector to select estimated parameters.
%          c{3} = ims   = index vector to select measured states.
%          c{4} = imo   = index vector to select model outputs.
%          c{5} = x0    = initial state vector.
%          c{6} = u0    = initial control vector.
%          c{7} = fdata = array of measured flight test data, 
%                         geometry, and mass/inertia properties.  
%
%  Output:
%
%      y = model output vector time history = [vt,beta,alfa,p,q,r,phi,the,psi].
%      x = model state vector time history = [vt,beta,alfa,p,q,r,phi,the,psi].
%  accel = vector of acceleration outputs = [ax,ay,az,pdot,qdot,rdot].
%

%
%    Calls:
%      nldyn_eqs.m
%      runk2a.m
%      adamb3a.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 Sept 2001 - Created and debugged, EAM.
%      14 Oct  2001 - Modified to use numerical integration routines, EAM.
%      23 July 2002 - Incorporated numerical integration and output calculation, EAM.  
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
%  Compute the state vector time history using 
%  second order Runge-Kutta numerical integration.
%  The runk2a.m code is a duplication of runk2.m, 
%  except that the acceleration outputs are saved 
%  at each time step.  
%
ims=c{3};
imo=c{4};
fdata=c{7};
npts=length(t);
dt=t(2)-t(1);
n=length(x0);
%[x,accel] = runk2a('nldyn_eqs',p,[u,fdata],t,x0,c);
[x,accel] = adamb3a('nldyn_eqs',p,[u,fdata],t,x0,c);
%
%  Compute output vector time histories 
%  according to imo, and substitute measured 
%  state time histories as indicated by ims.  
%
%  State vector indices in fdata.
%
xindx=[2:10]';
%
%  Substitute measured values for states 
%  as indicated by ims.
%
msindx=find(ims==1);
nms=length(msindx);
if nms > 0
%
%  Convert all states to radians.
%
  x(:,msindx)=fdata(:,xindx(msindx))*pi/180;
%
%  Except airspeed.
%
  if any(msindx==1)
    x(:,1)=x(:,1)*180/pi;
  end
end
%
%
%  Output equations.
%
y=zeros(npts,n+6);
%
%  Airspeed.
%
y(:,1)=x(:,1);
%
%  Sideslip angle.
%
y(:,2)=x(:,2);
%
%  Angle of attack.
%
y(:,3)=x(:,3);
%
%  Angular rates.  
%
y(:,[4:6])=x(:,[4:6]);
%
%  Euler angles.
%
y(:,[7:9])=x(:,[7:9]);
%
%  Translational accelerations.
%
g=32.174;
y(:,[10:12])=accel(:,[1:3])/g;
%
%  Angular accelerations.
%
y(:,[13:15])=accel(:,[4:6]);
%
%  Include only the selected model outputs. 
%
y=y(:,find(imo==1));
return
