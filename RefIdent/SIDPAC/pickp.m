function [px,py] = pickp(x,y)
%
%  function [px,py] = pickp(x,y)
%
%  Usage: [px,py] = pickp(x,y);
%
%  Description:
%
%    Uses the mouse to select a point on a plot of y 
%    against x in the figure window.  
%
%  Input:
%
%    x = vector of abscissa data for the plot.
%    y = vector of ordinate data for the plot.
%
%  Output:
%
%    px = x value of the selected point.
%    py = y value of the selected point.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 Oct 2000 - Created and debugged, EAM.
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
fprintf('\n\nSelect a point on the graph\n')
[px,py]=ginput(1);
%
%  Find nearest x vector element.
%
%xil=max(find(x<=px));
%xih=min(find(x>px));
%if abs(px-x(xil)) < abs(x(xih)-px)
%   px=x(xil);
%   py=y(xil);
%else
%   px=x(xih);
%   py=y(xih);
%end
hold on
plot(px,py,'mx')
hold off
fprintf('\n\nSelected point:\n\n')
fprintf('  px = %f    py = %f \n\n',px,py)
return
