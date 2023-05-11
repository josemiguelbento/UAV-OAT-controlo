function zsmep = xsmep(z,f,dt)
%
%  function zsmep = xsmep(z,f,dt)
%
%  Usage: zsmep = xsmep(z,f,dt);
%
%  Description:
%
%    Smoothes the endpoints of a measured time
%    history z using a time convolution implementation
%    of a low pass filter with cutoff frequency f for points
%    adjacent to the endpoints, then extrapolates the smoothed
%    adjacent points to obtain the endpoint estimates.  This avoids
%    using the endpoints themselves in the smoothing operation, which
%    produces a better result when the endpoints are very noisy.  
%
%  Input:
%    
%     z = vector or matrix of measured time histories.
%     f = low pass filter cutoff frequency, Hz.
%    dt = sampling interval, sec.
%
%  Output:
%
%    zsmep = vector or matrix of measured time histories
%            with smoothed endpoints.  
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 Sept 1997 - Created and debugged, EAM.
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
zsmep=z;
nmid=round(npts/2.-0.1);
ffac=pi;
ft=f + ffac/(nmid*dt);
w=2.*pi*f;
wt=2.*pi*ft;
dw=wt-w;
h=0*ones(nmid,1);
ho=f+ft;
hnorm=ho;
for i=1:nmid,
  h(i)=(pi/(2.*i*dt))*((sin(wt*i*dt)+sin(w*i*dt))/...
         (pi^2-(dw*i*dt)^2));
  hnorm=hnorm + 2.*h(i);
end
ho=ho/hnorm;
h=h/hnorm;
%
%  nx is the number of extrapolated adjacent points used
%  to compute the smoothed endpoints.
%
nx=3;
for i=2:2+nx-1,
  li=npts-i+1;
  zsmep(i,:)=ho*z(i,:);
  zsmep(li,:)=ho*z(li,:);
%
%  One sided smoothing used to avoid the endpoints.
%
  for k=1:nmid,
    zsmep(i,:)=zsmep(i,:)+2.*h(k)*z(i+k,:);
    zsmep(li,:)=zsmep(li,:)+2.*h(k)*z(li-k,:);
  end
end
%
%  Least squares slope estimation.
%
X=[ones(nx,1),dt*[1:nx]'];
Y=zsmep([2:2+nx-1],:);
SLPI=X\Y;
X=[ones(nx,1),dt*[npts-nx:npts-1]'];
Y=zsmep([npts-nx:npts-1],:);
SLPL=X\Y;
%
%  Extrapolation to estimate the endpoints.
%
zsmep(1,:)=SLPI(1,:);
zsmep(npts,:)=SLPL(1,:) + dt*npts*SLPL(2,:);
%
%  Restore the smoothed adjacent points to their original values.
%
zsmep([2:2+nx-1],:)=z([2:2+nx-1],:);
zsmep([npts-nx:npts-1],:)=z([npts-nx:npts-1],:);
return
