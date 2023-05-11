function val = int2(x1,x2,x1vec,x2vec,dmat)
%
%  function val = int2(x1,x2,x1vec,x2vec,dmat)
%
%  Usage: val = int2(x1,x2,x1vec,x2vec,dmat);
%
%  Description:
%
%    Finds a linearly interpolated value from input 
%    data matrix dmat, which is tabulated for the values 
%    in x1vec by row and x2vec by column.  Inputs x1 and x2
%    are the independent variable values corresponding 
%    to x1vec and x2vec, respectively.  Elements of input 
%    vectors x1vec and x2vec must increase monotonically.  
%
%  Input:
%    
%      x1 = first independent variable value.  
%      x2 = second independent variable value.
%   x1vec = vector of tabulated values for x1.  
%   x2vec = vector of tabulated values for x2.  
%    dmat = length(x1vec) x length(x2vec) data matrix.
%
%  Output:
%
%     val = linear interpolation value for x1 and x2.
%
%

%
%    Calls:
%      None
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
m=length(x1vec);
n=length(x2vec);
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
%  Find lower bound index for x2.
%
j=max(find(x2>=x2vec));
%
%  Set lower bound to 1 when x2 is lower
%  than all elements of x2vec.
%
if isempty(j)
  j=1;
end
%
%  Set upper bound to n-1, so data can 
%  be extrapolated at the high end.  
%
j=min(n-1,j);
%
%  Fractional index position of x2.
%
dx2=(x2-x2vec(j))/(x2vec(j+1)-x2vec(j));
t=dmat(i,j);
u=dmat(i,j+1);
%
%  Independent variable x1 linear interpolation.
%  Matrix dmat data is extrapolated if x1 is outside 
%  the limits of x1vec.
%
v=t+dx1*(dmat(i+1,j)-t);
w=u+dx1*(dmat(i+1,j+1)-u);
%
%  Independent variable x2 linear interpolation.
%  Matrix dmat data is extrapolated if x2 is outside 
%  the limits of x2vec.
%
val=v+dx2*(w-v);
return
