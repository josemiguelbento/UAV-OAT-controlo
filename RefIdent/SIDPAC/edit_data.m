function [ze,xe,npts,xvale,nvale] = edit_data(z,x,xval,xvali,xvalj,nval)
%
%  function [ze,xe,npts,xvale,nvale] = edit_data(z,x,xval,xvali,xvalj,nval)
%
%  Usage: [ze,xe,npts,xvale,nvale] = edit_data(z,x,xval,xvali,xvalj,nval);
%
%  Description:
%
%    Edits the data arranged in least squares form
%    z=x*theta, where theta is the unknown parameter vector.  
%    Outputs are the modified z,x,npts,xval, and nval variables 
%    after editing, named ze,xe,npts,xvale, and nvale, respectively.  
%    Inputs xvali and xvalj are the i and j indices of the
%    array xval corresponding to the independent variable value 
%    whose associated data points are to be removed.  
%    For example, to remove all data points
%    where the third independent variable equals the fourth
%    value in its range of values, xvali=4 and xvalj=3.  
%
%  Input:
%    
%       z = dependent variable vector.
%       x = independent variable array.
%    xval = array of independent variable values.
%   xvali = row number of xval array for the independent variable value 
%           whose associated data points are to be removed.
%   xvalj = column number of xval array for the independent variable value 
%           whose associated data points are to be removed.
%    nval = integer vector with an element for each independent variable
%           that contains the number of values for that independent variable.
%
%  Output:
%
%      ze = edited dependent variable vector.
%      xe = edited independent variable array.
%    npts = number of data points after data editing.
%   xvale = array of independent variable values for the edited data.
%   nvale = nval for the edited data.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 June 1996 - Created and debugged, EAM.
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
[m,n]=size(x);
[mval,nvars]=size(xval);
z=z(:,1);
%
%  Keep inputs legal.
%
if xvalj > n
  xvalj=n;
end
if xvalj < 1
  xvalj=1;
end
if xvali > mval
  xvali=mval;
end
if xvali < 1
  xvali=1;
end
%
%  Find indices for which independent variable xvalj
%  is not equal to xval(xvali,xvalj).  These indices are retained
%  in the edited data xe and ze.  
%
tmp=x(:,xvalj);
indx=find(tmp~=xval(xvali,xvalj));
%
%  Keep data points matching selected indices.
%
ze=z(indx);
xe=x(indx,:);
[xvale,nvale]=x_values(xe);
npts=length(ze);
return
