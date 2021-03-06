function xdot = xdot_fpr(t, x, u, param, bXparV)

% Function to compute the state derivatives (i.e., RHS of state equations) 
% test_case = 22 -- Flight path reconstruction, multiple time segments (NZI=3),
%                   longitudinal and lateral-directional motion
%                   states  - u, v, w, phi, theta, psi, h
%                   outputs - V, alpha, beta, phi, theta, psi, h
%                   inputs  - ax, ay, az, p, q, r, (pdot, qdot, rdot)
% State equations (10.11)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% State variables
uV    = x(1);
vV    = x(2);
wV    = x(3);
phi   = x(4);
theta = x(5);
psi   = x(6);
h     = x(7);

% Parameters
b_ax  = param(1);
b_ay  = param(2);
b_az  = param(3);
b_p   = param(4);
b_q   = param(5);
b_r   = param(6);

% correct control inputs (accelerations and angular rates) for measurement offsets
ax   = u(1) - b_ax;
ay   = u(2) - b_ay;
az   = u(3) - b_az;
p    = u(4) - b_p;
q    = u(5) - b_q;
r    = u(6) - b_r;
pDot = u(7);
qDot = u(8);
rDot = u(9);

g_acc = 9.80;

% Accelerations at CG, Eq. (10.8)
xASCG = -1.010;
yASCG =  0.886;
zASCG =  0.103;
axCG  = ax + xASCG*(q*q+r*r ) - yASCG*(p*q-rDot) - zASCG*(p*r+qDot);
ayCG  = ay - xASCG*(p*q+rDot) + yASCG*(p*p+r*r ) - zASCG*(q*r-pDot);
azCG  = az - xASCG*(p*r-qDot) - yASCG*(q*r+pDot) + zASCG*(p*p+q*q );

% State equations, Eqs. (10.11)
xdot(1) = axCG -          g_acc*sin(theta) + r*vV - q*wV;
xdot(2) = ayCG + g_acc*sin(phi)*cos(theta) + p*wV - r*uV;
xdot(3) = azCG + g_acc*cos(phi)*cos(theta) + q*uV - p*vV;

xdot(4) = p + (q*sin(phi) + r*cos(phi)) * tan(theta);
xdot(5) =      q*cos(phi) - r*sin(phi);
xdot(6) =     (q*sin(phi) + r*cos(phi)) / cos(theta);

xdot(7) = uV*sin(theta) - vV*sin(phi)*cos(theta) - wV*cos(phi)*cos(theta);

% xdot must be a column vector
xdot = xdot';

return
% end of function
