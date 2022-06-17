% Differentiate specified measured signal -- Multiple time segments:
% It is to be called only once for each signal to be differentiated.
% First time derivative of a signal with filter 12th order
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

function y = ndiff_Filter12(x, Nzi, izhf, dtk) 

iIni = 1;

for kzi=1:Nzi,               % Nzi-loop for multiple time segments
    
    if (kzi > 1) iIni = izhf(kzi-1) + 1; end
    iEnd = izhf(kzi);
    
    for kk=iIni:iEnd,         % time-point loop for a particular time segment
        
        if (kk < iIni+2  |  kk > iEnd-2 ),
            if (kk == iEnd),
                % set first two and last two points to values of third from start and end
                hdum(iIni  ) = hdum(iIni+2);
                hdum(iIni+1) = hdum(iIni+2);
                hdum(iEnd-1) = hdum(iEnd-2);
                hdum(iEnd  ) = hdum(iEnd-2);
            end
            
        elseif (kk <= iIni+12  |  kk >= iEnd-12 ),
            % (0; 0.666667; -0.083333) for 2-12th data points from the beginning and end:
            hdum(kk) = ( - 0.083333*( x(kk+2) - x(kk-2) )...
                         + 0.666667*( x(kk+1) - x(kk-1) ) ) / dtk;
                    
        else
            % 12th order for 13th to iEND-13 data points:
            hdum(kk) = ( - 0.00000003078 *( x(kk+12) - x(kk-12) )...
                         + 0.00000080592 *( x(kk+11) - x(kk-11) )...
                         - 0.00001019499 *( x(kk+10) - x(kk-10) )...
                         + 0.00008307106 *( x(kk+ 9) - x(kk- 9) )...
                         - 0.00049064461 *( x(kk+ 8) - x(kk- 8) )...
                         + 0.00224298741 *( x(kk+ 7) - x(kk- 7) )...
                         - 0.00828682164 *( x(kk+ 6) - x(kk- 6) )...
                         + 0.02557191749 *( x(kk+ 5) - x(kk- 5) )...
                         - 0.06793084336 *( x(kk+ 4) - x(kk- 4) )...
                         + 0.16104649973 *( x(kk+ 3) - x(kk- 3) )...
                         - 0.36248024996 *( x(kk+ 2) - x(kk- 2) )...
                         + 0.92297577618 *( x(kk+ 1) - x(kk- 1) ) ) /dtk;
        end
        
    end  % End of time-point loop for a particular time segment
    
end      % End of Nzi-loop

% Overwrite the particular channel with filtered values:
y = hdum';