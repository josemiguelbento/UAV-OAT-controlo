%
%  script cut_back.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_back;
%
%  Description:
%
%    Clears current GUI and goes to the previous GUI.
%

%
%    Calls:
%      sid_ws.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      11 Jan 2000 - Created and debugged, EAM.
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
clear tl fdatal ans ti tf yi yf indi indil indio indf indfl indfo;
%
%  Close the current figure and call the previous GUI setup.  
%
close;
sid_ws;
return
