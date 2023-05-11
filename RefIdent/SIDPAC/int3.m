function val = int3(x1,x2,x3,x1vec,x2vec,x3vec,dmat)
%
%  function val = int2(x1,x2,x3,x1vec,x2vec,x3vec,dmat)
%
%  Usage: val = int2(x1,x2,x3,x1vec,x2vec,x3vec,dmat);
%
%  Description:
%
%    Finds a linearly interpolated value from input 
%    data matrix dmat, which is tabulated for the values 
%    in x1vec by row, x2vec by column, and x3vec by page.  
%    Inputs x1, x2, and x3 are the independent variable
%    values corresponding to x1vec, x2vec, and x3vec, 
%    respectively.  Elements of input vectors x1vec, 
%    x2vec, and x3vec must increase monotonically.  
%
%  Input:
%    
%      x1 = first independent variable value.  
%      x2 = second independent variable value.
%      x3 = third independent variable value.
%   x1vec = vector of tabulated values for x1.  
%   x2vec = vector of tabulated values for x2.  
%   x3vec = vector of tabulated values for x3.  
%    dmat = length(x1vec) x length(x2vec) x length(x3vec) data matrix.
%
%  Output:
%
%     val = linear interpolation value for x1, x2, and x3.
%
%

%
%    Calls:
%      int2.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      13 June 1999 - Created and debugged, EAM.
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
l=length(x3vec);
%
%  Find lower bound index for x3.
%
k=max(find(x3>=x3vec));
%
%  Set lower bound to 1 when x3 is lower
%  than all elements of x3vec.
%
if isempty(k)
  k=1;
end
%
%  Set upper bound to l-1, so data can 
%  be extrapolated at the high end.  
%
k=min(l-1,k);
%
%  Fractional index position of x3.
%
dx3=((x3-x3vec(k))/(x3vec(k+1)-x3vec(k)));
%
%  Use 2-D interpolation first to get endpoint
%  data values for the third independent variable
%  linear interpolation.
%
t=int2(x1,x2,x1vec,x2vec,squeeze(dmat(:,:,k)));
u=int2(x1,x2,x1vec,x2vec,squeeze(dmat(:,:,k+1)));
%
%  Independent variable x3 linear interpolation.
%  Matrix dmat data is extrapolated if x3 is outside 
%  the limits of x3vec.
%
val=t+dx3*(u-t);
return
