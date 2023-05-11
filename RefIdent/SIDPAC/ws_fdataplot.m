%
%  script ws_fdataplot.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_fdataplot;
%
%  Description:
%
%    Plots columns of workspace data matrix fdata according to user input.  
%
%  Input:
%    
%    fdata = matrix of column vector data.
%        t = time vector corresponding to fdata, sec.
%
%  Output:
%
%    2-D plot
%
%

%
%    Author:  Eugene A. Morelli
%
%    Calls:
%      sid_plot.m
%
%    History:  
%      29 Aug 2000 - Created and debugged, EAM.
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

%
%  Get the listbox value.
%
iypltvar=get(gcbo,'Value');
%
%  Correlate listbox value with fdata variable name.
%
ypltlab=varlab(iypltvar,:);
%
%  Set the plot variables.
%
xpltvar=t;
ypltvar=fdata(:,iypltvar);
%
%  Strip any markers on the plot labels.
%
xpltlab(1)=' ';
ypltlab(1)=' ';
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
