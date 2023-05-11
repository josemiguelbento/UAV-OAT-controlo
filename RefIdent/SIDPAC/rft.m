function [X,C] = rft(x,dC,X0,C0)
%
%  function [X,C] = rft(x,dC,X0,C0)
%
%  Usage: [X,C] = rft(x,dC,X0,C0);
%
%  Description:
%
%    Computes and adds a single term to the summation for recursive
%    calculation of the finite discrete Fourier transform, which is 
%
%                  X(w) = sum(x.*exp(-jay*w*t))
%
%    Each row of input X0 is a vector of Fourier transform values
%    from the previous time step for the corresponding element of 
%    the x vector, and C0 is a row vector of Fourier integral values 
%    defined by:
%
%                   C0 = exp(-jay*w*t0)
%
%    from the previous time t0.  Vector w contains the frequencies 
%    in rad/sec for the finite Fourier transform, and jay=sqrt(-1).   
%    Input x is the current value of the time history to be transformed.
%    For a chosen frequency vector w and a fixed sampling interval dt, 
%    input dC is a vector defined by:
%
%                   dC = exp(-jay*w*dt)
%    so that
%                    C = C0.*dC
%    since
%                    t = t0 + dt
%
%  Input:
%    
%     x = current value of the input time history vector.
%    dC = constant multiplicative increments for C0. 
%    X0 = complex Fourier transform values for x, last time step.
%    C0 = Fourier integral values, last time step.
%
%  Output:
%
%     X = complex Fourier transform values for x, current time step.
%     C = Fourier integral values, current time step.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      05 November 1999 - Created and debugged, EAM.
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
%  Apply the recursive discrete Fourier transform, 
%  X(w) = sum(x.*exp(-jay*w*t)).
%
X=X0+x*C0;
C=C0.*dC;
return
