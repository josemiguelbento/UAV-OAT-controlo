function [val,valo,corfac,endcor,f,H] = fint(h,t,w)
%
%  function [val,valo,corfac,endcor,f,H] = fint(h,t,w)
%
%  Usage: [val,valo,corfac,endcor,f,H] = fint(h,t,w);
%
%  Description:
%
%    Evaluates the finite Fourier integral whose integrand is 
%
%                  h(t).*exp(-jay*w(k)*t)
%
%    over the time defined by vector t, for each (kth) 
%    element of w, where w is a vector of frequencies in rad/sec.  
%    Multiplicative and endpoint corrections are made  
%    using third order Filon coefficients, so that
%    the integral is evaluated with high accuracy. 
%    Arbitrary frequency resolution is achieved using a 
%    modified discrete Fourier transform called the chirp z-transform.
%
%  Input:
%    
%     h = matrix of column vector time histories in the Fourier integral.
%     t = time column vector, sec.
%     w = frequency vector for the zoom Fourier transform, rad/sec.
%
%  Output:
%
%      val = complex value of the Fourier integral.  
%     valo = complex value of the Fourier integral without corrections.
%   corfac = multiplicative correction factor for the 
%            discrete Fourier transform.
%   endcor = additive correction for the endpoints. 
%        f = frequency vector for the zoom Fourier transform, Hz.
%        H = complex zoom Fourier transform vector corresponding to h.
%

%
%    Calls:
%      ficor.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     08 May 1996 - Created and debugged, EAM.
%     02 Mar 2000 - Allow row or column vector w input, EAM.
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
t=t(:,1);
%
%  Define constants.
%
[npts,nsigs]=size(h);
dt=t(2)-t(1);
jay=sqrt(-1);
a=t(1);
b=t(npts);
M=length(w);
val=zeros(M,nsigs);
valo=val;
%
%  Apply the zoom Fourier transform.
%
f0=w(1)/(2*pi);
f1=w(M)/(2*pi);
df=(f1-f0)/(M-1);
A=exp(jay*2*pi*f0*dt);
if M > 1
  phi=2*pi*df*dt;
else
  phi=0;
end
%
%  Fourier transform definition: H(f)=integral[h(t).*exp(-jay*w*t)dt] on [a,b].
%  Program czt switches the sign of the exponent of Z (i.e., jay*phi).
%
Z=exp(-jay*phi);
H=czt(h,M,Z,A);
%
%  Compute the associated frequencies.
%
if M > 1
  f=[f0:df:f1]';
else
  f=f0;
end
w=2*pi*f;
%
%  Compute multiplicative and endpoint corrections.
%
for j=1:nsigs,
  [corfac,endcor]=ficor(h(:,j),t,w);
%
%  Do the final calculations, including corrections.
%
  val(:,j)=dt*exp(-jay*w*a).*(corfac.*H(:,j) + endcor);
  valo(:,j)=dt*exp(-jay*w*a).*H(:,j);
end
return
