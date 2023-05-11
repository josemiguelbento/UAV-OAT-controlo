%
%  script sid_close.m
%
%  Usage: sid_close;
%
%  Description:
%
%    Clears all the graphic handle variables 
%    and closes the figure window.  
%
%  Input:
%
%     None
%
%  Output:
%
%     None
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      29 Aug 2000 - Created and debugged, EAM.
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
%  Close the figure window.
%
close(FgH);
%
%  Clear the handle variables.
%
clear *H;
%
%  Clear the plot variables.
%
clear xpltvar xpltlab ixpltvar ypltvar ypltlab iypltvar;
return
