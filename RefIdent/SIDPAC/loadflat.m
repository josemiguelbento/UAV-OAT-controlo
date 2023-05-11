function [data,npts,hdr] = loadflat(fname,nhdr,nchnls)
%
%  function [data,npts,hdr] = loadflat(fname,nhdr,nchnls)
%
%  Usage: [data,npts,hdr] = loadflat(fname,nhdr,nchnls);
%
%  Description:
%
%    Reads a general ascii flat file with nhdr header lines, 
%    and nchnls data channels for each data point.  
%    Data is loaded into Matlab workspace and placed in array
%    data, which has size [npts,nchnls], where npts is the number
%    of data points read.  The header information is recorded in hdr.
%
%  Input:
%    
%     fname = file name for the input ascii data file.
%      nhdr = number of header lines.
%    nchnls = number of data channels for each data point. 
%
%  Output:
%
%      data = data array.
%      npts = count of the data points read.
%       hdr = file header.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Mar  1996 - Created and debugged, EAM.
%      30 June 2001 - Repaired header recording, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
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
hdr=char(zeros(nhdr,80));
for i=1:nhdr,
  tmp=fgetl(fid);
  hdr(i,[1:length(tmp)])=tmp;
end
%
%  Read all the data points from the ascii flat file, 
%  nchnls data channels per data point.
%
fmt='%e ';
[data,n]=fscanf(fid,fmt,[nchnls,inf]);
fclose(fid);
data=data';
[npts,ncol]=size(data);
return
