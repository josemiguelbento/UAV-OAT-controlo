function cost = tau_cost(tau,U,Z,nord,dord,p,w)
%
%  function cost = tau_cost(tau,U,Z,nord,dord,p,w)
%
%  Usage: cost = tau_cost(tau,U,Z,nord,dord,p,w);
%
%  Description:
%
%    Computes the frequency domain cost for a constant coefficient single-
%    input single-output (SISO) low order equivalent system (LOES)
%    transfer function longitudinal model with numerator order nord, 
%    denominator order dord, nominal transfer function parameters p, 
%    and equivalent time delay tau.  The parameter estimation uses 
%    the equation error formulation with complex least squares 
%    regression in the frequency domain.  This function is used as 
%    input to Matlab m-file fmin.m or gold.m to determine the equivalent 
%    time delay corresponding to the minimum time / frequency domain cost.  
%
%  Input:
%    
%        U = Fourier transform of the control vector time history.
%        Z = Fourier transform of the measured output vector time history.
%     nord = transfer function model numerator order.
%     dord = transfer function model denominator order.
%        p = transfer function model parameter vector.
%        w = frequency vector, rad/sec.
%
%  Output:
%
%     cost = frequency domain cost for the complex least squares regression.
%
%

%
%    Calls:
%      tfregr.m
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
f=w/(2*pi);
nf=length(f);
jw=sqrt(-1)*w;
%
%  Implement the pure time delay.
%
Ul=U.*exp(-jw*tau);
%
%  Arrange the data for the complex least squares estimation.
%
[zr,xr]=tfregr(Ul,Z,nord,dord,w);
%
%  Find the model prediction for this time delay.
yr=xr*p;
%
%  The cost can be computed in the time domain for least squares
%  in the frequency domain, because of Parseval's theorem.  
%
%cost=0.5*(z-y)'*(z-y);
cost=0.5*(zr-yr)'*(zr-yr);
return
