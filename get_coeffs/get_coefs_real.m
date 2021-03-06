% UAV-ART // Aerotec - Nucleo de estudantes de Engenharia Aeroespacial
% Estimation of aerodynamic coefficients 
% Authors: - Mariana Ribeiro 
%          - Tomás Nunes 
%          - João Peixoto
clear all; 
close all;
clc; 

% Parameters - faltam constantes do motor
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
k_motor = 80;
C_prop  = 1.0;
k_T_P   = 0;
k_Omega = 0;


%% Get data
data_load = load('./flight_data_1/ProcessedData_2022_05_07_11_13_57.mat');
data_aux = data_load.el_1;

%% Convert PWM to Degree
% RCch1 = delta_a; RCch2 = delta_e: RCch3 = delta_t; RCch4 = delta_r
% In data: - delta in PWM; - RCch in degrees; - except delta_t and RCch3
[pwm2deg_ail, pwm2deg_el, pwm2deg_rud] = PWM2degree();
data_aux.RCch1 = deg2rad(pwm2deg_ail(data_aux.delta_a));
data_aux.RCch2 = deg2rad(pwm2deg_el(data_aux.delta_e));
data_aux.RCch3 = data_aux.delta_t;
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
% data_T.RCch1 = zeros(300,1);
% data_T.RCch4 = zeros(300,1);
data = table2struct(data_T);

%% Compute linear accelerations - finite differences method 
%acceleration from data, without using finite differences above
[u_dot] = [data.ax];
[v_dot] = [data.ay];
[w_dot] = [data.az];

%Compute external forces
[fx, fy, fz] = external_forces(mass, u_dot, v_dot, w_dot, data);

%Compute lift, drag and lateral forces 
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




