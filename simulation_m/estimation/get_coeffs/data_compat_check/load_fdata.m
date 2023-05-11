function [fdata] = load_fdata(datafile)

% RCch1 = delta_a; RCch2 = delta_e: RCch3 = delta_t; RCch4 = delta_r
% In data: - delta in PWM; - RCch in degrees; - except delta_t and RCch3
[pwm2deg_ail, pwm2deg_el, pwm2deg_rud] = PWM2degree();
datafile.RCch1 = deg2rad(pwm2deg_ail(datafile.delta_a));
datafile.RCch2 = deg2rad(pwm2deg_el(datafile.delta_e));
datafile.RCch3 = datafile.delta_t;
datafile.RCch4 = deg2rad(pwm2deg_rud(datafile.delta_r));

% (1x1) struct to (Nx1) struct
data_T = struct2table(datafile);
data_T.Properties.VariableNames{'roll'} = 'phi';
data_T.Properties.VariableNames{'pitch'} = 'theta';
data_T.Properties.VariableNames{'yaw'} = 'psi';
data_T.phi = deg2rad(data_T.phi);
data_T.psi = deg2rad(data_T.psi);
data_T.theta = deg2rad(data_T.theta);
data_T.AoA = deg2rad(data_T.AoA);
data_T.beta = deg2rad(data_T.beta);
fdata = table2struct(data_T);

end