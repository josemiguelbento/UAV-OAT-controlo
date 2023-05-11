function [val,n] = find_val(x)
%
%  function [val,n] = find_val(x)
%
%  Usage: [val,n] = find_val(x);
%
%  Description:
%
%    Finds all distinct values contained in the input vector x, 
%    stores the n distinct values in output vector val.  
%
%  Input:
%    
%      x = independent variable vector.
%
%  Output:
%
%    val = vector of independent variable values.
%      n = independent variable value count.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      14 Apr 1997 - Created and debugged, EAM.
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
x=x(:,1);
npts=length(x);
%
%  Initialize the output vector.
%
val=zeros(npts,1);
%
%  Compute val and n the input x vector. 
%
vec=x;
indx=[1:1:length(vec)]';
n=0;
while ~isempty(indx)
  vec=vec(indx);
  n=n+1;
  val(n)=vec(1);
  indx=find(vec~=val(n));
end
val=val(1:n);
return
