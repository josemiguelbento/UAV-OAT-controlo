function [A] = ls1(x,y)

var_size = size(x);

var_num = var_size(2);
var_length = var_size(1);

A = ((x' * x)^(-1)) * x' * y;

end