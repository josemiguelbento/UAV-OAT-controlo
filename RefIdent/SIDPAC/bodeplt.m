function bodeplt(w,mag,ph)
%
%  function bodeplt(w,mag,ph)
%
%  Usage: bodeplt(w,mag,ph);
%
%  Description:
%
%    Draws a conventional Bode plot for the 
%    frequency range defined by input frequency 
%    vector w in rad/sec.
%
%  Input:
%
%      w = frequency vector, rad/sec.
%    mag = transfer function magnitude vector or matrix, dB.
%     ph = transfer function phase vector or matrix, deg.
%
%  Output:
%
%    graphics:
%      Bode plot
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 Nov  1996 - Created and debugged, EAM.
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
subplot(2,1,1), semilogx(w,mag)
%
%  No tick labels on the upper plot.
%
set(gca,'XTickLabel','')
title('Bode Plot');
ylabel('magnitude, dB');
set(gca,'FontSize',9)
grid on;
subplot(2,1,2), semilogx(w,ph)
xlabel('frequency (rad/sec)');
ylabel('phase, deg');
set(gca,'FontSize',9)
%
%  Move the lower plot up.  
%
pltPos=get(gca,'Position');
pltPos(2)=pltPos(2)+0.04;
set(gca,'Position',pltPos);
grid on;
return
