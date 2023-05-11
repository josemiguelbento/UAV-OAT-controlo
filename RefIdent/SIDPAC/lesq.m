function [y,p,crb,s2,sv] = lesq(x,z,svlim,p0,crb0)
%
%  function [y,p,crb,s2,sv] = lesq(x,z,svlim,p0,crb0)
%
%  Usage: [y,p,crb,s2,sv] = lesq(x,z,svlim,p0,crb0);
%
%  Description:
%
%    Computes the least squares estimate of real parameter 
%    vector p, where y=x*p and y matches the measured 
%    quantity z in a least squares sense.  The model output y, 
%    the estimated parameter covariance matrix crb, and 
%    the model error variance s2, are estimated based on the 
%    parameter estimate p.  Inputs specifying minimum singular 
%    value ratio, initial estimated parameter vector p0, and 
%    initial estimated parameter covariance matrix crb0 
%    are optional.  This routine works for real or complex data.  
%
%  Input:
%
%      x = matrix of column regressors.
%      z = measured output vector time history.
%  svlim = minimum singular value ratio for matrix inversion (optional).
%     p0 = initial parameter vector (optional).
%   crb0 = initial parameter covariance matrix (optional).
%
%  Output:
%
%      y = model output vector time history.
%      p = vector of parameter estimates.
%    crb = estimated parameter covariance matrix.
%     s2 = model error variance estimate.
%     sv = vector of singular values of the information matrix.
%

%
%    Calls:
%      misvd.m
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      7 June 1997 - Created and debugged, EAM.
%     23 Sept 2000 - Added a priori information options, EAM.
%     24 Feb  2001 - Corrected comments, EAM.
%     30 Sept 2001 - Removed unnecessary s20 input, EAM.
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

%
%  Initialization.
%
[npts,np]=size(x);
if nargin<3 | isempty(svlim)
  svlim=eps*npts;
end
if svlim <=0
  svlim=eps*npts;
end
%
%  Standard least squares parameter estimation
%  using input data only.  
%
xtx=real(x'*x);
%xtxi=inv(xtx);
[xtxi,sv]=misvd(xtx,svlim);
%p=xtx\real(x'*z);
p=xtxi*real(x'*z);
y=x*p;
%
%  Real s2 used to remove round-off error.
%
s2=real((z-y)'*(z-y))/(npts-np);
%crb=s2*inv(xtx);
crb=s2*xtxi;
%
%  Modifications for a priori information.
%
%  Only implement the modifications for 
%  a priori information if both p0 
%  and crb0 are input.  
%
if nargin==5
%
%  Check crb0 dimensions.
%
  [m,n]=size(crb0);
  if m~=np | n~=np
    fprintf('\n Input matrix crb0 has wrong dimensions \n\n')
    return
  end
%
%  Check for non-singular crb0.
%
  if (1/cond(crb0))>0
%
%  The value of xtx0 is really xtx0/s20, which 
%  is the quantity required in subsequent 
%  expressions.  It is therefore not necessary
%  to explicitly specify s20, the error variance 
%  for the a priori parameter estimation
%  that resulted in p0 and crb0.  
%
    xtx0=misvd(crb0);
  else
    xtx0=zeros(np,np);
  end
  p0=cvec(p0);
%
%  Combined information matrix.  Using summed values 
%  scaled by the model error variance estimate is 
%  equivalent to least squares regression using 
%  a concatenated set of equations.  
%
  xtxi=misvd(xtx/s2 + xtx0);
%
%  For the a priori information, x'*z = (x'*x)*p.
%
  p=xtxi*(real(x'*z)/s2 + xtx0*p0);
  y=x*p;
%
%  Cramer-Rao bound matrix for the weighted least 
%  weighted least squares formulation resulting 
%  from the a priori information.  
%
  crb=xtxi;
%
%  Computing a single model error variance for 
%  the weighted least squares problem does not 
%  make sense, because the model error variances
%  are different for the two parts of the 
%  weighted least squares problem.  Output s2
%  is for the x and z data only, ignoring all 
%  a priori information. 
%
end
return
