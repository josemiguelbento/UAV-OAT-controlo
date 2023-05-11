function mlab = ws_mrk_chnl(lab,n)
%
%  function mlab = ws_mrk_chnl(lab,n)
%
%  Usage: mlab = ws_mrk_chnl(lab,n);
%
%  Description:
%
%    Mark or clear the (abs(n))th channel label in lab, 
%    and store the result in mlab.
%
%  Input:
%
%     lab = character array of channel labels.
%       n = flag for channel number to be marked or cleared:
%           if n=abs(n), mark the abs(n)th channel.
%           if n=-abs(n), clear the abs(n)th channel.
%
%
%  Output:
%
%    mlab = character array of channel labels 
%           with the abs(n)th channel marked or cleared.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 Jan 2000 - Created and debugged, EAM.
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
%  Mark or clear the nth channel.
%
mlab=lab;
if n > 0
  mlab(n,1)='*';
else
  n=abs(n);
  mlab(n,1)=' ';
end
return
