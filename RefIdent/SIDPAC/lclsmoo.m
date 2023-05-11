function zs = lclsmoo(z)
%
%  function zs = lclsmoo(z)
%
%  Usage: zs = lclsmoo(z);
%
%
%  Description:
%
%    Computes smoothed time histories using local smoothing.
%
%  Input:
%    
%    z = vector or matrix of measured time histories.
%
%  Output:
%
%    zs = smoothed vector or matrix of measured time histories.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Nov 1998 - Created and debugged, EAM.
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
zs=zeros(npts,no);
delc=z(4,:)-3*z(3,:)+3*z(2,:)+z(1,:);
delq=z(5,:)-4*z(4,:)+6*z(3,:)-4*z(2,:)+z(1,:);
zs(1,:)=z(1,:)+(1/5)*delc+(3/35)*delq;
zs(2,:)=z(2,:)-(2/5)*delc-(1/7)*delq;
for i=3:npts-2,
  zs(i,:)=z(i,:)-(3/35)*(z(i-2,:)-4*z(i-1,:)+6*z(i,:)-4*z(i+1,:)+z(i+2,:));  
end
delc=z(npts,:)-3*z(npts-1,:)+3*z(npts-2,:)+z(npts-3,:);
delq=z(npts,:)-4*z(npts-1,:)+6*z(npts-2,:)-4*z(npts-3,:)+z(npts-4,:);
zs(npts-1,:)=z(npts-1,:)+(2/5)*delc-(1/7)*delq;
zs(npts,:)=z(1,:)-(1/5)*delc+(3/35)*delq;
return
