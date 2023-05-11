%
%  script plot3d_view.m
%
%  Calling m-file: plot3d.m
%
%  Usage: plot3d_view;
%
%  Description:
%
%    Changes the 3D plot view, according to user input.
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
%      plot3d_view_exit.m
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
%  Set the initial zoom factor to 1.
%
zfac=1;
%
%  Set Button functions.
%
set(gcf,'WindowButtonDownFcn','plot3d_view_exit;');
set(gcf,'WindowButtonMotionFcn','pt=get(gcf,''CurrentPoint'');');
%
%  Initialize the current pointer position 
%  in the center of the figure window.
%
center=[0.5,0.5];
set(gcf,'CurrentPoint',center);
%
%  Initialize the pointer position on 
%  the screen at the center of 
%  the figure window.  This must be done 
%  because the pointer cannot be positioned
%  in the figure window, only on the screen.
%
FigPos=get(gcf,'Position');
FigCtr=[FigPos(1)+FigPos(3)/2,FigPos(2)+FigPos(4)/2];
ssize=get(0,'ScreenSize');
set(0,'PointerLocation',[ssize(3)*FigCtr(1),ssize(4)*FigCtr(2)]);
%
%  Set up for view changing loop. 
%
stick=[0,0];
axis vis3d;
AxPos=get(gca,'Position');
pt=get(gcf,'CurrentPoint');
lcont=1;
[AxAz,AxEl]=view;
k=[2,2];
%
%  View changing loop.  This loop is terminated
%  when lcont=0, which happens on a 
%  right mouse button click in vis_view_exit.m.  
%
while lcont>0,
%
%  View position control by cursor position.
%
  stick=center-pt;
%
%  Implement azimuth and elevation changes.
%
  if abs(stick(1))>0.05
    AxAz=AxAz+k(1)*stick(1);
  end
  if abs(stick(2))>0.05
    AxEl=AxEl+k(2)*stick(2);
  end
  view(AxAz,AxEl);
  drawnow;
end
return
