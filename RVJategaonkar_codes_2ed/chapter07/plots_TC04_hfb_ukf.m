function t = plots_TC04_hfb_ukf(t, parFEM, Z, U, sy, sx, sxstd, method);

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Conversion factor radians to degrees
r2d = 180/pi;

XL = t(end) + 5;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(811),plot(t,Z(:,1),     t,sy(:,1),'r');grid;ylabel('V (m/s)');
title('Time histories of output variables (measured and estimated); input variables')
subplot(812),plot(t,Z(:,2)*r2d, t,sy(:,2)*r2d,'r');grid;ylabel('\alpha (°)');
subplot(813),plot(t,Z(:,3)*r2d, t,sy(:,3)*r2d,'r');grid;ylabel('\theta (°)');
subplot(814),plot(t,Z(:,4)*r2d, t,sy(:,4)*r2d,'r');grid;ylabel('q (°/s)');
subplot(815),plot(t,Z(:,5)*r2d, t,sy(:,5)*r2d,'r');grid;ylabel('qp (°/s2)');
subplot(816),plot(t,Z(:,6),     t,sy(:,6),'r');    grid;ylabel('ax (m/s2)');
subplot(817),plot(t,Z(:,7),     t,sy(:,7),'r');    grid;ylabel('az (m/s2)');
subplot(818),plot(t,U(:,1)*r2d);                   grid;ylabel('{\delta_e} (°)');
xlabel('Time in sec');  

disp(' ')
disp('The time history plots for the model output from UKF may show large deviations')
disp('for the first data point. This is because, the initial p0 specified in')
disp('mDEfCase**.m may be too large for the system states or parameters.')
disp('The Sigma points are computed based on initially specified xa0 and p0.')
disp('For the subsequent data points the Sigma points are generated using the updated')
disp('covariances, which are computed by the UKF-algorithm, and are more realistic.')
disp('This problem is specific to UKF only.')

% Plot time histories of estimated parameters
figure(2)
subplot(611),plot(t,sx(:,5),'k', t,sx(:,5)+sxstd(:,5),'r',...
                                 t,sx(:,5)-sxstd(:,5),'r',...
                                 [0 XL],[parFEM(1,1) parFEM(1,1)]);grid;ylabel('CD_0');
                                 legend('x','x+\sigma','x-\sigma','FEM',1)
title('UKF: Convergence of parameter estimates with error bounds')
subplot(612),plot(t,sx(:,6),'k', t,sx(:,6)+sxstd(:,6),'r',...
                                 t,sx(:,6)-sxstd(:,6),'r',...
                                 [0 XL],[parFEM(1,2) parFEM(1,2)]);grid;ylabel('CD_V');
subplot(613),plot(t,sx(:,7),'k', t,sx(:,7)+sxstd(:,7),'r',...
                                 t,sx(:,7)-sxstd(:,7),'r',...
                                 [0 XL],[parFEM(1,3) parFEM(1,3)]);grid;ylabel('CD_{\alpha}');
subplot(614),plot(t,sx(:,8),'k', t,sx(:,8)+sxstd(:,8),'r',...
                                 t,sx(:,8)-sxstd(:,8),'r',...
                                 [0 XL],[parFEM(1,4) parFEM(1,4)]);grid;ylabel('CL_0');
subplot(615),plot(t,sx(:,9),'k', t,sx(:,9)+sxstd(:,9),'r',...
                                 t,sx(:,9)-sxstd(:,9),'r',...
                                 [0 XL],[parFEM(1,5) parFEM(1,5)]);grid;ylabel('CL_V');
subplot(616),plot(t,sx(:,10),'k', t,sx(:,10)+sxstd(:,10),'r',...
                                  t,sx(:,10)-sxstd(:,10),'r',...
                                  [0 XL],[parFEM(1,6) parFEM(1,6)]);grid;ylabel('CL_{\alpha}');

figure(3)
subplot(511),plot(t,sx(:,11),'k', t,sx(:,11)+sxstd(:,11),'r',...
                                  t,sx(:,11)-sxstd(:,11),'r',...
                                  [0 XL],[parFEM(1,7) parFEM(1,7)]);grid;ylabel('Cm_0');
                                  legend('x','x+\sigma','x-\sigma','FEM',1)
