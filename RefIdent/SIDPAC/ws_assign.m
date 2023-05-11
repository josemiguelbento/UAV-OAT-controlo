%
%  script ws_assign.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_assign;
%
%  Description:
%
%    Assigns plotted variables to columns in the 
%    standard workspace flight test data matrix fdata, 
%    according to user input.  
%
%  Input:
%    
%    varname = cell array of workspace variable names.
%    workspace variables
%
%  Output:
%
%    fdata = standard workspace flight test data matrix.
%
%

%
%    Author:  Eugene A. Morelli
%
%    Calls:
%      ws_mrk_chnl.m
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
%  Reset pushbutton display.
%
set(gcbo,'Value',0),
%
%  Assign the plotted variable to the selected standard fdata channel. 
%
PuH=findobj(gcbf,'Tag','Popupmenu1');
n=get(PuH,'Value');
fdata(:,n)=fact*ypltvar;
%
%  Mark or clear the assigned channel in the list.
%
if fact==0
  varlab=ws_mrk_chnl(varlab,-n);
else
  varlab=ws_mrk_chnl(varlab,n);
end
%
%  Refresh the variable list for the fdata popupmenu.
%
set(PuH,'String',varlab);
%
%  Set the popupmenu value to the next fdata channel 
%  without exceeding nchnls.
%
set(PuH,'Value',min([n+1,nchnls]));
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
