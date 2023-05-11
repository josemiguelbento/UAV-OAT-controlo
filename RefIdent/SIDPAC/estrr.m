function rr = estrr(y,z)
%
%  function rr = estrr(y,z)
%
%  Usage: rr = estrr(y,z);
%
%  Description:
%
%    Computes the discrete noise covariance matrix estimate, 
%    assuming the measurement noise processes are uncorrelated.  
%
%  Input:
%    
%      y = model output vector time history. 
%      z = measured output vector time history.
%
%  Output:
%
%     rr = discrete measurement noise covariance matrix estimate. 
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 1997 - Created and debugged, EAM.
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
v=z-y;
rr=zeros(no,no);
for j=1:no,
  rr(j,j)=v(:,j)'*v(:,j)/npts;
end
return
