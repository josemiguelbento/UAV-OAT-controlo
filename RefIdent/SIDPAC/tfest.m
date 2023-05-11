function [y,num,den,p,crb,s2,zr,xr,f,cost] = tfest(u,z,t,nord,dord,w)
%
% function [y,num,den,p,crb,s2,zr,xr,f,cost] = tfest(u,z,t,nord,dord,w)
%
% Usage: [y,num,den,p,crb,s2,zr,xr,f,cost] = tfest(u,z,t,nord,dord,w);
%
% Description:
%
%    Estimates the parameters for a constant coefficient 
%    single-input, single-output (SISO) transfer function
%    model with numerator order nord and denominator order dord.
%    The parameter estimation uses the equation error formulation
%    with complex least squares regression in the frequency domain.
%
%  Input:
%    
%    u    = measured input time history.
%    z    = measured output time history.
%    t    = time vector, sec.
%    nord = transfer function model numerator order.
%    dord = transfer function model denominator order.
%    w    = frequency vector, rad/sec.
%
%  Output:
%
%    y    = model output time history.
%    num  = vector of numerator parameter estimates in descending order.
%    den  = vector of denominator parameter estimates in descending order.
%    p    = vector of parameter estimates.
%    crb  = estimated parameter covariance matrix.
%    s2   = equation error variance estimate.
%    zr   = complex dependent variable vector for the linear regression.
%    xr   = complex independent variable matrix for the linear regression.
%    f    = frequency vector for the complex Fourier transformed data, Hz.
%    cost = value of the cost for the complex least squares estimation.
%

%
%    Calls:
%      cvec.m
%      fint.m
%      tfregr.m
%      lesq.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     02 Sept 1997 - Created and debugged, EAM.
%     02 Mar  2000 - Allow row or column vector w input, EAM.
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
u=u(:,1);
z=z(:,1);
t=t(:,1);
w=cvec(w);
%
%  Compute the zoom Fourier transforms.
%
U=fint(u,t,w);
Z=fint(z,t,w);
f=w/(2*pi);
%
%  Arrange the data for the complex least squares estimation.
%
[zr,xr]=tfregr(U,Z,nord,dord,w);
%
%  Least squares solution, including the parameter covariance 
%  matrix, crb, and the model error variance estimate, s2.
%
[yr,p,crb,s2]=lesq(xr,zr);
%
%  Unscramble the parameter vector.
%
num=p(1:nord+1)';
den=[1,p(nord+2:nord+1+dord)'];
%
%  Time domain simulated output.
%
y=lsim(num,den,u,t);
%
%  Compute the cost in the time domain for least squares in the
%  frequency domain.  This can be done because of Parseval's theorem.  
%
%cost=0.5*(zr-yr)'*(zr-yr);
cost=0.5*(z-y)'*(z-y);
return
