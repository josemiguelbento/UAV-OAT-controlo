function zs = hsmoo(z,bw,dt)
%
%  function zs = hsmoo(z,bw,dt)
%
%  Usage: zs = hsmoo(z,bw,dt);
%
%  Description:
%
%    Low pass filters the input data z by passing frequencies
%    in the interval [0,bw] Hz using fixed weight smoothing.  
%
%  Input:
%    
%     z = vector or matrix of measured time histories.
%    bw = scalar cutoff frequency, Hz.
%    dt = sampling interval, sec.
%
%  Output:
%
%    zs = low pass filtered vector or matrix of measured time histories.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 Dec 1995 - Created and debugged, EAM.
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
%
%  Compute the fixed smoothing weights.
%
nmid=round(npts/2.-0.1);
ffac=pi;
f=bw;
ft=f + ffac/(nmid*dt);
w=2.*pi*f;
wt=2.*pi*ft;
dw=wt-w;
h=0*ones(nmid,1);
ho=f+ft;
hnorm=0.;
zs=0*ones(npts,n);
hnorm=ho;
for i=1:nmid,
  h(i)=(pi/(2.*i*dt))*((sin(wt*i*dt)+sin(w*i*dt))/...
       (pi^2-(dw*i*dt)^2));
  hnorm=hnorm + 2.*h(i);
end
ho=ho/hnorm;
h=h/hnorm;
%
%  Smooth interior points using adjacent data points.
%
for j=1:n,
  for i=2:nmid,
    zs(i,j)=ho*z(i,j);
    for k=1:i-1,
      zs(i,j)=zs(i,j) + h(k)*(z(i+k,j)+z(i-k,j));
    end
    zs(i,j)=zs(i,j) + 2.*(h(i:nmid)'*z(i+i:i+nmid,j));
  end
  if mod(npts,2)==0
    ll=nmid+1;
  else
    ll=nmid+2;
  end
  for i=ll:npts-1,
    m=npts-i;
    zs(i,j)=ho*z(i,j);
    for k=1:m,
      zs(i,j)=zs(i,j) + h(k)*(z(i+k,j)+z(i-k,j));
    end
    for k=m+1:nmid,
      zs(i,j)=zs(i,j) + 2.*h(k)*z(i-k,j);
    end
  end
%
%  Smooth the endpoints using the points on one side twice.
%
  zs(1,j)=ho*z(1,j);...
  zs(1,j)=zs(1,j)+2.*(h(1:nmid)'*z(1+1:1+nmid,j));
  zs(npts,j)=ho*z(npts,j);...
  for k=1:nmid,
    zs(npts,j)=zs(npts,j) + 2.*h(k)*z(npts-k,j);
  end
  if mod(npts,2)~=0
    zs(nmid+1,j)=ho*z(nmid+1,j);
    for k=1:nmid,
      zs(nmid+1,j)=zs(nmid+1,j)+h(k)*(z(nmid+1+k,j)+z(nmid+1-k,j));
    end
  end
end
return
