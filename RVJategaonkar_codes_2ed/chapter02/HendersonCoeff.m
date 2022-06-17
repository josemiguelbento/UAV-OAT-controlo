% Henderson filter coefficients
% according to equation 2.16
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA


% Filter length (Window size), i.e. number of data points
% N = 7;    
% N = 9;    
N = 13;    
% N = 21;  
% N = 23;    

m = (N-1)/2;
i = 0;
for j=-m:m
    i = i+1;
    numerator = 315 * ((m+1)^2-j^2) * ((m+2)^2-j^2) * ...
                      ((m+3)^2-j^2) * (3*(m+2)^2-11*j^2-16);
                  
    denominator = 8 * (m+2) * ((m+2)^2-1)   * (4*(m+2)^2-1) * ...
                              (4*(m+2)^2-9) * (4*(m+2)^2-25);
    wts(i) = numerator/denominator;
end

disp('Henderson Filter weights:');
disp(['Filter length (Window size) = ', num2str(N)]);
wts_prnt = sprintf('%7.4f  ', wts);
disp(wts_prnt)

