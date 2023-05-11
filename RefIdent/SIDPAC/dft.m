function [X,f] = dft(x,t)
%
%  function [X,f] = dft(x,t)
%
%  Usage: [X,f] = dft(x,t);
%
% 
%  Description:   
% 
%    Computes the discrete Fourier transform
%    for an input vector or matrix x, with the  
%    maximum number of frequency points = size(x,1).  
%    The routine is vectorized, so x can be a matrix of 
%    column vectors.  The discrete Fourier transform 
%    is computed by the definition, with no FFT algorithm. 
%
%  Input:
%
%    x =  vector or matrix of time history data.  
%    t =  time vector, sec.
%
%  Output:
%
%    X = discrete Fourier transform.
%    f = frequency vector, Hz.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      05 Nov 2001 - Created and debugged, EAM.
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
[N,n]=size(x);
dt=1/round(1/(t(2)-t(1)));
%
%  Discrete frequency vector.
%
f=[0:1:N-1]'/N;
jay=sqrt(-1);
%
%  The discrete Fourier transform basis functions 
%  are in the rows of Wki. 
%
Wki=exp(-2*pi*jay*f*[0:1:N-1]);
%
%  Compute the discrete Fourier transform the hard way.
%
X=Wki*x;
%
%  Dimensionalize the frequency vector.
%
f=f*(1/dt);
return
