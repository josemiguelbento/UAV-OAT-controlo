function [Y,num,den] = flattf(p,U,w,x0,c)
%
%  function [Y,num,den] = flattf(p,U,w,x0,c)
%
%  Usage: [Y,num,den] = flattf(p,U,w,x0,c);
%
%  Description:
%
%    Matlab m-file for closed loop lateral 
%    low order equivalent system transfer function model
%    in the frequency domain.
%
%  Input:
%
%    p = parameter vector.
%    U = input vector in the frequency domain.
%    w = frequency vector, rad/sec.
%   x0 = initial state vector.
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
%     Y = model output vector in the frequency domain.
%   num = transfer function numerator polynomial coefficients.
%   den = transfer function denominator polynomial coefficients.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      01 May 2000 - Created and debugged, EAM.
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
%no=1;
no=2;
Y=zeros(nw,no);
%
%  Model parameterization.
%
np=length(p);
nord=[2,2];
num=zeros(no,max(nord)+1,ni);
den=[1,p(1),p(2),p(3)];
%num(1,:,1)=[0,p(4),p(5)];
%num(1,:,2)=[p(6),p(7),p(8)];
%num(2,:,1)=[p(9),p(10),p(11)];
%num(2,:,2)=[0,p(12),p(13)];
%num(1,:,1)=[p(4),p(5),p(6)];
%num(2,:,1)=[0,p(7),p(8)];
num(1,:,1)=[p(4),p(5),p(6)];
num(1,:,2)=[p(7),p(8),p(9)];
num(2,:,1)=[p(10),p(11),p(12)];
num(2,:,2)=[p(13),p(14),p(15)];
numer=[-w2,jw,ones(nw,1)];
denom=[-jw.*w2,-w2,jw,ones(nw,1)];
%
%  Determine whether to use equation error
%  or output error formulation.
%
if ~isreal(c)
%
%  Equation error.
%
%
%  Loop over outputs and inputs.
%
  for j=1:no,
    Zj=c(:,j);
    Y(:,j)=(-denom(:,[2:4]).*Zj(:,ones(1,3)))*den(2:4)';
    for k=1:ni,
      Uk=U(:,k);
%
%  Implement the equivalent time delay.
%
      Uk=Uk.*exp(-p(np-ni+k)*jw);
      numjk=squeeze(num(j,:,k));
      Y(:,j)=Y(:,j) + (numer.*Uk(:,ones(1,3)))*numjk';
    end
  end
else
%
%  Output error.
%
  for j=1:no,
    for k=1:ni,
      Uk=U(:,k);
%
%  Implement the equivalent time delay.
%
      Uk=Uk.*exp(-p(np-ni+k)*jw);
      numjk=squeeze(num(j,:,k));
      Y(:,j)=Y(:,j) + ((numer.*Uk(:,ones(1,3)))*numjk')./(denom*den');
    end
  end
end
return
