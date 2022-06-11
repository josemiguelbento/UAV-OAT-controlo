function [output] = remove_bias_PWM(input, bias_ail, bias_el, bias_rud)

output = input;

output.delta_a = input.delta_a - bias_ail;
output.delta_e = input.delta_e - bias_el;
output.delta_r = input.delta_r - bias_rud;
end