function fco = freqcut(wf,dt)
%
%  function fco = freqcut(wf,dt)
%
%  Usage: fco = freqcut(wf,dt);
%
%  Description:
%
%    Determines the cutoff frequencies defined by the 
%    Wiener filter in the frequency domain.  
%
%  Input:
%    
%    wf = vector or matrix Wiener filter in the frequency domain.  
%    dt = sampling interval, sec.
%
%  Output:
%
%    fco = scalar or vector of cutoff frequencies, hz.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      01 Mar 1997 - Created and debugged, EAM.
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
[npts,n]=size(wf);
fco=0*ones(n,1);
for j=1:n,
  for i=1:npts-1,
    if wf(i,j)>=0.5 
      if wf(i+1,j)<0.5 
        fco(j)=i/(2.*(npts-1)*dt);
      end
    end
  end
end
return
