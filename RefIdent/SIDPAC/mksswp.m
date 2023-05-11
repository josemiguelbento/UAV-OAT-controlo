function [y,t,pf,f] = mksswp(amp,fmin,fmax,dt,T)
%
%  function [y,t,pf,f] = mksswp(amp,fmin,fmax,dt,T)
%
%  Usage: [y,t,pf,f] = mksswp(amp,fmin,fmax,dt,T);
%
%  Description:
%
%    Generates a Schroeder chirp signal of time 
%    length T with sample rate dt, by combining 
%    equally-spaced frequencies between fmin and fmax 
%    in Hz, using a flat power spectrum.  The number 
%    of harmonic components is maximized, and depends 
%    on the maneuver time T, and the selected 
%    frequency band [fmin,fmax].  The signal 
%    has low relative peak factor for a 
%    given spectrum.  Outputs are the Schroeder 
%    chirp signal y, corresponding time vector t, 
%    the frequencies for the harmonic components f,
%    and the relative peak factor:
%
%        pf = (max(y)-min(y))/(2*sqrt(2)*rms(y))
%
%  Reference:
%
%    Schroeder, M.R., "Synthesis of Low-Peak-Factor
%    Signals and Binary Sequences with Low Autocorrelation", 
%    IEEE Transactions on Information Theory, January 1970, pp. 85-89.  
%
%
%  Input:
%
%     amp = input amplitude.
%    fmin = minimum frequency, Hz.
%    fmax = maximum frequency, Hz.
%      dt = sampling interval, sec.
%       T = maneuver time, sec.
%
%
%  Output:
%
%       y = Schroeder chirp signal. 
%       t = time vector, sec.
%      pf = relative peak factor.
%       f = frequencies of harmonic components, Hz.
%

%
%    Calls:
%      rms.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     25 May 2000 - Created and debugged, EAM.
%     22 Aug 2000 - Changed notation to match Schroeder paper, EAM.
%                   Added checks on fmax and fmin, EAM.
%                   Added phase adjustment so signal starts at zero, EAM.
%     26 Oct 2000 - Modified calculation of phase adjustments for zero 
%                   start so that optimization is not required, EAM.
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
t=[0:dt:T]';
npts=length(t);
y=zeros(npts,1);
%
%  Find appropriate harmonics and phase angles.
%
if fmax<=fmin
  fprintf('\nIllegal frequency bounds\n\n');
  return
end
fmin=max(fmin,1/T);
fmax=min(fmax,1/(2*dt));
f=[fmin:1/T:fmax];
w=2*pi*f;
N=length(w);
%
%  Flat power spectrum.
%
p=1/N;
%
%  Phase angles.
%
ph=zeros(1,N);
for n=2:N,
  ph(n)=ph(1)-pi*n*n/N;
%  ph(n)=pi*n*n/(2*N);
end
%
%  Find phase offset for a zero initial condition.
%  Variable dph is the resolution for the phase shift.  
%
phoff=zeros(1,N);
dph=0.001*ones(1,N);
%
%  Find the sign of the initial point without phase shift.
%
yisgn=sign(sum(cos(ph)));
%
%  Increment phase shift until a sign change occurs.
%
while sign(sum(cos(ph+phoff)))==yisgn
  phoff=phoff+dph;
end
%
%phcost=inline('sum(cos(phoff+ph))');
%phoff=fzero(phcost,0,optimset('disp','off'),ph);
%
%  Adjust component phases for zero initial condition.
%
ph=ph+phoff;
%
%  Compute the composite Schroeder signal.  
%
for k=1:N,
  y=y+cos(w(k)*t+ph(k));
end
%
%  Normalize the result.  The same normalization
%  applies to all components because of the 
%  flat power spectrum.  Scale the result using 
%  the input amp.  
%
y=amp*sqrt(1/(2*N))*y;
%
%  Compute the peak factor.
%
pf=(max(y)-min(y))/(2*sqrt(2)*rms(y));
return






