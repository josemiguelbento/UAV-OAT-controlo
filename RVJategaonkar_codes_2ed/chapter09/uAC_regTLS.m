% uAC_regTLS
%
% Chapter 2 'Data Gathering'
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Unstable aircraft (simulated data), short period, Output error method
% Section 9.16.1 
%
% Total least squares method 
% This is a separate program to compute the LS estimates.
% The data is read once.
% The Normal equation is to be solved once for each output; 
% in the present case there are two outputs, az and qdot.
% Since qdot is not measured directly, it is obtained by numerical
% differentiation of q.

disp(' ');
disp('Unstable aircraft - simulated data:')
disp('Total Least Squares method:')

load -ascii ..\flt_data\unStabAC_sim.asc;
data  = unStabAC_sim;     
Ndata = size(unStabAC_sim,1);
dt    = 0.05;                           % sampling time
time  = [0:dt:Ndata*dt-dt]';            % time

%--------------------------------------------------------------------------
% Observation variable az (= Zw*w + Zq*q + Zde*de)
YAz = data(:,6);

% Input variables w, q, de
XAz = [data(:,3) data(:,4) data(:,5)];

% TLS estimates by svd
np  = size(XAz,2);
np1 = np + 1;
XYcomp = [XAz YAz];              % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);  % Compute svd - economy: only for first n columns of ue
AzPar = -(ve(1:np,np1)/ve(np1,np1));

disp(' ')
disp('estimates of parameters appearing in az')
[YAzhat, par_std, par_std_rel, R2Stat] = LS_Stat(XAz, YAz, AzPar);

%--------------------------------------------------------------------------
% Observation variable qdot (= Mw*w + Mq*q + Mde*de)
Nzi = 1;
izhf(1) = Ndata;
q = data(:,4);
Yqdot = ndiff_Filter08(q, Nzi, izhf, dt);

% Input variables w, q, de
Xqdot = [data(:,3) data(:,4) data(:,5)];

% TLS estimates by svd
np  = size(Xqdot,2);
np1 = np + 1;
XYcomp = [Xqdot Yqdot];              % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);  % Compute svd - economy: only for first n columns of ue
qdotPar = -(ve(1:np,np1)/ve(np1,np1));


disp(' ')
disp('estimates of parameters appearing in qDot')
[Yqdothat, par_std, par_std_rel, R2Stat] = LS_Stat(Xqdot, Yqdot, qdotPar);


%--------------------------------------------------------------------------
%Plot time histories of computed (measured) and estimated variables
figure(1)
subplot(511),plot(time,YAz(:,1),'b', time,YAzhat(:,1),'r'); grid; ylabel('Az (m(s2)');
title('Time histories of output variables (measured and estimated), and inputs')
subplot(512),plot(time,Yqdot(:,1),'b', time,Yqdothat(:,1),'r'); grid; ylabel('qDot (rad/s2)');
subplot(513),plot(time,Xqdot(:,1)); grid; ylabel('w (m/s)');
subplot(514),plot(time,Xqdot(:,2)); grid; ylabel('q (rad/s)');
subplot(515),plot(time,Xqdot(:,3)); grid; ylabel('\delta_e (rad)');
xlabel('Time in sec'); 

