function [Y,num,den] = flontf(p,U,w,x0,c)
%
%  function [Y,num,den] = flontf(p,U,w,x0,c)
%
%  Usage: [Y,num,den] = flontf(p,U,w,x0,c);
%
%  Description:
%
%    Matlab m-file for closed loop longitudinal 
%    low order equivalent system transfer function model
%    parameter estimation in the frequency domain.
%
%  Input:
%
%     p = parameter vector.
%     U = input vector in the frequency domain.
%     w = frequency vector, rad/sec.
%    x0 = initial state vector.
%
%  For equation error formulation:
%     c = matrix of measured output vectors in the frequency domain = Z.
%
%  For output error formulation:
%     c = column vector of constants.
%
%
%  Output:
%
%       Y = matrix of model output vectors in the frequency domain.
%     num = transfer function numerator polynomial coefficients.
%     den = transfer function denominator polynomial coefficients.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      04 May 2000 - Created and debugged, EAM.
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
%
%  Model parameterization.
%
numa=[0,p(1)];
numq=[p(1),p(2)];
%numq=p(4)*[1,p(1)];
%numq=p(1)*[1,1.5];
%numq=p(1)*[1,p(2)];
den=[1,p(3),p(4)];
%den=[1,p(1)-p(3),-(p(3)*p(1)+p(2))];
%den=[1,p(2),p(3)];
%den=[1,2*p(3)*p(4),p(4)*p(4)];
%num=[numa;numq];
num=numq;
[no,maxnord]=size(num);
maxnord=maxnord-1;
%
%  Frequency vectors.
%
jay=sqrt(-1);
jw=jay*w;
w2=w.*w;
%
%  Input/Output data.
%
[nw,ni]=size(U);
Ul=U(:,1);
%
%  Implement the equivalent time delay.
%
Ul=Ul.*exp(-p(np)*jw);
Y=zeros(nw,no);
%
%  Determine whether to use equation error or output error formulation.
%
if ~isreal(c)
%
%  Equation error.
%
  Z=c;
  for j=1:no,
    Y(:,j)=Y(:,j) + [jw.*Ul,Ul]*num(j,:)' ...
                  - [jw.*Z(:,j),Z(:,j)]*den(2:3)';
  end
else
%
%  Output error.
%
  denom=[-w2,jw,ones(nw,1)]*den';
  for j=1:no,
    Y(:,j)=Y(:,j) + [jw.*Ul,Ul]*num(j,:)'./denom;
%
%  Include 2.5 Hz structural filter in the model.
%
%    Y(:,j)=Y(:,j) + ([jw.*Ul,Ul]*num(j,:)'./denom)...
%                    ./(0.0637*jw + ones(nw,1));
  end
end
return
