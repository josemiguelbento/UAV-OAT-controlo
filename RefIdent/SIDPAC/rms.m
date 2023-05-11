function y = rms(x)
%
%  function y = rms(x)
%
%  Usage: y = rms(x);
%
%  Description:
%
%    Computes the root mean square (rms) of a vector or matrix input x.  
%    If x is a matrix, y is a row vector of the rms values for each column.  
%
%  Input:
%    
%    x = input vector or matrix.
%
%  Output:
%
%    y = scalar root mean square value(s).
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      25 Feb 1998 - Created and debugged, EAM.
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
[n,m]=size(x);
y=zeros(1,m);
for j=1:m,
  y(j)=sqrt((x(:,j)'*x(:,j))/n);
end
return
