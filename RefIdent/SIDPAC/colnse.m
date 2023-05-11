function [z,cnse,blnse,nse] = colnse(y,t,bw,nselev,pwrf)
%
%  function [z,cnse,blnse,nse] = colnse(y,t,bw,nselev,pwrf)
%
%  Usage: [z,cnse,blnse,nse] = colnse(y,t,bw,nselev,pwrf);
%
%  Description:
%
%    Corrupts y using gaussian random noise with standard deviation 
%    equal to nselev times the root mean square value of each 
%    column of y.  The noise is colored with a band-limited 
%    component in the frequency interval [0,bw] Hz and the fraction 
%    of the total noise power (band-limited plus wide-band) that is
%    band-limited equals pwrf.  If input pwrf is omitted, the 
%    fraction of the total noise power that is band limited is set to
%    a uniform random number on the interval [0,1].  Relationship of 
%    output noise sequences is cnse = blnse + nse.  
%    
%
%  Input:
%    
%         y = matrix of column vector time histories.
%         t = time vector.
%        bw = bandwidth of the band-limited noise component, Hz.
%    nselev = noise level in fraction of rms of the columns of y.
%      pwrf = fraction of total noise power that is band-limited, [0,1].
%
%
%  Output:
%
%       z = matrix of column vector time histories with gaussian colored noise. 
%    cnse = matrix of column vector gaussian colored noise sequences.
%   blnse = matrix of column vector gaussian band-limited  noise sequences.
%     nse = matrix of column vector gaussian wide band noise sequences.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 May 1999 - Created and debugged, EAM.
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
[npts,n]=size(y);
dt=t(2)-t(1);
nse=zeros(npts,n);
randn('seed',sum(100*clock));
ford=5;
%
%  Get white gaussian random noise for raw material for the 
%  band limiting process which will produce the band limited noise.
%
for j=1:n,
  nse(:,j)=nselev*sqrt((y(:,j)'*y(:,j))/npts)*randn(npts,1);
end
nmid=floor(npts/2);
if mod(npts,2)==0
  nmid=nmid-1;
end
blnse=0*ones(2*nmid+npts,n);
%
%  Use ford order Chebyshev low pass filter with bandwidth bw.
%  Extended length of blnse is necessary for the technique
%  used to avoid endpoint problems.
%
[b,a]=cheby1(ford,0.5,bw*2.*dt);
blnse(nmid+1:nmid+npts,:)=nse;
%
%  Reflect nmid points on each end about a zero ordinate.
%  This is done to avoid endpoint problems with the low pass filter.
%
for j=1:n,
  blnse(1:nmid,j)=-blnse(2*nmid+1:-1:nmid+2,j);
  blnse(nmid+npts+1:nmid+npts+nmid,j)=-blnse(nmid+npts-1:-1:npts,j);
  blnse(:,j)=filtfilt(b,a,blnse(:,j));
end
%
%  Restore the proper length to the noise sequence. 
%
blnse=blnse(nmid+1:nmid+npts,:);
%
%  Fix the initial value of the band limited noise to zero
%  to avoid inaccurate initial conditions.
%
blnse=blnse-ones(npts,1)*blnse(1,:);
%
%  Combine wide band and bandlimited noise sequences
%  to produce colored noise.
%
cnse=0*ones(npts,n);
%
%  Get a uniformly distributed random variable to determine
%  the balance between bandlimited noise and wide band noise
%  in the colored noise sequence if the pwrf input is not provided.
%
if nargin < 5
  rand('seed',sum(100*clock));
  pwrf=rand(n,1);
else
  if length(pwrf) < n
    pwrf=pwrf(1)*ones(n,1);
  end
end
%
%  Get a new realization of white gaussian random noise 
%  for the broad band noise component.
%
for j=1:n,
  nse(:,j)=nselev*sqrt((y(:,j)'*y(:,j))/npts)*randn(npts,1);
end
%
%  Mix narrow band and broad band noise.
%
for j=1:n,
  scf=sqrt(pwrf(j)*(nse(:,j)'*nse(:,j))/(blnse(:,j)'*blnse(:,j)));
  blnse(:,j)=scf*blnse(:,j);
  nse(:,j)=sqrt(1-pwrf(j))*nse(:,j);
  cnse(:,j)=blnse(:,j) + nse(:,j);
end
%
%  Corrupt the true outputs with colored noise.
%
z=y + cnse;
return
