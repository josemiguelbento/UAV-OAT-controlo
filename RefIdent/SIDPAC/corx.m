function [corlm,xtxn,sx,xn] = corx(x,ctr)
%
%  function [corlm,xtxn,sx,xn] = corx(x,ctr)
%
%  Usage: [corlm,xtxn,sx,xn] = corx(x,ctr);
%
%  Description:
%
%    Computes the normalized regressor matrix xn and 
%    the normalized regressor correlation matrix corlm 
%    from the input regressor matrix x.  Input ctr
%    determines whether the regressors are centered 
%    about the mean value (ctr=0) or the initial 
%    value (ctr=1, default).  The normalized 
%    correlation matrix is an indication of the 
%    conditioning of the least squares linear 
%    regression parameter estimation problem.  
%
%  Input:
%    
%       x = matrix of column regressors.
%     ctr = regressor centering option (optional):
%           = 0 for mean value centering.
%           = 1 for initial value centering (default).
%
%  Output:
%
%    corlm = normalized regressor correlation matrix.
%     xtxn = normalized x'*x information matrix.
%       sx = vector of regressor standard deviations.
%       xn = normalized regressor matrix.
%

%
%    Author:  Eugene A. Morelli
%
%    Calls:
%      None
%
%    History:  
%      07 Oct 2000 - Created and debugged, EAM.
%      16 Sep 2001 - Modified to use mean or initial value 
%                    centering, dropped z calculations, EAM.  
%      02 Jul 2002 - Changed name to corx.m, EAM.
%
%
%  Copyright (C) 2002  Eugene A. Morelli
%
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
%  Determine the centering option.
%
if nargin < 2
  ctr=1;
end
%
%  Center the regressors.
%
if ctr==0
  xbar=mean(x);
else
%
%  Use initial value instead of mean value, 
%  to account for the fact that the variation 
%  of the measured output and the regressors 
%  should be about the trim values, and not 
%  about the mean values.  Also, the variations 
%  about the mean are generally not balanced 
%  or symmetric. 
%
  xbar=x(1,:);
end
%
%  Center the data and scale for number of data points.
%
xn=(x-ones(npts,1)*xbar)/sqrt(npts-1);
%
%  Compute xn covariance matrix.
%
cvar=xn'*xn;
sx=sqrt(diag(cvar));
%
%  Normalize the centered data by the standard deviations.
%
xn=xn./(ones(npts,1)*sx');
%
%  Correlation matrix and data for the normalized regression problem.
%
corlm=xn'*xn;
xtxn=corlm;
return
