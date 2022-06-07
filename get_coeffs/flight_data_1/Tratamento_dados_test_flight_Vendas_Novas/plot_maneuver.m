function plot_maneuver(input)

figure()
plot(input.time,input.delta_a)
hold on
plot(input.time,input.delta_e)
hold on
plot(input.time,input.delta_r)
xlabel('Time [s]') 
ylabel('PWM') 
legend('Ailerons','Elevator','Rudder')

end