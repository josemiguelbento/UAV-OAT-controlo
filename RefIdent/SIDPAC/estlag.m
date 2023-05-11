function [tau,ul] = estlag(u,y,t,trm,ldbg)
%
%  function [tau,ul] = estlag(u,y,t,trm,ldbg)
%
%  Usage: [tau,ul] = estlag(u,y,t,trm,ldbg);
%
%  Description:
%
%    Estimates the pure time delay of output time history vector y
%    with respect to input time history vector u, using 
%    linear backward extrapolation in time to the trim amplitude
%    from the point of maximum slope after the initial sharp edge input.
%    Trim mean values and standard deviations are computed based 
%    on an initial trm seconds of steady trim.  
%
%  Input:
%    
%      u = input time history vector.  
%      y = output time history vector.
%      t = time vector, sec.
%    trm = steady trim time at the start of the input time history, sec.
%   ldbg = 1 to display debugging output
%          0 to skip debugging output
%
%  Output:
%
%    tau = time lag, sec.
%     ul = input time history vector delayed by the estimated lag.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      25 Sept 1997 - Created and debugged, EAM.
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
if nargin < 5
  ldbg=0;
end
dt=t(2)-t(1);
npts=length(t);
mult=3.0;
%
%  Compute input trim parameters.
%
ntrm=round(trm/dt)+1;
ubar=mean(u(1:ntrm));
usig=std(u(1:ntrm));
%
%  Find the index where the input time history departs
%  from the mean trim value.  This is defined as
%  the index just preceding the first penetration of 
%  mult standard deviations from the mean, where the mean
%  and standard deviations were calculated from the initial trim.
%
uindx=0;
for i=ntrm:npts,
  if uindx == 0
    if abs(u(i)-ubar) > mult*usig
      uindx=i-1;
    end
  end
end
%
%  Input breakout time.
%
ut=t(uindx);
%
%  Linear backward extrapolation to the value of the output  
%  at the input breakout time is used to obtain
%  the time of departure for the output.  
%  The backward linear extrapolation is made from 
%  the point of maximum locally smoothed slope
%  after the input breakout time.  
%
%  Compute the smoothed slope for the output time history.
%  Smooth the entire time history to avoid endpoint effects.
%
yd=deriv(y,dt);
%
%  Find the end of the initial input pulse by finding the last
%  index with the same sign as that of the initial input deflection.
%
findx=uindx+round(0.1/dt);
if yd(findx)>=0.0
  ydsign=1.0;
else
  ydsign=-1.0;
end
while sign(yd(findx))==ydsign
  findx=findx+1;
end
findx=findx-1;
%
%  Find the maximum absolute slope and the corresponding index.
%
[yd_max,imax]=max(abs(yd(uindx:findx)));
%
%  Correct for the index offset in using max 
%  over the index range uindx:findx.  
%
imax=uindx+imax-1;
%
%  Linear extrapolation to the output value at the beginning of the input.  
%
yinit=y(uindx);
yt=t(imax)-abs(y(imax)-yinit)/yd_max;
%
%  Plot the data for the backward linear extrapolation.
%
tp=[yt,t(imax)]';
yp=[y(uindx),y(imax)]';
iplt=round(0.25/dt);
il=uindx-iplt;
ih=imax+iplt;
plot(t(il:ih),[u(il:ih),y(il:ih)],tp,yp);
grid on;
hold on;
plot(t(imax),y(imax),'+')
plot(t(uindx),u(uindx),'+')
plot(yt,y(uindx),'+')
hold off
%
%  Pure time delay calculation.
%
tau=yt-ut;
%
%  Lagged input calculation.
%
ul=ulag(u,t,tau);
%
%  Debug output.
%
if ldbg==1
  fprintf('\n Input breakout at index %4.0f',uindx)
  fprintf('\n Input breakout time = %7.3f',ut)
  fprintf('\n End of first output slope at index %4.0f',findx)
  fprintf('\n Max output derivative = %6.2f at index %4.0f',yd_max,imax)
  fprintf('\n Output breakout time = %7.3f \n\n',yt)
end
return


