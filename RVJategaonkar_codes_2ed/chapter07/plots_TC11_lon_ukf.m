function t = plots_TC11_lon_ukf(t, parOEM, Z, U, syukf, sxukf, sxukfstd, method);

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

XL = t(end) + 5;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(311),plot(t,Z(:,1), t,syukf(:,1),'r-.');grid;ylabel('{\alpha} (°)');
title('UKF: Time histories of output variables (measured and estimated); input variables')
subplot(312),plot(t,Z(:,2), t,syukf(:,2),'r-.');grid;ylabel('q (°/s)');
subplot(313),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)'); xlabel('Time in sec'); 

% Plot time histories of estimated parameters
figure(2)
subplot(811),plot(t,sxukf(:,3),'k', t,sxukf(:,3)+sxukfstd(:,3),'r',...
                                    t,sxukf(:,3)-sxukfstd(:,3),'r',...
                                    [0 XL],[parOEM(1,1) parOEM(1,1)]);grid;ylabel('Z_0');
title('UKF: Convergence of parameter estimates with error bounds')
subplot(812),plot(t,sxukf(:,4),'k', t,sxukf(:,4)+sxukfstd(:,4),'r',...
                                    t,sxukf(:,4)-sxukfstd(:,4),'r',...
                                    [0 XL],[parOEM(1,2) parOEM(1,2)]);grid;ylabel('Z_{\alpha}');
subplot(813),plot(t,sxukf(:,5),'k', t,sxukf(:,5)+sxukfstd(:,5),'r',...
                                    t,sxukf(:,5)-sxukfstd(:,5),'r',...
                                    [0 XL],[parOEM(1,3) parOEM(1,3)]);grid;ylabel('Z_q');
subplot(814),plot(t,sxukf(:,6),'k', t,sxukf(:,6)+sxukfstd(:,6),'r',...
                                    t,sxukf(:,6)-sxukfstd(:,6),'r',...
                                    [0 XL],[parOEM(1,4) parOEM(1,4)]);grid;ylabel('Z_{\deltae}');
subplot(815),plot(t,sxukf(:,7),'k', t,sxukf(:,7)+sxukfstd(:,7),'r',...
                                    t,sxukf(:,7)-sxukfstd(:,7),'r',...
                                    [0 XL],[parOEM(1,5) parOEM(1,5)]);grid;ylabel('M_0');
subplot(816),plot(t,sxukf(:,8),'k', t,sxukf(:,8)+sxukfstd(:,8),'r',...
                                    t,sxukf(:,8)-sxukfstd(:,8),'r',...
                                    [0 XL],[parOEM(1,6) parOEM(1,6)]);grid;ylabel('M_{\alpha}');
subplot(817),plot(t,sxukf(:,9),'k', t,sxukf(:,9)+sxukfstd(:,9),'r',...
                                    t,sxukf(:,9)-sxukfstd(:,9),'r',...
                                    [0 XL],[parOEM(1,7) parOEM(1,7)]);grid;ylabel('M_q');
subplot(818),plot(t,sxukf(:,10),'k',t,sxukf(:,10)+sxukfstd(:,10),'r',...
                                    t,sxukf(:,10)-sxukfstd(:,10),'r',...
                                    [0 XL],[parOEM(1,8) parOEM(1,8)]);grid;ylabel('M_{\deltae}');
                                    xlabel('Time in sec');  

% Plot time histories of estimated parameters
figure(3)
subplot(321),plot(t,sxukf(:,4),'m',[0 XL],[parOEM(1,2) parOEM(1,2)]);
                  axis([0 XL,-2 2]);grid;legend('Z_{\alpha} UKF','    MLE',1);
title('UKF: Convergence of parameter estimates')
subplot(323),plot(t,sxukf(:,5),'m',[0 XL],[parOEM(1,3) parOEM(1,3)]);
                  axis([0 XL,-2 2]);grid;legend('Z_q UKF','    MLE',1);
subplot(325),plot(t,sxukf(:,6),'m',[0 XL],[parOEM(1,4) parOEM(1,4)]);
                  axis([0 XL,-2 2]);grid;legend('Z_{\deltae} UKF','     MLE',1);
                  xlabel('Time in sec')
subplot(322),plot(t,sxukf(:,8),'m',[0 XL],[parOEM(1,6) parOEM(1,6)]);
                  axis([0 XL, -10 0]);grid;legend('M_{\alpha} UKF','     MLE',1);
subplot(324),plot(t,sxukf(:,9),'m',[0 XL],[parOEM(1,7) parOEM(1,7)]);
                  axis([0 XL,-5 0]);grid;legend('M_q UKF','     MLE',1);
subplot(326),plot(t,sxukf(:,10),'m',[0 XL],[parOEM(1,8) parOEM(1,8)]);
                  axis([0 XL,-10 0]);grid;legend('M_{\deltae} UKF','     MLE',1);
                  xlabel('Time in sec')
