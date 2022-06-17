function Theta = RLSff(X, Y, lamda, P, theta)

% Recursive least squares method with forgetting factor: Section 7.2.1 and 7.2.2 
%
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%  
% Inputs:
%     X       Data matrix of independent variables, (Ndata,nparam)
%     Y       Dependent variable, (Ndata,1)
%     lamda   Forgetting factor, scalar
%     P       Initial dispersion matrix, (nparam,nparam)
%     theta   Initial parameter values, (nparam,1)
%
% Outputs:
%     Theta   Time histories of estimated parameters
%

%--------------------------------------------------------------------------
[Ndata, nparam] = size(X);

for k=1:Ndata, 
 
    x = X(k,:)';

    % Gain K(k+1)
	Kgain = P*x / (lamda + x'*P*x );                % Eq. (7.17)
    
    % Estimate parameters theta(k+1)
    y(k)  = theta' * x;                             % Eq. (7.16)
    theta = theta + Kgain * ( Y(k,1) - y(k) );
    
    % P(k+1)
	P = ( P - Kgain * x' * P  ) / lamda ;           % Eq. (7.18)
    
    Theta(k,:) = theta';
    
end 
% End of function