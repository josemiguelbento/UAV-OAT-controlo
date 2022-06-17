function T = plots_TC23_ffnn_Lat(T, Ndata, NdataPred, XS, YS, SY, SYpred);

figure(1)
subplot(511),plot(T,YS(:,1),'b', T,SY(:,1),'r'); grid; ;ylabel('C_Y');
title('Time histories of input and output (measured and estimated) variables: training cycle')
subplot(512),plot(T,YS(:,2),'b', T,SY(:,2),'r'); grid; ;ylabel('C_l');
subplot(513),plot(T,YS(:,3),'b', T,SY(:,3),'r'); grid; ;ylabel('C_n');
subplot(514),plot(T,XS(:,4),'b');                grid; ;ylabel('\delta_a (rad)');
subplot(515),plot(T,XS(:,5),'b');                grid; ;ylabel('\delta_r (rad)');
xlabel('Time in sec');  

figure(2)
subplot(511),plot(T,YS(:,1),'b', T,SYpred(:,1),'r'); grid; ;ylabel('C_Y');
title('Time histories of input and output (measured and estimated) variables: prediction cycle')
subplot(512),plot(T,YS(:,2),'b', T,SYpred(:,2),'r'); grid; ;ylabel('C_l');
subplot(513),plot(T,YS(:,3),'b', T,SYpred(:,3),'r'); grid; ;ylabel('C_n');
subplot(514),plot(T,XS(:,4),'b');                    grid; ;ylabel('\delta_a (rad)');
subplot(515),plot(T,XS(:,5),'b');                    grid; ;ylabel('\delta_r (rad)');
xlabel('Time in sec');  
