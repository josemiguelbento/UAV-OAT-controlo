function [fmax,wmax] = pwrband(x,t,fract)
%
%  function [fmax,wmax] = pwrband(x,t,fract)
%
%  Usage: [fmax,wmax] = pwrband(x,t,fract);
%
%  Description:
%
%    Computes the frequency band containing 
%    a specified fraction (fract) of the total
%    power in an input time series x, where 
%    0<=fract<=1.  Output is the upper bound of 
%    the frequency band in Hz (fmax) and rad/sec (wmax).  
%
%  Input:
%    
%       x = vector time history.  
%       t = time vector, sec.
%   fract = fraction of total power, 0<=fract<=1.
%
%  Output:
%
%    fmax = frequency band upper bound, Hz.
%    wmax = frequency band upper bound, rad/sec.
%
%

%
%    Calls:
%      spect.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      11 June 1996 - Created and debugged, EAM.
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
[npts,n]=size(x);
fract=max(0,min(1,fract));
fmax=zeros(n,1);
t=t(:,1);
[P,f]=spect(x,t,0,1);
v=axis;
for j=1:n,
  Pc=cumsum(P);
  Pc=Pc/sum(P);
  indx=max(find(Pc<=fract));
  fmax(j)=f(indx);
  plot(f,P(:,j)),axis([0 5 v(3:4)]),
  hold on;
  plot([fmax(j);fmax(j)],[0,v(4)],'r')
  title(['Signal # ',num2str(j)])  
  hold off;
end
wmax=2*pi*fmax;
return
