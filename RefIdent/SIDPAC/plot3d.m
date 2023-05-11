function [zmat,xvec,yvec] = plot3d(x,z,xlab,ylab,zlab,pbtn)
%
%  function [zmat,xvec,yvec] = plot3d(x,z,xlab,ylab,zlab,pbtn)
%
%  Usage: [zmat,xvec,yvec] = plot3d(x,z,xlab,ylab,zlab,pbtn);
%
%
%  Description:
%
%    Computes independent variable vectors xvec and 
%    yvec using the unique elements of the first two 
%    columns in regressor matrix x.  Output zmat is 
%    the corresponding matrix of z values needed for 
%    3D plotting.  Input dependent variable z
%    is normally a vector from a regression problem.  
%    The routine creates a 3D plot of z as a 
%    function of xvec and yvec, with axis labels xlab, 
%    ylab, and zlab for the x, y, and z axes, respectively.  
%    Input z can also be a matrix of dependent variable  
%    vectors - zmat is then a 3 dimensional array, 
%    and multiple 3D plots are drawn.  Input pbtn 
%    controls the addition of Rotate View and Close 
%    pushbuttons in the figure window.  Inputs xlab, 
%    ylab, zlab, and pbtn are optional.
%
%  Input:
%    
%      x = matrix of column vectors for two independent variables. 
%      z = vector or matrix of corresponding dependent variable(s).
%   xlab = x axis label. 
%   ylab = y axis label. 
%   zlab = z axis label. 
%   pbtn = flag for Rotate View and Close pushbuttons:
%          = 1 to add Rotate View and Close pushbuttons.
%          = 0 to omit all pushbuttons (default).
%
%  Output:
%
%    zmat = matrix of z elements corresponding to xvec and yvec.
%    xvec = vector of unique elements of x(:,1).
%    yvec = vector of unique elements of x(:,2).
%
%    graphics:
%      3D plot
%

%
%    Calls:
%      x_values.m
%      unstk_data.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      23 June 1999 - Created and debugged, EAM.
%      24 May  2001 - Modified default view, EAM.
%      20 Apr  2002 - Added Rotate and Close buttons, 
%                     modified to use current figure and axes, EAM.
%      02 May  2002 - Added pbtn flag to make pushbuttons optional, EAM.
%
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
[npts,n]=size(z);
%
%  Arrange the data for 3D plotting.
%
[xval,nval]=x_values(x(:,[1:2]));
[zmat,xvec,yvec]=unstk_data(z(:,1),x(:,[1:2]),xval,nval);
%
%  Plot the first column of z using a mesh plot.  
%  EdgeColor must be set to 'interp' for smooth
%  rotated views of the mesh plot alone.
%
clf,
hm=mesh(xvec,yvec,zmat);
set(hm,'EdgeColor','interp');
%
%  Plot additional columns of z using a surface plot.
%
if n > 1
  ztmp=zmat;
  [nr,nc]=size(ztmp);
  zmat=zeros(nr,nc,n);
  zmat(:,:,1)=ztmp;
  for j=2:n,
    zmat(:,:,j)=unstk_data(z(:,j),x(:,[1:2]),xval,nval);
    h=surface(xvec,yvec,squeeze(zmat(:,:,j)));
    set(h,'EdgeColor','interp','FaceColor','interp');
  end
end
%
%  Set view and label axes.
%
grid on;
view(45,30);
%
%  Freeze the aspect ratio properties
%  so the plot is the same when rotated.
%
axis vis3d;
%
%  Set the figure units to normalized 
%  so that user control of the 
%  plot rotation works properly.  
%
set(gcf,'Units','normalized');
%
%  Axis labeling.
%
if nargin < 3
  xlabel('x');
else
  xlabel(xlab);
end
if nargin < 4
  ylabel('y');
else
  ylabel(ylab);
end
if nargin < 5
  zlabel('z');
else
  zlabel(zlab);
end
%
%  Z axis label orientation.
%
%if nargin < 5
%  zlabel('z','Rotation',0);
%else
%  zlabel(zlab,'Rotation',0);
%end
if nargin < 6
  pbtn=0;
end
if pbtn==1
%
%  Information for all buttons.
%
  yPos=0.08;
  xPos=0.90;
  btnHt=0.045;
  btnWid=0.095;
  spacing=0.06;
%
%  Rotate button.
%
  uicontrol( 'Style','pushbutton', ...
             'Units','normalized', ...
             'Position',[xPos yPos btnWid btnHt], ...
             'String','Rotate', ...
             'Callback','plot3d_view;');
%
%  Close button.
%
  uicontrol( 'Style','pushbutton', ...
             'Units','normalized', ...
             'Position',[xPos yPos-spacing btnWid btnHt], ...
             'String','Close', ...
             'Callback',['set(gcf,''WindowButtonDownFcn'','''');', ...
                         'clear lcont; close(gcf);']);
end
return
