% Filter noisy flight measured data -- Multiple time segments:
% 'smoothMulTS' incorporates a low pass / symmetrical digital filter. 
% It does not introduce any lag in the filtered values. 
% It is to be called only once for each signal to be filtered.
%
% This filter developed by Spencer is based on fifteen points, the current
% value and preceding as well as following seven data points.
% However, a 3rd order filter for 4-7th points from the beginning and the end; 
% and no smmoting for the first and the last three points of each time segment.
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%     x       input signal (time history)
%     Nzi     Number of concatenated time records (maneuvers)
%     izhf    cumulative index at which the concatenated time records end;
%             Example: for Nzi=3, with Nts1, Nts2, Nts3 sample points for the
%                      three time records, then izhf will be 
%                      [Nts1; Nts1+Nts2; Nts1+Nts2+Nts3]
%
% Output:
%     y       smoothed signal (time history)


function y = smoothMulTS(x, Nzi, izhf) 

iIni = 1;

for kzi=1:Nzi,               % Nzi-loop for multiple time segments
    
    if (kzi > 1) iIni = izhf(kzi-1) + 1; end
    iEnd = izhf(kzi);
    
    for kk=iIni:iEnd,         % time-point loop for a particular time segment
        
        if  kk <= iIni+2  |  kk >= iEnd-2,
            % No smoothing for first and last three points:
            hdum(kk) = x(kk);
            
        elseif kk <= iIni+7  |  kk >= iEnd-7,
            % 3rd order filter for 4-7th from beginning and end:
            hdum(kk) = (    7.0*( x(kk-2) + x(kk+2) )...
                         + 24.0*( x(kk-1) + x(kk+1) )...
                         + 34.0*  x(kk)            ) / 96.0;
                    
        else
            % 14th order filter for 8th to iEND-7 data points:
            hdum(kk) = ( -  3.0*( x(kk-7) + x(kk+7) )...
                         -  6.0*( x(kk-6) + x(kk+6) )...
                         -  5.0*( x(kk-5) + x(kk+5) )...
                         +  3.0*( x(kk-4) + x(kk+4) )...
                         + 21.0*( x(kk-3) + x(kk+3) )...
                         + 46.0*( x(kk-2) + x(kk+2) )...
                         + 67.0*( x(kk-1) + x(kk+1) )...
                         + 74.0*  x(kk)            ) / 320.0;
        end
        
    end  % End of time-point loop for a particular time segment
    
end      % End of Nzi-loop

% filtered values:
y = hdum';

return
%end of function