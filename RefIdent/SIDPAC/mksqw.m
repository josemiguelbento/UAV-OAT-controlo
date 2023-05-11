function [y,t] = mksqw(amp,tpulse,npulse,tdelay,dt,tmax)
%
%  function [y,t] = mksqw(amp,tpulse,npulse,tdelay,dt,tmax)
%
%  Usage: [y,t] = mksqw(amp,tpulse,npulse,tdelay,dt,tmax);
%
%  Description:
%
%    Creates an alternating square wave input vector of length
%    tmax, with single pulse time tpulse, pulse amplitudes amp, and 
%    individual integer pulse widths given by the elements of npulse.  
%
%  Input:
%
%       amp = input amplitudes for each pulse.
%    tpulse = time for a single pulse, sec.
%    npulse = vector of integer pulse widths, e.g., npulse = [3 2 1 1].  
%    tdelay = time delay before the square wave input starts, sec.
%        dt = sampling time, sec.
%      tmax = time length for the input, sec.
%
%  Output:
%
%       y = alternating square wave input vector.  
%       t = time vector, sec.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History: 
%      01 May 1997 - Created and debugged, EAM.
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
t=[0:dt:tmax]';
npts=length(t);
y=zeros(npts,1);
%
%  Make sure npulse input is in the correct form.
%
indx=find(npulse~=0);
npulse=abs(npulse(indx));
npulse=round(npulse);
np=length(npulse);
%
%  Set pulse amplitudes.
%
if length(amp)~=np
  amp=amp(1)*ones(1,np);
end
%
%  Compute delay offset.
%
n0=round(tdelay/dt) + 1;
%
%  Variable s carries the sign.
%
s=1;
%
%  Generate the square wave. 
%
for j=1:np,
  n1=n0 + round(npulse(j)*tpulse/dt);
  y(n0+1:n1)=s*amp(j)*ones(n1-n0,1);
  n0=n1;
  s=-s;
end
%
%  Correct the length if sum(npulse)*tpulse > tmax.
%
y=y(1:npts);
return
