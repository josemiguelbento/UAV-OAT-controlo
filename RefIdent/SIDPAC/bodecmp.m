function [mag,ph,w] = bodecmp(num,den,tau,lplot,w)
%
%  function [mag,ph,w] = bodecmp(num,den,tau,lplot,w)
%
%  Usage: [mag,ph,w] = bodecmp(num,den,tau,lplot,w);
%
%  Description:
%
%    Computes the magnitude and phase of input transfer function(s)
%    with time delay over the frequency range w in rad/sec.
%    Plots the results on a single bode plot.  For multiple systems, 
%    the numerators, denominators, and time delays must be stacked
%    by row in num, den, and tau.  This may require adding some leading 
%    zeros.  The routine can also be used with a single denominator den.  
%    Input w is optional.  If input w is omitted, 
%    w is set to a vector containing 100 points logarithmically 
%    spaced on the interval [0.1,10] rad/sec.  
%
%  Input:
%
%     num = transfer function numerator vector, descending powers of s by column.
%     den = transfer function denominator vector, descending powers of s by column.
%     tau = equivalent time delay, sec.
%   lplot = plot flag
%           = 1 for plots.
%           = 0 for no plots.
%       w = frequency vector, rad/sec (optional).
%
%  Output:
%
%    mag = transfer function magnitude vector, dB.
%     ph = transfer function phase, deg.
%      w = frequency vector, rad/sec.
%
%    graphics:
%      Bode plot
%

%
%    Calls:
%      bodeplt.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 Nov  1996 - Created and debugged, EAM.
%      22 Sept 2000 - Cleaned up error handling and plot output, EAM.
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
  nw=100;
  wmin=0.1;
  wmax=10;
  w=logspace(log10(wmin),log10(wmax),nw)';
else
  nw=length(w);
  wmin=min(w);
  wmax=max(w);
end
[no,m]=size(num);
[nd,n]=size(den);
if length(tau)~=no
  tau=tau(1)*ones(no,1);
end
if nd~=1 & nd<no
  den=den(1,:);
  nd=1;
  fprintf('\n USING SINGLE (FIRST) DENOMINATOR FOR ALL NUMERATORS \n\n');
end
if n<m
  fprintf('\n NOT A PROPER RATIONAL TRANSFER FUNCTION \n\n');
end
jay=sqrt(-1);
rtd=180/pi;
jw=jay*w;
numvec=[m-1:-1:0];
denvec=[n-1:-1:0];
mag=zeros(nw,no);
nmag=zeros(nw,no);
dmag=zeros(nw,nd);
ph=zeros(nw,no);
for j=1:no,
%
%  Constant term first.
%
  nmag(:,j)=num(j,m)*ones(nw,1);
%
%  Terms involving powers of jay*w.
%
  for i=1:m-1,
    nmag(:,j)=nmag(:,j) + num(j,i)*(jw.^numvec(i));
  end
end
%
%  Single denominator.
%
if nd==1,
%
%  Constant term first.
%
  dmag=den(n)*ones(nw,1);
%
%  Terms involving powers of jay*w.
%
  for i=1:n-1,
    dmag=dmag + den(i)*(jw.^denvec(i));
  end
else
%
%  Multiple denominators.
%
  for j=1:no,
%
%  Constant term first.
%
    dmag(:,j)=den(j,n)*ones(nw,1);
%
%  Terms involving powers of jay*w.
%
    for i=1:n-1,
      dmag(:,j)=dmag(:,j) + den(j,i)*(jw.^denvec(i));
    end
  end
end
jd=1;
for j=1:no,
  tf=nmag(:,j)./dmag(:,jd);
%
%  Include the pure time delay.
%
  tf=tf.*exp(-tau(j)*jw);
  mag(:,j)=20*log10(abs(tf));
  ph(:,j)=atan2(imag(tf),real(tf));
  ph(:,j)=unwrap(ph(:,j))*rtd;
%
%  Successive numerators go with the respective denominators.
%
  if jd<nd,
    jd=jd+1;
  end
end
%
%  Plot results.
%
if lplot==1,
  bodeplt(w,mag,ph);
end
return
