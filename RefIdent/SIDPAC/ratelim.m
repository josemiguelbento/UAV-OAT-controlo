function ul = ratelim(u,t,urlim)
%
%  function ul = ratelim(u,t,urlim)
%
%  Usage: ul = ratelim(u,t,urlim);
%
%  Description:
%
%    Computes rate limited u, using rate limits in urlim.
%
%  Input:
%    
%      u = matrix of input column vectors.
%      t = time vector.
%  urlim = vector of maximum rate limits.
%
%  Output:
%
%     ul = matrix of rate limited input column vectors.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      01 Nov 1996 - Created and debugged, EAM.
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
[npts,n]=size(u);
dt=t(2)-t(1);
urlim=abs(urlim);
ul=u;
for j=1:n,
  for i=1:npts-1,
    if abs(u(i+1,j)-ul(i,j))>urlim(j)*dt
      if (u(i+1,j)-ul(i,j))>urlim(j)*dt
        ul(i+1,j)=ul(i,j)+urlim(j)*dt;
      else
        ul(i+1,j)=ul(i,j)-urlim(j)*dt;
      end
    else
      ul(i+1,j)=u(i+1,j);
    end
  end
end
return
