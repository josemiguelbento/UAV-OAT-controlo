function [zs,fco,rr,b,f,wf,gv,sigab,nseab] = smoo(z,t,fcep,lplot,auto)
%
%  function [zs,fco,rr,b,f,wf,gv,sigab,nseab] = smoo(z,t,fcep,lplot,auto)
%
%  Usage: [zs,fco,rr,b,f,wf,gv,sigab,nseab] = smoo(z,t,fcep,lplot,auto);
%
%  Description:
%
%    Computes smoothed time histories and noise 
%    covariance matrix estimates using optimal Fourier smoothing.  
%    This version requires the analyst to select signal cut-off 
%    frequency for the deterministic signal, based on the Lanczos
%    spectral estimate.  Inputs fcep, lplot, and auto are optional.  
%
%  Input:
%    
%    z    = vector or matrix of measured time histories.
%    t    = time vector, sec.
%    fcep = cutoff frequency for low pass filtering 
%           of the endpoints, Hz (default = 1).
%   lplot = plot flag:
%           = 1 for smoothing plots.
%           = 0 to skip the plots (default). 
%    auto = flag indicating type of operation:
%           = 1 for automatic  (no user input required) (default).
%           = 0 for manual  (user input required).
%
%  Output:
%
%    zs    = smoothed vector or matrix of measured time histories.
%    fco   = scalar or vector of cutoff frequencies, Hz.
%    rr    = scalar or matrix discrete noise covariance estimate.
%    b     = vector or matrix of Fourier sine series coefficients 
%            for detrended time histories reflected about the origin.  
%    f     = vector of frequencies for the Fourier 
%            sine series coefficients, Hz.
%    wf    = vector or matrix of filter weights in the frequency domain.
%    gv    = vector or matrix of input time histories 
%            with endpoint discontinuities removed. 
%    sigab = vector or matrix frequency domain model of
%            the absolute Fourier sine coefficients
%            for the deterministic part of the measured time histories.  
%    nseab = scalar or vector of the constant 
%            frequency domain model of
%            the absolute Fourier sine coefficients
%            for the random noise part of the measured time histories.
%

%
%    Calls:
%      xsmep.m
%      fsinser.m
%      mfilt.m
%      wnfilt.m
%      compzs.m
%      rrest.m
%      freqcut.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     14 Mar  1993 - Created and debugged, EAM.  
%     01 Aug  1999 - Modified for manual operation, EAM.
%     18 Jan  2000 - Modified plotting for SID use, EAM.
%     15 Sept 2000 - Modified to include option for  
%                    automatic Wiener filtering, EAM.
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
[npts,n]=size(z);
dt=1/round(1/(t(2)-t(1)));
%
%  Provide default inputs, if necessary.
%
if nargin < 5,
  auto=1;
end
if nargin < 4,
  lplot=0;
end
if nargin < 3,
  fcep=1.0;
end
if lplot==1
  Fg2H=figure('Units','normalized',...
              'Position',[0.352 0.0437 0.64 0.88],...
              'Color',[0.8 0.8 0.8],...
              'Name','Smoother Plots',...
              'NumberTitle','off',...
              'Tag','Fig2',...
              'ToolBar','none');
end
%
%  Smooth the endpoints. 
%
zsmep=xsmep(z,fcep,dt);
%
%  Reflect the time history about the time origin,
%  and expand in a Fourier sine series.  
%
[b,f,gv]=fsinser(zsmep,dt);
%
%  Manual ideal filtering or automatic Wiener filtering.
%
if auto==0
  wf=mfilt(b,f);
%
%  Signal and noise models for the ideal filter.
%
  sigab=abs(b).*wf;
  nseab=ones(size(b));
%
%  Find cut-off frequencies from the filter.  
%
  fco=freqcut(wf,dt);
%
%  Implement the Wiener filter for the manual case.  
%  Compute signal and noise models for the Wiener 
%  filter by normalizing the signal and noise models
%  so they both equal one at the cut-off frequency.
%
  for j=1:n,
    sigab(:,j)=ones(npts,1)./((f/fco(j)).^3);
    nseab(:,j)=ones(npts,1);
    wf(:,j)=(sigab(:,j).^2)./(sigab(:,j).^2+nseab(:,j).^2);
  end
else
  [wf,sigab,nseab]=wnfilt(b);
%
%  Find cut-off frequencies from the filters.  
%
  fco=freqcut(wf,dt);
end
%
%  Construct the smoothed signals. 
%
zs=compzs(zsmep,wf,b);
%
%  Estimate the noise variances.  
%
rr=rrest(z,zs);
if lplot==1,
  for j=1:n,
    fprintf(1,'\n\n Plots for Signal # %i\n',j),
    clf;
    subplot(3,1,1),plot(t,z(:,j)),ylabel('z'),grid on,
    subplot(3,1,2),plot(t,zs(:,j)),ylabel('zs'),grid on,
    subplot(3,1,3),plot(t,z(:,j)-zs(:,j)),ylabel('z-zs'),xlabel('t (sec)'),grid on,
    fprintf('\n\n Frequency cut-off at %4.1f Hz ',fco(j));
    if n > 1
      fprintf('for signal # %i\n\n',j);
    else
      fprintf('\n\n')
    end
    if j < n
      fprintf('\n Press any key to continue ... '),pause,
    end
  end
  fprintf('\n Press any key to continue ... '),pause,
  close(Fg2H)
else
  for j=1:n,
    fprintf('\n\n Frequency cut-off at %4.1f Hz ',fco(j));
    if n > 1
      fprintf('for signal # %i\n\n',j);
    else
      fprintf('\n\n')
    end
  end
end
return
