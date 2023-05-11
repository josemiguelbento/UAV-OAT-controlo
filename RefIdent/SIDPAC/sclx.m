function [xs,xsf] = sclx(x)
%
%  function [xs,xsf] = sclx(x)
%
%  Usage: [xs,xsf] = sclx(x);
%
%  Description:
%
%    Scales the columns of x by mapping the values
%    so that the maximum or minimum values correspond
%    to 1 or -1, respectively.  An individual scaling 
%    factor is applied to each column of x.  
%    Output xs is the scaled x matrix.  
%
%  Input:
%
%      x = matrix of independent variable data vectors.
%
%  Output:
%
%     xs = scaled matrix of independent variable data vectors.
%    xsf = vector of scale factors for each column of x.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      29 Dec 2000 - Created and debugged, EAM.
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
%  Use the largest absolute value in each column
%  to scale the independent variable matrix x.
%
xmin=min(x);
xmax=max(x);
xsf=max(abs(xmax),abs(xmin));
xs=ones(npts,n);
for j=1:n,
%
%  Avoid divide by zero in the scaling process.
%
  if xsf(j)==0
    xsf(j)=1;
  end
  xs(:,j)=x(:,j)/xsf(j);
end
return
