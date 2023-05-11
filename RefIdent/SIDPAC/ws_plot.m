%
%  script ws_plot.m
%
%  Calling GUI: ws_cut
%
%  Usage: ws_plot;
%
%  Description:
%
%    Plots workspace variables according to user input.  
%
%  Input:
%    
%    varname = cell array of workspace variable names.
%    workspace variables.
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
%  Correlate listbox value with workspace variable name.
%
ypltlab=char(varname(iypltvar));
%
%  Set the ordinate variable for plotting.
%
ypltvar=eval(ypltlab);
%
%  Strip any marker on the x axis plot label.
%
xpltlab(1)=' ';
%
%  If this workspace variable is an array, 
%  plot the first column against xpltvar, 
%  unless the channel selection popupmenu is visible.  
%  In that case, plot the channel specified in the 
%  channel selection popupmenu.  
%
if size(ypltvar,1)==size(xpltvar,1) & size(ypltvar,2) > 1
  if strcmp(get(Pu3H,'Visible'),'on')
    ypltvar=eval([ypltlab,'(:,',num2str(get(Pu3H,'Value')),')']);
  else
    set(Tb3H,'Visible','on','String','Array column number:');
    set(Pu3H,'Value',1,'Visible','on',...
             'String',num2str([1:size(ypltvar,2)]'));
    ypltvar=eval([ypltlab,'(:,',num2str(1),')']);
  end
else
  set(Tb3H,'Visible','off');
  set(Pu3H,'Visible','off');
end
%
%  If this workspace variable is a vector 
%  that is not the same length as xpltvar, 
%  plot the first element against xpltvar,  
%  unless the channel selection popupmenu is visible.  
%  In that case, plot the element specified in the 
%  element selection popupmenu.  
%
if ((size(ypltvar,1)==1 & size(ypltvar,2)~=1) ...
    | (size(ypltvar,1)~=1 & size(ypltvar,2)==1))
  if length(ypltvar)~=size(xpltvar,1)
    if strcmp(get(Pu4H,'Visible'),'on')
      ypltvar=eval([ypltlab,'(',num2str(get(Pu4H,'Value')),')']);
    else
      set(Pu4H,'Value',1,'Visible','on',...
               'String',num2str([1:length(ypltvar)]'));
      ypltvar=eval([ypltlab,'(',num2str(1),')']);
    end
    set(Tb4H,'Visible','on','String',['Vector element:  ',num2str(ypltvar)])
    ypltvar=ypltvar*ones(size(xpltvar,1),1);  
  else
    set(Tb4H,'Visible','off')
    set(Pu4H,'Visible','off');
  end
else
  set(Tb4H,'Visible','off')
  set(Pu4H,'Visible','off');
end
%
%  If this workspace variable is a scalar,
%  plot the scalar against xpltvar.  
%
if size(ypltvar,1)==size(ypltvar,2) & size(ypltvar,1)==1
  set(Tb5H,'Visible','on','String',['Scalar:  ',num2str(ypltvar)])
  ypltvar=ypltvar*ones(size(xpltvar,1),1);  
else
  set(Tb5H,'Visible','off')
end
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
