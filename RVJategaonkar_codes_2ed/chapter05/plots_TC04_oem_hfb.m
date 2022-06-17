function [T] = plots_TC04_oem_hfb(T, Z, Y, Uinp, params, par_std, iter);

% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Time history plots of measured and estimated responses and parameter convergence
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa)   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, thrust  
%                  parameters - CD0, CDV, CDAL, CL0, CLV, CLAL, CM0, CMV, CMAL, CMQ, CMDE
%                               f11, f22, f33, f44 (diagonal elements of process noise matrix)

% Conversion factor radians to degrees
r2d = 180/pi;

%Plot time histories of measured and estimated observation variables
figure(1)
subplot(811),plot(T,Z(:,1), T,Y(:,1),'r'); grid; ylabel('V (m/s)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(812),plot(T,Z(:,2)*r2d, T,Y(:,2)*r2d,'r'); grid; ylabel('\alpha (°)');
subplot(813),plot(T,Z(:,3)*r2d, T,Y(:,3)*r2d,'r'); grid; ylabel('\theta (°)');
subplot(814),plot(T,Z(:,4)*r2d, T,Y(:,4)*r2d,'r'); grid; ylabel('q (°/s)');
subplot(815),plot(T,Z(:,5)*r2d, T,Y(:,5)*r2d,'r'); grid; ylabel('qp (°/s2)');
subplot(816),plot(T,Z(:,6), T,Y(:,6),'r');         grid; ylabel('ax (m/s2)');
subplot(817),plot(T,Z(:,7), T,Y(:,7),'r');         grid; ylabel('az (m/s2)');
subplot(818),plot(T,Uinp(:,1)*r2d);                grid; ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0, 
    iterations = [0:iter];
    figure(2); zoom;
    subplot(321);errorbar(iterations, params(1,:),par_std(1,:));ylabel('CD0');        xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(322);errorbar(iterations, params(2,:),par_std(2,:));ylabel('CDV');        xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(3,:),par_std(3,:));ylabel('CD\alpha');   xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(4,:),par_std(4,:));ylabel('CL0');        xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(5,:),par_std(5,:));ylabel('CLV');        xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(6,:),par_std(6,:));ylabel('CL{\alpha}'); xlabel('iteration #');grid
    
    figure(3); zoom;
    subplot(321);errorbar(iterations, params( 7,:),par_std( 7,:));ylabel('Cm0');         xlabel('iteration #');grid
    title('Convergence of parameter estimates with error bounds')
    subplot(322);errorbar(iterations, params( 8,:),par_std( 8,:));ylabel('CmV');         xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params( 9,:),par_std( 9,:));ylabel('Cm\alpha');    xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(10,:),par_std(10,:));ylabel('Cmq');         xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(11,:),par_std(11,:));ylabel('Cm{\delta}e'); xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(11,:),par_std(11,:));ylabel('Cm{\delta}e'); xlabel('iteration #');grid
end