function bcoeff = binomialCoeff(n, k)
%
% Compute the binomial coefficient for given n and k.
% n and k must be non negative integers.
% Bionomial coefficient is given by n!/k!/(n-k)!
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

bcoeff = 0;

if ( n>k && k>=0 ),
    bcoeff = factorial(n) / factorial(k) / factorial(n-k);
end
