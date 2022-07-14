function [output] = uniform_maneuver(input)

aux_1 = 1;
aux_2 = 1;
aux_3 = 1;
aux_4 = 1;

output.roll  =  zeros(length(input.p(:,1)),1);
output.pitch =  zeros(length(input.p(:,1)),1);
output.yaw   =  zeros(length(input.p(:,1)),1);

output.h   =  zeros(length(input.p(:,1)),1);

output.AoA  =  zeros(length(input.p(:,1)),1);
output.beta =  zeros(length(input.p(:,1)),1);

output.delta_a  =  zeros(length(input.p(:,1)),1);
output.delta_e  =  zeros(length(input.p(:,1)),1);
output.delta_t  =  zeros(length(input.p(:,1)),1);
output.delta_r  =  zeros(length(input.p(:,1)),1);

output.Va  =  zeros(length(input.p(:,1)),1);

output.VN  =  zeros(length(input.p(:,1)),1);
output.VE  =  zeros(length(input.p(:,1)),1);
output.VD  =  zeros(length(input.p(:,1)),1);

output.p =  input.p(:,2);
output.q =  input.q(:,2);
output.r =  input.r(:,2);

output.ax =  input.ax(:,2);
output.ay =  input.ay(:,2);
output.az =  input.az(:,2);

output.roll(1)  =  input.roll(aux_1,2);
output.pitch(1) =  input.pitch(aux_1,2);
output.yaw(1)   =  input.yaw(aux_1,2);

output.h(1)   =  input.h(aux_1,2);

output.AoA(1)  =  input.AoA(aux_2,2);
output.beta(1) =  input.beta(aux_2,2);

output.delta_a(1)  =  input.delta_a(aux_2,2);
output.delta_e(1)  =  input.delta_e(aux_2,2);
output.delta_t(1)  =  input.delta_t(aux_2,2);
output.delta_r(1)  =  input.delta_r(aux_2,2);

output.Va(1)  =  input.Va(aux_3,2);

output.VN(1)  =  input.VN(aux_4,2);
output.VE(1)  =  input.VE(aux_4,2);
output.VD(1)  =  input.VD(aux_4,2);

if(input.p(1,1) > input.roll(aux_1,1))
    aux_1 = aux_1 + 1;
end

if(input.p(1,1) > input.beta(aux_2,1))
    aux_2 = aux_2 + 1;
end

if(input.p(1,1) > input.Va(aux_3,1))
    aux_3 = aux_3 + 1;
end

if(input.p(1,1) > input.VN(aux_4,1))
    aux_4 = aux_4 + 1;
end


for i=2:length(input.p(:,1))
    
    if(input.p(i,1) < input.roll(aux_1,1))
        output.roll(i)  =  output.roll(i-1);
        output.pitch(i) =  output.pitch(i-1);
        output.yaw(i)   =  output.yaw(i-1);
        output.h(i)   =  output.h(i-1);
    else
        output.roll(i)  =  input.roll(aux_1,2);
        output.pitch(i) =  input.pitch(aux_1,2);
        output.yaw(i)   =  input.yaw(aux_1,2);
        output.h(i)   =  input.h(aux_1,2);
        if(aux_1 < length(input.roll(:,1)))
            aux_1 = aux_1 + 1;
        end
    end
    
    if(input.p(i,1) < input.beta(aux_2,1))
        output.AoA(i)  =  output.AoA(i-1);
        output.beta(i) =  output.beta(i-1);
        
        output.delta_a(i)  =  output.delta_a(i-1);
        output.delta_e(i)  =  output.delta_e(i-1);
        output.delta_t(i)  =  output.delta_t(i-1);
        output.delta_r(i)  =  output.delta_r(i-1);
    else
        output.AoA(i)  =  input.AoA(aux_2,2);
        output.beta(i) =  input.beta(aux_2,2);
        
        output.delta_a(i)  =  input.delta_a(aux_2,2);
        output.delta_e(i)  =  input.delta_e(aux_2,2);
        output.delta_t(i)  =  input.delta_t(aux_2,2);
        output.delta_r(i)  =  input.delta_r(aux_2,2);
        if(aux_2 < length(input.beta(:,1)))
            aux_2 = aux_2 + 1;
        end
    end
    
    if(input.p(i,1) < input.Va(aux_3,1))
        output.Va(i)  =  output.Va(i-1);
    else
        output.Va(i)  =  input.Va(aux_3,2);
        if(aux_3 < length(input.Va(:,1)))
            aux_3 = aux_3 + 1;
        end
    end
    
    if(input.p(i,1) < input.VN(aux_4,1))
        output.VN(i)  =  output.VN(i-1);
        output.VE(i)  =  output.VE(i-1);
        output.VD(i)  =  output.VD(i-1);
    else
        output.VN(i)  =  input.VN(aux_4,2);
        output.VE(i)  =  input.VE(aux_4,2);
        output.VD(i)  =  input.VD(aux_4,2);
        if(aux_4 < length(input.VN(:,1)))
            aux_4 = aux_4 + 1;
        end
    end
    
end

[output.u, output.v, output.w] = vel_NED_to_body(output.VN, output.VE,...
                                output.VD, output.roll, output.pitch,...
                                output.yaw);

total_time = (input.p(end,1) - input.p(1,1))*10^(-6);
time_sampling = total_time/(length(input.p(:,1))-1);

output.time = (0:time_sampling:total_time)';

end