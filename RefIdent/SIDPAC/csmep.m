function zsmep = csmep(z,t,ts)
%
%  function zsmep = csmep(z,t,ts)
%
%  Usage: zsmep = csmep(z,t,ts);
%
%  Description:
%
%    Determines smoothed endpoints for the input measured time 
%    history z using a cubic least squares fit to the first ts seconds 
%    of the time vector t.  Number of rows of z and t must be 
%    the same.  Input z can be a matrix of column vector 
%    time histories.  Input ts can be a scalar to apply the 
%    same interval to all columns of z, or a vector to apply 
%    different values of ts to each column of z.  
%
%  Input:
%    
%     z = vector or matrix of measured time histories.
%     t = time vector, sec.
%    ts = initial time interval for the spline fit, sec.
%
%  Output:
%
%    zsmep = vector or matrix of measured time histories
%            with smoothed endpoints.  
%

%
%    Calls:
%      cubic_dtrend.m
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Feb 2001 - Created and debugged, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
[npts,no]=size(z);
ts=cvec(ts);
%
%  Fill in values for ts, if necessary.
%
if length(ts) < no
  n=length(ts);
  ts=[ts;ts(n)*ones(no-n,1)];
end
dt=1/(round(2/(t(3)-t(1))));
zsmep=z;
for j=1:no,
  npts=round(ts(j)/dt) + 1;
  [zd,zctf] = cubic_dtrend(z([1:npts],j),t(1:npts));
  zsmep(1,j)=zctf(1);
end
return
