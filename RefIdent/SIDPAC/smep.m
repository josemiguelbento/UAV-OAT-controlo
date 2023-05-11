function zsmep = smep(z,f,dt)
%
%  function zsmep = smep(z,f,dt)
%
%  Usage: zsmep = smep(z,f,dt);
%
%  Description:
%
%    Smoothes the endpoints of a measured
%    time history z using a time convolution implementation
%    of a low pass filter with cutoff frequency f.  
%
%  Input:
%    
%    z = vector or matrix of measured time histories.
%    f = low pass filter cutoff frequency, hz.
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
%      14 May 1997 - Created and debugged, EAM.
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
end;
ho=ho/hnorm;
h=h/hnorm;
zsmep(1,:)=ho*z(1,:);
zsmep(npts,:)=ho*z(npts,:);
for k=1:nmid,
  zsmep(1,:)=zsmep(1,:)+2.*h(k)*z(1+k,:);
  zsmep(npts,:)=zsmep(npts,:)+2.*h(k)*z(npts-k,:);
end
return
