function delta = reference(uu,P)
    mode = uu(1);
    delta_e_max = uu(2);
    delta_a_max = uu(3);
    delta_r_max = uu(4);
    delta_t = uu(5);
    dt = uu(6);
    t = uu(7);

    if mode == 0
        if t >= 0 && t < 3*dt
            delta_e = delta_e_max;
            delta_a = 0;
            delta_r = 0;
        elseif t >= 3*dt && t < 5*dt
            delta_e = -delta_e_max;
            delta_a = 0;
            delta_r = 0;
        elseif  t >= 5*dt && t < 6*dt
            delta_e = delta_e_max;
            delta_a = 0;
            delta_r = 0;
        elseif t >= 6*dt && t < 7*dt
            delta_e = -delta_e_max;
            delta_a = 0;
            delta_r = 0;
        else
            delta_e = 0;
            delta_a = 0;
            delta_r = 0;
        end

    elseif mode == 1
        if t >= 0 && t < 3*dt
            delta_e = 0;
            delta_a = delta_a_max;
            delta_r = 0;
        elseif t >= 3*dt && t < 5*dt
            delta_e = 0;
            delta_a = -delta_a_max;
            delta_r = 0;
        elseif  t >= 5*dt && t < 6*dt
            delta_e = 0;
            delta_a = delta_a_max;
            delta_r = 0;
        elseif t >= 6*dt && t < 7*dt
            delta_e = 0;
            delta_a = -delta_a_max;
            delta_r = 0;
        else
            delta_e = 0;
            delta_a = 0;
            delta_r = 0;
        end

    elseif mode == 2
        if t >= 0 && t < 3*dt
            delta_e = 0;
            delta_a = 0;
            delta_r = delta_r_max;
        elseif t >= 3*dt && t < 5*dt
            delta_e = 0;
            delta_a = 0;
            delta_r = -delta_r_max;
        elseif  t >= 5*dt && t < 6*dt
            delta_e = 0;
            delta_a = 0;
            delta_r = delta_r_max;
        elseif t >= 6*dt && t < 7*dt
            delta_e = 0;
            delta_a = 0;
            delta_r = -delta_r_max;
        else
            delta_e = 0;
            delta_a = 0;
            delta_r = 0;
        end
    end

    delta = [delta_e; delta_a; delta_r; delta_t];
end

