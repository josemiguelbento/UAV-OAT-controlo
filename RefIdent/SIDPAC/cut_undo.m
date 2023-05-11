%
%  script cut_undo.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_undo;
%
%  Description:
%
%    Undo a maneuver cut of the workspace flight test data matrix fdata.
%
%  Input:
%    
%    fdata = matrix of column vector data.
%        t = time vector corresponding to fdata, sec.
%    indil = previous initial fdata index.
%    indfl = previous final fdata index.
%
%  Output:
%
%     2-D plot.
%
%

%
%    Calls:
%      sid_plot.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 Jan 2000 - Created and debugged, EAM.
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
%  Undo the maneuver cut by restoring the last index limits.
%
indi=indil;
indf=indfl;
%
%  Set plot variables.
%
xpltvar=t(indi:indf);
ypltvar=fdata([indi:indf],iypltvar);
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
