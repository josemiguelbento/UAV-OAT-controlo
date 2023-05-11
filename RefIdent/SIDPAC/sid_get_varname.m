%
%  script sid_get_varname.m
%
%  Usage: sid_get_varname;
%
%  Description:
%
%    Creates a list of workspace variable names, 
%    excluding handle variables, plotting variables, 
%    and plot label variables.  
%
%  Input:
%
%    workspace variables.
%
%  Output:
%
%    varname = cell array of workspace variable names.
%
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
%  First get all workspace variable names.  
%
varname=who;
%
%  Define index variables.
%
j=0;
ivec=zeros(length(varname),1);
%
%  Look over all the workspace names.
%
for i=1:length(varname),
%
%  See if this name contains H for handle.
%
  m=findstr('H',char(varname(i)));
%
%  If the name has no H, or if H is not the last
%  character, and the variable name is not used 
%  for a plotting or label variable, then include 
%  the variable name in the list.
%
  if (isempty(m) | max(m)~=length(char(varname(i)))) ...
       & isempty(strfind(char(varname(i)),'plt')) ...
       & isempty(strfind(char(varname(i)),'var'))
    ivec(j+1)=i;
    j=j+1;
  end
end
%
%  Update the workspace variable list to exclude
%  handle variables.  
%
ivec=ivec(1:j);
varname=varname(ivec);
clear i j m ivec;
return
