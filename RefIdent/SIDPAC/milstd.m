function hqr = milstd(num,den,tau,lplot)
%
%  function hqr = milstd(num,den,tau,lplot)
%
%  Usage: hqr = milstd(num,den,tau,lplot);
%
%  Description:
%
%    Computes the predicted level of handling qualities rating hqr
%    based on input numerator, denominator, and equivalent time delay
%    of the pitch rate to longitudinal stick deflection transfer function, 
%    using the data in MIL-STD 1797A.  Logical input lplot
%    is used to select plots of the requirements with the location
%    of characteristics from the current system indicated.  
%
%  Input:
%
%     num = transfer function numerator vector, descending powers of s.
%     den = transfer function denominator vector, descending powers of s.
%     tau = equivalent time delay, sec.
%   lplot = 1 for plots of the requirements with current system indicated.
%           0 for no plots.
%
%  Output:
%
%    hqr = predicted handling qualities level.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      30 Sept 1998 - Created and debugged, EAM.
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
zeta_lim=[0.35,1.30;...
         0.25,2.00;...
         0.15,10.00];
wn_lim=[1.0,0.6,0.0]';
wn_Tt2_lim=[1.85,1.0,0.0]';
tau_lim=[0.1,0.2,0.25]';
num=num(1,:);
m=length(num);
n=length(den);
if n<=m
  fprintf('\n NOT A PROPER RATIONAL TRANSFER FUNCTION \n');
  return
end;
if m~=2
  fprintf('\n NUMERATOR MUST BE FIRST ORDER \n');
  return
end
if n~=3
  fprintf('\n DENOMINATOR MUST BE SECOND ORDER \n');
  return
end
[wn,zeta]=damp(den);
Tt2=-1/roots(num);
%
%  Damping requirement.
%
if zeta>zeta_lim(1,1) & zeta<zeta_lim(1,2)
  zeta_hqr=1;
elseif zeta>zeta_lim(2,1) & zeta<zeta_lim(2,2)
  zeta_hqr=2;
else
  zeta_hqr=3;
end
zeta_hqr,
%
%  Natural frequency requirement.
%
if wn>=wn_lim(1)
  wn_hqr=1;
elseif wn>=wn_lim(2)
  wn_hqr=2;
else
  wn_hqr=3;
end
wn_hqr,
%
%  (Numerator zero) * (natural frequency) requirement.
%
wn_Tt2=wn*Tt2;
if wn_Tt2>=wn_Tt2_lim(1)
  wn_Tt2_hqr=1;
elseif wn_Tt2>=wn_Tt2_lim(2)
  wn_Tt2_hqr=2;
else
  wn_Tt2_hqr=3;
end
wn_Tt2_hqr,
%
%  Equivalent time delay requirement.
%
if tau<=tau_lim(1)
  tau_hqr=1;
elseif tau<=tau_lim(2)
  tau_hqr=2;
else
  tau_hqr=3;
end
tau_hqr,
%
%  Final hqr determination.
%
hqr=max([tau_hqr,wn_Tt2_hqr,wn_hqr,zeta_hqr]');
%
%  Plot results.
%
if lplot==1,
  loglog(zeta,wn_Tt2,'*');
  V=axis;
  axis([0.1 5 V(3) V(4)]);
  title('MIL-STD 1797A Short Period Flying Qualities Requirements');
  xlabel('zeta');
  ylabel('wn * Ttheta2');
  grid on;
  hold on;
  L1_x=[zeta_lim(1,1),zeta_lim(1,1),zeta_lim(1,2),zeta_lim(1,2)]';
  L1_y=[V(4),wn_Tt2_lim(1),wn_Tt2_lim(1),V(4)]';
  loglog(L1_x,L1_y,'-');
  L2_x=[zeta_lim(2,1),zeta_lim(2,1),zeta_lim(2,2),zeta_lim(2,2)]';
  L2_y=[V(4),wn_Tt2_lim(2),wn_Tt2_lim(2),V(4)]';
  loglog(L2_x,L2_y,'-');
  text(0.6,1.1*wn_Tt2_lim(2),'Level 2');
  text(0.6,1.1*wn_Tt2_lim(1),'Level 1');
  hold off;
end
return


