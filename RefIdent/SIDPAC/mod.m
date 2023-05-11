function y = mod(n,d)
%
%  function y = mod(n,d)
%
%  Usage: y = mod(n,d);
%
%  Description:
%
%    Computes the integer remainder of n/d.
%
%  Input:
%    
%    n = input positive integer dividend.
%    d = input positive integer divisor.
%
%  Output:
%
%    y = integer remainder of n/d.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      2 Mar 1996 - Created and debugged, EAM.
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
if n <= 0 | d <= 0
  y = 0;
else
  n=round(n);
  d=round(d);
  y = n - d*fix(n/d);
end
return
