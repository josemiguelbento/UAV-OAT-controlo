function [zr,xr] = tfregr(U,Z,nord,dord,w)
%
%  function [zr,xr]=tfregr(U,Z,nord,dord,w)
%
%  Usage: [zr,xr] = tfregr(U,Z,nord,dord,w);
%
%  Description:
%
%  Performs the calculations required to assemble
%  the dependent vector (zr) and the matrix of independent
%  variable vectors (xr) for complex least squares 
%  parameter estimation in the frequency domain using
%  transfer function models.  This routine handles general 
%  single input, single output (SISO) cases.  
%
%
%  Input:
%    
%    U    = discrete Fourier transformed input vector.
%    Z    = matrix of discrete Fourier transformed output vectors.
%    nord = vector of numerator orders for the model.
%    dord = denominator order for the model.
%    w    = frequency vector, rad/sec.
%
%  Output:
%
%    zr = complex dependent variable vector 
%         for the least squares parameter estimation.
%    xr = matrix of complex independent variable vectors 
%         for the least squares parameter estimation.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      15 July 1997 - Created and debugged, EAM.
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
U=U(:,1);
Z=Z(:,1);
w=w(:,1);
jw=sqrt(-1)*w;
w2=w.*w;
nw=length(w);
tncol=dord+1+nord+1;
tmp=zeros(nw,tncol);
ncol=0;
%
%  Denominator terms.
%
for i=dord:-1:0,
  ncol=ncol + 1;
  tmp(:,ncol)=Z;
  for k=1:i,
    tmp(:,ncol)=tmp(:,ncol).*jw;
  end
end
%
%  Input and derivatives terms.
%
for i=nord:-1:0,
  ncol=ncol + 1;
  tmp(:,ncol)=U;
  for k=1:i,
    tmp(:,ncol)=tmp(:,ncol).*jw;
  end
end
%
%  Final regressor configuration:
%
%  zr = D(dord)Z
%  xr = [D(nord)U,D(nord-1)U,...,DU,U,-D(dord-1)Z,-D(dord-2)Z,...,-DZ,-Z]
%
%  Scale the regression problem to avoid high frequency weighting.
%
sclvec=jw.^(dord-1);
zr=tmp(:,1)./sclvec;
xr=[tmp(:,[dord+2:tncol]),-tmp(:,[2:dord+1])]./sclvec(:,ones(1,tncol-1));
%
%  Make the output the dependent variable in the regression problem.  
%
%zr=tmp(:,dord+1);
%xr=[tmp(:,[dord+2:tncol]),-tmp(:,[1:dord])];
%
%  No scaling - regression problem is weighted toward high frequencies.
%
%zr=tmp(:,1);
%xr=[tmp(:,[dord+2:tncol]),-tmp(:,[2:dord+1])];
return
