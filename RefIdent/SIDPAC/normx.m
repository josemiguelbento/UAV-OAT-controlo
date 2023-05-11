function xn = normx(x,xmin,xmax)
%
%  function xn = normx(x,xmin,xmax)
%
%  Usage: xn = normx(x,xmin,xmax);
%
%  Description:
%
%    Normalizes the columns of x by mapping the  
%    values using the corresponding elements of
%    xmin and xmax to [-1,1].  Output xn is the 
%    normalized x matrix.  
%
%  Input:
%
%      x = matrix of independent variable data vectors.
%   xmin = vector of minimum independent variable values.
%   xmax = vector of maximum independent variable values.
%
%  Output:
%
%     xn = normalized matrix of independent variable data vectors.
%
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      09 Dec 2000 - Created and debugged, EAM.
%      18 Jun 2002 - Vectorized the calculations, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
[npts,n]=size(x);
%
%  Check the input dimensions.
%
m=length(xmin);
xmin=cvec(xmin);
k=length(xmax);
xmax=cvec(xmax);
if n~=m | n~=k
  fprintf('\n INPUT DIMENSION MISMATCH \n');
  return
end
%
%  Compute the normalized xn array.
%
xn=-ones(npts,n) + 2*(x-ones(npts,1)*xmin')./(ones(npts,1)*(xmax-xmin)');
return
