function [y,x,npts] = stk_data(yarr,xval,nval)
%
%  function [y,x,npts] = stk_data(yarr,xval,nval)
%
%  Usage: [y,x,npts] = stk_data(yarr,xval,nval);
%
%  Description:
%
%    Arranges data array yarr (e.g., read in by m-file loadasc.m)
%    into a vector of data points arranged in the least squares form
%    y=x*p, where p is the unknown parameter vector.  
%    Input array xval contains the independent variable values
%    arranged columnwise for each independent variable, and 
%    integer vector nval has an element corresponding to 
%    each independent variable which contains the number of values 
%    for that independent variable.  
%
%  Input:
%    
%    yarr = array containing data read in by m-file loadasc.m.  
%    xval = array of independent variable values.
%    nval = integer vector with an element for each independent variable
%           that contains the number of values for that independent variable.
%
%  Output:
%
%      y = dependent variable vector.
%      x = independent variable array.
%   npts = number of points.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 Sept 1997 - Created and debugged, EAM.
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
[m,n]=size(yarr);
nvar=length(nval);
if m~=nval(1)
  fprintf('\n INDEPENDENT VARIABLE VALUE NUMBER MISMATCH \n');
  return
end
%
%  Assemble y and the first column of x.
%
y=yarr(:,1);
x=xval([1:nval(1)],1);
for j=2:n,
  y=[y;yarr(:,j)];
  x=[x;xval([1:nval(1)],1)];
end
npts=length(y);
if nvar>1,
  for i=2:nvar,
%
%  Determine block size for the current (ith) independent variable.
%
    nblk=1;
    for j=1:i-1,
      nblk=nblk*nval(j);
    end
%
%  Create a column with one cycle of the current (ith)
%  independent variable, which has one block length
%  for each distinct value.  
%
    tmp=xval(1,i)*ones(nblk,1);
    for k=2:nval(i),
      tmp=[tmp;xval(k,i)*ones(nblk,1)];
    end
%
%  Concatenate cycles of the current (ith) independent variable
%  to cover the entire set of data points. 
%
    xcol=tmp;
    for ki=2:round(npts/length(tmp)),
      xcol=[xcol;tmp];
    end
%
%  Append the current (ith) independent variable values to x.
%
    x=[x,xcol];
  end
end
[m,n]=size(x);
if npts~=m,
  fprintf('\n y to x NUMBER OF POINTS MISMATCH \n');
end
return
