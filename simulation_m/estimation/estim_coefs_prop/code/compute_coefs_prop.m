clear
close all

%% data gathering
propStr = '13x6.5';
supplyStr = 'bat4s';
vStrs = ["0","6","10","15","20","25"];
Va_total = [];
DeltaT_total = [];
T_total = [];

D_prop = str2double(propStr(1:2));  % diameter of propeller in inches
D_prop = 0.0254*D_prop;             % conversion to meters

for i=1:length(vStrs)
    load("Ficheiros_processados/ProcessedData_test_prop"+propStr+"_"+supplyStr+"_v"+vStrs(i))
    Va_total = [Va_total; Va'];
    DeltaT_total = [DeltaT_total; DeltaT'];
    T_total = [T_total; T'];
end

clear Va
clear DeltaT
clear T
clear i
clear I
clear rpm
clear time
clear V

%% data obtention
[C_prop,k_motor] = estimMotorCoefs(D_prop,T_total,DeltaT_total,Va_total);

%% debugging
rho = 1.225;
S_prop = pi * (D_prop/2)^2;

% 3-D plot
[DeltaT_theo,Va_theo] = meshgrid(0.01:0.01:1,1:20);
T_theo = 0.5*rho*S_prop*C_prop*(k_motor^2*DeltaT_theo.^2-Va_theo.^2);

figure()
surf(DeltaT_theo,Va_theo,T_theo)
grid on
hold on
scatter3(DeltaT_total,Va_total,T_total,'filled')
xlabel('$\delta_t$','Interpreter','latex')
ylabel('$V_a$ (m/s)','Interpreter','latex')
zlabel('$T$ (N)','Interpreter','latex')
set(gca,'FontSize',10)
view(-10,10)

% 2-D plot DeltaT vs T
T_theo2 = 0.5*rho*S_prop*C_prop*(k_motor^2*DeltaT_total.^2-Va_total.^2);
figure()
scatter(DeltaT_total,T_theo2)
grid on
hold on
scatter(DeltaT_total,T_total,'filled')
xlabel('$\delta_T$ (m/s)','Interpreter','latex')
ylabel('$T$ (N)','Interpreter','latex')
set(gca,'FontSize',10)

%% least squares
function [C_prop,k_motor] = estimMotorCoefs(D_prop,f_prop,delta_t,Va)
    rho = 1.225;                % air density in kg/m^3
    S_prop = pi * (D_prop/2)^2; % propeller area in m^2

    % least-squares model as ||Ax-b||^2
    b = 2/(rho*S_prop)*f_prop;
    A = [delta_t.^2,-Va.^2];
    x = (A'*A)\(A'*b);

    C_prop = x(2);
    k_motor = sqrt(x(1)/x(2));
end