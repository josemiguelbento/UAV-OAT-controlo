function [u,v,w] = vel_NED_to_body(VN,VE,VD,roll,pitch,yaw)

u = zeros(length(VN), 1);
v = zeros(length(VN), 1);
w = zeros(length(VN), 1);

for i=1:length(u)
    v_out_body(i,:) = rotateFromInertialtoBody(roll(i),pitch(i),yaw(i),...
                                                VN(i),VE(i),VD(i));
end

u = v_out_body(:,1);
v = v_out_body(:,2);
w = v_out_body(:,3);
end