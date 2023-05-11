%
%  script cut_next.m
%
%  Calling GUI: sid_cut
%
%  Usage: cut_next;
%
%  Description:
%
%    Computes force and moment coefficients, 
%    puts results in fdata, then clears current GUI 
%    and goes to the next GUI.
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
%    fdata = matrix of column vector data cut to the maneuver.
%        t = time vector corresponding to fdata, sec.
%
%

%
%    Calls:
%      sid_odef.m
%      compfc.m
%      compmc.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      11 Jan 2000 - Created and debugged, EAM.
%      18 Jan 2000 - Added force and moment coefficient
%                    calculations, EAM.
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
set(gcbo,'Value',0);
%
%  Save uncut data.
%
to=t;
fdatao=fdata;
%
%  Cut the maneuver using the current fdata index limits.
%
t=t(indi:indf);
fdata=fdata([indi:indf],:);
%
%  Make time vector start at zero.
%
t=t-t(1);
%
%  Compute force and moment coefficients if required 
%  data channels are assigned in standard data array fdata.
%
[CX,CY,CZ,CD,CYW,CL,CT,pv,qv,rv]=compfc(fdata,cbar,bspan,sarea);
fdata(:,[61:63])=[CX,CY,CZ];
fdata(:,[67:69])=[CD,CYW,CL];
fdata(:,70)=CT;
fdata(:,[71:73])=[pv,qv,rv];
[Cl,Cm,Cn]=compmc(fdata,cbar,bspan,sarea);
fdata(:,[64:66])=[Cl,Cm,Cn];
%
%  Mark the calculated channel labels.
%
varlab([61:73],1)=char('*'*ones(13,1));
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
clear indil indfl indio indfo nbi nbf ans ti tf yi yf;
clear CX CY CZ CD CYW CL CT pv qv rv Cl Cm Cn;
clear z zlab u ulab;
%
%  Close the current figure and call the next GUI setup.  
%
close;
sid_dcmp;
return
