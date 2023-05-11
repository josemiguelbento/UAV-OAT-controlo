function [Y,num,den] = ftf(p,U,w,x0,c)
%
%  function [Y,num,den] = ftf(p,U,w,x0,c)
%
%  Usage: [Y,num,den] = ftf(p,U,w,x0,c);
%
%  Description:
%
%    Matlab m-file for a general SISO transfer function model
%    in the frequency domain.
%
%  Input:
%
%    p = parameter vector.
%    U = input vector in the frequency domain.
%    w = frequency vector, rad/sec.
%   x0 = initial state vector.
%    c = 2x1 cell array:
%        c{1} = numerator exponents.
%        c{2} = denominator exponents.
%
%  Output
%
%       Y = model output vector in the frequency domain.
%     num = transfer function numerator polynomial coefficients.
%     den = transfer function denominator polynomial coefficients.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      15 Sept 2000 - Created and debugged, EAM.
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
%  Get the exponents of the numerator terms.
%
nexp=c{1};
nnp=length(nexp);
%
%  Get the exponents of the denominator terms. 
%
dexp=c{2};
ndp=np-nnp;
%
%  Numerator and denominator parameters.
%
num=p(1:nnp)';
den=[1,p(nnp+1:np)'];
%
%  Compute model output in the frequency domain
%  for this single-input, single-output (SISO) case.
%
U=U(:,1);
nw=length(w);
Y=zeros(nw,1);
jw=sqrt(-1)*w;
numer=(jw(:,ones(1,nnp)).^(ones(nw,1)*nexp));
denom=jw(:,ones(1,ndp+1)).^(ones(nw,1)*dexp);
Y=((numer*num').*U)./(denom*den');
return
