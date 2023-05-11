function xp = axcnv(x,phi,the,psi,dflag)
%
%  function xp = axcnv(x,phi,the,psi,dflag)
%
%  Usage: xp = axcnv(x,phi,the,psi,dflag);
%
%  Description:
%
%    Computes the components of input vector x in an axis system
%    which is rotated by the Euler angles phi, the, and psi.
%    Input dflag is optional.  
%
%  Input:
%
%       x = input (3 x 1) vector or (npts x 3) matrix of input vectors.
%     phi = Euler roll angle, rad.
%     the = Euler pitch angle, rad.
%     psi = Euler yaw angle, rad.
%   dflag = 1 for body to earth axes conversion (default).
%           0 for earth to body axes conversion.
%
%  Output:
%
%    xp = rotated input (3 x 1) vector 
%         or (npts x 3) matrix of input vectors.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 June 1995 - Created and debugged, EAM.
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
[m,n]=size(x);
xp=zeros(m,n);
if nargin<5
  dflag=1;
end
sphi=sin(phi);
sthe=sin(the);
spsi=sin(psi);
cphi=cos(phi);
cthe=cos(the);
cpsi=cos(psi);
%
%  More than one vector to process.
%
if n > 1
  x=x(:,[1:3]);
%
%  Vectors of Euler angles.
%
  if length(phi)==m,
    for i=1:m,
      lmat(1,1)=cthe(i).*cpsi(i);
      lmat(1,2)=cthe(i).*spsi(i);
      lmat(1,3)=-sthe(i);
      lmat(2,1)=sphi(i).*sthe(i).*cpsi(i) - cphi(i).*spsi(i);
      lmat(2,2)=sphi(i).*sthe(i).*spsi(i) + cphi(i).*cpsi(i);
      lmat(2,3)=sphi(i).*cthe(i);
      lmat(3,1)=cphi(i).*sthe(i).*cpsi(i) + sphi(i).*spsi(i);
      lmat(3,2)=cphi(i).*sthe(i).*spsi(i) - sphi(i).*cpsi(i);
      lmat(3,3)=cphi(i).*cthe(i);
      if dflag==1
        lmat=lmat';
      end
      xp(i,:) = (lmat*x(i,:)')';
    end
  else
%
%  Single set of the Euler angles, more 
%  than one vector to process.
%
    lmat(1,1)=cthe(1).*cpsi(1);
    lmat(1,2)=cthe(1).*spsi(1);
    lmat(1,3)=-sthe(1);
    lmat(2,1)=sphi(1).*sthe(1).*cpsi(1) - cphi(1).*spsi(1);
    lmat(2,2)=sphi(1).*sthe(1).*spsi(1) + cphi(1).*cpsi(1);
    lmat(2,3)=sphi(1).*cthe(1);
    lmat(3,1)=cphi(1).*sthe(1).*cpsi(1) + sphi(1).*spsi(1);
    lmat(3,2)=cphi(1).*sthe(1).*spsi(1) - sphi(1).*cpsi(1);
    lmat(3,3)=cphi(1).*cthe(1);
    if dflag==1
      lmat=lmat';
    end
    xp=(lmat*x')';
  end
else
%
%  Single set of the Euler angles, 
%  one vector to process.
%
  lmat(1,1)=cthe(1).*cpsi(1);
  lmat(1,2)=cthe(1).*spsi(1);
  lmat(1,3)=-sthe(1);
  lmat(2,1)=sphi(1).*sthe(1).*cpsi(1) - cphi(1).*spsi(1);
  lmat(2,2)=sphi(1).*sthe(1).*spsi(1) + cphi(1).*cpsi(1);
  lmat(2,3)=sphi(1).*cthe(1);
  lmat(3,1)=cphi(1).*sthe(1).*cpsi(1) + sphi(1).*spsi(1);
  lmat(3,2)=cphi(1).*sthe(1).*spsi(1) - sphi(1).*cpsi(1);
  lmat(3,3)=cphi(1).*cthe(1);
  if dflag==1
    lmat=lmat';
  end
  xp=lmat*x;
end
return
