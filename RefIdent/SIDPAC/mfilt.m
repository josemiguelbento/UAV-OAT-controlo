function wf = mfilt(b,f)
%
%  function wf = mfilt(b,f)
%
%  Usage: wf = mfilt(b,f);
%
%  Description:
%
%    Implements an ideal filter using the Lanczos
%    method.  This version requires the analyst 
%    to select signal cut-offs in the frequency domain.
%
%  Input:
%    
%    b = vector or matrix of Fourier sine series coefficients 
%        for detrended time histories reflected about the origin.  
%    f = vector of frequencies for the Fourier sine series 
%        coefficients, Hz.
%
%  Output:
%
%    wf    = vector or matrix filter weights in the frequency domain.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      06 Aug 1999 - Created and debugged, EAM.
%      18 Jan 2000 - Modified plotting for SID, EAM.
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
[npts,n]=size(b);
ab=abs(b);
df=f(2)-f(1);
clf;
for j=1:n,
  fprintf(1,'\n\n Analysis for Signal # %i\n',j)
  plot(f,ab(:,j)),grid on,
  fprintf('\n\n Select upper limit for the abscissa \n');
  [xul,py]=ginput(1);
  set(gca,'XLim',[-Inf,xul])
  fprintf('\n\n Select frequency cut-off ')
  fprintf('\n (end of large components) \n');
  [scof,py]=ginput(1);
  scofi=round(scof/df);
  scof=f(scofi);
%
%  Compute the ideal filter weights for all frequency indices.
%
  for i=1:npts,
    if i <= scofi,
      wf(i,j)=1.0;
    else
      wf(i,j)=0.0;
    end
  end
end
return
