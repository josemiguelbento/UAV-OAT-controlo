function [y,t,w] = mkfswp(amp,tdelay,wmin,wmax,dt,tmax,type)
%
%  function [y,t,w] = mkfswp(amp,tdelay,wmin,wmax,dt,tmax,type)
%
%  Usage: [y,t,w] = mkfswp(amp,tdelay,wmin,wmax,dt,tmax,type);
%
%  Description:
%
%    Creates a frequency sweep with amplitude amp 
%    covering the frequency range between wmin and wmax inclusive.
%
%  Input:
%    
%    amp    = input amplitude.
%    tdelay = time delay before the frequency sweep starts, sec.
%    wmin   = minimum frequency, rad/sec.
%    wmax   = maximum frequency, rad/sec.
%    dt     = sampling time, sec.
%    tmax   = time length for the frequency sweep, sec.
%    type   = frequency sweep type
%             = 0 for logarithmic frequency sweep (default if omitted).
%             = 1 for linear frequency sweep.
%
%  Output:
%
%    y = vector frequency sweep with amplitude amp covering 
%        the frequency range from wmin to wmax inclusive.  
%    t = time vector, sec.
%    w = vector of frequency as a function of time.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     12 Sept 1997 - Created and debugged, EAM.
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
t=[0:dt:tmax]';
npts=length(t);
y=zeros(npts,1);
if wmin <= 0
  wmin=0.01;
end
if nargin < 7
  type=0;
end
%
%  Index for the first point after the time delay.  Create a new
%  time vector tl that starts immediately following the time delay.  
%
n0=floor(tdelay/dt)+1;
tl=t(n0:npts);
tl=tl-tl(1);
m=length(tl);
%
%  Change w as a function of time.  
%
if type==0,
  w=logspace(log10(wmin),log10(wmax),m)';
else
%  w=linspace(wmin,wmax/2,m)';
  w=linspace(wmin,wmax,m)';
end
%
%  Generate frequency sweep.
%
y(n0:npts)=amp*sin(w.*tl);
%
%  Make sure the input ends at zero.
%
if y(npts) < 0,
  i=max(find(y >=0));
else
  i=max(find(y < 0));
end
y(i+1:npts)=zeros(npts-i,1);
return
