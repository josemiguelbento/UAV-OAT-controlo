function T = plots_TC04_ffnn_hfb(T, Ndata, NdataPred, XS, YS, SY, SYpred);

% Plot time histories of measured inputs; and of measured and estimated outputs

figure(1)
subplot(611),plot(T,YS(:,1),'b', T,SY(:,1),'r'); grid; ;ylabel('C_D');
title('Time histories of input and output (measured and estimated) variables: training cycle')
subplot(612),plot(T,YS(:,2),'b', T,SY(:,2),'r'); grid; ;ylabel('C_L');
subplot(613),plot(T,YS(:,3),'b', T,SY(:,3),'r'); grid; ;ylabel('C_m');
subplot(614),plot(T,XS(:,2),'b');                grid; ;ylabel('\alpha (rad)');
subplot(615),plot(T,XS(:,3),'b');                grid; ;ylabel('q (rad/s)');
subplot(616),plot(T,XS(:,1),'b');                grid; ;ylabel('\delta_e (rad)');
xlabel('Time in sec');  

figure(2)
subplot(611),plot(T,YS(:,1),'b', T,SYpred(:,1),'r'); grid; ;ylabel('C_D');
title('Time histories of input and output (measured and estimated) variables: prediction cycle')
subplot(612),plot(T,YS(:,2),'b', T,SYpred(:,2),'r'); grid; ;ylabel('C_L');
subplot(613),plot(T,YS(:,3),'b', T,SYpred(:,3),'r'); grid; ;ylabel('C_m');
subplot(614),plot(T,XS(:,2),'b');                    grid; ;ylabel('\alpha (rad)');
subplot(615),plot(T,XS(:,3),'b');                    grid; ;ylabel('q (rad/s)');
subplot(616),plot(T,XS(:,1),'b');                    grid; ;ylabel('\delta_e (rad)');
xlabel('Time in sec');  
