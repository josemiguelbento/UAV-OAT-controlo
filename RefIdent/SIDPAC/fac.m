function y = fac(n)
%
%  function y = fac(n)
%
%  Usage: y = fac(n);
%
%  Description:
%
%    Computes n factorial.
%
%  Input:
%    
%    n = input positive integer.
%
%  Output:
%
%    y = n factorial.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 Feb 1992 - Created and debugged, EAM.
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
if n < 0
  y = 0;
else
  if n == 0
     y = 1;
  else
    y = 1;
    for i = 1:n
      y = y*i;
    end
  end
end
return
