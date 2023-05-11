function [output] = create_maneuver(input, time_min, time_max)

time_min = time_min*10^6; %us
time_max = time_max*10^6; %us

output.roll = select_maneuver(input.roll, time_min, time_max);
output.pitch = select_maneuver(input.pitch, time_min, time_max);
output.yaw = select_maneuver(input.yaw, time_min, time_max);

output.h = select_maneuver(input.h, time_min, time_max);

output.p = select_maneuver(input.p, time_min, time_max);
output.q = select_maneuver(input.q, time_min, time_max);
output.r = select_maneuver(input.r, time_min, time_max);

output.AoA = select_maneuver(input.AoA, time_min, time_max);
output.beta = select_maneuver(input.beta, time_min, time_max);

output.delta_a = select_maneuver(input.delta_a, time_min, time_max);
output.delta_e = select_maneuver(input.delta_e, time_min, time_max);
output.delta_t = select_maneuver(input.delta_t, time_min, time_max);
output.delta_r = select_maneuver(input.delta_r, time_min, time_max);

output.ax = select_maneuver(input.ax, time_min, time_max);
output.ay = select_maneuver(input.ay, time_min, time_max);
output.az = select_maneuver(input.az, time_min, time_max);

output.Va = select_maneuver(input.Va, time_min, time_max);

output.VN = select_maneuver(input.VN, time_min, time_max);
output.VE = select_maneuver(input.VE, time_min, time_max);
output.VD = select_maneuver(input.VD, time_min, time_max);
end