function z = buzz(y,nselev)
%
%  function z = buzz(y,nselev)
%
%  Usage: z = buzz(y,nselev);
%
%  Description:
%
%    Corrupts y using Gaussian random noise with 
%    standard deviation equal to nselev times 
%    the root mean square value of each column of y.
%
%  Input:
%
%         y = matrix of column vector time histories.
%    nselev = noise level in terms of the root mean square values
%             of the columns of y.  For example, if nselev=0.1, then
%             the signal to noise ratio of z will be 10 to 1.  
%
%  Output:
%
%      z = matrix of column vector time histories with added Gaussian white noise. 
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Mar 1996 - Created and debugged, EAM.
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
[npts,n]=size(y);
randn('seed',sum(100*clock));
for j=1:n,
  nse(:,j)=nselev*sqrt((y(:,j)'*y(:,j))/npts)*randn(npts,1);
end
z=y+nse;
return
