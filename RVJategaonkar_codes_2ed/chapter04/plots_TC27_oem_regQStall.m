function T = plots_TC27_oem_regQStall(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Conversion factors radians to degrees and meters to feet
r2d  = 180/pi;
m2ft = 1/0.3048;

% Plot time histories of measured and estimated observation variables
figure(1)
subplot(611),plot(T,Z(:,1),'b', T,Y(:,1),'r'); grid; ylabel('CD ()');
title('Time histories of output variables (measured and estimated)')
subplot(612),plot(T,Z(:,2),'b', T,Y(:,2),'r'); grid; ylabel('CL (-)');
subplot(613),plot(T,Z(:,3),'b', T,Y(:,3),'r'); grid; ylabel('Cm (-)');
subplot(614),plot(T,Uinp(:,1)*r2d); grid; ylabel('{\delta}_e (°)'); 
subplot(615),plot(T,Uinp(:,7)*r2d); grid; ylabel('{\alpha} (°)'); 
subplot(616),plot(T,Uinp(:,9)    ); grid; ylabel('V (m/s)'); 
xlabel('Time in sec'); 

% Crossplot of CL versus Alpha
figure(2)
plot(Uinp(:,7)*r2d,Z(:,2),'b', Uinp(:,7)*r2d,Y(:,2),'r'); grid; ylabel('CL');
xlabel('Angle of attack (deg)'); 
title('Crossplot of flight and estimated CL versus angle of attack')
