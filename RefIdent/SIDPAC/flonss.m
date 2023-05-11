function [Y,A,B,C,D] = flonss(p,U,w,x0,c)
%
%  function [Y,A,B,C,D] = flonss(p,U,w,x0,c)
%
%  Usage: [Y,A,B,C,D] = flonss(p,U,w,x0,c);
%
%  Description:
%
%    Matlab m-file for closed loop longitudinal 
%    low order equivalent system state space model 
%    in the frequency domain.
%
%  Input:
%
%    p = parameter vector.
%    U = input vector in the frequency domain.
%    w = frequency vector, rad/sec.
%   x0 = initial state vector.
%    c = vector of constants.
%
%  Output:
%
%        Y = model output vector in the frequency domain.
%  A,B,C,D = system matrices.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Nov 1996 - Created and debugged, EAM.
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
np=length(p);
[nw,ni]=size(U);
nw=length(w);
jay=sqrt(-1);
jw=jay*w;
vtg=c(1);
A=[-p(1),1;...
   p(2),p(3)];
B=[0;p(4)];
%A=[-1.25,1;...
%    p(1),p(2)];
%B=[0;p(3)];
[ns,ni]=size(B);
C=[0,1];
%C=eye(ns,ns);
%C=[1,0;...
%   0,1;...
%   vtg*p(1),vtg*(p(2)-1)];
[no,ns]=size(C);
D=zeros(no,ni);
%D=[0;0;vtg*p(3)];
%
%  Single input - Longitudinal stick.
%
%  Input time delay estimated in the time domain.
%
Ul=U;
%
%  Estimate input time delay in the frequency domain. 
%
for k=1:ni,
  Ul(:,k)=Ul(:,k).*exp(-jw*p(np-ni+k));
end
Y=zeros(nw,no);
%
%  Determine whether to use equation error or output error formulation.
%
if ~isreal(c)
%
%  Equation error.
%
  Z=c;
  for i=1:nw,
    Y(i,:)=(A*Z(i,:).' + B*Ul(i,:).').';
  end
else
%
%  Output error.
%
  for i=1:nw,
    x=(jw(i)*eye(ns,ns)-A)\(B*Ul(i,:).');
    Y(i,:)=(C*x + D*Ul(i,:).').';
  end
end
return
