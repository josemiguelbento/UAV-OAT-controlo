function [xo,a] = gsorth(x)
%
%  function [xo,a] = gsorth(x)
%
%  Usage: [xo,a] = gsorth(x);
%
%  Description:
%
%    Orthogonalizes a set of vectors in matrix x, 
%    using a forward Gram-Schmidt vector orthogonalization
%    technique.  
%
%  Input:
%    
%     x = matrix of column vectors.
%
%  Output:
%
%    xo = matrix of orthogonal column vectors.
%     a = matrix of orthogonalization constants.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      3 Sept 2001 - Created and debugged, EAM.
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
[npts,n]=size(x);
%
%  The first column of x is the first 
%  orthgonal vector.    
%
xo=x;
%
%  Finished if there is only one vector in x.
%
if n > 1
%
%  Loop to orthogonalize the kth vector
%  with respect to all the previously 
%  orthogonalized vectors.  
%
  a=zeros(n,n);
%
%  Loop on number of vectors in x.
%
  for k=2:n,
%
%  Loop on past orthogonalized vectors.
%
    for j=1:k-1,
      a(k,j)=(xo(:,j)'*x(:,k))/(xo(:,j)'*xo(:,j));
    end
    xo(:,k)=x(:,k)-xo*a(k,:)';
  end
%
%  Check for non-orthogonality.
%
  ztol=1.0e-08;
  xotxo=zeros(n,n);
  for i=1:n,
    for j=i+1:n,
      xotxo(i,j)=xo(:,i)'*xo(:,j);
      if xotxo(i,j) > ztol
        fprintf('\n Non-orthogonal measure: ');
        fprintf('sum( xo(:,%2i) .* xo(:,%2i) ) = %13.6e \n\n',i,j,xotxo(i,j));
      end
    end
  end
end
return
