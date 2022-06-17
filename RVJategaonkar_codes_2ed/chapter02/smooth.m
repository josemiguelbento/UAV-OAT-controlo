% Filter noisy flight measured data -- for a single time segment:
% 'smoothMulTS' incorporates a low pass / symmetrical digital filter. 
% It does not introduce any lag in the filtered values. 
% It is to be called only once for each signal to be filtered.
%
% This filter developed by Spencer is based on fifteen points, the
% current value and preceding as well as following seven data points.
% However, a 3rd order filter for 4-7th from beginning and end; and
% no smmoting for the first and last three points of each time segment.
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%     x       input signal (time history)
%     Ndt     Number of data points;
%
% Output:
%     y       smoothed signal (time history)

function y = smooth(x, Ndt) 

y = x;

% 3rd order filter for 4-7th from beginning and end:
for i1 = [4:7 Ndt-6:Ndt-3]
     y(i1) = (    7.0*( x(i1-2) + x(i1+2) )...
               + 24.0*( x(i1-1) + x(i1+1) )...
               + 34.0*  x(i1)) / 96.0;
end

% 14th order filter for 8th to Ndt-7 data points:
for i1 = 8:Ndt-7
    y(i1) = ( -  3.0*( x(i1-7) + x(i1+7) )...
              -  6.0*( x(i1-6) + x(i1+6) )...
              -  5.0*( x(i1-5) + x(i1+5) )...
              +  3.0*( x(i1-4) + x(i1+4) )...
              + 21.0*( x(i1-3) + x(i1+3) )...
              + 46.0*( x(i1-2) + x(i1+2) )...
              + 67.0*( x(i1-1) + x(i1+1) )...
              + 74.0*  x(i1)            ) /320.0;
end
