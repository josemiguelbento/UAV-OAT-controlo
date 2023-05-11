function [y,xp] = comfun(x,ap,iap)
%
%  function [y,xp] = comfun(x,ap,iap)
%
%  Usage: [y,xp] = comfun(x,ap,iap);
%
%  Description:
%
%    Computes the function y as an ordinary polynomial expansion 
%    with length(iap) terms.  Vector iap specifies the powers of the 
%    independent variables contained in columns of x, and vector ap 
%    contains the parameter values.  The powers of the
%    independent variables contained in each element of vector iap
%    from least significant digit to most significant digit 
%    correspond to the columns of the independent variable matrix x in order.  
%
%  Input:
%    
%      x = matrix of independent variable vectors.
%     ap = vector of parameter values for each polynomial term.
%    iap = vector of integers indicating powers of the independent 
%          variables for each polynomial term.
%
%  Output:
%
%      y = polynomial function of the independent variables in x.
%     xp = matrix of independent variable functions generated
%          from x according to iap.  
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      14 Nov 1995 - Created and debugged, EAM.
%      10 Dec 2000 - Vectorized and changed input/output, EAM.
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
[npts,nvar]=size(x);
nterms=length(iap);
ap=cvec(ap);
%
%  Generate the polynomial function matrix and the final model
%  output based on the polynomial functions.
%
xp=ones(npts,nterms);
for i=1:nterms,
  indx=iap(i);
  for j=1:nvar,
    ji=round(rem(indx,10));
    if ji~=0
      xp(:,i)=xp(:,i).*(x(:,j).^ji);
    end
    indx=floor(indx/10);
  end
end
%
%  Compute the model output.
%
y=xp*ap(1:nterms);
return
