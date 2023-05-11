%
%  script totter_demo.m
%
%  Usage: totter_demo;
%
%  Description:
%
%    Demonstrates flight data analysis and modeling 
%    using SIDPAC for a longitudinal flight test maneuver 
%    on the NASA Glenn Twin Otter aircraft.
%
%  Input:
%
%    None
%
%  Output:
%
%    data file
%    2-D plots
%

%
%    Calls:
%      compfc.m
%      compmc.m
%      xsmep.m
%      lesq.m
%      r_colores.m
%      model_disp.m
%      swr.m
%      zep.m
%      tfest.m
%      nldyn_psel.m
%      oe.m
%      nldyn.m
%      m_colores.m
%      plotpest.m
%      tfsim.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%     11 Jul 2002 - Created and debugged, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%

%
%  Load the data file.
%
load 'totter_lon_020213f1_018.mat'
%
%  Set up the figure window.
%
FgH=figure('Units','normalized','Position',[.506 .231 .504 .715],...
           'Name','SIDPAC Demonstration','NumberTitle','off','Toolbar','none');
%
%  Plot the measured inputs and outputs.
%
subplot(4,1,1), plot(t,fdata(:,14),'LineWidth',2), 
title('Twin Otter Flight Test Data','FontWeight','bold'),
grid on, ylabel('elevator  (deg)'),
subplot(4,1,2), plot(t,fdata(:,4),'LineWidth',2), 
grid on, ylabel('alpha  (deg)'), 
subplot(4,1,3), plot(t,fdata(:,6),'LineWidth',2), 
grid on, ylabel('q  (deg/sec)'), 
subplot(4,1,4), plot(t,fdata(:,13),'LineWidth',2), 
grid on, ylabel('az  (g)'), xlabel('time (sec)'), 
fprintf('\n\n The figure shows the measured input and outputs.')
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Calculate aerodynamic force and moment coefficients.
%
fprintf('\n\n Calculate the non-dimensional ')
fprintf('\n aerodynamic force and moment ')
fprintf('\n coefficients using compfc.m and compmc.m:')
fprintf('\n\n [CX,CY,CZ,CD,CYw,CL]=compfc(fdata);')
fprintf('\n\n [Cl,Cm,Cn]=compmc(fdata);')
[CX,CY,CZ,CD,CYw,CL]=compfc(fdata);
[Cl,Cm,Cn,pv,qv,rv]=compmc(fdata);
subplot(2,1,1),plot(t,CZ,'LineWidth',2),grid on,ylabel('Z Force Coefficient'),
title('Non-Dimensional Coefficients from Flight Test Data','FontWeight','bold'),
subplot(2,1,2),plot(t,Cm,'LineWidth',2),grid on,ylabel('Pitching Moment Coefficient'),xlabel('time (sec)'), 
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Assemble the regressor matrix.
%
fprintf('\n\n Assemble the matrix of regressors ')
fprintf('\n for equation-error parameter estimation: ')
fprintf('\n\n alpha  (rad)'),
fprintf('\n qhat '),
fprintf('\n elevator  (rad)'),
X=[fdata(:,4)*pi/180,fdata(:,72),fdata(:,14)*pi/180];
%
%  Plot the regressors.
%
subplot(3,1,1),plot(t,X(:,1),'LineWidth',2),grid on,ylabel('alpha  (rad)'),
title('Equation-Error Regressors','FontWeight','bold'),
subplot(3,1,2),plot(t,X(:,2),'LineWidth',2),grid on,ylabel('qhat '),
subplot(3,1,3),plot(t,X(:,3),'LineWidth',2),grid on,ylabel('elevator  (rad)'),
xlabel('time (sec)'),
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Find smoothed trim values. 
%
fprintf('\n\n Find the smoothed trim values ')
fprintf('\n from the regressors using xsmep.m:')
fprintf('\n\n X0=xsmep(X,1.0,dt);')
X0=xsmep(X,1,dt);
%
%  Plot the regressors and the smoothed trim values.
%
subplot(3,1,1),plot(t,X(:,1),'LineWidth',2),hold on,
title('Equation-Error Regressors','FontWeight','bold'),
plot(t(1),X(1,1),'r.','MarkerSize',14,'LineWidth',2), hold off,
grid on,ylabel('alpha  (rad)'),
subplot(3,1,2),plot(t,X(:,2),'LineWidth',2), hold on,
plot(t(1),X(1,2),'r.','MarkerSize',14,'LineWidth',2), hold off,
grid on,ylabel('qhat '),
subplot(3,1,3),plot(t,X(:,3),'LineWidth',2), hold on,
plot(t(1),X(1,3),'r.','MarkerSize',14,'LineWidth',2), hold off,
grid on,ylabel('elevator  (deg)'),xlabel('time (sec)'),
%
%  Remove the smoothed trim values.
%
fprintf('\n\n Remove the smoothed trim values ')
fprintf('\n from the regressors using :')
fprintf('\n\n X=X-ones(size(X,1),1)*X0(1,:);')
X=X-ones(size(X,1),1)*X0(1,:);
%
%  Program lesq.m requires a constant regressor for the bias term.
%
X=[X,ones(size(X,1),1)];
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Linear regression for the Z force coefficient.
%
fprintf('\n\n Z force coefficient:')
fprintf('\n\n Estimate stability and control ')
fprintf('\n derivatives using equation-error ')
fprintf('\n linear regression program lesq.m: ')
fprintf('\n\n [yZ,pZ,crbZ,s2Z]=lesq(X,CZ);')
[yZ,pZ,crbZ,s2Z]=lesq(X,CZ);
%
%  Plot the results.
%
subplot(2,1,1),plot(t,CZ,t,yZ,'r:','LineWidth',2),grid on,
title('Equation-Error Parameter Estimation','FontWeight','bold'),
ylabel('CZ'),legend('Flight data','Regression model',0),
subplot(2,1,2),plot(t,CZ-yZ,'LineWidth',1.5),grid on,
ylabel('Residual'),xlabel('time (sec)'),
%
%  Compute and display the error bounds.  
%
fprintf('\n\n Compute the estimated parameter ')
fprintf('\n error bounds using r_colores.m: ')
fprintf('\n\n [crbZ,crboZ]=r_colores(X,CZ); ')
[crbZ,crboZ]=r_colores(X,CZ);
serroZ=sqrt(diag(crboZ));
serrZ=sqrt(diag(crbZ));
perrZ=100*serrZ./abs(pZ);
fprintf('\n\n Display the parameter estimation ')
fprintf('\n results using model_disp.m:')
Xlab=['alpha  (rad)   ';'qhat           ';'elevator  (rad)'];
model_disp(pZ,serrZ,[1,10,100,0],Xlab);
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Stepwise regression for the pitching moment coefficient.
%
fprintf('\n\n Pitching moment coefficient: ')
fprintf('\n\n Add a nonlinear cross term alpha*elevator ,')
fprintf('\n regressor and use stepwise regression program swr.m:')
fprintf('\n\n [ym,pm,crbm,s2m]=swr(X,Cm);')
%
%  Program swr.m adds the bias term automatically, 
%  so the constant regressor is not necessary.  Add 
%  the nonlinear cross term to the regressor matrix X.  
%
X=[X(:,[1:3]),X(:,1).*X(:,3)];
[ym,pm,crbm,s2m,Xm,pindxm]=swr(X,Cm,1);
%
%  Include only parameters for selected regressors.
%
pm=pm(pindxm);
%
%  Plot the results.
%
subplot(2,1,1),plot(t,Cm,t,ym,'r:','LineWidth',1.5),grid on,
title('Pitching Moment Coefficient','FontWeight','bold'),
ylabel('Cm'),legend('Flight data','Equation-Error model')
subplot(2,1,2),plot(t,Cm-ym,'LineWidth',1.5),grid on,
ylabel('Residual'),xlabel('time (sec)'),
%
%  Compute and display the error bounds.
%
fprintf('\n\n Compute the estimated parameter ')
fprintf('\n error bounds using r_colores.m: ')
fprintf('\n\n [crbm,crbom]=r_colores(X,Cm); ')
[crbm,crbom]=r_colores(Xm,Cm);
serrom=sqrt(diag(crbom));
serrm=sqrt(diag(crbm));
perrm=100*serrm./abs(pm);
fprintf('\n\n Display the parameter estimation ')
fprintf('\n results using model_disp.m:')
model_disp(pm,serrm,[1,10,100,0],Xlab);
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Estimate the transfer function model q/de.
%
fprintf('\n\n Estimate the transfer function ')
fprintf('\n for pitch rate to elevator deflection ')
fprintf('\n (q/de), using tfest.m:')
fprintf('\n\n [ytf,num,den,ptf,crbtf,s2tf,zr,xr,f] = tfest(u,z,t,1,2,w);')
fprintf('\n\n The frequency vector is w = 2*pi*[0.3:.01:1.3]''.')
w=2*pi*[0.3:.01:1.3]';
%
%  Detrend the time domain data for frequency domain analysis.
%
u=zep(fdata(:,14));
z=zep(fdata(:,6));
subplot(2,1,1),plot(t,u,'LineWidth',2),grid on,
title('Transfer Function Modeling Data','FontWeight','bold'),
ylabel('Elevator  (deg)'),
subplot(2,1,2),plot(t,z,'LineWidth',2),grid on,
ylabel('Pitch Rate  (deg/sec)'),xlabel('time (sec)'),
fprintf('\n\n Press any key to continue ... '),pause,
[ytf,num,den,ptf,crbtf,s2tf,zr,xr,f] = tfest(u,z,t,1,2,w);
subplot(2,1,1),plot(f,abs(zr),f,abs(xr*ptf),'r:','LineWidth',1.5),grid on,
title('Frequency Domain Transfer Function Modeling','FontWeight','bold'),
ylabel('Magnitude'),legend('Flight data','Transfer function model')
subplot(2,1,2),plot(f,unwrap(angle(zr)),f,unwrap(angle(xr*ptf)),'r:','LineWidth',1.5),grid on,
ylabel('Phase'),xlabel('Frequency (Hz)'),
fprintf('\n'),tf(num,den),
fprintf('\n\n The figure shows the frequency domain fit. ')
fprintf('\n\n Identified modes from the transfer function ')
fprintf('\n identification in the frequency domain are: \n')
damp(den),
fprintf('\n\n Press any key to continue ... '),pause,
subplot(2,1,1),plot(t,z,t,ytf,'r:','LineWidth',1.5),grid on,
title('Equation-Error Frequency Domain Transfer Function Modeling','FontWeight','bold'),
ylabel('Pitch Rate (deg/sec)'),legend('Flight data','Transfer function model')
subplot(2,1,2),plot(t,z-ytf,'LineWidth',2),grid on,
ylabel('Residual'),xlabel('time (sec)'),
fprintf('\n\n The figure now shows the time domain fit. ')
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Estimate the dimensional stability and control derivatives 
%  using time-domain output-error parameter estimation.  
%
fprintf('\n\n\n Now estimate the non-dimensional stability ')
fprintf('\n and control derivatives using output-error ')
fprintf('\n parameter estimation in the time domain.')
fprintf('\n\n Input:   elevator (rad)')
fprintf('\n Outputs: alpha (rad), q (rad/sec), az (g)')
dtr=pi/180;
u=fdata(:,[14:16])*dtr;
z=[fdata(:,[4,6])*dtr,fdata(:,13)];
%
%  Plot the measured inputs and outputs.
%
subplot(4,1,1), plot(t,u(:,1),'LineWidth',2), 
title('Output-Error Time Domain Modeling','FontWeight','bold'),
grid on, ylabel('elevator  (rad)'), 
subplot(4,1,2), plot(t,z(:,1),'LineWidth',2), 
grid on, ylabel('alpha  (rad)'), 
subplot(4,1,3), plot(t,z(:,2),'LineWidth',2), 
grid on, ylabel('q  (rad/sec)'), 
subplot(4,1,4), plot(t,z(:,3),'LineWidth',2), 
grid on, ylabel('az  (g)'), xlabel('time (sec)'), 
fprintf('\n\n The figure shows the measured input and outputs.')
%
%  Set up for the output-error parameter estimation using 
%  nldyn.m to define the dynamic model.
%
nldyn_psel;
fprintf('\n\n Press any key to continue ... '),pause, 
%
%  Find initial parameter values for the 
%  output-error parameter estimation.
%
fprintf('\n\n Initial values of the parameters in ')
fprintf('\n vector p0 are obtained from the ')
fprintf('\n equation-error solution:\n')
%
%  Omit the CZq term in the output-error formulation, 
%  because of low sensitivity at low angles of attack.
%
p0=[pZ([1,3,4]);pm],
serr0=[serrZ([1,3,4]);serrm];
fprintf('\n\n Estimate the model parameters ')
fprintf('\n using output-error parameter estimation ')
fprintf('\n program oe.m and dynamic model file nldyn.m:  ')
fprintf('\n\n [y,p,crb,rr]=oe(''nldyn'',p0,u,t,x0,cc,z);')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Starting oe.m ...')
tic,[y,p,crb,rr]=oe('nldyn',p0,u,t,x0,cc,z);toc,
%
%  Plot the results.
%
clf, title('Output-Error Parameter Estimation','FontWeight','bold'),
subplot(3,1,1),plot(t,z(:,1),t,y(:,1),'r:','LineWidth',2),grid on,ylabel('alpha  (rad)'),
legend('Flight data','Output-Error model',0),
subplot(3,1,2),plot(t,z(:,2),t,y(:,2),'r:','LineWidth',2),grid on,ylabel('q  (rad/sec)'),
subplot(3,1,3),plot(t,z(:,3),t,y(:,3),'r:','LineWidth',2),grid on,ylabel('az  (g)'),xlabel('time (sec)'),
fprintf('\n The plots show the measured output data ')
fprintf('\n and the identified model fit. ')
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Examine the residuals.
%
clf, subplot(3,1,1),plot(t,z(:,1)-y(:,1),'LineWidth',2),grid on;ylabel('alpha residuals (rad)'),
title('Residuals','FontSize',12,'FontWeight','bold'),
subplot(3,1,2),plot(t,z(:,2)-y(:,2),'LineWidth',2),grid on;ylabel('q residuals (rad/sec)'),
subplot(3,1,3),plot(t,z(:,3)-y(:,3),'LineWidth',2),grid on;ylabel('az residuals (g)'),xlabel('time (sec)'),
%
%  Correct the estimated parameter error bounds.
%
fprintf('\n\n The output residuals are colored ')
fprintf('\n (due to modeling error), so the ')
fprintf('\n Cramer-Rao bounds calculated by oe.m must ')
fprintf('\n be corrected for colored residuals using ')
fprintf('\n program m_colores.m:')
fprintf('\n\n [crb,crbo] = m_colores(''nldyn'',p,u,t,x0,c,z);')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Starting m_colores.m ...\n\n')
tic,[crb,crbo] = m_colores('nldyn',p,u,t,x0,cc,z);toc,
serr=sqrt(diag(crb));
%
%  Display the parameter estimation results.
%
model_disp(p,serr,[1,100,0,1,10,100,0],Xlab);
leglab=['Equation-Error';'Output-Error  '];
parlab=['CZ_alpha';'CZ_de   ';'CZ_o    ';...
        'Cm_alpha';'Cm_q    ';'Cm_de   ';'Cm_o    '];
