%
%  script ws_arrayplot.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_arrayplot;
%
%  Description:
%
%    Plots a specified colum of a workspace 
%    array variable according to user input.  
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
%    Author:  Eugene A. Morelli
%
%    Calls:
%      sid_plot.m
%
%    History:  
%      29 Aug 2000 - Created and debugged, EAM.
%      10 Jul 2002 - Modified to also plot vector elements, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%

%
%  When this routine is called, the 
%  plot variables and labels are already set.
%  Just get the column number from the callback object,
%  and draw the plot.  
%
%
%  If this workspace variable is an array, 
%  plot the selected column against xpltvar.  
%  Otherwise, the workspace variable is a vector, 
%  so plot the selected element against xpltvar.
%
%
%  Set the ordinate variable for plotting.
%
ypltvar=eval(ypltlab);
%
%  Plot the vector element or array column.
%
if size(ypltvar,1)==1 | size(ypltvar,2)==1
  if length(ypltvar)~=size(xpltvar,1)
%
%  Vector element.
%
    ypltvar=eval([ypltlab,'(',num2str(get(gcbo,'Value')),')']);
    set(Tb4H,'Visible','on','String',['Vector element:  ',num2str(ypltvar)])
    ypltvar=ypltvar*ones(size(xpltvar,1),1);
  end
else
%
%  Array column.
%
  ypltvar=eval([ypltlab,'(:,',num2str(get(gcbo,'Value')),')']);
end
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
