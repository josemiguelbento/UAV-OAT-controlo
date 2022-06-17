function t = plots_TC08_uAC_3RPE(t, parOEM, Z, U, syekf,sxekf,sxekfstd,...
                                                  syukf,sxukf,sxukfstd,...
                                                  syukfAug,sxukfAug,sxukfAugstd,method);

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

% Conversion factor radians to degrees
r2d = 180/pi;

XL = t(end) + 5;

% EKF: Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(411),plot(t,Z(:,1),'b', t,syekf(:,1),'r');grid;ylabel('a_z (m/s2)');
title('EKF: Time histories of output variables (measured and estimated); input variable')
subplot(412),plot(t,Z(:,2),'b', t,syekf(:,2),'r');grid;ylabel('w (m/s)');
subplot(413),plot(t,Z(:,3),'b', t,syekf(:,3),'r');grid;ylabel('q (rad/s)');
subplot(414),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

% EKF: Plot time histories of estimated parameters
figure(2)
subplot(511),plot(t,sxekf(:,3),'k', t,sxekf(:,3)+sxekfstd(:,3),'r',...
                                    t,sxekf(:,3)-sxekfstd(:,3),'r');grid;ylabel('Z_w');
title('EKF: Convergence of parameter estimates with error bounds')
subplot(512),plot(t,sxekf(:,4),'k', t,sxekf(:,4)+sxekfstd(:,4),'r',...
                                    t,sxekf(:,4)-sxekfstd(:,4),'r');grid;ylabel('Z_{\eta}');
subplot(513),plot(t,sxekf(:,5),'k', t,sxekf(:,5)+sxekfstd(:,5),'r',...
                                    t,sxekf(:,5)-sxekfstd(:,5),'r');grid;ylabel('m_w');
subplot(514),plot(t,sxekf(:,6),'k', t,sxekf(:,6)+sxekfstd(:,6),'r',...
                                    t,sxekf(:,6)-sxekfstd(:,6),'r');grid;ylabel('m_q');
subplot(515),plot(t,sxekf(:,7),'k', t,sxekf(:,7)+sxekfstd(:,7),'r',...
                                    t,sxekf(:,7)-sxekfstd(:,7),'r');grid;ylabel('m_{\deltae}');

                                
% UKF: Plot time histories of measured and estimated observation variables and control inputs
figure(3)
subplot(411),plot(t,Z(:,1),'b', t,syukf(:,1),'r');grid;ylabel('a_z (m/s2)');
title('UKF: Time histories of output variables (measured and estimated); input variable')
subplot(412),plot(t,Z(:,2),'b', t,syukf(:,2),'r');grid;ylabel('w (m/s)');
subplot(413),plot(t,Z(:,3),'b', t,syukf(:,3),'r');grid;ylabel('q (rad/s)');
subplot(414),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

% UKF: Plot time histories of estimated parameters
figure(4)
subplot(511),plot(t,sxukf(:,3),'k', t,sxukf(:,3)+sxukfstd(:,3),'r',...
                                    t,sxukf(:,3)-sxukfstd(:,3),'r');grid;ylabel('Z_w');
title('UKF: Convergence of parameter estimates with error bounds')
subplot(512),plot(t,sxukf(:,4),'k', t,sxukf(:,4)+sxukfstd(:,4),'r',...
                                    t,sxukf(:,4)-sxukfstd(:,4),'r');grid;ylabel('Z_{\eta}');
subplot(513),plot(t,sxukf(:,5),'k', t,sxukf(:,5)+sxukfstd(:,5),'r',...
                                    t,sxukf(:,5)-sxukfstd(:,5),'r');grid;ylabel('m_w');
subplot(514),plot(t,sxukf(:,6),'k', t,sxukf(:,6)+sxukfstd(:,6),'r',...
                                    t,sxukf(:,6)-sxukfstd(:,6),'r');grid;ylabel('m_q');
subplot(515),plot(t,sxukf(:,7),'k', t,sxukf(:,7)+sxukfstd(:,7),'r',...
                                    t,sxukf(:,7)-sxukfstd(:,7),'r');grid;ylabel('m_{\deltae}');

                                
% UKFaugmented: Plot time histories of measured and estimated observation variables and control inputs
figure(5)
subplot(411),plot(t,Z(:,1),'b', t,syukfAug(:,1),'r');grid;ylabel('a_z (m/s2)');
title('UKFaug: Time histories of output variables (measured and estimated); input variable')
subplot(412),plot(t,Z(:,2),'b', t,syukfAug(:,2),'r');grid;ylabel('w (m/s)');
subplot(413),plot(t,Z(:,3),'b', t,syukfAug(:,3),'r');grid;ylabel('q (rad/s)');
subplot(414),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

% UKFaugmented: Plot time histories of estimated parameters
figure(6)
subplot(511),plot(t,sxukfAug(:,3),'k', t,sxukfAug(:,3)+sxukfAugstd(:,3),'r',...
                                    t,sxukfAug(:,3)-sxukfAugstd(:,3),'r');grid;ylabel('Z_w');
title('UKFaug: Convergence of parameter estimates with error bounds')
subplot(512),plot(t,sxukfAug(:,4),'k', t,sxukfAug(:,4)+sxukfAugstd(:,4),'r',...
                                    t,sxukfAug(:,4)-sxukfAugstd(:,4),'r');grid;ylabel('Z_{\eta}');
subplot(513),plot(t,sxukfAug(:,5),'k', t,sxukfAug(:,5)+sxukfAugstd(:,5),'r',...
                                    t,sxukfAug(:,5)-sxukfAugstd(:,5),'r');grid;ylabel('m_w');
subplot(514),plot(t,sxukfAug(:,6),'k', t,sxukfAug(:,6)+sxukfAugstd(:,6),'r',...
                                    t,sxukfAug(:,6)-sxukfAugstd(:,6),'r');grid;ylabel('m_q');
subplot(515),plot(t,sxukfAug(:,7),'k', t,sxukfAug(:,7)+sxukfAugstd(:,7),'r',...
                                    t,sxukfAug(:,7)-sxukfAugstd(:,7),'r');grid;ylabel('m_{\deltae}');
