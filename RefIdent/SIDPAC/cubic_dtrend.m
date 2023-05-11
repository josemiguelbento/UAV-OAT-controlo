function [yd,yctf] = cubic_dtrend(y,t)
%
%  function [yd,yctf] = cubic_dtrend(y,t)
%
%  Usage: [yd,yctf] = cubic_dtrend(y,t);
%
%  Description:
%
%    Computes a cubic trend function of time based on y,
%    then subtracts that trend from y and puts the result in yd. 
%
%  Input:
%    
%    y = column vector empirical function.
%    t = time vector, sec.
%
%  Output:
%
%     yd = y with a cubic trend function of time removed.
%   yctf = cubic trend function of time based on y.
%

%
%    Calls:
%      lesq.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      18 Jan 2000 - Created and debugged, EAM.
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
y=y(:,1);
npts=length(y);
%
%  Use least squares regression on y 
%  with polynomial terms in t to find
%  the cubic detrend function of time.
%
x=[ones(npts,1),t,t.*t,t.*t.*t];
[yctf,p,cvar,s2]=lesq(x,y);
yd=y-yctf;
return
