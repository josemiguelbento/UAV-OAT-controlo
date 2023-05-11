function zmat = plotsurf(xmin,xmax,ap,iap,xlab,ylab,zlab)
%
%  function zmat = plotsurf(xmin,xmax,ap,iap,xlab,ylab,zlab)
%
%  Usage: zmat = plotsurf(xmin,xmax,ap,iap,xlab,ylab,zlab);
%
%
%  Description:
%
%    Computes and plots a surface based on input
%    independent variable limit vectors xmin and 
%    xmax, using ap and iap to compute output values
%    of zmat.  Inputs xlab, ylab, and zlab are optional.
%
%  Input:
%    
%   xmin = vector of minimum independent variable values.
%   xmax = vector of maximum independent variable values.
%     ap = parameter vector for ordinary polynomial function expansion.
%    iap = vector of integer indices for ordinary polynomial functions.
%   xlab = x axis label. 
%   ylab = y axis label. 
%   zlab = z axis label. 
%
%  Output:
%
%    zmat = matrix of model values corresponding to xvec and yvec.
%
%    graphics:
%      3-D plot
%

%
%    Calls:
%      cvec.m
%      normx.m
%      comfun.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 Dec 2000 - Created and debugged, EAM.
%      10 Mar 2002 - Repaired comments, EAM.
%
%
%  Copyright (C) 2000  Eugene A. Morelli
%
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
xmin=cvec(xmin);
xmax=cvec(xmax);
%
%  Use 10 intervals for each independent variable.
%
m=10;
xvec=[xmin(1):(xmax(1)-xmin(1))/m:xmax(1)]';
yvec=[xmin(2):(xmax(2)-xmin(2))/m:xmax(2)]';
%
%  Normalized independent variables are needed
%  to compute the model output properly.
%
xc=normx([xvec,yvec],xmin,xmax);
%
%  Compute the model outputs.
%
zmat=zeros(m+1,m+1);
for i=1:m+1,
  for j=1:m+1,
    zmat(i,j)=comfun([xc(i,1),xc(j,2)],ap,iap);
  end
end
%
%  Plot the model output zmat using a 3D surface plot.
%
h=surf(xvec,yvec,zmat');
set(h,'EdgeColor','interp','FaceColor','interp');
%
%  Set view and label axes.
%
grid on;
view(-45,30);
%set(gca,'YLim',[-20,100])
if nargin < 5
  xlabel('x');
else
  xlabel(xlab);
end
if nargin < 6
  ylabel('y');
else
  ylabel(ylab);
end
if nargin < 7
  zlabel('z');
else
  zlabel(zlab);
end
return
