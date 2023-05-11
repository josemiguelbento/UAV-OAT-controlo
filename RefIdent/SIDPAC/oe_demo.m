%
%  script oe_demo.m
%
%  Usage: oe_demo;
%
%  Description:
%
%    Demonstrates output error maximum likelihood 
%    parameter estimation for linearized  
%    longitudinal dynamics using flight test data
%    from the NASA Glenn Twin Otter aircraft.  
%
%  Input:
%
%    None
%
%  Output:
%
%    graphics:
%      2D plots
%

%
%    Calls:
%      xsmep.m
%      oe.m
%      tlonss.m
%      m_colores.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 Jan 2001 - Created and debugged, EAM.
%      27 Aug 2002 - Updated and corrected, EAM.
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
fprintf('\n\n Output Error Maximum Likelihood')
fprintf('\n Parameter Estimation Demo ')
fprintf('\n\n Loading longitudinal example data...')
load 'oe_lon_example.mat'
pause(1);
fprintf('\n\n\n For longitudinal dynamics output error parameter ')
fprintf('\n estimation, the variables are : \n')
states,
outputs,
inputs,
%
%  Assemble the inputs and outputs.
%
z=[fdata(:,[4,6])*pi/180,fdata(:,13)];
u=[fdata(:,14)*pi/180,ones(length(t),1)];
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.453 .221 .542 .685],...
           'Color',[0.8 0.8 0.8],...
           'Name','Output Error Parameter Estimation',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .9 .8],...
         'XGrid','on', 'YGrid','on');
subplot(2,1,1),plot(t,u(:,1)),grid on;ylabel(inputs(1,:)),
title('\itMeasured Inputs','FontSize',12,'FontWeight','bold'),
subplot(2,1,2),plot(t,u(:,2)),grid on;ylabel(inputs(2,:)),xlabel('Time (sec)'),
subplot(3,1,1),plot(t,z(:,1)),grid on;ylabel(outputs(1,:)),
title('\itMeasured Outputs','FontSize',12,'FontWeight','bold'),
Plt1H=gca;
subplot(3,1,2),plot(t,z(:,2)),grid on;ylabel(outputs(2,:)),
Plt2H=gca;
subplot(3,1,3),plot(t,z(:,3)),grid on;ylabel(outputs(3,:)),xlabel('Time (sec)'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Initial conditions are determined from smoothed ')
fprintf('\n measured values, using program xsmep.m: \n ')
xs=xsmep(z(:,[1:2]),2.0,dt);
x0=xs(1,:)',
axes(Plt1H);hold on,plot(t(1),x0(1),'r.','LineWidth',2,'MarkerSize',14),hold off;
axes(Plt2H);hold on,plot(t(1),x0(2),'r.','LineWidth',2,'MarkerSize',14),hold off;
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The dynamic model and parameterization are defined ')
fprintf('\n in the user-defined file tlonss.m for this example. ')
fprintf('\n Here is the listing for tlonss.m: ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n')
!type tlonss.m
fprintf('\n\n\n The model and parameterization are such that ')
fprintf('\n the first parameter is Za, the seventh parameter ')
fprintf('\n is Mde, and so on.  The constant input ')
fprintf('\n vector c passes in any constants needed for the model. ')
%
%  For this model, pass in the mean airspeed in fps.
%
c=mean(fdata(:,2));
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Initial values of the parameters in vector p0 are ')
fprintf('\n computed using an equation error method: \n')
zd=deriv(z(:,[1:2]),dt);
p0=[z(:,[1:2]),u]\zd;
%
%  Include the accelerometer bias.  
%
p0=[p0(:,1);p0(:,2);-1],
fprintf('\n\n Now estimate the model parameters ')
fprintf('\n using program oe.m.  ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Starting output error parameter estimation program oe ...\n')
[y,p,crb,rr]=oe('tlonss',p0,u,t,x0,c,z);
%
%  Plot the results.
%
clf,
title('\itResults','FontSize',12,'FontWeight','bold'),
subplot(3,1,1),plot(t,[z(:,1),y(:,1)]),grid on;ylabel(outputs(1,:)),
legend('Measured','Model',0),
subplot(3,1,2),plot(t,[z(:,2),y(:,2)]),grid on;ylabel(outputs(2,:)),
subplot(3,1,3),plot(t,[z(:,3),y(:,3)]),grid on;ylabel(outputs(3,:)),xlabel('Time (sec)'),
fprintf('\n\n The plots show the measured output data ')
fprintf('\n and the identified model fit. ')
fprintf('\n\n Press any key to continue ... '),pause,
%
%  Examine the residuals.
%
clf,
subplot(3,1,1),plot(t,z(:,1)-y(:,1)),grid on;ylabel('alpha residuals (rad)'),
title('\itResiduals','FontSize',12,'FontWeight','bold'),
subplot(3,1,2),plot(t,z(:,2)-y(:,2)),grid on;ylabel('q residuals (rps)'),
subplot(3,1,3),plot(t,z(:,3)-y(:,3)),grid on;ylabel('az residuals (g)'),xlabel('Time (sec)'),
pause(1);
fprintf('\n\n\n The residual plots indicate that the residuals ')
fprintf('\n are colored (due to modeling errors), so the ')
fprintf('\n Cramer-Rao bounds calculated by oe.m must be ')
fprintf('\n corrected for colored residuals using ')
fprintf('\n program m_colores.m.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Starting Cramer-Rao bound calculation program m_colores ...\n\n')
[crb,crbo] = m_colores('tlonss',p,u,t,x0,c,z);
serr=sqrt(diag(crb));
fprintf('\n         Za = %8.4f  +/- %8.4f \n',p(1),serr(1));
fprintf('\n         Zq = %8.4f  +/- %8.4f \n',p(2),serr(2));
fprintf('\n        Zde = %8.4f  +/- %8.4f \n',p(3),serr(3));
fprintf('\n         Ma = %8.4f  +/- %8.4f \n',p(5),serr(5));
fprintf('\n         Mq = %8.4f  +/- %8.4f \n',p(6),serr(6));
fprintf('\n        Mde = %8.4f  +/- %8.4f \n',p(7),serr(7));
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Identified system matrices A and B are: \n')
[y,x,A,B,C,D] = tlonss(p,u,t,x0,c);
A,B,
fprintf('\n\n Eigenvalues of A are:\n')
damp(A),
[wn,zeta]=damp(A);
wn=wn(1);
zeta=zeta(1);
fprintf('\n\n The identified short period frequency is %7.2f Hz, ',wn/(2*pi))
fprintf('\n which corresponds to a period of %7.2f seconds',2*pi/wn),
clear ans xs;
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
