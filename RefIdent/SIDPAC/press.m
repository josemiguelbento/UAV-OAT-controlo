function P = press(x,y,z)
%
%  function P = press(x,y,z)
%
%  Usage: P = press(x,y,z);
%
%  Description:
%
%    Computes the predicted sum of squares (PRESS) metric 
%    for fitting the linear regression model y to measured z
%    using the regressor matrix x.  The output is the PRESS 
%    statistic for model structure determination.
%
%  Input:
%    
%     x = matrix of regressor column vectors.
%     y = linear regression model fit to z using x.
%     z = measured dependent variable vector.
%
%  Output:
%
%     P = predicted sum of squares (PRESS) metric.
%
%       PRESS = sum([z(i)-y(i|x(1),x(2),...,x(i-1),x(i+1),...,x(N))]^2)
% 

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 April 2000 - Created and debugged, EAM.
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
xixtx=x*inv(x'*x);
%
%  Compute PRESS using the alternate expression in Appendix B
%  of NASA TP-1916, by Klein, Batterson, and Murphy, October 1981.  
%
P=0;
for i=1:npts,
  P=P + ((z(i)-y(i))^2)/(1-xixtx(i,:)*x(i,:)');
end
return
