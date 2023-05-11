function y = tfsim(num,den,tau,u,t,x0,c)
%
%  function y = tfsim(num,den,tau,u,t,x0,c)
%
%  Usage: y = tfsim(num,den,tau,u,t,x0,c);
%
%  Description:
%
%    Finds the output time history for a model
%    specified in transfer function form:
%
%      Y = num*U*exp(-tau*s)/den
%
%
%  Input:
%    
%    num = transfer function numerator.
%    den = transfer function denominator.
%    tau = input time delay.  
%      u = input time history.
%      t = time vector, sec.
%     x0 = initial conditions (optional).
%      c = vector of constants (optional).
%
%  Output:
%
%       y = output time history.
%

%
%    Calls:
%      ulag.m
%      ocf.m
%      lssim.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 Sept 1999 - Created and debugged, EAM.
%      26 Aug  2002 - Modified to use ocf.m and lssim.m, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
npts=length(t);
dt=1/round(2/(t(3)-t(1)));
if nargin < 7,
  c=zeros(11,1);
end
dord=length(den)-1;
if nargin < 6,
  x0=zeros(dord,1);
end
n=length(x0);
y=zeros(npts,1);
if dord~=n,
  fprintf('\nInitial conditions incorrectly specified\n')
  return
end
icnum=zeros(1,n);
%
%  Compute input including time delay.  
%
ul=ulag(u,t,tau);
%
%  Convert the transfer function model to 
%  observer canonical form.
%
[A,B,C,D]=ocf(num,den);
%
%  Find the complete solution.
%
y=lssim(A,B,C,D,ul,t,x0);
return
