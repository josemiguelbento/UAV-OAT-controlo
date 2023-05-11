function [y,A,f,phi,dydt] = mkrandss(n,t,magmin,magmax,fmin,fmax)
%
%  function [y,A,f,phi,dydt] = mkrandss(n,t,magmin,magmax,fmin,fmax)
%
%  Usage: [y,A,f,phi,dydt] = mkrandss(n,t,magmin,magmax,fmin,fmax);
%
%  Description:
%
%    Generates a random signal by summing n sine components 
%    with magnitudes selected randomly from [magmin,magmax], 
%    and frequency selected randomly from [fmin,fmax].  
%    Duration of the generated random signal is tmax.  
%
%  Input:
%    
%        n = number of random sine components.  
%        t = time vector, sec.
%   magmin = lower limit for random magnitudes.
%   magmax = upper limit for random magnitudes.
%     fmin = lower limit for random frequencies.
%     fmax = upper limit for random frequencies.  
%
%
%  Output:
%
%     y = random signal.  
%     A = vector of random amplitudes.
%     f = vector of random frequencies.
%   phi = vector of random phase angles.
%  dydt = analytic time derivative of y.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 May 1999 - Created and debugged, EAM.
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
t=t(:,1);
npts=length(t);
y=zeros(npts,1);
dydt=zeros(npts,1);
rand('seed',sum(100*clock));
f=rand(n,1)*(fmax-fmin)+fmin;
A=rand(n,1)*(magmax-magmin)+magmin;
phi=rand(n,1)*2*pi-pi;
for j=1:n,
  y=y+A(j)*sin(2*pi*f(j)*t+phi(j));
  dydt=dydt+A(j)*2*pi*f(j)*cos(2*pi*f(j)*t+phi(j));
end
return
