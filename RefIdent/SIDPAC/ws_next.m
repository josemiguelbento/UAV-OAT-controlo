%
%  script ws_next.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_next;
%
%  Description:
%
%    Clears current GUI and goes to the next GUI.
%
%

%
%    Author:  Eugene A. Morelli
%
%    Calls:
%      sid_cut.m
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
%  Workspace Next pushbutton script.
%
%
%  Reset pushbutton display.
%
set(gcbo,'Value',0),
%
%  Clear the figure window.
%
clf;
%
%  Remove all graphics handles.
%
clear *H;
%
%  Clean up auxiliary workspace variables.
%
clear fact n ncnv cnv ans;
%
%  Close the current figure and call the next GUI setup.  
%
close;
sid_cut;
return
