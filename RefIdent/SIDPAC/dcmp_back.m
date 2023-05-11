%
%  script dcmp_back.m
%
%  Calling GUI: sid_dcmp
%
%  Usage: dcmp_back;
%
%  Description:
%
%    Clears current GUI and goes to the previous GUI.
%
%

%
%    Calls:
%      sid_cut.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Oct 2000 - Created and debugged, EAM.
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
clear caselab typelab no xpltlab ypltlab;
%
%  Close the current figure and call the previous GUI setup.  
%
close;
sid_cut;
return
