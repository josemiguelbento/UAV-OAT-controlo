function [y,t,ons] = mkrdn(amp,tdelay,tfinal,dt,tmax,n,bw,pwrf)
%
%  function [y,t,ons] = mkrdn(amp,tdelay,tfinal,dt,tmax,n,bw,pwrf)
%
%  Usage: [y,t,ons] = mkrdn(amp,tdelay,tfinal,dt,tmax,n,bw,pwrf);
%
%  Description:
%
%    Creates n random noise input vectors of length
%    tmax, with root mean square amplitude amp.  If optional 
%    inputs bw and pwrf are specified, the noise is colored with 
%    a band-limited component in the frequency interval [0,bw] Hz 
%    and the fraction of the total noise power (band-limited plus wide-band) 
%    that is band-limited equals pwrf.  Inputs n, bw, and pwrf 
%    are optional.  Defaults for n, bw, and pwrf give a 
%    single vector of white noise.  
%
%  Input:
%    
%       amp = input amplitude.
%    tdelay = time delay before the random noise input starts, sec.
%    tfinal = quiet time at the end of the random noise input, sec.
%        dt = sampling time, sec.
%      tmax = time length for the input, sec.
%         n = number of random noise vectors to be generated (default=1).
%        bw = bandwidth of the band-limited noise component, Hz (default=1/(2*dt)).
%      pwrf = fraction of total noise power that is band-limited, [0,1] (default=0).
%
%  Output:
%
%       y = matrix of n random noise input column vectors.  
%       t = time vector.
%     ons = matrix of n original noise sequence column vectors.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     06 Apr 1996 - Created and debugged, EAM.
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
%
%  Check for values of n, bw, and pwrf.
%
if nargin < 8
  pwrf=0;
end
pwrf=cvec(pwrf);
if nargin < 7
  bw=1/(2*dt);
end
bw=cvec(bw);
if nargin < 6 | n<=0
  n=1;
else
  n=round(n);
end
if length(pwrf) < n
  pwrf=pwrf(1)*ones(n,1);
end
if length(bw) < n
  bw=bw(1)*ones(n,1);
end
%
%  If only one value is given for amp, tdelay, or tfinal, 
%  make amp and tdelay the same for all n.
%
amp=cvec(amp);
if length(amp) < n
  amp=amp(1)*ones(n,1);
end
tdelay=cvec(tdelay);
if length(tdelay) < n
  tdelay=tdelay(1)*ones(n,1);
end
tfinal=cvec(tfinal);
if length(tfinal) < n
  tfinal=tfinal(1)*ones(n,1);
end
y=zeros(npts,n);
%
%  Random noise input.
%
randn('seed',sum(100*clock));
%
%  Get white gaussian random noise for raw material for the 
%  band limiting process which will produce the band limited noise.
%
nse=randn(npts,n);
ons=nse;
nmid=floor(npts/2);
if mod(npts,2)==0
  nmid=nmid-1;
end
blnse=zeros(2*nmid+npts,n);
%
%  Use ford order Chebyshev low pass filter with bandwidth bw.
%  Extended length of blnse is necessary for the technique
%  used to avoid endpoint problems.
%
ford=5;
blnse(nmid+1:nmid+npts,:)=nse;
%
%  Reflect nmid points on each end about a zero ordinate.
%  This is done to avoid endpoint problems with the low pass filter.
%
li=(nmid+1)*ones(n,1);
for j=1:n,
  blnse(1:nmid,j)=-blnse(2*nmid+1:-1:nmid+2,j);
  blnse(nmid+npts+1:nmid+npts+nmid,j)=-blnse(nmid+npts-1:-1:npts,j);
  [b,a]=cheby1(ford,0.5,bw(j)*2.*dt);
  blnse(:,j)=filtfilt(b,a,blnse(:,j));
  if blnse(li(j),j) < 0
    while blnse(li(j),j) < 0
      li(j)=li(j)+1;
    end
  else
    while blnse(li(j),j) > 0
      li(j)=li(j)+1;
    end
  end
end
%
%  Restore the proper length to the noise sequence. 
%
for j=1:n,
  blnse([1:npts],j)=blnse(li(j):li(j)+npts-1,j);
end
blnse=blnse([1:npts],:);
%
%  Fix the initial value of the band limited noise to zero
%  to avoid inaccurate initial conditions.
%
%blnse=blnse-ones(npts,1)*blnse(1,:);
%
%  Get a new realization of white gaussian random noise 
%  for the broad band noise component.
%
nse=randn(npts,n);
%
%  Combine wide band and bandlimited noise sequences
%  to produce colored noise.
%
for j=1:n,
  if pwrf(j)<=0
    y(:,j)=amp(j)*nse(:,j);
  else
    scf=sqrt(pwrf(j)*(nse(:,j)'*nse(:,j))/(blnse(:,j)'*blnse(:,j)));
    blnse(:,j)=scf*blnse(:,j);
    nse(:,j)=sqrt(1-pwrf(j))*nse(:,j);
    y(:,j)=amp(j)*(blnse(:,j) + nse(:,j));
  end
end
%
%  Time delay and final quiet time.
%  Don't overwrite the initial part, which
%  starts the time series at or near zero.  
%
n0=round(tdelay/dt) + ones(n,1);
n1=round(tfinal/dt) + ones(n,1);
for j=1:n,
  y(:,j)=[zeros(n0(j),1);y([1:npts-n0(j)],j)];
  if tfinal > 0.0
    y([npts-n1(j)+1:npts],j)=zeros(n1(j),1);
  end
end
return
