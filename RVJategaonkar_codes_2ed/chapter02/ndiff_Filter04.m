% Differentiate specified measured signal -- Multiple time segments:
% It is to be called only once for each signal to be differentiated.
% First time derivative of a signal with filter 4th order
%
% Inputs:
%     x       input signal (time history)
%     Nzi     Number of concatenated time records (maneuvers)
%     izhf    cumulative index at which the concatenated time records end;
%             Example: for Nzi=3, with Nts1, Nts2, Nts3 sample points for the
%                      three time records, izhf will be 
%                      [Nts1; Nts1+Nts2; Nts1+Nts2+Nts3]
%     dtk     Sampling time
%
% Output:
%     y       time derivative of x (Caution: x will be overwritten)
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

function y = ndiff_Filter04(x, Nzi, izhf, dtk) 

iIni = 1;

for kzi=1:Nzi,               % Nzi-loop for multiple time segments
    
    if (kzi > 1) iIni = izhf(kzi-1) + 1; end
    iEnd = izhf(kzi);
    
    for kk=iIni:iEnd,         % time-point loop for a particular time segment
        
        if (kk < iIni+2  |  kk > iEnd-2 ),
            if (kk == iEnd),
                % set first two and last two points to values for third from start and end
                hdum(iIni  ) = hdum(iIni+2);
                hdum(iIni+1) = hdum(iIni+2);
                hdum(iEnd-1) = hdum(iEnd-2);
                hdum(iEnd  ) = hdum(iEnd-2);
            end
            
        elseif (kk <= iIni+4  |  kk >= iEnd-4 ),
            % (0; 0.666667; -0.083333) for 2-4th from beginning and end:
            hdum(kk) = ( - 0.083333*( x(kk+2) - x(kk-2) )...
                         + 0.666667*( x(kk+1) - x(kk-1) ) ) / dtk;
                    
        else
            % 4th order 
            hdum(kk) = ( - 0.00357142857 *( x(kk+ 4) - x(kk- 4) )...
                         + 0.03809523809 *( x(kk+ 3) - x(kk- 3) )...
                         - 0.20000000000 *( x(kk+ 2) - x(kk- 2) )...
                         + 0.80000000000 *( x(kk+ 1) - x(kk- 1) ) ) /dtk;
        end
        
    end  % End of time-point loop for a particular time segment
    
end      % End of Nzi-loop

% Overwrite the particular channel with filtered values:
y = hdum';