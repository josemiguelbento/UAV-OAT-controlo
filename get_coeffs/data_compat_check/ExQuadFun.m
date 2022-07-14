% Simple example to illustrate optimization of one-dimensional quadratic cost function
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
  
% Define range of x-values and compute actual function
x = [-5:0.1:5]; 
y = 8*x.^2;
plot(x,y,'b'), title('Newton iteration'), axis([-5 5,0 200]); grid; xlabel('x'); ylabel('y');
disp('hit any key to continue ...'), pause

% Initialization
x0  = 4; 
niter_max = 10;
iter = 0;
y1Prev = Inf;
eps = 1e-4;

disp(' ')
disp('Iteration   x      Function Value')

% Loop over the maximum number of iterations
while iter <= niter_max;
    
    y1     = 8*x0.^2;
    dydx   = 16*x0;
    d2ydx2 = 16;

    par_prnt = sprintf('%3i   %10.4f   %10.4f', iter, x0, y1);
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
    if (relChange <= eps  ),
        disp('Convergence achieved')
        disp('For this quadratic cost function, the convergence is really ')
        disp('achieved in a single iteration; the second iteration is ')
        disp('performed just to check the termination in an iterative loop.')
        break 
    end
    
    x0     = x1; 
    iter   = iter + 1;
    y1Prev = y1;
    
end

hold off