% Differentiate specified measured signal -- Multiple time segments:
% It is to be called only once for each signal to be differentiated.
% First time derivative of a signal using Savitzky-Golay differentiator,
% based on matlab function sgolay (with 2nd order polynomial, 5 points).
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

function y = ndiff_SGolay_p2n5(x, Nzi, izhf, dtk) 

% Compute Savitzky-Golay differentiation filter G
% Second order polynomial, with 9 data points (equivalent of ndiff_Filter02)
nPoly      = 2;
WinSize    = 5;
HalfWin    = ((WinSize+1)/2) - 1;
[bSG, gSG] = sgolay(nPoly, WinSize); 

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
            % Savitzky-Golay
            hdum(kk) = dot(gSG(:,2), x(kk-HalfWin:kk+HalfWin)) /dtk; 
        end
            
    end  % End of time-point loop for a particular time segment

end      % End of Nzi-loop

% Overwrite the particular channel with filtered values:
y = hdum';