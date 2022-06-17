function T = plots_TC03_oem_lat_pr(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Time history plots of measured and estimated responses and parameter convergence
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 

% Conversion factor radians to degrees
r2d = 180/pi;

% Plot time histories of measured and estimated observation variables
figure(1)
subplot(511),plot(T,Z(:,1)*r2d, T,Y(:,1)*r2d,'r'); grid; ylabel('p (°/s)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(512),plot(T,Z(:,2)*r2d, T,Y(:,2)*r2d,'r'); grid; ylabel('r (°/s)');
subplot(513),plot(T,Uinp(:,1)*r2d);                grid; ylabel('{\delta_a} (°)');
subplot(514),plot(T,Uinp(:,2)*r2d);                grid; ylabel('{\delta_r} (°)'); 
subplot(515),plot(T,Uinp(:,3)*r2d);                grid; ylabel('{\beta} (°)');
xlabel('Time in sec');  

% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0, 
    iterations = 0:iter;
    figure(2); zoom;
    subplot(321);errorbar(iterations, params(1,:),par_std(3,:));ylabel('Lp');         xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(322);errorbar(iterations, params(2,:),par_std(4,:));ylabel('Lr');         xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(3,:),par_std(5,:));ylabel('L{\delta}a'); xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(4,:),par_std(6,:));ylabel('L{\delta}r'); xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(5,:),par_std(2,:));ylabel('L\beta');     xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(6,:),par_std(1,:));ylabel('L0');         xlabel('iteration #');grid
    
    figure(3); zoom;
    subplot(321);errorbar(iterations, params( 7,:),par_std( 9,:));ylabel('Np');         xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(322);errorbar(iterations, params( 8,:),par_std(10,:));ylabel('Nr');         xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params( 9,:),par_std(11,:));ylabel('N{\delta}a'); xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(10,:),par_std(12,:));ylabel('N{\delta}r'); xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(11,:),par_std( 8,:));ylabel('N\beta');     xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(12,:),par_std( 7,:));ylabel('N0');         xlabel('iteration #');grid
end