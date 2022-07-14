clear
clc
close all

%% Escolher Ficheiro
% 2022_05_07_11_13_57.mat
% ou
% 2022_05_07_12_57_56.mat

name = '2022_05_07_11_13_57';
load(name+".mat");

%% Selecao de Variaveis

data.roll = [AHR2(:,2), AHR2(:,3)]; %phi
data.pitch = [AHR2(:,2), AHR2(:,4)]; %theta
data.yaw = [AHR2(:,2), AHR2(:,5)]; %psi

data.h = [AHR2(:,2), AHR2(:,6)];

data.p = [IMU_0(:,2), IMU_0(:,4)];
data.q = [IMU_0(:,2), IMU_0(:,5)];
data.r = [IMU_0(:,2), IMU_0(:,6)];

data.AoA = [AOA(:,2), AOA(:,3)];
data.beta = [AOA(:,2), AOA(:,4)];

data.delta_a = [AETR(:,2), AETR(:,3)];
data.delta_e = [AETR(:,2), AETR(:,4)];
data.delta_t = [AETR(:,2), AETR(:,5)];
data.delta_r = [AETR(:,2), AETR(:,6)];

data.ax = [IMU_0(:,2), IMU_0(:,7)];
data.ay = [IMU_0(:,2), IMU_0(:,8)];
data.az = [IMU_0(:,2), IMU_0(:,9)];

data.Va = [ARSP_0(:,2), ARSP_0(:,4)];

data.VN = [XKF1_0(:,2), XKF1_0(:,7)];
data.VE = [XKF1_0(:,2), XKF1_0(:,8)];
data.VD = [XKF1_0(:,2), XKF1_0(:,9)];

% % NED frame
% data.vn = [XKF1_0(:,2), XKF1_0(:,7)];
% data.ve = [XKF1_0(:,2), XKF1_0(:,8)];
% data.vd = [XKF1_0(:,2), XKF1_0(:,9)];
% 
% data.wn = [XKF2_0(:,2), XKF2_0(:,7)];
% data.we = [XKF2_0(:,2), XKF2_0(:,8)];

clearvars -except data name

%% Selecao de manobras
% 2022_05_07_11_13_57.mat:
% Elevator:
%    >> 533.1s - 539.1s
%    >> 568.5s - 575.1s
%    >> 620.5s - 625.9s
%    >> 652.2s - 658.3s (esta não foi bem conseguida)
% Ailerons:
% 	>> 696.8s - 704s
% 	>> 719.7s - 730.3s
% 	>> 796.7s - 804.3s
% 	>> 835.6s - 846.1s
% Rudder:
% 	>> 887.8s - 894.9s
%
% 2022_05_07_12_57_56.mat:
% Ailerons:
% 	>> 896.1s - 904.6s
% 	>> 933s - 941.5s 
% 
% Elevator:
% 	>> 999.9s - 1006.6s

if (strcmp(name,'2022_05_07_11_13_57'))
    man_el_1 = create_maneuver(data,533.1,539.1);
    man_el_2 = create_maneuver(data,568.5,575.1);
    man_el_3 = create_maneuver(data,620.5,625.9);
    man_el_4 = create_maneuver(data,652.2,658.3);
    
    man_ail_1 = create_maneuver(data,696.8,704);
    man_ail_2 = create_maneuver(data,719.7,730.3);
    man_ail_3 = create_maneuver(data,796.7,804.3);
    man_ail_4 = create_maneuver(data,835.6,846.1);
    
    man_rud_1 = create_maneuver(data,887.8,894.9);
    
elseif(strcmp(name,'2022_05_07_12_57_56'))
    man_ail_1 = create_maneuver(data,896.1,904.6);
    man_ail_2 = create_maneuver(data,933,941.5);
    
    man_el_1 = create_maneuver(data,999.9,1006.6);    
end

%% Uniformizacao dos dados

