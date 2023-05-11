function nshift = tshift(x,y)
%
%  function nshift = tshift(x,y)
%
%  Usage: nshift = tshift(x,y);
%
%  Description:
%
%    Computes the number of samples that vector y 
%    is shifted in time relative to vector x using 
%    the cross correlation function.  
%
%  Input:
%    
%    x = reference input vector.
%    y = comparison input vector.
%
%  Output:
%
%    nshift = integer number of samples that vector y
%             is shifted relative to vector x.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 June 1994 - Created and debugged, EAM.
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
x=x(:,1);
[npts,n]=size(y);
nshift=zeros(n,1);
for i=1:n,
%
%  Find the cross correlation.
%
  xc=xcorr(x,y(:,i));
%
%  Maximum correlation marks the sample lead or lag.
%
  maxindex=find(xc==max(xc));
%
%  The length(xc) is always odd - find the middle index which 
%  corresponds to zero lead/lag.
%
  midindex=(length(xc)+1)/2;
  nshift(i)=maxindex-midindex;
  if nshift>=0
    disp([' y lags x by ',num2str(nshift),' sample(s)']);
  else
    disp([' y leads x by ',num2str(abs(nshift)),' sample(s)']);
  end
end
return

