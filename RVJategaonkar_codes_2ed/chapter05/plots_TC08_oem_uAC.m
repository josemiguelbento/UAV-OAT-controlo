function t = plots_TC08_oem_uAC(t, Z, Y, Uinp, params, par_std, iter);

% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Conversion factor radians to degrees
r2d = 180/pi;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(411),plot(t,Z(:,1),'b', t,Y(:,1),'r');grid;ylabel('a_z (m/s2)');
title('Time histories of output variables (measured and estimated); input variable')
subplot(412),plot(t,Z(:,2),'b', t,Y(:,2),'r');grid;ylabel('w (m/s)');
subplot(413),plot(t,Z(:,3),'b', t,Y(:,3),'r');grid;ylabel('q (rad/s)');
subplot(414),plot(t,Uinp(:,1));grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

