function [F_Lift, F_Drag] = aero_forces_bodytostab(data, body_FL, body_FD)

for i=1:length(data)
    % rotation matrix body to stability frame
    Rbs = [ cos(data(i).AoA) sin(data(i).AoA) ; -sin(data(i).AoA) cos(data(i).AoA)];
    matrix_F = Rbs*[-body_FD(i);-body_FL(i)];
    F_Drag(i) = matrix_F(1);
    F_Lift(i) = matrix_F(2);
end
end