function [crb,crbo,y,p,sv] = r_colores(x,z,svlim)
%
%  function [crb,crbo,y,p,sv] = r_colores(x,z,svlim)
%
%  Usage: [crb,crbo,y,p,sv] = r_colores(x,z,svlim);
%
%  Description:
%
%    Computes the Cramer-Rao bounds for least squares regression
%    parameter estimation both conventionally and accounting for 
%    the actual frequency content of the residuals.  
%    The regression model is y=x*p.  The routine also computes
%    the least squares estimate of parameter vector p, 
%    where y=x*p and y matches the measured quantity z 
%    in a least squares sense.  The singular values of the information
%    matrix, which indicate the conditioning of the least squares
%    solution, are placed in output vector sv.  
%
%  Input:
%    
%        x = matrix of column regressors.
%        z = measured output vector time history.
%    svlim = minimum singular value ratio for matrix inversion (optional).
%
%  Output:
%
%     crb = corrected Cramer-Rao bounds accounting for colored residuals.
%    crbo = conventional Cramer-Rao bounds.
%       y = model output vector time history.
%       p = vector of parameter estimates.
%      sv = vector of singular values of the information matrix.
%

%
%    Calls:
%      misvd.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      11 Mar 1998 - Created and debugged, EAM.
%      12 Apr 2001 - Made svlim input optional, EAM.
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
[npts,np]=size(x);
if nargin<3 | isempty(svlim) 
  svlim=eps*npts;
end
if svlim <=0
  svlim=eps*npts;
end
xtx=x'*x;
%xtxi=inv(xtx);
[xtxi,sv]=misvd(xtx,svlim);
z=z(:,1);
p=xtxi*x'*z;
y=x*p;
v=z-y;
s2=(v'*v)/(npts-np);
crbo=s2*xtxi;
sen=x;
%
%  Compute a biased estimate of the residual autocorrelation, 
%  because the unbiased calculation has undesirable end effects
%  in the autocorrelation estimate.  
%
rvv=xcorr(v,'biased');
nmid=npts;
rvvmat=zeros(npts,npts);
for k=1:npts,
  rvvmat(k,:)=rvv(nmid-k+1:nmid-k+npts)';
end
%
%  Corrected Cramer-Rao bound calculation outer loop.
%
%crbsum=zeros(np,np);
%for i=1:npts,
%
%  Inner loop sum.
%
%  Use the fact that rvv(i-j)=rvv(j-i), then add one because 
%  the initial rvv vector index is one, not zero.
%
%  indx=nmid-i+1;
%  sumat=rvv([indx:indx+npts-1])'*sen;
%  crbsum=crbsum + sen(i,:)'*sumat;
%end
crb=xtxi'*sen'*rvvmat*sen*xtxi;
return
