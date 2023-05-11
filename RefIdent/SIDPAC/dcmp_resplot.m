%
%  script dcmp_resplot.m
%
%  Calling GUI: sid_dcmp
%
%  Usage: dcmp_resplot;
%
%  Description:
%
%    Plots data compatibility analysis residuals 
%    according to user input.
%
%  Input:
%    
%    fdata = matrix of measured flight data in standard configuration.
%        t = time vector, sec.
%       yc = data compatibility model output vector time history.
%
%  Output:
%
%    2-D plots
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      29 Oct 2000 - Created and debugged, EAM.
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
%  Plot the corresponding measured and model data
%  according to the kinematics listbox value.
%
if (get(Pu1H,'Value')==1)
%
%  Rotational kinematics.
%
%  Draw the plot.
%
  axes(Ax1H),plot(t,fdata(:,8)-yc(:,4)*180/pi)
%
%  Get plot label, strip any markers on the plot label, 
%  then label the ordinate.
%
  ypltlab=varlab(8,:);ypltlab(1)=' ';ylabel(ypltlab);
%
%  Second plot.
%
  axes(Ax2H),plot(t,fdata(:,9)-yc(:,5)*180/pi)
  ypltlab=varlab(9,:);ypltlab(1)=' ';ylabel(ypltlab);
%
%  Third plot.
%
  axes(Ax3H),plot(t,fdata(:,10)-yc(:,6)*180/pi)
  ypltlab=varlab(10,:);ypltlab(1)=' ';ylabel(ypltlab);
else
%
%  Translational kinematics.
%
  axes(Ax1H),plot(t,fdata(:,2)-yc(:,1))
  ypltlab=varlab(2,:);ypltlab(1)=' ';ylabel(ypltlab);
  axes(Ax2H),plot(t,fdata(:,3)-yc(:,2)*180/pi)
  ypltlab=varlab(3,:);ypltlab(1)=' ';ylabel(ypltlab);
  axes(Ax3H),plot(t,fdata(:,4)-yc(:,3)*180/pi)
  ypltlab=varlab(4,:);ypltlab(1)=' ';ylabel(ypltlab);
end
%
%  Abscissa label.
%
xpltlab=varlab(1,:);xpltlab(1)=' ';xlabel(xpltlab);
%
%  Grids on or off according to the grid radio button value.
%
if (get(RbH,'Value')==1)
  grid on,axes(Ax2H),grid on,axes(Ax1H),grid on,
else
  grid off,axes(Ax2H),grid off,axes(Ax1H),grid off,
end
%
%  Add the legend to the first plot.
%
legend('Residual',0);
return
