function T = plots_oem_fpr(T, Z, Y, Uinp, params, par_std, iter);

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
subplot(711),plot(T,Z(:,1), T,Y(:,1),'r');         grid; ylabel('V (m/s)');
title('Time histories of output variables (measured and estimated)')
subplot(712),plot(T,Z(:,2)*r2d, T,Y(:,2)*r2d,'r'); grid; ylabel('\alpha (°)');
subplot(713),plot(T,Z(:,3)*r2d, T,Y(:,3)*r2d,'r'); grid; ylabel('\beta (°)');
subplot(714),plot(T,Z(:,4)*r2d, T,Y(:,4)*r2d,'r'); grid; ylabel('\phi (°)');
subplot(715),plot(T,Z(:,5)*r2d, T,Y(:,5)*r2d,'r'); grid; ylabel('\theta (°)');
subplot(716),plot(T,Z(:,6)*r2d, T,Y(:,6)*r2d,'r'); grid; ylabel('\psi (°)');
subplot(717),plot(T,Z(:,7)*m2ft,T,Y(:,7)*m2ft,'r');grid; ylabel('h (ft)');
xlabel('Time in sec'); 

% Plot time histories of control inputs
figure(2)
subplot(611),plot(T,Uinp(:,1));     grid; ylabel('ax (m/s^2)'); 
title('Time histories of input variables (measured)')
subplot(612),plot(T,Uinp(:,2));     grid; ylabel('ay (m/s^2)'); 
subplot(613),plot(T,Uinp(:,3));     grid; ylabel('az (m/s^2)');
subplot(614),plot(T,Uinp(:,4)*r2d); grid; ylabel('p (°/s)');
subplot(615),plot(T,Uinp(:,5)*r2d); grid; ylabel('q (°/s)');
subplot(616),plot(T,Uinp(:,6)*r2d); grid; ylabel('r (°/s)');
xlabel('Time in sec'); 

% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0, 
    iterations = 0:iter;
    figure(3); zoom;
    subplot(321);errorbar(iterations, params(1,:),par_std(1,:));ylabel('bax'); xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(322);errorbar(iterations, params(2,:),par_std(2,:));ylabel('bay'); xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(3,:),par_std(3,:));ylabel('bz');  xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(4,:),par_std(4,:));ylabel('bp');  xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(5,:),par_std(5,:));ylabel('bq');  xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(6,:),par_std(6,:));ylabel('br');  xlabel('iteration #');grid
end