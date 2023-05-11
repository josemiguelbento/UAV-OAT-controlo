function cmpsigs(t,x)
%
%  function cmpsigs(t,x)
%
%  Usage: cmpsigs(t,x);
%
%  Description:
%
%    Draws a plot comparing the column vector signals in x 
%    scaled and biased so that the waveform information can be 
%    directly compared.  Scaling is done relative to the signal 
%    in the first column of x.  
%
%  Input:
%
%       t = time vector, sec.
%       x = matrix of column vector signals to be plotted and compared.
%
%  Output:
%
%    graphics:
%      comparison plot
%

%
%    Calls:
%      rms.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      9 Apr 1995 - Created and debugged, EAM.
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
[m,n]=size(x);
if m~=npts
  fprintf('\n Vector length mismatch \n\n');
end
xz=x-ones(npts,1)*x(1,:);
xsize=rms(xz);
xscale=ones(1,n)./(xsize/xsize(1)),
plot(t,xz.*(ones(npts,1)*xscale))
title('Comparison plot')
grid on;
xlabel('time (sec)');
return