if (strcmp(name,'2022_05_07_11_13_57'))
    el_1 = uniform_maneuver(man_el_1);
    el_2 = uniform_maneuver(man_el_2);
    el_3 = uniform_maneuver(man_el_3);
    el_4 = uniform_maneuver(man_el_4);
    
    ail_1 = uniform_maneuver(man_ail_1);
    ail_2 = uniform_maneuver(man_ail_2);
    ail_3 = uniform_maneuver(man_ail_3);
    ail_4 = uniform_maneuver(man_ail_4);
    
    rud_1 = uniform_maneuver(man_rud_1);
    
    clearvars -except el_1 el_2 el_3 el_4 ail_1 ail_2 ail_3 ail_4 rud_1 name
    
elseif(strcmp(name,'2022_05_07_12_57_56'))
    ail_1 = uniform_maneuver(man_ail_1);
    ail_2 = uniform_maneuver(man_ail_2);
    
    el_1 = uniform_maneuver(man_el_1);   
    
    clearvars -except el_1 ail_1 ail_2 name
end

%% Retirar bias PWM
% 2022_05_07_11_13_57.mat:
% >> delta_a = -132PWM;
% >> delta_e = 35PWM; 
% >> delta_r = -17PWM.
% 
% 2022_05_07_12_57_56.mat:
% >> delta_a = -220PWM;
% >> delta_e = 26PWM; 
% >> delta_r = -17PWM.

if (strcmp(name,'2022_05_07_11_13_57'))
    bias_delta_a = -132;
    bias_delta_e = 35;
    bias_delta_r = -17;
     
    el_1 = remove_bias_PWM(el_1, bias_delta_a, bias_delta_e, bias_delta_r);
    el_2 = remove_bias_PWM(el_2, bias_delta_a, bias_delta_e, bias_delta_r);
    el_3 = remove_bias_PWM(el_3, bias_delta_a, bias_delta_e, bias_delta_r);
    el_4 = remove_bias_PWM(el_4, bias_delta_a, bias_delta_e, bias_delta_r);
    
    ail_1 = remove_bias_PWM(ail_1, bias_delta_a, bias_delta_e, bias_delta_r);
    ail_2 = remove_bias_PWM(ail_2, bias_delta_a, bias_delta_e, bias_delta_r);
    ail_3 = remove_bias_PWM(ail_3, bias_delta_a, bias_delta_e, bias_delta_r);
    ail_4 = remove_bias_PWM(ail_4, bias_delta_a, bias_delta_e, bias_delta_r);
    
    rud_1 = remove_bias_PWM(rud_1, bias_delta_a, bias_delta_e, bias_delta_r);
    
    clearvars -except el_1 el_2 el_3 el_4 ail_1 ail_2 ail_3 ail_4 rud_1 name
    
elseif(strcmp(name,'2022_05_07_12_57_56'))
    bias_delta_a = -220;
    bias_delta_e = 26;
    bias_delta_r = -17;
    
    ail_1 = remove_bias_PWM(ail_1, bias_delta_a, bias_delta_e, bias_delta_r);
    ail_2 = remove_bias_PWM(ail_2, bias_delta_a, bias_delta_e, bias_delta_r);
    
    el_1 = remove_bias_PWM(el_1, bias_delta_a, bias_delta_e, bias_delta_r);
    
    clearvars -except el_1 ail_1 ail_2 name
end

%% Plots
if (strcmp(name,'2022_05_07_11_13_57'))
    plot_maneuver(el_1);
    plot_maneuver(el_2);
    plot_maneuver(el_3);
    plot_maneuver(el_4);
    
    plot_maneuver(ail_1);
    plot_maneuver(ail_2);
    plot_maneuver(ail_3);
    plot_maneuver(ail_4);
    
    plot_maneuver(rud_1);
    
elseif(strcmp(name,'2022_05_07_12_57_56'))
    plot_maneuver(ail_1);
    plot_maneuver(ail_2);
    
    plot_maneuver(el_1);   
end

%% Guardar manobras

if (strcmp(name,'2022_05_07_11_13_57'))
    save("Manobras_processadas/ProcessedData_"+name+".mat","el_1","ail_1",...
        "el_2","ail_2","el_3","ail_3","el_4","ail_4","rud_1");
    
elseif(strcmp(name,'2022_05_07_12_57_56'))
    save("Manobras_processadas/ProcessedData_"+name+".mat","el_1","ail_1",...
        "ail_2");
end
