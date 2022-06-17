function T = plots_TC23_attas_regLonLat(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Conversion factor radians to degrees
r2d  = 180/pi;
m2ft = 1/0.3048;

% Plot time histories of measured and estimated observation variables
figure(1)
subplot(611),plot(T,Z(:,1),'b', T,Y(:,1),'r'); grid; ylabel('CD ()');
title('Time histories of output variables (measured and estimated)')
subplot(612),plot(T,Z(:,2),'b', T,Y(:,2),'r'); grid; ylabel('CL (-)');
subplot(613),plot(T,Z(:,3),'b', T,Y(:,3),'r'); grid; ylabel('Cm_{AC} (-)');
subplot(614),plot(T,Z(:,4),'b', T,Y(:,4),'r'); grid; ylabel('CY (-)');
subplot(615),plot(T,Z(:,5),'b', T,Y(:,5),'r'); grid; ylabel('Cl_{AC} (-)');
subplot(616),plot(T,Z(:,6),'b', T,Y(:,6),'r'); grid; ylabel('Cn_{AC} (-)');
xlabel('Time in sec'); 

% Plot time histories of control inputs
figure(2)
subplot(711),plot(T,Uinp(:,1)*r2d); grid; ylabel('\delta_e (°)'); 
title('Time histories of input variables (measured)')
subplot(712),plot(T,Uinp(:,2)*r2d); grid; ylabel('\delta_a (°)'); 
subplot(713),plot(T,Uinp(:,3)*r2d); grid; ylabel('\delta_r (°)');
subplot(714),plot(T,Uinp(:,4)*r2d); grid; ylabel('p (°/s)');
subplot(715),plot(T,Uinp(:,5)*r2d); grid; ylabel('q (°/s)');
subplot(716),plot(T,Uinp(:,6)*r2d); grid; ylabel('r (°/s)');
subplot(717),plot(T,Uinp(:,7)*r2d, T,Uinp(:,8)*r2d); grid; ylabel('\alpha, \beta (°)');
xlabel('Time in sec'); 
