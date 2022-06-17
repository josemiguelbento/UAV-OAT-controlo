function T = plots_TC27_ffnn_regQStall(T, Ndata, NdataPred, XS, YS, SY, SYpred);

figure(1)
subplot(511),plot(T,YS(:,1),'b', T,SY(:,1),'r'); grid; ;ylabel('C_D');
title('Time histories of input and output (measured and estimated) variables: training cycle')
subplot(512),plot(T,YS(:,2),'b', T,SY(:,2),'r'); grid; ;ylabel('C_L');
subplot(513),plot(T,YS(:,3),'b', T,SY(:,3),'r'); grid; ;ylabel('C_m');
subplot(514),plot(T,XS(:,1),'b');                grid; ;ylabel('\alpha (rad)');
subplot(515),plot(T,XS(:,3),'b');                grid; ;ylabel('\delta_e (rad)');
xlabel('Time in sec');  

figure(2)
plot(XS(:,1),YS(:,2),'b', XS(:,1),SY(:,2),'r'); ylabel('C_L'); grid;
title('Crossplot of CL versus Angle of attack: training cycle')
xlabel('\alpha (deg)');  

figure(3)
subplot(511),plot(T,YS(:,1),'b', T,SYpred(:,1),'r'); grid; ;ylabel('C_D');
title('Time histories of input and output (measured and estimated) variables: prediction cycle')
subplot(512),plot(T,YS(:,2),'b', T,SYpred(:,2),'r'); grid; ;ylabel('C_L');
subplot(513),plot(T,YS(:,3),'b', T,SYpred(:,3),'r'); grid; ;ylabel('C_m');
subplot(514),plot(T,XS(:,1),'b');                    grid; ;ylabel('\alpha (rad)');
subplot(515),plot(T,XS(:,3),'b');                    grid; ;ylabel('\delta_e (rad)');
xlabel('Time in sec');  

figure(4)
plot(XS((1:NdataPred),1),YS(:,2),'b', XS((1:NdataPred),1),SYpred(:,2),'r'); ylabel('C_L'); grid;
title('Crossplot of CL versus Angle of attack: prediction cycle')
xlabel('\alpha (rad)');  
 