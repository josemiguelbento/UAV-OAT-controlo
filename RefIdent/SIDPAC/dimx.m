function x = dimx(xn,xmin,xmax)
%
%  function x = dimx(xn,xmin,xmax)
%
%  Usage: x = dimx(xn,xmin,xmax);
%
%  Description:
%
%    Dimensionalizes the normalized columns of xn,
%    which have values in the interval [-1,1], 
%    to engineering units, using xmin and xmax.
%    Output x is the dimensionalized xn matrix 
%    in engineering units.  
%
%  Input:
%
%     xn = normalized matrix of independent variable data vectors.
%   xmin = vector of minimum independent variable values.
%   xmax = vector of maximum independent variable values.
%
%  Output:
%
%      x = matrix of independent variable data vectors.
%
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Jun 2002 - Created and debugged, EAM.
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
[npts,n]=size(xn);
%
%  Check the input dimensions.
%
xmin=cvec(xmin);
m=length(xmin);
xmax=cvec(xmax);
k=length(xmax);
if n~=m | n~=k
  fprintf('\n INPUT DIMENSION MISMATCH \n');
  return
end
%
%  Find the scaling values.
%
xscl=(xmax-xmin)/2;
%
%  Find the center values.
%
xctr=(xmax+xmin)/2;
%
%  Compute the x array in engineering units.
%
x=xn.*(ones(npts,1)*xscl') + ones(npts,1)*xctr';
return
