function cmpplt(z,y,t)
%
%  function cmpplt(z,y,t)
%
%  Usage: cmpplt(z,y,t);
%
%  Description:
%
%    Plots z, y, and z-y versus t 
%    in the current figure window.  
%
%  Input:
%    
%     y = model vector time history.  
%     z = measured vector time history.
%     t = time vector, sec.
%
%  Output:
%
%    graphics:
%      2-D plots
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      8 Sept 2000 - Created and debugged, EAM.
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
z=z(:,1);
y=y(:,1);
t=t(:,1);
npts=length(t);
if npts~=length(z) | npts ~=length(y)
  fprintf('\n Input vector lengths are not consistent \n\n');
  return
end
subplot(2,1,1);plot(t,[z,y]);
grid on;legend('z','y');
subplot(2,1,2);plot(t,z-y);
grid on;legend('residual z-y');
return
