function lrchk = repchk(indx,n)
%
%  function lrchk = repchk(indx,n)
%
%  Usage: lrchk = repchk(indx,n);
%
%  Description:
%
%    Checks that the nth indexed orthogonal function 
%    has not already been generated.  
%
%
%  Input:
%    
%    indx = vector of orthogonal function indices.
%       n = total number of orthogonal functions (nth is the latest one).
%
%  Output:
%
%    lrchk = logical output for the order check.
%            =0 when the nth orthogonal function has not been generated before.
%            =1 when the nth orthogonal function has been generated before.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 2000 - Created and debugged, EAM.
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
lrchk=0;
%
%  Check latest orthogonal function index against all previous indices.
%
for i=1:n-1,
  if indx(n)==indx(i)
    lrchk=1;
  end
end
return
