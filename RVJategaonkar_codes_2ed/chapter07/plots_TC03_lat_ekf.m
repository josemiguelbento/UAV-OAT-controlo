function t = plots_TC03_lat_ekf(t, parOEM, Z, U, sy, sx, sxstd, method);

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Time history plots of measured and estimated responses and parameter convergence
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
%                Parameters - Lp, Lr, Lda, Ldr, Lbeta, L0, Np, Nr, Nda, Ndr, Nbeta, N0
%                Augmented states - p, r, Lp, Lr, Lda, Ldr, Lbeta, L0, Np, Nr, Nda, Ndr, Nbeta, N0

% Conversion factor radians to degrees
r2d = 180/pi;

XL = t(end) + 5;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(511),plot(t,Z(:,1)*r2d, t,sy(:,1)*r2d,'r');grid;ylabel('p (°/s)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(512),plot(t,Z(:,2)*r2d, t,sy(:,2)*r2d,'r');grid;ylabel('r (°/s)');
subplot(513),plot(t,U(:,1)*r2d);grid;ylabel('{\delta_a} (°)');
subplot(514),plot(t,U(:,2)*r2d);grid;ylabel('{\delta_r} (°)'); 
subplot(515),plot(t,U(:,3)*r2d);grid;ylabel('{\beta} (°)');
xlabel('Time in sec');  

% Plot time histories of estimated parameters
figure(2)
subplot(611),plot(t,sx(:,3),'k', t,sx(:,3)+sxstd(:,3),'r',...
                                 t,sx(:,3)-sxstd(:,3),'r',...
                                 [0 XL],[parOEM(1,1) parOEM(1,1)]);grid;ylabel('L_p');
                                 legend('x','x+\sigma','x-\sigma','OEM',1)
title('EKF: Convergence of parameter estimates with error bounds')
subplot(612),plot(t,sx(:,4),'k', t,sx(:,4)+sxstd(:,4),'r',...
                                 t,sx(:,4)-sxstd(:,4),'r',...
                                 [0 XL],[parOEM(1,2) parOEM(1,2)]);grid;ylabel('L_r');
subplot(613),plot(t,sx(:,5),'k', t,sx(:,5)+sxstd(:,5),'r',...
                                 t,sx(:,5)-sxstd(:,5),'r',...
                                 [0 XL],[parOEM(1,3) parOEM(1,3)]);grid;ylabel('L_{\deltaa}');
subplot(614),plot(t,sx(:,6),'k', t,sx(:,6)+sxstd(:,6),'r',...
                                 t,sx(:,6)-sxstd(:,6),'r',...
                                 [0 XL],[parOEM(1,4) parOEM(1,4)]);grid;ylabel('L_{\deltar}');
subplot(615),plot(t,sx(:,7),'k', t,sx(:,7)+sxstd(:,7),'r',...
                                 t,sx(:,7)-sxstd(:,7),'r',...
                                 [0 XL],[parOEM(1,5) parOEM(1,5)]);grid;ylabel('L_{\beta}');
subplot(616),plot(t,sx(:,8),'k', t,sx(:,8)+sxstd(:,8),'r',...
                                 t,sx(:,8)-sxstd(:,8),'r',...
                                 [0 XL],[parOEM(1,6) parOEM(1,6)]);grid;ylabel('L_0');
                                 xlabel('Time in sec');  

% Plot time histories of estimated parameters
figure(3)
subplot(321),plot(t,sx(:,7),'m',[0 XL],[parOEM(1,5) parOEM(1,5)]);
                  axis([0 XL,-6 2]);grid;legend('L_{\beta} EKF','    MLE',1);
title('EKF: Convergence of parameter estimates')
subplot(323),plot(t,sx(:,3),'m',[0 XL],[parOEM(1,1) parOEM(1,1)]);
                  axis([0 XL,-4 2]);grid;legend('L_p EKF','    MLE',1);
subplot(325),plot(t,sx(:,5),'m',[0 XL],[parOEM(1,3) parOEM(1,3)]);
                  axis([0 XL,-10 2]);grid;legend('L_{\delta_a} EKF','     MLE',1);
                  xlabel('Time in sec')
subplot(322),plot(t,sx(:,13),'m',[0 XL],[parOEM(1,11) parOEM(1,11)]);
                  axis([0 XL,1 6]);grid;legend('N_{\beta} EKF','     MLE',1);
subplot(324),plot(t,sx(:,10),'m',[0 XL],[parOEM(1,8) parOEM(1,8)]);
                  axis([0 XL,-2 3]);grid;legend('N_r EKF','     MLE',1);
subplot(326),plot(t,sx(:,12),'m',[0 XL],[parOEM(1,10) parOEM(1,10)]);
                  axis([0 XL,-4 2]);grid;legend('N_{\delta_r} EKF','     MLE',1);
                  xlabel('Time in sec')
