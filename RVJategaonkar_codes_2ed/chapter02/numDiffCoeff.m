% Compute the coefficients of numerical differentiator with filter
%
% Solve AC = b, i.e. Eq. (2.16), where b = [1 0 0 0 ...]' and the elements of
% A are given by Aij = (-1)^(i+1) * j^(2i-1).
% The first order derivative is given by Equation (2.15)
% xodt (k) = (1/dt)*sum[Ci*[x(k+i)-x(k-i)]; where k is the discrete time
% point and i varies from 1 to N (the filter order).
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all

% Compute coefficients for filters up to 8th / 12th order
% for k=1:12,
for k=1:8,
    % Construct matrix A; Aij = (-1)^(i+1) * j^(2i-1)
    for i=1:k,
        for j=1:k,
            Amat(i,j) = (-1)^(i+1) * j^(2*i-1);
        end;
    end;

    % Vector b: b=[1 0 0 0 ...]'
    Bvec = [1 zeros(k-1,1)'];
     
    % Solve for Ci
    Ci = Amat\Bvec' / 2;               % Backslash operator instead of matrix inversion
     
    % Print coefficients:
    disp(' ');
    disp(['Numerical differentiation with filter: (Order of the filter = ', num2str(k), ')']);
    for i=1:k,
        coeff_prnt = sprintf('%3i   %18.14f', i, Ci(i));
        disp(coeff_prnt)
    end
     
end;