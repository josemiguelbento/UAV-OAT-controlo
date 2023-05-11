function mdlerr = model_err(z,s2,zlab,x,xlab)
%
%  function mdlerr = model_err(z,s2,zlab,x,xlab)
%
%  Usage: mdlerr = model_err(z,s2,zlab,x,xlab);
%
%  Description:
%
%    Plots the measured output z against x on the  
%    same plot with the model error corresponding 
%    to plus or minus 2*sqrt(s2).  This routine 
%    can be used to show the size of 
%    output variation that will be considered 
%    deterministic for modeling purposes.  
%
%
%  Inputs:
%    
%      z = vector of measured outputs.
%     s2 = error variance for z.  
%   zlab = ordinate label (optional).
%      x = vector of abscissa values (optional).
%   xlab = abscissa label (optional).
%
%
%  Output:
%
%   mdlerr = output error corresponding to sqrt(s2).  
%
%    graphics:
%      2D plot
%
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      09 Sept 2001 - Created and debugged, EAM.
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
z=cvec(z);
npts=length(z);
%
%  Plot z and the model error 
%  corresponding to 2*sqrt(s2).  
%
mdlerr=2*sqrt(s2);
if nargin < 3
  zlab='z';
end
if nargin < 4
  x=[1:1:npts]';
end
x=cvec(x);
if nargin < 5
  xlab='Observation';
end
plot(x,z),
hold on,
%
%  Put the output standard error bar
%  at approximately 1.5 percent of the 
%  plotted abscissa length.  
%
indx=round(0.015*npts);
zu=z(indx)+mdlerr;
zl=z(indx)-mdlerr;
plot([x(indx);x(indx)],[zl;zu],'r','LineWidth',2),
plot(x(indx),zl,'r^',x(indx),zu,'rv','MarkerSize',3)
grid on,
legend('Measured Output','Maximum Unmodeled Variation',0)
xlabel(xlab),ylabel(zlab),
hold off
return
