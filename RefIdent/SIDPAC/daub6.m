function [wx,cs,cd] = daub6(x,n,idir)
%
%  function [wx,cs,cd] = daub6(x,n,idir)
%
%  Usage: [wx,cs,cd] = daub6(x,n,idir);
%
%  Description:
%
%    Implements the sixth order Daubechies wavelet transform 
%    filter for x([1:n],:), where n must be a power of 2.  
%    Smooth components are stored in wx([1:n/2],:) 
%    and detail components are stored in wx([n/2+1:n],:).  
%    Input idir indicates the wavelet transform direction:
%      idir =  1 for the wavelet transform.  
%             -1 for the inverse wavelet transform. 
%
%  Input:
%    
%         x = matrix of time history vectors stored columnwise.
%         n = number of rows of x to be transformed (n must be a power of 2).
%      idir =  1 for the wavelet transform.
%             -1 for the inverse wavelet transform.
%
%  Output:
%
%      wx = wavelet transform for idir=1
%           inverse wavelet transform for idir=-1.
%      cs = smooth filter coefficients.
%      cd = detail filter coefficients.
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
wx=zeros(n,nc);
%
%  Assume wavelet transform calculation 
%  if idir is not specified.  
%
if nargin<3
  idir=1;
end
%
%  Filter coefficients.
%
den=16*sqrt(2);
sq10=sqrt(10);
sftt=sqrt(5+2*sqrt(10));
cs=[1+sq10+sftt,5+sq10+3*sftt,10-2*sq10+2*sftt,...
    10-2*sq10-2*sftt,5+sq10-3*sftt,1+sq10-sftt]'/den;
cd=[cs(6),-cs(5),cs(4),-cs(3),cs(2),-cs(1)]';
cs=cs*ones(1,nc);
cd=cd*ones(1,nc);
%
%  Wavelet transform.
%
nh=n/2;
if idir > 0
  i=1;
  for j=1:2:n-5,
    wx(i,:)=sum(cs.*x([j:j+5],:));
    wx(i+nh,:)=sum(cd.*x([j:j+5],:));
    i=i+1;
  end
%
%  Endpoint wrap-around - wavelet transform.
%
  wx(i,:)=sum(cs.*x([n-3,n-2,n-1,n,1,2],:));
  wx(i+1,:)=sum(cs.*x([n-1,n,1,2,3,4],:));
  wx(i+nh,:)=sum(cd.*x([n-3,n-2,n-1,n,1,2],:));
  wx(i+1+nh,:)=sum(cd.*x([n-1,n,1,2,3,4],:));
else
%
%  Inverse wavelet transform.
%
  j=5;
  cs=cs([5,2,3,4,1,6],:);
  cd=cd([1,6,3,4,5,2],:);
  for i=1:nh-2,
    wx(j,:)=sum(cs.*x([i,i+nh,i+1,i+nh+1,i+2,i+nh+2],:));
    wx(j+1,:)=sum(cd.*x([i,i+nh,i+1,i+nh+1,i+2,i+nh+2],:));
    j=j+2;
  end
%
%  Endpoint wrap-around - inverse wavelet transform.
%
  wx(1,:)=sum(cs.*x([nh-1,n-1,nh,n,1,nh+1],:));
  wx(2,:)=sum(cd.*x([nh-1,n-1,nh,n,1,nh+1],:));
  wx(3,:)=sum(cs.*x([nh,n,1,nh+1,2,nh+2],:));
  wx(4,:)=sum(cd.*x([nh,n,1,nh+1,2,nh+2],:));
end
return


