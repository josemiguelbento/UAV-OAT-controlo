function [wx,cs,cd] = wt(wtname,x,idir,n)
%
%  function [wx,cs,cd] = wt(wtname,x,idir,n)
%
%  Usage: [wx,cs,cd] = wt(wtname,x,idir,n);
%
%  Description:
%
%    Implements wavelet transform filter wtname on input data 
%    matrix of column vectors x using the pyramid algorithm.  
%    When the length of x is not a power of 2, the algorithm 
%    zero-pads the data to the next higher power of 2.  If optional
%    input n is provided, then x([1:n],:) is used as the input data,
%    provided n is a power of 2.  Otherwise, the next higher power of 2
%    is used.
%      
%    Forward wavelet transform for idir =  1. 
%    Inverse wavelet transform for idir = -1.  
%
%  Input:
%    
%    wtname = name of the m-file that computes the wavelet filter.
%         x = matrix of time history vectors stored columnwise.
%      idir =  1 for forward wavelet transform.
%             -1 for inverse wavelet transform.
%         n = number of rows of x to be transformed (n must be a power of 2).
%
%  Output:
%
%     wx = wavelet transform for idir=1; inverse wavelet transform for idir=-1.
%     cs = smooth filter coefficients.
%     cd = detail filter coefficients.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Jan 1999 - Created and debugged, EAM.
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
[npts,nc]=size(x);
%
%  Find the smallest power of two that is larger than the number of 
%  data points to use as the record size for wavelet transform.  
%
if nargin < 4
  n=npts;
end
n=2.^(ceil(log(n)/log(2)));
if n > npts
  x=[x;zeros(n-npts,nc)];
end
wx=x([1:n],:);
%
%  Wavelet transform - pyramid algorithm.  Symmetric coefficients 
%  are stored in the top nn/2 indices (small row indices), and 
%  differential coefficients are stored in the bottom nn/2 indices
%  (small row indices) of wx.  
%
if idir > 0
  nn=n;
  while nn >= 4,
    [wx([1:nn],:),cs,cd]=eval([wtname,'(wx,nn,idir)']);
    nn=nn/2;
  end
else
%
%  Inverse wavelet transform.
%
  nn=4;
  while nn <= n,
    [wx([1:nn],:),cs,cd]=eval([wtname,'(wx,nn,idir)']);
    nn=nn*2;
  end
end
return
