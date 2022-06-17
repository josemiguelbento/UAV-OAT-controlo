% Differentiate specified measured signal -- Multiple time segments:
% It is to be called only once for each signal to be differentiated.
% First time derivative of a signal using Lanczos differentiator,
% using second order polynomial and five data points.
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
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

function y = ndiff_Lanczos_p2n5(x, Nzi, izhf, dtk) 
 
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
        else
            % (0; 0.1; 0.2)
            hdum(kk) = (   0.2*( x(kk+2) - x(kk-2) )...
                         + 0.1*( x(kk+1) - x(kk-1) ) ) / dtk;
            % hdum = 0;
            % for i=1:m
            %     hdum = hdum + 3/dtk * i * (y1(k+i)-y1(k-i)) / (m*(m+1)*(2*m+1));
            % end

        end
        
    end  % End of time-point loop for a particular time segment
    
end      % End of Nzi-loop

% Overwrite the particular channel with filtered values:
y = hdum';