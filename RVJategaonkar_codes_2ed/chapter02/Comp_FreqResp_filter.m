function FR_mag_sm = Comp_FreqResp_filter(nOrder, c0, dCoeff, Omega) 

% Compute magnitude response H(Omega) of a filter/smoother
% according to equation 2.14
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

FR_mag_sm = c0;
for j=1:nOrder
    FR_mag_sm = FR_mag_sm + 2.0 * dCoeff(j)*cos(j.*Omega);   % Equation 2.14
end

return