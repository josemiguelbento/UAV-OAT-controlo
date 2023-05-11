function zs = compzs(z,wf,b)
%
%  function zs = compzs(z,wf,b)
%
%  Usage: zs = compzs(z,wf,b);
%
%  Description:
%
%    Reconstructs smoothed measured time histories using 
%    Fourier sine series coefficients and the Wiener fileter
%    in the frequency domain.  Endpoints are not affected, 
%    so the trend represented by the endpoints of z 
%    is duplicated for zs.  
%
%  Input:
%    
%    z  = vector or matrix measured time histories.
%    wf = vector or matrix Wiener filter in the frequency domain.  
%    b  = vector or matrix of Fourier sine series coefficients 
%         for detrended time histories reflected about the origin.  
%
%  Output:
%
%    zs = smoothed vector or matrix measured time histories.  
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      04 May 1997 - Created and debugged, EAM.
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
gvs=0*ones(npts,n);
iv=[0:1:npts-1]'/(npts-1);
wflim=0.0001;
for j=1:n,
  for k=1:npts,
    if wf(k,j)>=wflim 
      gvs(:,j)=gvs(:,j) + wf(k,j)*b(k,j)*sin(k*pi*iv);
    end
  end
end
zs=gvs+ones(npts,1)*z(1,:)+iv*(z(npts,:)-z(1,:));
return
