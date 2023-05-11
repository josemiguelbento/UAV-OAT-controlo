%
%  script ws_update.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_update;
%
%  Description:
%
%    Updates the workspace variable list and plots the first variable.
%
%  Input:
%    
%    workspace variables.
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
%      sid_get_varname.m
%      sid_plot.m
%
%    History:  
%      12 Jan 2000 - Created and debugged, EAM.
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
%  Get the workspace variable names.
%
sid_get_varname;
%
%  Set plotted variable to the first workspace variable.
%
set(findobj(gcbf,'Tag','Listbox1'),'Value',1);
iypltvar=1;
%
%  Correlate listbox value with workspace variable name.
%
ypltlab=char(varname(iypltvar));
%
%  Set the ordinate variable for plotting.
%
ypltvar=eval(ypltlab);
%
%  Reset pushbutton display.
%
set(gcbo,'Value',0);
%
%  Reset the listbox display.
%
set(findobj(gcbf,'Tag','Listbox1'),'String',varname);
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
