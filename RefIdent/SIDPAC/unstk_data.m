function [yarr,x1,x2] = unstk_data(y,x,xval,nval)
%
%  function [yarr,x1,x2] = unstk_data(y,x,xval,nval)
%
%  Usage: [yarr,x1,x2] = unstk_data(y,x,xval,nval);
%
%  Description:
%
%    Re-arranges data from least squares form y=x*p, where
%    p is the unknown parameter vector, into two independent
%    variable vectors, x1 and x2, and an array for the dependent 
%    variable, yarr.  The rectangular array of data
%    can be plotted directly as a 3-D surface in Matlab.  
%    Input array xval contains the independent variable values
%    arranged columnwise for each independent variable, and 
%    integer vector nval has an element corresponding to 
%    each independent variable which contains the number of values 
%    for that independent variable.  
%
%  Input:
%    
%       y = dependent variable vector.
%       x = independent variable array.
%    xval = array of independent variable values.
%    nval = integer vector with an element for each independent variable
%           that contains the number of values for that independent variable.
%
%  Output:
%
%    yarr = dependent variable data array.  
%      x1 = data vector for the first independent variable.
%      x2 = data vector for the second independent variable.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      23 Sept 1997 - Created and debugged, EAM.
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
nvar=length(nval);
if nvar~=2,
  fprintf('\n ONLY TWO INDEPENDENT VARIABLES CAN BE CHOSEN FOR A 3-D PLOT \n');
  return
end
x1=xval([1:nval(1)],1);
x2=xval([1:nval(2)],2);
yarr=y(1:nval(1));
for j=2:nval(2),
  yarr=[yarr,y((j-1)*nval(1)+1:j*nval(1))];
end
yarr=yarr';
return
