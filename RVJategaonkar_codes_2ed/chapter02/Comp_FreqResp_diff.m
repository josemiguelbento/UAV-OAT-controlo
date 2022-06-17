function FR_mag = Comp_FreqResp_diff(nOrder, dCoeff, Omega) 

% Compute magnitude response H(Omega) of a differentiator
% according to equation 2.21
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

FR_mag = 0.0;
for j=1:nOrder
    FR_mag = FR_mag + dCoeff(j)*sin(j.*Omega);    % Equation 2.21
end
FR_mag = 2 * abs(FR_mag);
return