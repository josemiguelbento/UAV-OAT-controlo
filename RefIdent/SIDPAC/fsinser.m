function [b,f,gv] = fsinser(z,dt)
%
%  function [b,f,gv] = fsinser(z,dt)
%
%  Usage: [b,f,gv] = fsinser(z,dt);
%
%  Description:
%
%    Computes Fourier sine series coefficients for vector or matrix
%    of measured time histories.  The time histories are detrended
%    (endpoints fixed to zero) and reflected about the origin
%    first to produce an odd function of time.  This means the 
%    Fourier series will be only sine terms and the magnitudes of 
%    the Fourier coefficients for the deterministic part
%    of the measured time histories decrease with the cube of the 
%    number of terms retained in the series.  
%
%  Input:
%    
%    z  = vector or matrix of measured time histories.
%    dt = sampling interval, sec.
%
%  Output:
%
%    b  = vector or matrix of Fourier sine series coefficients
%         for detrended time histories reflected about the origin.  
%    f  = vector of frequencies for the Fourier sine series coefficients.
%    gv = vector or matrix of input time histories with endpoint 
%         discontinuities removed.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      06 Apr 1997 - Created and debugged, EAM.
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
[npts,no]=size(z);
b=0*ones(npts,no);
f=[1:1:npts]'/(2*(npts-1)*dt);
gv=0*ones(npts,no);
iv=[0:1:npts-1]'/(npts-1);
for j=1:no,
  gv(:,j)=z(:,j)-ones(npts,1)*z(1,j)-iv*(z(npts,j)-z(1,j));
end
for j=1:no,
  for k=1:npts-1,
    b(k,j)=gv(:,j)'*sin(k*pi*iv);
    b(k,j)=b(k,j)*(2./(npts-1));
  end
end
return
