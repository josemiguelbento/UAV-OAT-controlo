function T = plots_TC02_oem_SimNoise(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Conversion factor radians to degrees
r2d = 180/pi;

% Plot time histories of measured and estimated observation variables
figure(1)
subplot(811),plot(T,Z(:,1)*r2d, T,Y(:,1)*r2d,'r'); grid; ylabel('pdot (°/s2)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(812),plot(T,Z(:,2)*r2d, T,Y(:,2)*r2d,'r'); grid; ylabel('rdot (°/s2)');
subplot(813),plot(T,Z(:,3),     T,Y(:,3),    'r'); grid; ylabel('ay (m/s2)');
subplot(814),plot(T,Z(:,4)*r2d, T,Y(:,4)*r2d,'r'); grid; ylabel('p (°/s)');
subplot(815),plot(T,Z(:,5)*r2d, T,Y(:,5)*r2d,'r'); grid; ylabel('r (°/s)');
subplot(816),plot(T,Uinp(:,1)*r2d);                grid; ylabel('{\delta_a} (°)');
subplot(817),plot(T,Uinp(:,2)*r2d);                grid; ylabel('{\delta_r}  (°)');
subplot(818),plot(T,Uinp(:,3)    );                grid; ylabel('{vk}  (m/s)');...
xlabel('Time in sec');  


% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0, 
    iterations = [0:iter];
    figure(2); zoom;
    subplot(521);errorbar(iterations, params(1,:),par_std(1,:));ylabel('Lp');          xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(522);errorbar(iterations, params(6,:),par_std(6,:));ylabel('Np');          xlabel('iteration #');grid
    subplot(523);errorbar(iterations, params(2,:),par_std(2,:));ylabel('Lr');          xlabel('iteration #');grid
    subplot(524);errorbar(iterations, params(7,:),par_std(7,:));ylabel('NLr');         xlabel('iteration #');grid
    subplot(525);errorbar(iterations, params(3,:),par_std(3,:));ylabel('L{\delta}a');  xlabel('iteration #');grid
    subplot(526);errorbar(iterations, params(8,:),par_std(8,:));ylabel('NL{\delta}a'); xlabel('iteration #');grid
    subplot(527);errorbar(iterations, params(4,:),par_std(4,:));ylabel('L{\delta}r');  xlabel('iteration #');grid
    subplot(528);errorbar(iterations, params(9,:),par_std(9,:));ylabel('NL{\delta}r'); xlabel('iteration #');grid
    subplot(529);errorbar(iterations, params(5,:),par_std(5,:));ylabel('Lv');          xlabel('iteration #');grid
    subplot(5,2,10);errorbar(iterations, params(10,:),par_std(10,:));ylabel('Nv'); xlabel('iteration #');grid
end