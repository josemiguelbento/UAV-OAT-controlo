function zz = zep(z)
%
%  function zz = zep(z)
%
%  Usage: zz = zep(z);
%
%  Description:
%
%    Removes a linear trend from each column of input matrix z.
%    The resulting matrix zz consists of the columns of z 
%    with endpoints fixed to zero.
%
%  Input:
%
%     z = vector or matrix of measured time histories.
%
%  Output:
%
%    zz = vector or matrix of measured time histories
%           with endpoints fixed to zero.  
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      13 May 1995 - Created and debugged, EAM.
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
iv=[0:1:npts-1]'/(npts-1);
for j=1:no,
  zz(:,j)=z(:,j)-ones(npts,1)*z(1,j)-iv*(z(npts,j)-z(1,j));
end
return
