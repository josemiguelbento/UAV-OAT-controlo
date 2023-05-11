%
%  script cut_reset.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_reset;
%
%  Description:
%
%    Reset the workspace flight test data plot
%    to its original form before any cuts.
%
%  Input:
%    
%    fdata = matrix of column vector data.
%        t = time vector corresponding to fdata, sec.
%    indio = original initial fdata index.
%    indfo = original final fdata index.
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
%  Reset the standard flight test data matrix fdata 
%  indices to their original uncut values.
%
indi=indio;
indf=indfo;
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
