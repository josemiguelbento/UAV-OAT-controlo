function [y,p,crb,ph,seh,crbh,kh] = rlesq(x,z,ff,p0,crb0)
%
%  function [y,p,crb,ph,seh,crbh,kh] = rlesq(x,z,ff,p0,crb0)
%
%  Usage: [y,p,crb,ph,seh,crbh,kh] = rlesq(x,z,ff,p0,crb0);
%
%  Description:
%
%    Computes recursive least squares estimate of parameter vector p, 
%    where the assumed model structure is y=x*p, ff is the data 
%    forgetting factor, and z is the measured output.
%    Inputs specifying the forgetting factor ff, initial estimated 
%    parameter vector p0 and initial estimated parameter covariance 
%    matrix crb0 are optional.  
%
%  Input:
%    
%     x  = matrix of column regressors.
%     z  = measured output vector.
%     ff = data forgetting factor, usually 0.95 <= ff <= 1.0 (default=1).
%     p0 = initial parameter vector (default=zero vector).
%   crb0 = initial parameter covariance matrix (default=identity matrix).
%
%  Output:
%
%     y = model output using final estimated parameter values.
%     p = estimated parameter vector.
%   crb = estimated parameter covariance matrix.
%    ph = estimated parameter vector sequence.  
%   seh = estimated parameter standard error sequence.
%  crbh = estimated parameter covariance matrix sequence.  
%    kh = recursive least squares innovation weighting vector sequence.  
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      18 Mar  1996 - Created and debugged, EAM.
%      20 Sept 2000 - Updated notation, changed history 
%                     arrays for convenient plotting, EAM.
%      21 Sept 2001 - Added data forgetting factor, EAM.
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
[npts,np]=size(x);
z=z(:,1);
if nargin < 3
  ff=1;
end
if nargin < 4
  p0=zeros(np,1);
end
if nargin < 5
  crb0=eye(np,np);
end
ph=zeros(npts,np);
seh=zeros(npts,np);
crbh=zeros(npts,np,np);
kh=zeros(npts,np);
p0=cvec(p0);
p=p0;
crb=crb0;
ph(1,:)=p0';
seh(1,:)=sqrt(diag(crb0))';
crbh(1,:,:)=crb0;
for k=2:npts,
  xk=x(k,:)';
  kk=crb*xk/(ff + xk'*crb*xk);
  p=p + kk*(z(k) - xk'*p);
  crb=(1/ff)*(crb - crb*xk*xk'*crb/(ff + xk'*crb*xk));
  kh(k,:)=kk';
  ph(k,:)=p';
  seh(k,:)=sqrt(diag(crb))';
  crbh(k,:,:)=crb;
end
y=x*p;
return
