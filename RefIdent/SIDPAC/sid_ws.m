%
%  script sid_ws.m
%
%  Usage: sid_ws;
%
%  Description:
%
%    Creates GUI for assigning workspace measured variables 
%    to standard data channels in data matrix fdata.  
%    This routine contains all the code to set up the GUI.  
%
%  Input:
%
%    None
%
%  Output:
%
%    GUI
%
%

%
%    Calls:
%      sid_get_varname.m
%      ws_mrk_chnl.m
%      ws_plot.m
%      ws_fdataplot.m
%      ws_convert.m
%      ws_arrayplot.m
%      sid_grid.m
%      ws_assign.m
%      ws_update.m
%      ws_next.m
%      sid_close.m
%      sid_plot.m
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
%  Remove any residual graphic handles, 
%  then get workspace variable names.
%
clear *H;
sid_get_varname;
%
%  If fdata array exists, mark the channels
%  that have already been assigned.
%
if exist('fdata')
  for i=1:size(fdata,2),
    if norm(fdata(:,i))~=0
      varlab=ws_mrk_chnl(varlab,i);
    end
  end
end
clear i;
%
%  Define variable conversion labels.
%
if ~exist('varconvlab')
  varconvlab={'rad to deg';...
              'deg to rad';...
              'ft to m';...
              'm to ft';...
              'ft to in';...
              'in to ft';...
              'g to ft/sec2';...
              'ft/sec2 to g';...
              'ft/sec to kts';...
              'kts to ft/sec';...
              'slug to lbm';...
              'lbm to slug';...
              'kg to slug';...
              'slug to kg';...
              'lbf to N';...
              'N to lbf';...
              'original units'};
end
%
%  GUI set up.
%
%
%  Figure window.
%
FgH=figure('Units','normalized',...
           'Position',[0.352 0.0437 0.64 0.88],...
           'Color',[0.8 0.8 0.8],...
           'Name','Aircraft System IDentification',...
           'NumberTitle','off',...
           'Tag','Fig1',...
           'ToolBar','none');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[0.24 0.45 0.58 0.48],...
         'XGrid','on', 'YGrid','on',...
         'Tag','Axes1');
%
%  GUI heading text box.
%
HTbH=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.375 .97 .3 .025],...
               'String','Assemble the Data',...
               'FontSize',9,...
               'FontWeight','bold',...
               'FontAngle','italic');  
%
%  Listbox for workspace variables.
%
LbH=uicontrol('Style','listbox',...
               'Units','normalized',...
               'Position',[.01 .18 .125 .75],...
               'String',varname,...
               'Value',1,...
               'Tag','Listbox1',...
               'Callback','ws_plot;');
%
%  Text label for workspace variable listbox.
%
TbH=uicontrol('Style','text',...
              'Units','normalized',...
              'Position',[.005 .94 .125 .0475],...
              'String','Workspace variables:',...
              'FontSize',8);  
%
%  Popupmenu for fdata channels.
%
PuH=uicontrol('Style','popupmenu',...
              'Units','normalized',...
              'Position',[.8275 .1 .1725 .75],...
              'FontSize',6,...
              'String',varlab,...
              'Value',1,...
              'Tag','Popupmenu1',...
              'Callback','ws_fdataplot;');
%
%  Text label for fdata channels popupmenu.
%
Tb1H=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.84 .86 .15 .0475],...
               'String','Selected fdata channel:',...
               'FontSize',8);  
%
%  Popupmenu for unit conversion.
%
Pu2H=uicontrol('Style','popupmenu',...
               'Units','normalized',...
               'Position',[.495 -0.43 .115 .75],...
               'String',varconvlab,...
               'Value',1,...
               'Max',17,...
               'Tag','Popupmenu2',...
               'Callback','ws_convert');
%
%  Text label for unit conversion popupmenu.
%
Tb2H=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.5 .325 .08 .02],...
               'String','Convert:',...
               'FontSize',9);  
%
%  Popupmenu for plotting individual columns of 
%  arrays in the workspace.
%
Pu3H=uicontrol('Style','popupmenu',...
               'Units','normalized',...
               'Position',[.25 .05 .08 .14],...
               'FontSize',6,...
               'String',num2str([1:2]'),...
               'Value',1,...
               'Tag','Popupmenu3',...
               'Visible','off',...
               'Callback','ws_arrayplot;');
%
%  Text label for array column plotting.  
%
Tb3H=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.18 .2 .2 .025],...
               'String','Array element column :',...
               'FontSize',9,...
               'Visible','off');
%
%  Popupmenu for plotting individual elements of 
%  vectors in the workspace.
%
Pu4H=uicontrol('Style','popupmenu',...
               'Units','normalized',...
               'Position',[.25 .05 .08 .14],...
               'FontSize',6,...
               'String',num2str([1:2]'),...
               'Value',1,...
               'Tag','Popupmenu4',...
               'Visible','off',...
               'Callback','ws_arrayplot;');
%
%  Text label for vector element plotting.  
%
Tb4H=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.18 .2 .25 .025],...
               'String','Vector element :',...
               'FontSize',9,...
               'Visible','off');
%
%  Text label for scalar plotting.  
%
Tb5H=uicontrol('Style','text',...
               'Units','normalized',...
               'Position',[.18 .2 .2 .025],...
               'String','Scalar :  ',...
               'FontSize',9,...
               'Visible','off');
%
%  Radiobutton for grid.
%
RbH=uicontrol('Style','radiobutton',...
              'Units','normalized',...
              'Position',[.85 .35 .075 .025],...
              'String','Grid',...
              'FontSize',8,...
              'Value',1,...
              'Callback','sid_grid;');
%
%  Pushbutton for assigning fdata channels.
%
PbH=uicontrol('Style','pushbutton',...
              'Units','normalized',...
              'Position',[.85 .25 .1 .04],...
              'String','Assign',...
              'FontSize',9,...
              'FontWeight','bold',...
              'Callback','fact=1;ws_assign;');
%
%  Pushbutton for clearing fdata channels.
%
Pb2H=uicontrol('Style','pushbutton',...
               'Units','normalized',...
               'Position',[.85 .19 .1 .04],...
               'String','Clear',...
               'FontSize',9,...
               'FontWeight','bold',...
               'SelectionHighlight','off',...
               'Callback','fact=0;ws_assign;');
%
%  Pushbutton for updating the workspace variable list.
%
Pb3H=uicontrol('Style','pushbutton',...
               'Units','normalized',...
               'Position',[.175 .28 .22 .04],...
               'String','Update Variable List',...
               'FontSize',9,...
               'Callback','ws_update');
%
%  Pushbutton for moving to the next GUI screen.
%
Pb4H=uicontrol('Style','pushbutton',...
               'Units','normalized',...
               'Position',[.85 .13 .1 .04],...
               'String','Next >>',...
               'FontSize',9,...
               'FontWeight','bold',...
               'Callback','ws_next;');
%
%  Pushbutton for closing the graphic display.
%
Pb5H=uicontrol('Style','pushbutton',...
               'Units','normalized',...
               'Position',[.85 .07 .1 .04],...
               'String','Close',...
               'FontSize',9,...
               'FontWeight','bold',...
               'Callback','sid_close;');
%
%  Initialize the plot variables.
%
ixpltvar=1;
xpltlab=varlab(ixpltvar,:);
%
%  Strip any marker on the x axis plot label.
%
xpltlab(1)=' ';
xpltvar=t;
iypltvar=1;
ypltlab=char(varname(iypltvar));
ypltvar=eval(ypltlab);
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return