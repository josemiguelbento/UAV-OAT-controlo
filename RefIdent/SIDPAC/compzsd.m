function zsd = compzsd(z,wf,b,t,fcep)
%
%  function zsd = compzsd(z,wf,b,t,fcep)
%
%  Usage: zsd = compzsd(z,wf,b,t,fcep);
%
%  Description:
%
%    Reconstructs smoothed measured time history
%    derivatives using Fourier sine series coefficients 
%    and the Wiener filter in the frequency domain.  
%    The slope of the linear trend defined by the 
%    endpoints is included in zsd.  
%
%  Input:
%    
%      z  = vector or matrix measured time histories.
%      wf = vector or matrix Wiener filter in the frequency domain.  
%      b  = vector or matrix of Fourier sine series coefficients 
%           for detrended time histories reflected about the origin.  
%      t  = time vector, sec.
%    fcep = cutoff frequency for low pass filtering 
%           of the endpoints, Hz (default = 1 Hz).
%
%  Output:
%
%    zsd = smoothed vector or matrix measured time history derivatives.  
%

%
%    Calls:
%      xsmep.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 Dec 2001 - Created and debugged, EAM.
%      09 Jan 2002 - Added linear drift slope, EAM.
%      24 Feb 2002 - Corrected comments and added fcep input, EAM.
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
[npts,n]=size(z);
dt=1/round(1/(t(2)-t(1)));
%
%  Set default fcep to 1 Hz.
%
if nargin < 5,
  fcep=1.0;
end
%
%  Smooth the endpoints. 
%
zsmep=xsmep(z,fcep,dt);
%
%  Slope of the linear drift, which was removed
%  inside smoo.m.  
%
lslp=(zsmep(npts,:)-zsmep(1,:))/(t(npts)-t(1));
gvs=0*ones(npts,n);
iv=[0:1:npts-1]'/(npts-1);
wflim=0.0001;
for j=1:n,
  for k=1:npts,
    if wf(k,j)>=wflim 
      gvs(:,j)=gvs(:,j) + wf(k,j)*b(k,j)*cos(k*pi*iv)*k*pi/(npts-1);
    end
  end
end
zsd=gvs/dt + lslp;
return
