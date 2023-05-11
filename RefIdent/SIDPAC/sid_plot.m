function sid_plot(x,y,xlab,ylab)
%
%  function sid_plot(x,y,xlab,ylab)
%
%  Usage: sid_plot(x,y,xlab,ylab);
%
%  Description:
%
%    Draws a labeled plot of y versus x.  
%
%  Input:
%
%       x = abscissa vector.
%       y = ordinate vector(s).
%    xlab = x axis label.
%    ylab = y axis label. 
%
%
%  Output:
%
%    2-D plot
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      7 Jan 2000 - Created and debugged, EAM.
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

%
%  Check for data length mismatch.
%
if length(x)~=size(y,1) 
  return
end
%
%  Get the axis handle.
%
AxH=findobj(gcbf,'Tag','Axes1');
%
%  Check the grid status.
%
if strcmp(get(gca,'XGrid'),'on')
  lgrid=1;
else
  lgrid=0;
end
%
%  Plot data, label axes.  Plot modulus 
%  of complex numbers.
%
if isreal(y)
  plot(x,y)
else
  plot(x,abs(y))
end
xlabel(xlab);
ylabel(ylab);
%
%  Restore grid status. 
%
if lgrid==1
  grid on
else
  grid off
end
%
%  Plot title shows the maneuver length.
%
title(['Maneuver length = ',num2str(max(x)-min(x)),' sec']);
return