indx=[4,6]';
plotpest([p0(indx),p(indx)],[serr0(indx),serr(indx)],[],[],parlab(indx,:),leglab);
title('Parameter Estimation Results','FontWeight','bold')
fprintf('\n\n The figure shows that the equation-error ')
fprintf('\n and output-error parameter estimates are ')
fprintf('\n in statistical agreement. ')
fprintf('\n\n Press any key to continue ... '),pause,
save 'totter_results.mat' num den p serr p0 serr0 pZ serrZ pm serrm cc dtr;
%
%  Check the prediction capability.
%
load 'totter_lon_020213f1_017.mat'
fprintf('\n\n Now check the prediction capability ')
fprintf('\n using data from a different maneuver ')
fprintf('\n and the identified transfer function ')
fprintf('\n model from before:')
fprintf('\n'),tf(num,den),
u=fdata(:,14); u=zep(u);
z=fdata(:,6); z=zep(z);
ytfp=tfsim(num,den,0,u,t);
%
%  Plot the transfer function prediction results.
%
subplot(2,1,1),plot(t,z,t,ytfp,'r:','LineWidth',2),grid on,
title('Transfer Function Prediction','FontWeight','bold'),
ylabel('Pitch Rate (deg/sec)'),legend('Flight data','Transfer function prediction',4)
subplot(2,1,2),plot(t,z-ytfp,'LineWidth',2),grid on,
ylabel('Residual'),xlabel('time (sec)'),
fprintf('\n\n The figure shows the time domain prediction ')
fprintf('\n using the transfer function model identified ')
fprintf('\n using data from a different maneuver. ')
fprintf('\n\n Press any key to continue ... '),pause,
u=fdata(:,[14:16])*dtr;
z=[fdata(:,[4,6])*dtr,fdata(:,13)];
nldyn_psel;
yp=nldyn(p,u,t,x0,cc);
%
%  Plot the measured inputs and outputs.
%
subplot(4,1,1), plot(t,u(:,1),'LineWidth',2), 
title('Twin Otter Flight Test Data','FontWeight','bold'),
grid on, ylabel('elevator  (rad)'), 
subplot(4,1,2), plot(t,z(:,1),'LineWidth',2), 
grid on, ylabel('alpha  (rad)'), 
subplot(4,1,3), plot(t,z(:,2),'LineWidth',2), 
grid on, ylabel('q  (rad/sec)'), 
subplot(4,1,4), plot(t,z(:,3),'LineWidth',2), 
grid on, ylabel('az  (g)'), xlabel('time (sec)'), 
fprintf('\n\n\n The figure shows the measured input and outputs ')
fprintf('\n for the prediction maneuver. ')
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Plot the output-error prediction results.
%
title('Output-Error Prediction','FontWeight','bold'),
%
%  Correct for measurement biases.
%
bias=ones(length(t),1)\(z-yp);
yp=yp+ones(length(t),1)*bias;
subplot(3,1,1),plot(t,z(:,1)/dtr,t,yp(:,1)/dtr,'r:','LineWidth',2),grid on,ylabel('alpha  (rad)'),
legend('Flight data','Output-Error prediction',4),
title('Output-Error Model Prediction','FontWeight','bold'),
subplot(3,1,2),plot(t,z(:,2)/dtr,t,yp(:,2)/dtr,'r:','LineWidth',2),grid on,ylabel('q  (rad/sec)'),
subplot(3,1,3),plot(t,z(:,3),t,yp(:,3),'r:','LineWidth',2),grid on,ylabel('az  (g)'),xlabel('time (sec)'),
fprintf('\n The plots show the measured output data ')
fprintf('\n and the prediction using the output-error ')
fprintf('\n model identified using data from a different ')
fprintf('\n maneuver. ')
fprintf('\n\n\nEnd of demonstration \n\n')
return