title('UKF: Convergence of parameter estimates with error bounds')
subplot(512),plot(t,sx(:,12),'k', t,sx(:,12)+sxstd(:,12),'r',...
                                  t,sx(:,12)-sxstd(:,12),'r',...
                                  [0 XL],[parFEM(1,8) parFEM(1,8)]);grid;ylabel('Cm_V');
subplot(513),plot(t,sx(:,13),'k', t,sx(:,13)+sxstd(:,13),'r',...
                                  t,sx(:,13)-sxstd(:,13),'r',...
                                  [0 XL],[parFEM(1,9) parFEM(1,9)]);grid;ylabel('Cm_{\alpha}');
subplot(514),plot(t,sx(:,14),'k', t,sx(:,14)+sxstd(:,14),'r',...
                                  t,sx(:,14)-sxstd(:,14),'r',...
                                  [0 XL],[parFEM(1,10) parFEM(1,10)]);grid;ylabel('Cm_q');
subplot(515),plot(t,sx(:,15),'k', t,sx(:,15)+sxstd(:,15),'r',...
                                  t,sx(:,15)-sxstd(:,15),'r',...
                                  [0 XL],[parFEM(1,11) parFEM(1,11)]);grid;ylabel('Cm_{\deltae}');

% Plot time histories of estimated parameters
figure(4)
subplot(6,2,1),plot(t,sx(:,5),'m',[0 XL],[parFEM(1,1) parFEM(1,1)]);
                  axis([0 XL,-1 1]);grid;legend('CD_0 UKF','    FEM',1);
title('UKF: Convergence of parameter estimates')
subplot(6,2,3), plot(t,sx(:,6),'m',[0 XL],[parFEM(1,2) parFEM(1,2)]);
                  axis([0 XL,-1 1]);grid;legend('CD_V UKF','    FEM',1);
subplot(6,2,5), plot(t,sx(:,7),'m',[0 XL],[parFEM(1,3) parFEM(1,3)]);
                  axis([0 XL,-2 2]);grid;legend('CD_{\alpha} UKF','     FEM',1);
subplot(6,2,7), plot(t,sx(:,8),'m',[0 XL],[parFEM(1,4) parFEM(1,4)]);
                  axis([0 XL,-2 4]);grid;legend('CL_0 UKF','     FEM',1);
subplot(6,2,9), plot(t,sx(:,9),'m',[0 XL],[parFEM(1,5) parFEM(1,5)]);
                  axis([0 XL,-4 2]);grid;legend('CL_V UKF','     FEM',1);
subplot(6,2,11),plot(t,sx(:,10),'m',[0 XL],[parFEM(1,6) parFEM(1,6)]);
                  axis([0 XL,-0 8]);grid;legend('CL_{\alpha} UKF','     FEM',1);
                  xlabel('Time in sec')
subplot(6,2,2), plot(t,sx(:,11),'m',[0 XL],[parFEM(1,7) parFEM(1,7)]);
                  axis([0 XL,-2 2]);grid;legend('Cm_0 UKF','     FEM',1);
subplot(6,2,4), plot(t,sx(:,12),'m',[0 XL],[parFEM(1,8) parFEM(1,8)]);
                  axis([0 XL,-2 2]);grid;legend('Cm_V UKF','     FEM',1);
subplot(6,2,6), plot(t,sx(:,13),'m',[0 XL],[parFEM(1,9) parFEM(1,9)]);
                  axis([0 XL,-3 3]);grid;legend('Cm_{\alpha} UKF','     FEM',1);
subplot(6,2,8), plot(t,sx(:,14),'m',[0 XL],[parFEM(1,10) parFEM(1,10)]);
                  axis([0 XL,-40 -20]);grid;legend('Cm_q UKF','     FEM',1);
subplot(6,2,10),plot(t,sx(:,15),'m',[0 XL],[parFEM(1,11) parFEM(1,11)]);
                  axis([0 XL,-5 0]);grid;legend('Cm_{\deltae} UKF','     FEM',1);
                  xlabel('Time in sec')
