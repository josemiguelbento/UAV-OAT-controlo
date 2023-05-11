function [A,B,C,D] = ocf(num,den)
%
%  function [A,B,C,D] = ocf(num,den)
%
%  Usage: [A,B,C,D] = ocf(num,den);
%
%  Description:
%
%    Computes an equivalent state space form for 
%    the input numerator and denominator of a single transfer function.
%    The state space matrices are in observer canonical form, 
%    so that the transfer function coefficients appear directly
%    in the state space matrices. 
%
%  Input:
%
%     num = transfer function numerator vector.
%     den = transfer function denominator vector.
%
%  Output:
%
%    A,B,C,D = system matrices in observer canonical form.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      02 May 1994 - Created and debugged, EAM.
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
num=num(1,:);
m=length(num);
n=length(den);
if n<=m
  fprintf('\n NOT A PROPER RATIONAL TRANSFER FUNCTION \n');
  return
end
if den(1)~=1.0
  oden=den;
  den=den/oden(1);
  onum=num;
  num=num/oden(1);
end
B=num(m);
for j=m-1:-1:1,
  B=[B;num(j)];
end
if m<n-1
  B=[B;zeros(n-1-m,1)];
end
A=-den(n);
for i=n-1:-1:2,
  A=[A;-den(i)];
end
Af=[zeros(1,n-2);eye(n-2,n-2)];
A=[Af,A];
C=zeros(1,n-1);
C(n-1)=1.0;
D=0.0;
return
