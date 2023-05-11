% UAV-ART // Aerotec - Nucleo de estudantes de Engenharia Aeroespacial
% Estimation of aerodynamic coefficients 
% Authors: - Mariana Ribeiro 
%          - Tomás Nunes 
%          - João Peixoto
clear all; 
close all;
clc; 

% Parameters
mass    = 3.3;
rho     = 1.2682;
S_wing  = 0.384;
b       = 1.6;
c       = 0.24;
g       = 9.80665;
Ixx     = 0.170;
Iyy     = 0.289;
Izz     = 0.443;
Ixz     = 0.019;
S_prop  = 0.085633564;
k_motor = 34.297079912313790;      
C_prop = 0.532027688665616;      
k_T_P   = 0;
k_Omega = 0;

%% Get data
flight_log = '_2023_02_01_14_21_28';
%flight_log = '_2022_05_07_11_13_57';
data_load = load(strcat('./flight_data_1/ProcessedData',flight_log,'.mat'));
data_aux = data_load.ail_1;
%data_aux = data_load.el_1;

biases = strcat('data_compat_check/biases',flight_log,'.mat');
load(biases);
delta_ax = param(1);
delta_ay = param(2);
delta_az = param(3);
delta_p = param(4);
delta_q = param(5);
delta_r = param(6);
K_AoA = param(7);
delta_AoA = param(8);
K_beta = param(9);
delta_beta = param(10);

%% Convert PWM to Degree
% RCch1 = delta_a; RCch2 = delta_e; RCch3 = delta_t; RCch4 = delta_r;
% In data: - delta in PWM - except delta_t in percentage; - RCch in degrees
% - except RCch3;
[pwm2deg_ail, pwm2deg_el, pwm2deg_rud] = PWM2degree();
data_aux.RCch1 = deg2rad(pwm2deg_ail(data_aux.delta_a));
data_aux.RCch2 = deg2rad(pwm2deg_el(data_aux.delta_e));
data_aux.RCch3 = data_aux.delta_t/100;
data_aux.RCch4 = deg2rad(pwm2deg_rud(data_aux.delta_r));

% Plot maneuvers in PWM and Degree 
plot_PWM_deg(data_aux)

%% Convert format of struct to the one used in algorithm
% (1x1) struct to (Nx1) struct
data_T = struct2table(data_aux);
data_T.Properties.VariableNames{'roll'} = 'phi';
data_T.Properties.VariableNames{'pitch'} = 'theta';
data_T.Properties.VariableNames{'yaw'} = 'psi';
data_T.phi = deg2rad(data_T.phi);
data_T.psi = deg2rad(data_T.psi);
data_T.theta = deg2rad(data_T.theta);
data_T.AoA = deg2rad(data_T.AoA);
data_T.beta = deg2rad(data_T.beta);

alpha_0 = data_T.AoA(1);
beta_0 = data_T.beta(1);

% Remove biases
data_T.ax = data_T.ax + delta_ax;
data_T.ay = data_T.ay + delta_ay;
data_T.az = data_T.az + delta_az;
data_T.p = data_T.p + delta_p;
data_T.q = data_T.q + delta_q;
data_T.r = data_T.r + delta_r;
data_T.AoA = K_AoA*(data_T.AoA - alpha_0) + alpha_0 + delta_AoA;
data_T.beta = K_beta*(data_T.beta - beta_0) + beta_0 + delta_beta;

data = table2struct(data_T);

%% Compute linear accelerations - finite differences method 
%acceleration from data, without using finite differences above
[u_dot] = [data.ax];
[v_dot] = [data.ay];
[w_dot] = [data.az];

%Compute external forces
[fx, fy, fz] = external_forces(mass, u_dot, v_dot, w_dot, data);

%Compute lift, drag and lateral forces (em que referencial?)
[F_Lift, Fy, F_Drag] = compute_forces(mass, g, rho, S_prop, k_motor, C_prop, data, fx, fy, fz);

%Compute lift and drag coefficients 
[CL] = compute_coefficients(F_Lift, rho, S_wing, [data.Va], 1); 
[CD] = compute_coefficients(F_Drag, rho, S_wing, [data.Va], 1);

%Compute lateral force coefficient
[CY] = compute_coefficients(Fy, rho, S_wing, [data.Va], 1);

%Compute angular accelerations - finite differences method - longitudinal
[p_dot] = finite_differences([data.p]); 
[q_dot] = finite_differences([data.q]); 
[r_dot] = finite_differences([data.r]);


%Compute roll, pich and yaw moments
 [l, m, n] = compute_moments(Ixx, Iyy, Izz, Ixz, p_dot, q_dot, r_dot, data);
 % quando fizermos para os laterais talvez seja preciso subtrair o T de
 % propulsao no l?
 l = l - (-k_T_P.*(k_Omega.*[data.RCch3]).^2);

%Compute roll, pitch and yaw moment coefficients (extra term is for chord-c and wingspan-b)
[Cl] = compute_coefficients(l, rho, S_wing, [data.Va], b); 
[Cm] = compute_coefficients(m, rho, S_wing, [data.Va], c);
[Cn] = compute_coefficients(n, rho, S_wing, [data.Va], b);

% *** Weighted Least Squares ***

[X_long] = long_variables_matrix(data, c);

%Compute CL, CD and Cm coefficients with WLS 
[CL_coeffs, W_CL] = wls(X_long, CL', 0);
[CD_coeffs, W_CD] = wls(X_long, CD', 0);
[Cm_coeffs, W_Cm] = wls(X_long, Cm', 0);

% least squares (without weights)
% [CL_coeffs_ls] = ls1(X_long, CL');
% [CD_coeffs_ls] = ls1(X_long, CD');
% [Cm_coeffs_ls] = ls1(X_long, Cm');

[X_lat] = lat_variables_matrix(data, b);

%Compute CY, Cl and Cn coefficients with WLS 
k = diag(ones(6,1))*10^(-6); %completo lateral
%k = diag(ones(3,1))*10^(-6); %simplified model
[CY_coeffs, W_CY] = wls(X_lat, CY', k);
[Cl_coeffs, W_Cl] = wls(X_lat, Cl', k);
[Cn_coeffs, W_Cn] = wls(X_lat, Cn', k);

%% Tables

% Longitudinal
row_names = {'_0','_alpha','_q','_delta_e'};
col_names = {'CL_coeffs','CD_coeffs','Cm_coeffs'};
Long_T = table(CL_coeffs(:),CD_coeffs(:),Cm_coeffs(:),'VariableNames',col_names,'RowNames',row_names)

% Lateral
row_names = {'_0','_beta','_p','_r','_delta_a','_delta_r'};
col_names = {'CY_coeffs','Cl_coeffs','Cn_coeffs'};
Lat_T = table(CY_coeffs(:),Cl_coeffs(:),Cn_coeffs(:),'VariableNames',col_names,'RowNames',row_names)

% Plots
% figure();
% subplot(2,1,1);
% plot([data.time], F_Lift,'b');
% xlabel('t [s]')
% ylabel('Lift [N]')
% subplot(2,1,2);
% plot([data.time], rad2deg([data.AoA]),'r');
% xlabel('t [s]')
% ylabel('AoA [deg]')
% 
% figure();
% subplot(2,1,1);
% plot([data.time], F_Drag,'b');
% xlabel('t [s]')
% ylabel('Drag [N]')
% subplot(2,1,2);
% plot([data.time], rad2deg([data.AoA]),'r');
% xlabel('t [s]')
% ylabel('AoA [deg]')
