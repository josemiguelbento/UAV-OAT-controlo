function [x_dot] = finite_differences(x)

h = 0.01; %sampling period 

%Regressive finite differences - 2nd order (Regressiva)
% for i=3:length(x)
%     x_dot(i) = (3*x(i)-4*x(i-1)+x(i-2))/(2*h);
% end

%Regressive finite differences - 3nd order
for i=3:length(x)-1
    x_dot(i) = (x(i-2)-6*x(i-1)+3*x(i)+2*x(i+1))/(6*h);
end 
x_dot(end+1) = 0;

end