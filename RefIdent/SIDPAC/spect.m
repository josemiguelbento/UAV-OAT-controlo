function [P,f,Y,wdw,data] = spect(y,t,npart,lplot)
%
%  function [P,f,Y,wdw,data] = spect(y,t,npart,lplot)
%
%  Usage: [P,f,Y,wdw,data] = spect(y,t,npart,lplot);
%
%  Description:
%
%    Estimates the one-sided auto spectral density 
%    and the two-sided discrete Fourier transform
%    using data windowing in the time domain.  The power
%    spectral density P and the discrete Fourier transform Y
%    are computed using frequency resolution determined by the 
%    first power of two higher than the length of y.  Frequency 
%    range is [0,fs/2].
%
%  Input:
%    
%    y     = matrix of time history vectors stored columnwise.
%    t     = time vector.
%    npart = number of window partitions for the time domain data.
%            Any input <=0 will skip the data windowing; 
%            otherwise, the algorithm will use the nearest power of 2.
%    lplot = 1 for auto spectral density plot.
%            0 to skip the plot. 
%
%  Output:
%
%    P    = auto spectral density.
%    f    = vector of frequencies corresponding to the elements of P and Y, Hz.
%    Y    = discrete Fourier transform of y.
%    wdw  = time domain windowing function.
%    data = matrix containing the windowed time domain data partitions.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      16 May 1995 - Created and debugged, EAM.
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
%
%  Find the smallest power of two that is larger than the number of 
%  data points to use as the record size for the power spectral estimation.  
%
nfft=2.^(ceil(log(npts)/log(2)));
%
%  If npart<1 or the input is omitted, then omit
%  data windowing.  Number of data windows ndw
%  is 2*npart-1 for this implementation.  
%
if nargin<3
  nsect=0;
else
  if npart<=0
    nsect=0;
  else
    nsect=1;
    while nsect<npart
      nsect=nsect*2;
    end
  end
end
%
%  Set the plotting flag to zero when not specified.
%
if nargin<4
  lplot=1;
end
%
%  N is the number of data points for each data window.  Each
%  column of matrix data is zero padded to length nfft for
%  increased frequency resolution.  
%
if nsect>0
  N=round(nfft/nsect);
%
%  Use the Hanning window with 50 percent overlap.
%
%  wdw=0.5*(ones(N,1)-cos(2*pi*[0:1:N-1]'/(N-1)));
%
%  Use the Bartlett window with 50 percent overlap.
%
  wdw=ones(N,1)-abs(([0:1:N-1]'-(N/2)*ones(N,1))/(N/2));
  wss=nfft*(wdw'*wdw);
  ndw=2*nsect-1;
else
  N=nfft;
  wdw=ones(N,1);
  wss=nfft*nfft;
  ndw=1;
end
%
%  Time vector information used for frequency scaling.
%
t=t(:,1);
dt=t(2)-t(1);
fs=1/dt;
%
%  Number of non-negative frequencies is nf.
%
nf=nfft/2 + 1;
df=(fs/2)/(nf-1);
f=[0:df:fs/2]';
P=zeros(nf,n);
Y=zeros(nf,n);
%
%  Compute the power spectral density for each input data vector.
%
for j=1:n,
  data=zeros(nfft,ndw);
%
%  Zero pad the data to length nfft to get high resolution in frequency.
%
  ypad=zeros(nfft,1);
  ypad(1:npts)=y(:,j);
  ioff=0;
  for k=1:ndw,
    data([1:N],k)=wdw.*ypad(ioff+1:ioff+N);
    ioff=ioff+round(N/2);
  end
%
%  Compute the two-sided discrete Fast Fourier Transform.  
%  Fourier components at positive frequencies have
%  complex conjugate counterparts at corresponding negative frequencies.  
%  Fourier components for zero frequency and the Nyquist frequency 
%  are one-sided values, since they have no corresponding 
%  negative frequencies.  
%
  Yw=fft(data);
  Yw=Yw([1:nf],:);
%
%  Compute the windowed power spectral density, normalized so that
%  the power spectral density is one-sided.
%
  Pw=(2*Yw.*conj(Yw));
%
%  The Fourier transform is one-sided for zero frequency
%  and the Nyquist frequency only. 
%
  Pw(1,:)=(Yw(1,:).*conj(Yw(1,:)));
  Pw(nf,:)=(Yw(nf,:).*conj(Yw(nf,:)));
%
%  Average the individual power spectral densities to 
%  reduce the variance of the spectral estimates 
%  by a factor of 9*ndw/11.  Finally, normalize
%  the spectral estimates using wss so that the sum of the
%  P values equals the mean square value of the time function.
%  For windowed data, scale the Fourier transforms by 
%  the inverse of the root mean square of the windowing function.  
%
  if ndw>1
    P(:,j)=mean(Pw')'/wss;
    Y(:,j)=mean(Yw')'/sqrt((wdw'*wdw)/N);
  else
    P(:,j)=Pw/wss;
    Y(:,j)=Yw/sqrt((wdw'*wdw)/N);
  end
end
%
%  Optional auto spectral density plot.
%
if lplot==1
  plot(f,P);
  xlabel('frequency  (Hz)');
  title('Power Spectral Density');
%
%  Scale the abscissa to include only 0 to 3 Hz.
%  Leave ordinate scaling at the default.
%
  v=axis;
  axis([0 3 v(3:4)]);
end
return
