function T = plots_TC11_oem_sp(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


% Conversion factor radians to degrees
r2d = 180/pi;

% Plot time histories of measured and estimated observation variables; input variables
figure(1)
subplot(311),plot(T,Z(:,1)*r2d, T,Y(:,1)*r2d,'r'); grid; ylabel('\alpha (°)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(312),plot(T,Z(:,2)*r2d, T,Y(:,2)*r2d,'r'); grid; ylabel('q (°/s)');
subplot(313),plot(T,Uinp(:,1)*r2d);                grid; ylabel('{\delta}e (°)');
xlabel('Time in sec');  

% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0, 
    iterations = 0:iter;
    figure(2); zoom;
    subplot(321);errorbar(iterations, params(2,:),par_std(2,:));ylabel('Z\alpha');    xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(323);errorbar(iterations, params(3,:),par_std(3,:));ylabel('Zq');         xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(4,:),par_std(4,:));ylabel('Z{\delta}e'); xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(6,:),par_std(6,:));ylabel('M\alpha');    xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(7,:),par_std(7,:));ylabel('Mq');         xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(8,:),par_std(8,:));ylabel('M{\delta}e'); xlabel('iteration #');grid
end