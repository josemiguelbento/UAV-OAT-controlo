function t = plots_TC11_lon_rls(t, parOEM, Z, U, syrls, sxrls, sxrlsstd, method);

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

XL = t(end) + 5;

% Plot time histories of measured and estimated observation variables and control inputs
figure(1)
subplot(311),plot(t,Z(:,1), t,syrls(:,1),'r-.');grid;ylabel('{\alpha} (°)');
title('RLS: Time histories of output variables (measured and estimated); input variables')
subplot(312),plot(t,Z(:,2), t,syrls(:,2),'r-.');grid;ylabel('q (°/s)');
subplot(313),plot(t,U(:,1));grid;ylabel('{\delta_e} (°)'); xlabel('Time in sec'); 

% Plot time histories of estimated parameters
figure(2)
subplot(321),plot(t,sxrls(:,4),'m',[0 XL],[parOEM(1,2) parOEM(1,2)]);
                  axis([0 XL,-2 2]);grid;legend('Z_{\alpha} RLS','    MLE',1);
title('rls: Convergence of parameter estimates')
subplot(323),plot(t,sxrls(:,5),'m',[0 XL],[parOEM(1,3) parOEM(1,3)]);
                  axis([0 XL,-2 2]);grid;legend('Z_q RLS','    MLE',1);
subplot(325),plot(t,sxrls(:,6),'m',[0 XL],[parOEM(1,4) parOEM(1,4)]);
                  axis([0 XL,-2 2]);grid;legend('Z_{\deltae} RLS','     MLE',1);
                  xlabel('Time in sec')
subplot(322),plot(t,sxrls(:,8),'m',[0 XL],[parOEM(1,6) parOEM(1,6)]);
                  axis([0 XL, -10 0]);grid;legend('M_{\alpha} RLS','     MLE',1);
subplot(324),plot(t,sxrls(:,9),'m',[0 XL],[parOEM(1,7) parOEM(1,7)]);
                  axis([0 XL,-5 0]);grid;legend('M_q RLS','     MLE',1);
subplot(326),plot(t,sxrls(:,10),'m',[0 XL],[parOEM(1,8) parOEM(1,8)]);
                  axis([0 XL,-10 0]);grid;legend('M_{\deltae} RLS','     MLE',1);
                  xlabel('Time in sec')
