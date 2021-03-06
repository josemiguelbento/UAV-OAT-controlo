function plot_PWM_deg(data)

% Elevator
figure()
subplot(211)
plot(data.time,rad2deg(data.RCch2),'-b','Linewidth',1.5)
title('Elevator Degree')
ylabel('Degree', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')
subplot(212)
plot(data.time,data.delta_e,'-b','Linewidth',1.5)
title('Elevator PWM')
ylabel('PWM', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')

% Aileron
figure()
subplot(211)
plot(data.time,rad2deg(data.RCch1),'-b','Linewidth',1.5)
title('Aileron Degree')
ylabel('Degree', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')
subplot(212)
plot(data.time,data.delta_a,'-b','Linewidth',1.5)
title('Aileron PWM')
ylabel('PWM', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')

% Rudder
figure()
subplot(211)
plot(data.time,rad2deg(data.RCch4),'-b','Linewidth',1.5)
title('Rudder Degree')
ylabel('Degree', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')
subplot(212)
plot(data.time,data.delta_r,'-b','Linewidth',1.5)
title('Rudder PWM')
ylabel('PWM', 'Interpreter', 'none')
xlabel('time [s]', 'Interpreter', 'none')
end