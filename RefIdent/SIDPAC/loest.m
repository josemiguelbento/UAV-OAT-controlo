function [y,num,den,tau,p,crb,s2,zr,xr,f,cost]=loest(u,z,t,nord,dord,w,tau0)
%
% function [y,num,den,tau,p,crb,s2,zr,xr,f,cost] = loest(u,z,t,nord,dord,w,tau0)
%
% Usage: [y,num,den,tau,p,crb,s2,zr,xr,f,cost] = loest(u,z,t,nord,dord,w,tau0);
%
% Description:
%
%    Estimates the parameters for a constant coefficient single-
%    input, single-output (SISO) low order equivalent system (LOES)
%    transfer function model with numerator order nord, denominator
%    order dord, and equivalent time delay tau.  
%    The parameter estimation uses the equation error formulation
%    with complex least squares regression in the frequency domain.  
%    A golden section line search is used to determine  
%    the equivalent time delay corresponding to the minimum
%    time / frequency domain cost.  
%
%  Input:
%    
%       u = control vector time history.
%       z = measured output vector time history.
%       t = time vector, sec.
%    nord = transfer function model numerator order.
%    dord = transfer function model denominator order.
%       w = frequency vector, rad/sec.
%    tau0 = initial value for the equivalent time delay parameter tau.
%
%  Output:
%
%       y = model output time history.
%     num = vector of numerator parameter estimates in descending order.
%     den = vector of denominator parameter estimates in descending order.
%     tau = estimated equivalent time delay.
%       p = vector of parameter estimates.
%     crb = estimated parameter covariance matrix.  
%      s2 = equation error variance estimate.
%      zr = complex dependent variable vector for the linear regression.
%      xr = complex independent variable matrix for the linear regression.
%       f = frequency vector for the complex Fourier transformed data, Hz.
%    cost = value of the minimum cost.
%
%

%
%    Calls:
%      fint.m
%      tfregr.m
%      lesq.m
%      gold.m
%      tau_cost.m
%      tfsim.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      03 Aug 1999 - Created and debugged, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
maxloops=500;
tol=1.0e-06;
t=t(:,1);
u=u(:,1);
z=z(:,1);
p=zeros(nord+1+dord,1);
p0=-99*ones(length(p),1);
%
%  Use tau0 as an initial guess for tau, if tau0 is provided.  
%  Otherwise, start with tau=0.250 sec.
%
if nargin < 7
  ta=0;
  tc=0.5;
else
  ta=0;
  tc=2*tau0;
end
tau=(ta+tc)/2;
tau0=-99;
cost=1000;
%
%  Compute the zoom Fourier transforms.
%
U=fint(u,t,w);
Z=fint(z,t,w);
f=w/(2*pi);
jw=sqrt(-1)*w;
%
%  Iterative parameter estimation starts here.
%
nloops=0;
fprintf(1,'\n');
while nloops<=maxloops & norm(tau-tau0,2)>tol & norm(p-p0,2)>tol,
  if mod(nloops,5)==0,
    fprintf(1,'\n After %3.0f iterations: ',nloops);
    fprintf(1,' minimum cost = %11.4e at lag = %11.4e sec \n',cost,tau);
  end
%
%  Current parameters are now parameters from the previous iteration.
%
  p0=p;
  tau0=tau;
%
%  Implement the pure time delay.
%
  Ul=U.*exp(-jw*tau0);
%
%  Arrange the data for the complex least squares estimation.
%
  [zr,xr]=tfregr(Ul,Z,nord,dord,w);
%
%  Least squares solution, including the parameter covariance 
%  matrix, crb, and the model error variance estimate, s2.
%
  [yr,p,crb,s2]=lesq(xr,zr);
%
%  The cost can be computed in the time domain for least squares 
%  in the frequency domain, because of Parseval's theorem.  
%
%cost=0.5*(z-y)'*(z-y);
  f0=0.5*(zr-yr)'*(zr-yr);
%
%  Estimate a new time delay for fixed parameters p
%  using a golden section line search.  
%
  [tau,cost]=gold('tau_cost',U,Z,nord,dord,p,w,ta,tau0,tc,f0,tol);
  nloops=nloops + 1;
end
%
%  Compute final results.
%
Ul=U.*exp(-jw*tau);
[zr,xr]=tfregr(Ul,Z,nord,dord,w);
[yr,p,crb,s2]=lesq(xr,zr);
cost=0.5*(zr-yr)'*(zr-yr);
%
%  Unscramble the parameter vector.
%
np=length(p);
num=p(1:nord+1)';
den=[1,p(nord+2:np)'];
%
%  Find the parameter error measure for tau, using the 
%  analytic sensitivity of the equation error output to tau.
%
dyrdt=(xr.*[-jw(:,ones(1,nord+1)),zeros(length(w),dord)])*p;
%
%  Add tau to the estimated parameter vector.
%
p=[p;tau];
%
%  Re-compute the parameter covariance matrix, including 
%  the tau parameter.  
%
xr=[xr,dyrdt];
crb=s2*inv(real(xr'*xr));
%
%  Time domain simulated output.
%
y=tfsim(num,den,tau,u,t);
if nloops <= maxloops,
  fprintf(1,'\n\n Converged after %3.0f iterations: ',nloops);
  fprintf(1,'\n\n     minimum cost = %11.4e at lag = %11.4e sec\n',cost,tau);
  fprintf(1,'\n\n CONVERGENCE CRITERIA SATISFIED \n\n');
end
return
