function [xr,xc] = regsel(x,nreg)
%
%  function [xr,xc] = regsel(x,nreg)
%
%  Usage: [xr,xc] = regsel(x,nreg);
%
%  Description:
%
%    Selects regressor number nreg from the regressor matrix x
%    and puts this regressor in vector xc.  The matrix xr is comprised
%    of the remaining regressors from the original regressor matrix x.
%
%  Input:
%    
%       x = matrix of regressor column vectors.
%    nreg = number of the selected regressor column vector, 
%           counting from left to right.
%
%  Output:
%
%      xr = matrix of regressor column vectors 
%           with regressor number nreg removed.
%      xc = vector regressor number nreg. 
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 July 1996 - Created and debugged, EAM.
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
[npts,nr]=size(x);
nreg=max(1,min(nr,nreg));
xc=x(:,nreg);
if nr > 1
  xr=zeros(npts,nr-1);
  for i=1:nr
    if i < nreg
      xr(:,i)=x(:,i);
    else
      if i > nreg
        xr(:,i-1)=x(:,i);
      end
    end
  end
else
  xr=zeros(npts,1);
end
return
