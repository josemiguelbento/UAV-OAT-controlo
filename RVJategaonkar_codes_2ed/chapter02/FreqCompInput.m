% Frequency response magnitudes of the individual terms in the pitching
% moment equation as a function of the input signal frequency.
% Test case specified by Equations (2.6) and (2.7)
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA


% State matrix
A = [-0.0091  9.43   0    -9.80665;...
     -0.0022 -0.867  1     0;...
      0      -3.49  -2.04  0;...
      0       0      1     0];

% Control Matrix
B = [0 -0.11 -5.09 0]';

% Frequency vector (rad/s)
% W=(0.1:0.1:100);
% W=logspace(-1, 2, 100);

% Pitch acceleration qdot
C = [0 -3.49 -2.04 0];
D = [-5.09];
SYSQP = ss(A,B,C,D);

% M-Alpha contribution  
C = [0 -3.49 0 0];
D = [0];
SYSMAL = ss(A,B,C,D);

% M-Q contribution  
C = [0 0 -2.04 0];
D = [0];
SYSMQ = ss(A,B,C,D);

% M-DE contribution  
C = [0 0 0 0];
D = [-5.09];
SYSMDE = ss(A,B,C,D);

% Bode magnitude plot
bodemag(SYSQP,'b',SYSMAL,'g',SYSMQ,'m',SYSMDE,'r', {0.01 100}); grid

