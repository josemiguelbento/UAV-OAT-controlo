function [y,p,crb,ph,seh,crbh] = slesq(x,z,nint,nstep,p0,crb0)
%
%  function [y,p,crb,ph,seh,crbh] = slesq(x,z,nint,nstep,p0,crb0)
%
%  Usage: [y,p,crb,ph,seh,crbh] = slesq(x,z,nint,nstep,p0,crb0);
%
%  Description:
%
%    Computes sequential least squares estimate of parameter vector p, 
%    where the assumed model structure is y=x*p, and z is the 
%    measured output.  Parameters are estimated over intervals of 
%    nint points, each of which are offset by nstep points.  Inputs 
%    specifying initial estimated parameter vector p0 and initial 
%    estimated parameter covariance matrix crb0 are optional.  
%
%  Input:
%    
%     x  = matrix of column regressors.
%     z  = measured output vector.
%   nint = no. of points for each parameter estimation interval (default=50).
%  nstep = no. of points for offsets of the parameter estimation intervals (default=25). 
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
%

%
%    Calls:
%      cvec.m
%      lesq.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Aug  2001 - Created and debugged, EAM.
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
  nint=50;
end
if nargin < 4
  nstep=25;
end
if nargin < 5
  p0=zeros(np,1);
end
if nargin < 6
  crb0=zeros(np,np);
end
%
%  Find the number of sequential parameter estimates.
%
nest=floor(npts/nstep);
%
%  Initialization.
%
ph=zeros(nest,np);
seh=zeros(nest,np);
crbh=zeros(nest,np,np);
p0=cvec(p0);
s20=1;
pk=p0;
crbk=crb0;
s2k=s20;
ph(1,:)=p0';
seh(1,:)=sqrt(diag(crb0))';
crbh(1,:,:)=crb0;
y=zeros(nint,1);
%
%  Sequential parameter estimation loop.
%
for k=1:nest,
%
%  Data interval for the current sequential parameter estimation.
%
  indx=[(k-1)*nstep+1:(k-1)*nstep+nint];
%
%  Limit the index to the maximum number of data points.
%
  indx=indx(find(indx<=npts));
  fprintf('\n Interval %1i = [%4i :%4i] \n',k,min(indx),max(indx)),
%
%  Sequential parameter estimation using batch least squares.
%
  xk=x(indx,:);
  zk=z(indx);
  [yk,pk,crbk,s2k]=lesq(xk,zk,p0,crb0,s20);
%  [yk,pk,crbk,s2k]=lesq(xk,zk);
%
%  Record results.
%
  ph(k,:)=pk';
  seh(k,:)=sqrt(diag(crbk))';
  crbh(k,:,:)=crbk;
  if k==1
    y=yk;
  else
    y(indx)=yk;
  end
%
%  Initial estimates for next loop.
%
  p0=pk;
  crb0=crbk;
  s20=s2k;
end
fprintf('\n'),
y=y(1:npts);
p=pk;
crb=crbk;
return
