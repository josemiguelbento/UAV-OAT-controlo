function xdot = xdot_TC11_lon_sp(ts, x, u, param)

% Function to compute the state derivatives (i.e., RHS of state equations) 
% test_case = 11: Short period motion, nx=2, ny=2, nu=1, test aircraft ATTAS
%                 states  - alpha, q
%                 outputs - alpha, q
%                 inputs  - de 
%
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

alfa = x(1);
q    = x(2);

z0    = param(1);
zalfa = param(2);
zq    = param(3);
zdele = param(4);
m0    = param(5);
malfa = param(6);
mq    = param(7);
mdele = param(8);

dele  = u(1);

xdot(1) = z0 + zalfa*alfa + (zq+1)*q + zdele*dele;
    
xdot(2) = m0 + malfa*alfa +     mq*q + mdele*dele;
    
% xdot must be a column vector
xdot = xdot';

return
% end of function
