function [output] = select_maneuver(input, time_min, time_max)

aux_i = 1;

for i=1:length(input(:,1))
    if((input(i,1)>time_min) && (input(i,1)<time_max))
        output(aux_i,:) = input(i,:);
        aux_i = aux_i + 1;
    end
end
end