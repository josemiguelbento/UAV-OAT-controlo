function t = plots_TC08_uAC_ekf(t, parOEM, Z, U, sy, sx, sxstd, method)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

% Conversion factor radians to degrees
r2d = 180/pi;

XL = t(end) + 5;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(411),plot(t,Z(:,1),'b', t,sy(:,1),'r');grid;ylabel('a_z (m/s2)');
title('Time histories of output variables (measured and estimated); input variable')
subplot(412),plot(t,Z(:,2),'b', t,sy(:,2),'r');grid;ylabel('w (m/s)');
subplot(413),plot(t,Z(:,3),'b', t,sy(:,3),'r');grid;ylabel('q (rad/s)');
subplot(414),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

% Plot time histories of estimated parameters
figure(2)
subplot(511),plot(t,sx(:,3),'k', t,sx(:,3)+sxstd(:,3),'r',...
                                 t,sx(:,3)-sxstd(:,3),'r');grid;ylabel('Z_w');
title('Convergence of parameter estimates with error bounds')
subplot(512),plot(t,sx(:,4),'k', t,sx(:,4)+sxstd(:,4),'r',...
                                 t,sx(:,4)-sxstd(:,4),'r');grid;ylabel('Z_{\eta}');
subplot(513),plot(t,sx(:,5),'k', t,sx(:,5)+sxstd(:,5),'r',...
                                 t,sx(:,5)-sxstd(:,5),'r');grid;ylabel('m_w');
subplot(514),plot(t,sx(:,6),'k', t,sx(:,6)+sxstd(:,6),'r',...
                                 t,sx(:,6)-sxstd(:,6),'r');grid;ylabel('m_q');
subplot(515),plot(t,sx(:,7),'k', t,sx(:,7)+sxstd(:,7),'r',...
                                 t,sx(:,7)-sxstd(:,7),'r');grid;ylabel('m_{\deltae}');
