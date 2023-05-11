function [xval,nval] = x_values(x)
%
%  function [xval,nval] = x_values(x)
%
%  Usage: [xval,nval] = x_values(x);
%
%  Description:
%
%    Finds all distinct values contained in the independent
%    variable array x and stores the values in array xval.  Output
%    vector nval contains a count of the independent variable values.
%
%  Input:
%    
%      x = independent variable array.
%
%  Output:
%
%    xval = array of independent variable values.
%    nval = vector of independent variable value counts.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 Sept 1997 - Created and debugged, EAM.
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
%
%  Find the distinct values for each independent variable.
%
xval=zeros(npts,n);
nval=zeros(n,1);
nmax=0;
for j=1:n
  [val,n]=find_val(x(:,j));
  xval([1:n],j)=val;
  nval(j)=n;
  if n > nmax
    nmax=n;
  end
end
xval=xval([1:nmax],:);
return
