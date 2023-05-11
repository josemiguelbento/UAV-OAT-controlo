function ud = dband(u,d)
%
%  function ud = dband(u,d)
%
%  Usage: ud = dband(u,d);
%
%  Description:
%
%    Applies a dead band with amplitude d 
%    centered at zero to the input vector u.
%
%  Input:
%    
%    u = input vector.  
%    d = dead band amplitude.
%
%  Output:
%
%   ud = input vector with dead band of amplitude d.  
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 June 1993 - Created and debugged, EAM.
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
[npts,ni]=size(u);
ud=u;
d=abs(d);
for j=1:ni,
  indx=find(abs(u(:,j))<=d);
  ud(indx,j)=zeros(length(indx),1);
  indx=find(u(:,j)>d);
  ud(indx,j)=u(indx,j)-d*ones(length(indx),1);
  indx=find(u(:,j)<-d);
  ud(indx,j)=u(indx,j)+d*ones(length(indx),1);
end
return
