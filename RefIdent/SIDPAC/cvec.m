function yc = cvec(y)
%
%  function yc = cvec(y)
%
%  Usage: yc = cvec(y);
%
%  Description:
%
%    Makes y vector into a column vector, if it is not already. 
%
%  Input:
%    
%    y = input vector.
%
%  Output:
%
%    yc = column vector with same elements as y.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      02 Mar 2000 - Created and debugged, EAM.
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
[m,n]=size(y);
if n > m
  yc=y';
else
  yc=y;
end
yc=yc(:,1);
return
