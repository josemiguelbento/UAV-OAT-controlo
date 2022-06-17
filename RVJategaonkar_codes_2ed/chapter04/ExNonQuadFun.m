% An example to illustrate optimization of one-dimensional nonquadratic cost function
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
  
% Define range of x-values and compute actual function
x = [-5:0.1:5]; 
% x = [-10:0.1:5]; 
y = 4*x.^2 + 0.4*x.^3;
plot(x, y, 'b'), title('Newton iteration'), axis([-5 5,0 200]); grid; xlabel('x'); ylabel('y');
% plot(x, y, 'b'), title('Newton iteration'), axis([-10 5,0 200]); grid; xlabel('x'); ylabel('y');
disp('hit any key to continue ...'), pause

% Initialization
x0  = 4;   
% An interesting case for a different starting value of x0=-4:
% To run this case, uncomment the lines 10, 13, and 30; and run the program.
% It will be observed that the optimization algorithm finds a different extremum.
% It happens to be a local maximum. This is because in this simple demonstration 
% case, only the necessary condition of the first gradient being zero is
% checked, which is true for the minimum as well as for the maximum of a
% function. The further condition of the second gradient being positive or
% negative, which helps to determine whether the extremum is a maximum or
% minimum, is not implemented here. This additional case is provided to bring
% out this aspect and that the optimization algorithm may locate local
% extremum, depending upon the initial parameter values, if the cost function
% has multiple minimums.
% x0  = -4; 


niter_max = 10;
iter = 0;
disp(' ')
disp('Iteration   x      Function Value')
y1Prev = Inf;
eps = 1e-4;

% Loop over the maximum number of iterations
while iter <= niter_max;
    
    y1     = 4*x0.^2 + 0.4*x0.^3;
    dydx   = 8*x0    + 1.2*x0.^2;
    d2ydx2 = 8       + 2.4*x0;

    par_prnt = sprintf('%3i   %10.4f   %16.8f', iter, x0, y1);
    disp(par_prnt)

    yq  = y1 + dydx*(x -x0) + 0.5*d2ydx2*(x -x0).^2;
    hold on, plot(x, yq, 'm',  x0, y1, 'x'),

    stp  = - dydx/d2ydx2;
    x1   = x0 + stp;
    ymin = y1 + dydx*(x1-x0) + 0.5*d2ydx2*(x1-x0).^2;
    plot(x1, ymin, '*'), 
    
    disp('hit any key to continue ...'), pause
    
    % Check convergence (here very simple check)
    relChange = abs(y1Prev-y1);   
    if (relChange <= eps),
        disp('Convergence achieved')
        break 
    end
            
    x0     = x1; 
    iter   = iter + 1;
    y1Prev = y1;
    
end

hold off