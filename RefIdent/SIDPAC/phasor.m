function [mag,ph] = phasor(f)
%
%  function [mag,ph] = phasor(f)
%
%  Usage: [mag,ph] = phasor(f);
%
%  Description:
%
%    Converts a vector of complex numbers (f) into 
%    magnitude (mag) and phase angle (phase) vectors.
%    Phase angle is in degrees.  
%
%  Input:
%
%      f = scalar or vector of complex numbers.
%
%  Output:
%
%    mag = magnitude.
%     ph = phase angle, deg.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      04 Nov 1997 - Created and debugged, EAM.
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
mag=sqrt(real(f).^2 + imag(f).^2);
ph=(180/pi)*atan2(imag(f),real(f));
return
