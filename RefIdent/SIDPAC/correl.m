function corr = correl(cvar)
%
%  function corr = correl(cvar)
%
%  Usage: corr = correl(cvar);
%
%  Description:
%
%    Computes correlation matrix from the covariance matrix, cvar.
%
%  Input:
%    
%    cvar = covariance matrix.
%
%  Output:
%
%    corr = correlation matrix.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 Mar 1995 - Created and debugged, EAM.
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
[n,m]=size(cvar);
corr=zeros(n,n);
for i=1:n,
  for j=1:n,
    corr(i,j)=cvar(i,j)/(sqrt(cvar(i,i))*sqrt(cvar(j,j)));
  end
end
return
