function [axc,ayc,azc,xcg,ycg,zcg,aa,av] = accel_cor(fdata,auto,xloc,yloc,zloc)
%
%  function [axc,ayc,azc,xcg,ycg,zcg,aa,av] = accel_cor(fdata,auto,xloc,yloc,zloc)
%
%  Usage: [axc,ayc,azc,xcg,ycg,zcg,aa,av] = accel_cor(fdata,auto,xloc,yloc,zloc);
%
%  Description:
%
%    Corrects acceleration measurements from  
%    accelerometers located at [xloc,yloc,zloc] to the
%    aircraft center of gravity located at [xcg,ycg,zcg].  
%    If the accelerometer position coordinate inputs
%    are omitted, position coordinates for the F-18 HARV on 
%    flight 153 and later are used.  Smoothed numerical 
%    differentiation of the angular rates are used to 
%    minimize additional measurement noise on the 
%    corrected acceleration measurements.  
%
%  Input:
%    
%    fdata = flight test data array in standard configuration.
%     auto = flag indicating type of operation:
%            = 1 for automatic  (no user input required) (default).
%            = 0 for manual  (user input required).
%     xloc = vector of X positions of the X, Y, and Z accelerometers, in.
%     yloc = vector of Y positions of the X, Y, and Z accelerometers, in.
%     zloc = vector of Z positions of the X, Y, and Z accelerometers, in.
%
%  Output:
%
%    axc = X acceleration measurement, corrected to the C.G., g.
%    ayc = Y acceleration measurement, corrected to the C.G., g.
%    azc = Z acceleration measurement, corrected to the C.G., g.
%    xcg = X C.G. position, in.
%    ycg = Y C.G. position, in.
%    zcg = Z C.G. position, in.
%     aa = matrix of smoothed angular accelerations 
%          = [pdot,qdot,rdot], rad/sec^2.
%     av = matrix of smoothed angular velocities 
%          = [p,q,r], rad/sec.
%

%
%    Calls:
%      deriv.m
%      smoo.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 Jan 2001 - Created and debugged, EAM.
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
[npts,n]=size(fdata);
xcg=mean(fdata(:,45));
ycg=mean(fdata(:,46));
zcg=mean(fdata(:,47));
t=fdata(:,1);
t=t-t(1)*ones(npts,1);
dt=t(2)-t(1);
axc=zeros(npts,1);
ayc=zeros(npts,1);
azc=zeros(npts,1);
g=32.174;
%
%  Use default accelerometer positions for the 
%  F-18 HARV on flight 153 and later.  
%
if nargin < 5
  zloc=[83.3;81.8;82.4];
end
if nargin < 4
  yloc=[-1.4;0.9;-3.1];
end
if nargin < 3
  xloc=[376.9;377.2;375.1];
end
%
%  Do the smoothing in automatic mode by default.
%
if nargin < 2
  auto=1;
  lplot=0;
else
  auto=0;
  lplot=1;
end
%
%  Negative signs for the x and z displacements because
%  fuselage station and waterline positive directions
%  are opposite the x and z vehicle body axes.  
%
axx=-(xloc(1)-xcg)/12.;axy=(yloc(1)-ycg)/12.;axz=-(zloc(1)-zcg)/12.;
ayx=-(xloc(2)-xcg)/12.;ayy=(yloc(2)-ycg)/12.;ayz=-(zloc(2)-zcg)/12.;
azx=-(xloc(3)-xcg)/12.;azy=(yloc(3)-ycg)/12.;azz=-(zloc(3)-zcg)/12.;
avr=[fdata(:,5),fdata(:,6),fdata(:,7)]*pi/180.;
%
%  Numerically differentiate the angular rate data.
%
aar=deriv(avr,dt);
%
%  Use Fourier smoothing to remove endpoint 
%  discontinuities and noise from the numerical
%  differentiation.  Use 2 Hz for the endpoint smoothing.
%  The sequence is to numerically differentiate 
%  first, then smooth the result.  
%
fprintf('\n\n\nFor the angular acceleration smoothing: \n')
[aa,fcoa,rra,ba,fa,wfa]=smoo(aar,t,2.0,lplot,auto);
%
%  Smooth the angular velocities also.
%
fprintf('\n\n\nFor the angular velocity smoothing: \n')
[av,fcov,rrv,bv,fv,wfv]=smoo(avr,t,2.0,lplot,auto);
%
%  Implement the position correction for the
%  accelerometer measurements. 
%
axc=g*fdata(:,53)+(av(:,2).^2+av(:,3).^2)*axx ...
   -(av(:,1).*av(:,2)-aa(:,3))*axy ...
   -(av(:,1).*av(:,3)+aa(:,2))*axz;
axc=axc/g;
ayc=g*fdata(:,54)+(av(:,1).^2+av(:,3).^2)*ayy ...
   -(av(:,1).*av(:,2)+aa(:,3))*ayx ...
   -(av(:,2).*av(:,3)-aa(:,1))*ayz;
ayc=ayc/g;
azc=g*fdata(:,55)+(av(:,2).^2+av(:,1).^2)*azz ...
   -(av(:,1).*av(:,3)-aa(:,2))*azx ...
   -(av(:,2).*av(:,3)+aa(:,1))*azy;
azc=azc/g;
return
