close all

if mode == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%MorePlots for d_e 3211%%%%%%%%%%%%%%%

f = figure;
subplot(3,1,1)
plot(t,180/pi*delta(:,1),'Linewidth',1.5)
ylabel('\delta_e [deg]')
xlabel('Time [s]')
hold on
title('Elevator','Fontsize',11)
grid on

subplot(3,1,2)
plot(t,alpha*180/pi,'Linewidth',1.5)
ylabel('\alpha [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(3,1,3)
plot(t,Va,'Linewidth',1.5)
ylabel('V_a [m/s]')
xlabel('Time [s]')
hold on
title('Airspeed','Fontsize',11)
legend('Observed','Location','best')
grid on

figure
plot(t,-pos(:,3),'Linewidth',1.5) 
ylabel('Altitude [m]')
xlabel('Time [s]')
legend('Observed','Location','best')
hold on
grid on

elseif mode == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%MorePlots for d_a 3211%%%%%%%%%%%%%%%%

f = figure;
subplot(4,1,1)
plot(t,180/pi*delta(:,2),'Linewidth',1.5)
ylabel('\delta_a [deg]')
xlabel('Time [s]')
hold on
title('Aileron','Fontsize',11)
grid on

subplot(4,1,2)
plot(t,alpha*180/pi,'Linewidth',1.5)
ylabel('\alpha [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(4,1,3)
plot(t,beta*180/pi,'Linewidth',1.5)
ylabel('\beta [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(4,1,4)
plot(t,Va,'Linewidth',1.5)
ylabel('V_a [m/s]')
xlabel('Time [s]')
hold on
title('Airspeed','Fontsize',11)
legend('Observed','Location','best')
grid on

figure
plot(t,-pos(:,3),'Linewidth',1.5) 
ylabel('Altitude [m]')
xlabel('Time [s]')
legend('Observed','Location','best')
hold on
grid on

elseif mode == 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%MorePlots for d_r 3211%%%%%%%%%%%%%%%%

f = figure;
subplot(4,1,1)
plot(t,180/pi*delta(:,3),'Linewidth',1.5)
ylabel('\delta_r [deg]')
xlabel('Time [s]')
hold on
title('Rudder','Fontsize',11)
grid on

subplot(4,1,2)
plot(t,alpha*180/pi,'Linewidth',1.5)
ylabel('\alpha [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(4,1,3)
plot(t,beta*180/pi,'Linewidth',1.5)
ylabel('\beta [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(4,1,4)
plot(t,Va,'Linewidth',1.5)
ylabel('V_a [m/s]')
xlabel('Time [s]')
hold on
title('Airspeed','Fontsize',11)
legend('Observed','Location','best')
grid on

figure
plot(t,-pos(:,3),'Linewidth',1.5) 
ylabel('Altitude [m]')
xlabel('Time [s]')
legend('Observed','Location','best')
hold on
grid on

elseif mode == 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%MorePlots for d_a followed by d_r 3211%%%%%%%%%%%%%%%%

f = figure;
subplot(5,1,1)
plot(t,180/pi*delta(:,2),'Linewidth',1.5)
ylabel('\delta_a [deg]')
xlabel('Time [s]')
hold on
title('Aileron','Fontsize',11)
grid on

subplot(5,1,2)
plot(t,180/pi*delta(:,3),'Linewidth',1.5)
ylabel('\delta_r [deg]')
xlabel('Time [s]')
hold on
title('Rudder','Fontsize',11)
grid on

subplot(5,1,3)
plot(t,alpha*180/pi,'Linewidth',1.5)
ylabel('\alpha [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(5,1,4)
plot(t,beta*180/pi,'Linewidth',1.5)
ylabel('\beta [deg]')
hold on
title('Aerodynamic Angles','Fontsize',11)
grid on

subplot(5,1,5)
plot(t,Va,'Linewidth',1.5)
ylabel('V_a [m/s]')
xlabel('Time [s]')
hold on
title('Airspeed','Fontsize',11)
legend('Observed','Location','best')
grid on

figure
plot(t,-pos(:,3),'Linewidth',1.5) 
ylabel('Altitude [m]')
xlabel('Time [s]')
legend('Observed','Location','best')
hold on
grid on
end

% figure
% subplot(3,1,1)
% plot(t,att(:,1)*180/pi,'Linewidth',1.5)
% ylabel('\phi [deg]')
% hold on
% title('Aircraft Attitude','Fontsize',11)
% grid on
