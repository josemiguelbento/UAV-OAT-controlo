function y = ndiff_PavelH_p2n9(x, Nzi, izhf, dtk) 
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Differentiate specified measured signal -- Multiple time segments:
% It is to be called only once for each signal to be differentiated.
% First time derivative of a signal using Smooth noise-robust  
% differentiator by Pavel Holoborodko with nine data points
%
% Reference: Pavel Holoborodko;
% http://www.holoborodko.com/pavel/numerical-methods/numerical-derivative/smooth-low-noise-differentiators/
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

Npts = 9;
M  = (Npts-1)/2;
m  = (Npts-3)/2;
% Calculate the coefficients
for k = 1:M
    cks(k) = ( binomialCoeff (2*m, m-k+1) - ...
               binomialCoeff (2*m, m-k-1) ) / (2^(2*m+1));
end
cksF = [-cks(end:-1:1)'; 0; cks(1:end)']; % Rearrange for dot product

% Initialization of auxiliary variables
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
                         + 0.666667*( x(kk+1) - x(kk-1) ) ) /dtk;
        else
            % Pavel Holoborodko
%             xSum = 0.0;
%             for k = 1:M, 
%                 xSum = xSum + cks(k)/dtk * (x(kk+k)-x(kk-k));
%             end
%             hdum(kk) = xSum;
            hdum(kk) = dot(cksF, x(kk-M:kk+M)) /dtk;
        end
            
    end  % End of time-point loop for a particular time segment

end      % End of Nzi-loop

% Overwrite the particular channel with filtered values:
y = hdum';