function [z,x,npts,hdr,xval] = loadasc(fname,nhdr,nval)
%
%  function [z,x,npts,hdr,xval] = loadasc(fname,nhdr,nval)
%
%  Usage: [z,x,npts,hdr,xval] = loadasc(fname,nhdr,nval);
%
%  Description:
%
%    Reads a general ascii file with nhdr header lines, 
%    and nval(i) values for the ith independent variable.
%    Data is loaded into Matlab workspace and arranged
%    in the least squares form z=x*theta, where theta is
%    the unknown parameter vector.  The header information 
%    is recorded in hdr and npts is the number of data points read.
%
%  Input:
%    
%    fname = file name for the input ascii data file.
%     nhdr = number of header lines.
%     nval = integer vector with an element for each independent variable
%            that contains the number of values for that independent variable.
%
%  Output:
%
%       z = dependent variable vector.
%       x = independent variable array.
%    npts = count of the numerical values read.
%     hdr = file header.
%    xval = array of independent variable values.
%
%

%
%    Calls:
%      stk_data.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Jan 1996 - Created and debugged, EAM.
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
[fid,message]=fopen(fname,'r');
if fid < 3 
  message,
  return
end
%
%  Read and record the header lines.  
%
hdr=zeros(nhdr,80);
for i=1:nhdr,
  tmp=fgetl(fid);
  hdr(i,[1:length(tmp)])=tmp;
end
%
%  Compute xval from the input data file.
%
fmt='%e ';
nvar=length(nval);
nmax=1;
xval=zeros(prod(nval),length(nval));
for j=nvar:-1:1
  [tmp,n]=fscanf(fid,fmt,nval(j));
  if n > nmax
    nmax=n;
  end
  xval([1:n],j)=tmp;
end
xval=xval([1:nmax],:);
%
%  Read in all the data points.
%
[data,n]=fscanf(fid,fmt,[nval(1),inf]);
fclose(fid);
%
%  Arrange the data in least squares form.
%
[z,x,npts]=stk_data(data,xval,nval);
return
