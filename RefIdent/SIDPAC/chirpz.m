function [z,fz]=chirpz(x,m,f1,f2,Fs)
%
%  function [z,fz]=chirpz(x,m,f1,f2,Fs)
%
%  Usage: [z,fz]=chirpz(x,m,f1,f2,Fs);
%
% 
%  Description:   
% 
%    Computes the chirpz (zoom) discrete Fourier transform
%    for a real input vector x, with number of frequency points m
%    over frequency range f1 < f < f2 in Hz.  The integer m
%    must be less than or equal to length(x), otherwise frequency
%    domain points will be repeated.  
%
%  Input:
%
%    x  - data vector for application of the discrete Fourier transform.
%    m  - number of frequency points.
%    f1 - lower bound of the frequency band, Hz.
%    f2 - upper bound of the frequency band, Hz.
%    Fs - sampling rate, Hz.
%
%  Output:
%
%    z  - discrete Fourier transform in the specified frequency band.
%    fz - frequency points, Hz.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Apr 1994 - Created and debugged, EAM.
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
npts=length(x);
jay=sqrt(-1);
phi=(2*pi/m)*(f2-f1)/Fs;
%
%  The above choice of phi matches the literature, and is 
%  consistent with Matlab functions fft and czt.  However, 
%  the result is that the upper bound of the frequency band
%  is less than f2 by the amount df=(f2-f1)/m.
%
%phi=(2*pi/(m-1))*(f2-f1)/Fs;
w = exp(-jay*phi);
theta=2*pi*f1/Fs;
nvec=-[0:1:npts-1]';
kvec=-[0:1:m-1];
a = exp(jay*theta).^nvec;
nk = nvec*kvec;
z = zeros(m,1);
%
%  The operator .' means transpose without conjugation.
%
z=(w.^nk).'*(a.*x);
fz = f1*ones(m,1) + (0:m-1)'*(f2-f1)/m;
%fz = f1*ones(m,1) + (0:m-1)'*(f2-f1)/(m-1);
return
