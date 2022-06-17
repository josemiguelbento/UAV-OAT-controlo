function [fofy, fprime] = ffprime(yi, lamda);

% Activation function and its derivatives f-prime(y), assuming hyperbolic tangent 
% function as node activation.
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    yi      Vector of intermediate variables y1 = W1*u0 + W10...
%    lamda   Gain factor (slope) of the activation function.
%
% Outputs:
%    fofy    Activation function
%    fprime  Derivative of the activation function


expyi  = exp(-lamda*yi);
fofy   = (1-expyi)./(1+expyi);              % Activation function; Eq. (8.3) or Eq. (8.6)
fprime = (2*lamda*expyi)./((1+expyi).^2);   % Derivative of activation function; Eq. (8.15) 

return
% End of function