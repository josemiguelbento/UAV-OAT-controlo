%
%  script cut_plot.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_plot;
%
%  Description:
%
%    Plots columns of workspace data matrix fdata according to user input.  
%
%  Input:
%    
%    fdata = matrix of column vector data.
%        t = time vector corresponding to fdata, sec.
%     indi = initial fdata index for the maneuver.
%     indf = final fdata index for the maneuver.
%
%  Output:
%
%    2-D plot
%
%

%
%    Calls:
%      sid_plot.m
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
xpltvar=t(indi:indf);
ypltvar=fdata([indi:indf],iypltvar);
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
