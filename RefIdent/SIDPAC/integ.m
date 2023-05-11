function av = integ(aa,dt,aa0)
%
%  function av = integ(aa,dt,aa0)
%
%  Usage: av = integ(aa,dt,aa0);
%
%  Description:
%
%    Computes Euler integral of empirical functions.
%
%  Input:
%    
%     aa = matrix of column vector empirical functions.
%     dt = sampling time, sec.
%    aa0 = initial condition row vector (optional, default=0).
%
%  Output:
%
%    av = Euler integral of column vector empirical functions.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      25 Feb 2002 - Created and debugged, EAM.
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
[npts,n]=size(aa);
av=zeros(npts,n);
if nargin < 3
  aa0=zeros(1,n);
end
aa0=cvec(aa0)';
av(1,:)=aa0;
for i=2:npts,
  av(i,:)=av(i-1,:) + dt*(aa(i-1,:)+aa(i,:))/2;
end
return
