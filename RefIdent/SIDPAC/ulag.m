function ul = ulag(u,t,lag)
%
%  function ul = ulag(u,t,lag)
%
%  Usage: ul = ulag(u,t,lag);
%
%  Description:
%
%    Computes the lagged column vector time histories for the
%    input matrix of column vector time histories u, using 
%    the elements of vector lag for the individual time lags.
%    The time lags can be positive (ul lags u) or negatve (ul leads u).
%
%  Input:
%
%      u = matrix of column vector time histories.
%      t = time vector.
%    lag = vector of time delays, 
%          lag(j) is the lag for the jth input column vector.
%
%  Output:
%
%    ul = matrix of lagged column vector time histories.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Mar 1996 - Created and debugged, EAM.
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
ul=u;
uxl=u;
dt=t(2)-t(1);
%
%  Loop on the number of vectors to be lagged.
%
for j=1:ni,
%
%  Compute integral number of sample time delays.
%
  nlag=fix(lag(j)/dt);
  if nlag > 0
%
%  Integral sample time delayed vector.
%
    ul([1+nlag:npts],j)=u([1:npts-nlag],j);
    ul([1:nlag],j)=u(1,j)*ones(nlag,1);
%
%  Additional sample time delayed vector for interpolation.
%
    uxl([1+nlag+1:npts],j)=u([1:npts-nlag-1],j);
    uxl([1:nlag+1],j)=u(1,j)*ones(nlag+1,1);
  else
%
%  Integral sample time advanced vector.
%
    nlag=abs(nlag);
    ul([1:npts-nlag],j)=u([1+nlag:npts],j);
    ul([npts-nlag+1:npts],j)=u(npts,j)*ones(nlag,1);
%
%  Additional sample time advanced vector for interpolation.
%
    uxl([1:npts-nlag-1],j)=u([1+nlag+1:npts],j);
    uxl([npts-nlag:npts],j)=u(npts,j)*ones(nlag+1,1);
  end
%
%  Compute and implement the fractional sample time delay.
%
  dlag=abs(lag(j)/dt) - nlag;
  ul(:,j)=ul(:,j)+dlag*(uxl(:,j)-ul(:,j));
end
return
