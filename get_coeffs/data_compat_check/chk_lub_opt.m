function [nBounds, i_State] = chk_lub_opt(Nparam, nBounds, G, i_State)

% Check optimality conditions for parameters hitting the lower or upper
% bounds. If the optimality conditions are not met, then drop the 
% corresponding variables from the active set. 
% The Kuhn-Tucker optimality conditions at the two bounds are given by:
% Upper bound:  g(x(i)) < 0 for x(i)=param_max(i),
% Lower bound:  g(x(i)) > 0 for x(i)=param_min(i)
% where x is the parameter vector, g the gradient and _min/_max the bounds.
% Dropping the parameters from the active set implies make the corresponding
% parameters free. Active set contains +-1 for indices for parameters hitting
% the bounds, i.e. parameters for which the bounds (contraints) are active,
% and zero otherwise for free parameters.
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nparam        total number of parameters in the postulated model
%    nBounds       number of parameters hitting the bounds
%    G             gradient vector
%    i_State       active set
%
% Outputs:
%    nBounds       number of parameters hitting the bounds
%    i_State       active set


%--------------------------------------------------------------------------
for ip=1:Nparam,
    
    if i_State(ip) == -1,                   % Lower bound (LB) active
        
        % Optimality condition NOT satisfied for parameters hitting LB
        if G(ip) < 0, 
            % Drop the corresponding variable from the active set: 
            i_State(ip) = 0;                % reset i_State
            nBounds     = nBounds - 1;      % reduce nBounds by one
        end
        
    elseif i_State(ip) == 1,                % Upper bound (UB) active
                    
        % Optimality condition NOT satisfied for parameters hitting UB,
        if G(ip) > 0,
            % Drop the corresponding variable from the active set: 
            i_State(ip) = 0;                % reset i_State
            nBounds     = nBounds - 1;      % reduce nBounds by one
        end
                
    end
    
end

return
% end of function
