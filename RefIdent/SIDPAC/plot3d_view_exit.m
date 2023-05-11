%
%  script plot3d_view_exit.m
%
%  Calling m-file: plot3d_view.m
%
%  Usage: plot3d_view_exit;
%
%  Description:
%
%    Exits from plot3d_view.m, and refreshes the 3D plot.
%
%  Input:
%
%    None
%
%  Output:
%
%    graphics:
%      3D plot
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      20 Apr  2002 - Created and debugged, EAM.
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

%
%  Find which mouse button was pressed.
%
stype=get(gcf,'SelectionType');
%
%  Zoom in for a left button click.  
%  Zoom out for a shift + left button click.  
%
if strcmp(stype,'normal')
  zoom(10/9);
  zfac=zfac*10/9;
elseif strcmp(stype,'extend')
  zoom(9/10);
  zfac=zfac*9/10;
elseif strcmp(stype,'alt')
%
%  Kick out of the view changing loop, 
%  stop finding the current point in the figure window,
%  reset the WindowButtonDownFcn for the figure window, 
%  then restore the original 3D plot view.
%
  lcont=0;
  set(gcf,'WindowButtonDownFcn','');
  set(gcf,'WindowButtonMotionFcn','');
  grid on;
  view(45,30);
  zoom(1/zfac);
end
clear AxAz AxEl stick center k pt;
clear AxPos FigCtr FigPos ssize;
clear zfac stype;
return
