%
%  script cut_cutftd.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_cutftd;
%
%  Description:
%
%    Cuts workspace flight test data matrix fdata 
%    according to user input.  
%
%  Input:
%    
%    fdata = matrix of column vector data.
%        t = time vector corresponding to fdata, sec.
%
%  Output:
%
%     indi = initial fdata index for the maneuver.
%     indf = final fdata index for the maneuver.
%    indil = previous value of indi.
%    indfl = previous value of indf.
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
%  Save uncut data indices for undo.
%
indil=indi;
indfl=indf;
%
%  Turn on the help text box.
%
TbH=findobj(gcbf,'Tag','Text1');
set(TbH,'String',['                                    ';...
                  'Select initial time on the graph.   ';...   
                  'Use the right mouse button for      ';...
                  'manual input in the command window. ';...
                  '                                    ']);
set(TbH,'Visible','on');
%
%  Initial time input.
%
[ti,yi,nbi]=ginput(1);
if nbi~=1,
  ti=input('\n\nInput initial time  ');
  tf=input('\nInput final time  ');
else
%
%  Update the help text box.
%
  set(TbH,'String',['                                    ';...
                    'Select final time on the graph.     ';...   
                    '                                    ';...
                    '                                    ';...
                    '                                    ']);
%
%  Final time input.
%
  [tf,yf,nbf]=ginput(1);
  if nbf~=1,
    tf=input('\nInput final time  ');
  end
end
%
%  Initial time data conditioning.
%
if ti < 0 
  ti=0;
end
dt=1/round(1/(t(2)-t(1)));
ti=round(ti/dt)*dt;
fprintf('\n\nSelected initial time = %f \n',ti);
indi=max(find(t<=ti));
%
%  Final time data conditioning.
%
if tf <= 0 | tf > max(t),
  tf=max(t);
end
tf=round(tf/dt)*dt;
fprintf('\nSelected final time = %f \n\n\n',tf);
indf=min(find(t>=tf));
%
%  Turn off the help text box and 
%  return control to the command window.
%
set(TbH,'Visible','off');
%
%  Set plot variables for the cut maneuver.
%
xpltvar=t(indi:indf);
ypltvar=fdata([indi:indf],iypltvar);
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
