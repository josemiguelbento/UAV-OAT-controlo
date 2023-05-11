function [y,x,num,den] = tlontf(p,u,t,x0,c)
%
%  function [y,x,num,den] = tlontf(p,u,t,x0,c)
%
%  Usage: [y,x,num,den] = tlontf(p,u,t,x0,c);
%
%  Description:
%
%    Matlab m-file for longitudinal transfer function
%    dynamic model in the time domain. 
%
%  Input:
%
%    p = parameter vector.
%    u = input vector time history.
%    t = time vector.
%   x0 = initial state vector.
%    c = vector of inertia constants.
%
%  Output:
%
%      y = model output vector time history.
%      x = model state vector time history.
%    num = transfer function numerator polynomial coefficients.
%    den = transfer function denominator polynomial coefficients.
%
%

%
%    Calls:
%      tfsim.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      05 Oct 1996 - Created and debugged, EAM.
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
%  Longitudinal short period approximation.
%
np=length(p);
%numa=[0,p(1)];
%numq=p(1)*[1,p(2)];
%numq=p(4)*[1,p(1)];
numq=[p(1),p(2)];
%num=[numa;numq];
num=numq;
%den=[1,2*p(3)*p(4),p(4)*p(4)];
den=[1,p(3:np)'];
%den=[1,p(3:np-1)'];
%den=[p(3:np-1)',1];
%tau=p(np);
%ul=ulag(u,t,tau);
[y,x]=tfsim(num,den,0,u,t);
return
