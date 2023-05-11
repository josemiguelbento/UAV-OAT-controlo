function [xi,sv] = misvd(x,svlim)
%
%  function [xi,sv] = misvd(x,svlim)
%
%  Usage: [xi,sv] = misvd(x,svlim);
%
%  Description:
%
%    Computes generalized matrix inverse of input matrix x
%    using the singular value decomposition.  The inverse of singular or 
%    non-square x matrices are done in the least squares sense.  
%    Input svlim is optional.  
%
%  Input:
%    
%    x     = input matrix.
%    svlim = minimum singular value ratio for matrix inversion (optional).
%
%  Output:
%
%    xi = generalized matrix inverse of x.
%    sv = vector of singular values of x.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      16 May   1997 - Created and debugged, EAM.
%      19 April 2000 - Made svlim input optional, EAM. 
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
[m,n]=size(x);
[U,S,V]=svd(x,0);
sv=diag(S);
svmax=S(1,1);
%
%  Check for svlim input, use default if not provided.  
%
if nargin<2
  svlim=max(size(x))*eps;
end
%fprintf(1,'\n SINGULAR VALUES: \n');
for j=1:n,
%  fprintf(1,'     singular value %3.0f = %13.6e \n',j,S(j,j));
  if S(j,j)/svmax < svlim
    S(j,j)=0.0;
    fprintf(1,' SINGULAR VALUE %3.0f DROPPED \n',j);   
  else
    S(j,j)=1/S(j,j);
  end
end
xi=V*S*U';
return
