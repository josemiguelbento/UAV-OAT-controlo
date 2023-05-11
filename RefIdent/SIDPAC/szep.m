function zzep = szep(z,t)
%
%  function zzep = szep(z,t)
%
%  Usage: zzep = szep(z,t);
%
%  Description:
%
%    Removes a linear trend from each column of input matrix z
%    using smoothed endpoint estimates.  The resulting matrix zzep
%    consists of the columns of z with endpoints fixed to zero.
%
%  Input:
%    
%     z = vector or matrix of measured time histories.
%     t = time vector, sec.
%
%  Output:
%
%    zzep = vector or matrix of measured time histories
%           with endpoints fixed to zero.  
%
%

%
%    Calls:
%      xsmep.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 May 1995 - Created and debugged, EAM.
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
dt=t(2)-t(1);
zsmep=xsmep(z,1.0,dt);
iv=[0:1:npts-1]'/(npts-1);
for j=1:no,
  zzep(:,j)=zsmep(:,j)-ones(npts,1)*zsmep(1,j)-iv*(zsmep(npts,j)-zsmep(1,j));
end
return
