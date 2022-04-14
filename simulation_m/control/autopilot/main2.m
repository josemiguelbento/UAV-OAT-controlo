clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load structure with the physical parameters of the aircraft, its
% aerodynamic coefficients, initial conditions, wind parameters, controller
% gains and other necessary constants.
load trim/params

% Load aircraft for 3-D animation
load anim/aircraft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('anim','util','trim')

%T = 10; % simulation time in seconds
T = 10; % for mode 3
t = 0:P.Ts:T;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mode = 1;
%delta_e_max = -P.G.delta_e_max; % -30 graus
delta_e_max = -3/180*pi;
delta_a_max = -P.G.delta_a_max; % -20 graus
%delta_a_max = -5/180*pi;
%delta_r_max = -P.G.delta_r_max; % -45 graus
delta_r_max = -25/180*pi;
delta_t =0.4;
dt = 0.5;
t_0 = 1;
parameters = [0 mode delta_e_max delta_a_max delta_r_max delta_t dt t_0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sim('autopilot_sim2.slx',T);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos = state.signals.values(:,1:3); % [pn pe pd]
v   = state.signals.values(:,4:6); % [u v w]
att = state.signals.values(:,7:9); % [phi theta psi]
ang_v = state.signals.values(:,10:12); % [p q r]

%roll_ref = t*0;
%theta_ref = t*0;
%h_ref = t*0;
%chi_ref = t*0;
%Va_ref = t*0;

Va = airdata.signals.values(:,1);
alpha = airdata.signals.values(:,2);
beta = airdata.signals.values(:,3);
wind_data = airdata.signals.values(:,4:6); % [wn we wd]

chi = atan2(Va.*sin(att(:,3))+wind_data(:,2), ...
                                    Va.*cos(att(:,3))+wind_data(:,1));
delta = delta.signals.values; % [delta_e delta_a delta_r delta_t]

% Aerodynamic Forces and Moments (expressed in the body frame)
F_aero = aero.signals.values(:,1:3); % [Drag Fy Lift]
T_aero = aero.signals.values(:,4:6); % [L M N]

% Total Forces and Moments (expressed in the body frame)
F_body = FM.signals.values(:,1:3); % [fx fy fz]
T_body = FM.signals.values(:,4:6); % [taux tauy tauz], tauy = M, tauz = N

% Total Acceleration (expressed in the body frame)
% accel(:,1) = 1/P.mass * F_body(:,1) + P.gravity*sin(att(:,2)); % ax
% accel(:,2) = 1/P.mass * F_body(:,2) - P.gravity*cos(att(:,2)).*sin(att(:,1)); %ay
% accel(:,3) = 1/P.mass * F_body(:,3) - P.gravity*cos(att(:,2)).*cos(att(:,1)); %az
accel(:,1) = 1/P.mass * F_body(:,1) + ang_v(:,3).*v(:,2) - ang_v(:,2).*v(:,3); %udot
accel(:,2) = 1/P.mass * F_body(:,2) + ang_v(:,1).*v(:,3) - ang_v(:,3).*v(:,1); %vdot
accel(:,3) = 1/P.mass * F_body(:,3) + ang_v(:,2).*v(:,1) - ang_v(:,1).*v(:,2); %wdot


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drawAircraft(pos,att,V,F,facecolors,2e-3)
morePlots2
% logTXT
% logTXT_wAccel
% logTXT_wAero
 logTXT_wAeroAccel