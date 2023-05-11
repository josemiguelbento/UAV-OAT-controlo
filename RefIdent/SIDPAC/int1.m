function val = int1(x1,x1vec,dvec)
%
%  function val = int1(x1,x1vec,dvec)
%
%  Usage: val = int1(x1,x1vec,dvec);
%
%  Description:
%
%    Finds a linearly interpolated value from input 
%    data vector dvec, which is tabulated for the values 
%    in x1vec by row.  Input x1 is the independent variable 
%    value corresponding to x1vec.  Elements of input 
%    vector x1vec must increase monotonically.  If dvec 
%    is a matrix of column vectors, output val
%    is a row vector of interpolated values for each
%    column of dvec.  
%
%  Input:
%    
%      x1 = independent variable value.  
%   x1vec = vector of tabulated values for x1.  
%    dvec = data vector or matrix.  
%
%  Output:
%
%     val = linear interpolation value for x1.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 July 2000 - Created and debugged, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
m=length(x1vec);
%
%  Find lower bound index for x1.
%
i=max(find(x1>=x1vec));
%
%  Set lower bound to 1 when x1 is lower
%  than all elements of x1vec.
%
if isempty(i)
  i=1;
end
%
%  Set upper bound to m-1, so data can 
%  be extrapolated at the high end.  
%
i=min(m-1,i);
%
%  Fractional index position of x1.
%
dx1=((x1-x1vec(i))/(x1vec(i+1)-x1vec(i)));
%
%  Independent variable x1 linear interpolation.
%  Matrix dvec data is extrapolated if x1 is outside 
%  the limits of x1vec.
%
val=dvec(i,:)+dx1*(dvec(i+1,:)-dvec(i,:));
return
