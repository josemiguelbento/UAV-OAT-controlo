%
%  script sid_grid.m
%
%  Calling GUI: sid_ws, sid_cut, sid_dcmp
%
%  Usage: sid_grid;
%
%  Description:
%
%    Toggles the grid on a 2-D plot according to user input.
%
%  Input:
%    
%    None
%
%  Output:
%
%     2-D plot
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 Jan 2000 - Created and debugged, EAM.
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
%  Grid switch function.
%
if get(gcbo,'Value')==1
  grid on;
else
  grid off;
end
return
