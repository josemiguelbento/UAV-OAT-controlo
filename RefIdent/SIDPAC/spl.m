function x = spl(data,kts,n)
%
%  function x = spl(data,kts,n)
%
%  Usage: x = spl(data,kts,n);
%
%  Description:
%
%    Computes nth order splines of the input data vector, 
%    using the values in input vector kts for the knots.  
%
%  Input:
%    
%    data = input data vector.
%       t = time vector.
%     kts = vector of values for the knots.
%       n = spline order.
%
%  Output:
%
%    x = matrix of spline functions in order of the input knot sequence.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 Mar 1996 - Created and debugged, EAM.
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
n=round(n);
kts=kts(:,1);
nk=length(kts);
data=data(:,1);
npts=length(data);
x=zeros(npts,nk);
%
%  Make sure knot locations are legal.
%
chk=0;
for j=1:nk,
  if kts(j) < min(data)
    kts(j) = min(data);
    chk = chk + 1;
  end
  if kts(j) > max(data)
    kts(j) = max(data);
    chk = chk + 1;
  end
end
if chk>0
  fprintf('\n\n %3.0f knot(s) out of range \n\n',chk)
  return
end
%
%  Generate the splines.
%
for j=1:nk,
  indx=find(data>=kts(j));
  x(indx,j)=(data(indx)-kts(j)*ones(length(indx),1)).^n;
end
return
