function [X, xWS, tNewX, iNewX] = timeDelay(X, tDelay, xWS, tNewX, iNewX, nTdMx)
%
% Time delay the signal X by tDelay (see Section 3.4).
% Caveat: the input array X will be overwritten.
% 
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    X          current X-values
%    tDelay     time delay
%    xWS(I,J)   work space for intermediate saving of X-values
%               ESTIMA: XHLF(0:QMAX, J=0:nTdMx-1); now xWS(QMAX+1,nTdMx)
%    tNewX      time corresponding to the X-value
%    iNewX      index in xWS corresponding to the X-value
%    nTdMx      maximum nTdMx previous X-values are stored
%
% Outputs:
%    X          Time delayed X-values
%    xWS(I,J)   work space for intermediate saving of X-values
%    tNewX      time corresponding to the new X-value
%    iNewX      index in xWS corresponding to the new X-value


global kk  LF  iPar        % from costfun_oem / gradFG
global dt  ts              % from costfun_oem / gradFG
global rk_IntStp  tCur     % from integration functions (ruku*)
%    kk         index of the current data point being processed
%    LF         starting (data point) index of the current time segment being processed
%    iPar       index of the free parameter being varied
%    dt         sampling time
%    ts         time correspodning to the index kk
%    rk_IntStp  flag for Runge-Kutta integeration steps; set in functions for 
%               numerical numerical integration ruku*);
%               = True for intermediate steps; = FALSE for interval beginning
%    tCur       time for which something is being computed (tCur is varied in ruku*) 


% Initialization
iParP1  = iPar + 1;
nTdMxP1 = nTdMx + 1;

%-----------------------------------------------------------------------------------
% Save new X-values

% For Runge-Kutta intermediate steps, do not save X
if ~rk_IntStp,
    
    % New time segment => RE-Initialize xWS and return
    if kk == LF,
        for i1=1:nTdMx,
            xWS(iParP1,i1) = X;
        end
        iNewX = 1;
        tNewX = ts;
        return
    end

    % for ts<>tNewX => Increase iNewX and tNewX
    if ( abs(ts-tNewX) > 1.e-10*dt ),          % eps=1.0e-10*dt;
        iNewXP1 = iNewX+1;
        if (iNewXP1 <= nTdMx),
            iNewX = mod(iNewXP1, nTdMxP1);
        else
            iNewX = 1; 
        end
        tNewX = ts;
    end
    
    % Save X in work space
    xWS(iParP1,iNewX) = X;
    
end

%-----------------------------------------------------------------------------------
% Deviation from the current index ihlf
iDif = isinteger( (ts - tCur + tDelay)/dt );

% Program stop, when the work space is not sifficient
if iDif > nTdMx-1,
    disp('Error termination: Error in the program TimeDelay for time delay!');
    disp([' nTdMx =', num2str(nTdMx), ...
          ' must be increased at least to = ', num2str(iDif+1) ]);
    disp('Program terminated in the subroutine TimeDelay.');
    xxBREAK1_TimeDelay  % break;
end

% Program termination for large negative time delays
if iDif < -2,
    disp('Error termination: Error in the program TimeDelay for time delay!');
    disp('Negative time dealy ');
    disp('Program terminated in the subroutine TimeDelay.');
    xxBREAK2_TimeDelay    % break;
end

% Otherwise, possibly extrapolate
if iDif < 0, iDif = 0; end

%-----------------------------------------------------------------------------------
% Compute time delayed X-values

% Find indices k1, k2 in which the value is to be interpolated
idum = iNewX + nTdMx - double(iDif) - 1;
k1   = mod(idum, nTdMxP1) + 1;
if (k1 < nTdMx ),
    k2 = mod(k1+1, nTdMxP1);
else
    k1 = nTdMx;
    k2 = 1;
    iNewX = 1;
end

% Interpolation 
tk1 = ts - double(iDif + 1) * dt;              % tk1 = Time corresponding to k1
FAK = (tCur - tDelay - tk1) / dt;              % Factor for interpolation
X   = (1.D0-FAK) * xWS(iParP1,k1) + FAK * xWS(iParP1,k2);

return
% end of function