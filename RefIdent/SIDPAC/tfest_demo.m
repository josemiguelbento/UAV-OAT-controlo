%
%  script tfest_demo.m
%
%  Usage: tfest_demo;
%
%  Description:
%
%    Demonstrates transfer function estimation 
%    program tfest.m using noisy data from the 
%    F-16 nonlinear simulation.  
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
%      tfest.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      15 Mar 2001 - Created and debugged, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
fprintf('\n\n Transfer Function Estimation Demo ')
fprintf('\n\n Loading example data...\n')
load 'tfest_example.mat'
pause(1);
fprintf('\n\n For roll mode transfer function estimation, the input ')
fprintf('\n is aileron deflection in deg, and the output is roll rate ')
fprintf('\n in rad/sec.')
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.469 .247 .528 .659],...
           'Color',[0.8 0.8 0.8],...
           'Name','Transfer Function Identification',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .75 .8],...
         'XGrid','on', 'YGrid','on',...
         'Tag','Axes1');
u=fdata(:,15);
z=fdata(:,5)*pi/180;
fprintf('\n\n The plots show the input and output time histories from ')
fprintf('\n a nonlinear F-16 simulation using a Schroeder sweep input. ')
fprintf('\n The roll rate response has 10 percent gaussian noise added ')
fprintf('\n to the values from the nonlinear simulation.  ')
subplot(2,1,2),plot(t,z),grid on,xlabel('Time (sec)'),ylabel('Roll Rate (rps)'),
subplot(2,1,1),plot(t,u),grid on,ylabel('Aileron (deg)'),
title('\itSimulated Measured Data','FontSize',12,'FontWeight','bold'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n For the frequency domain analysis, use ')
fprintf('\n the frequency vector w = 2*pi*[0.1:0.05:1.5] (rad/sec). ')
w=2*pi*[0.1:0.05:1.5]';
fprintf('\n\n Identify a 0/1 order transfer function ')
fprintf('\n for the roll rate response to aileron input.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Working...')
[y,num,den,p,crb,s2,zr,xr,f]=tfest(u,z,t,0,1,w);
clf,
subplot(2,1,1),plot(t,z,t,y),
grid on,legend('Data','Model'),xlabel('Time (sec)'),ylabel('Roll Rate (rps)'),
subplot(2,1,2),plot(t,z-y),
grid on,xlabel('Time (sec)'),ylabel('Residual (rps)'),
fprintf('\n\n The plot shows the model match to the simulated ')
fprintf('\n measured data.  ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n The identified transfer function is: \n')
sys=tf(num,den),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n The estimated parameters and 95 percent ')
fprintf('\n confidence bounds are:')
serr=sqrt(diag(crb));
fprintf('\n\n Lda = %6.2f  +/- %6.2f',p(1),2*serr(1))
fprintf('\n Lp  = %6.2f  +/- %6.2f',-p(2),2*serr(2))
fprintf('\n\n Corresponding values from a linear model ')
fprintf('\n generated from central finite differences ')
fprintf('\n on the nonlinear simulation are:')
fprintf('\n\n Lda = %6.2f ',B(2,1))
fprintf('\n Lp  = %6.2f ',A(2,2))
fprintf('\n\n Program tfest.m uses equation error in the ')
fprintf('\n frequency domain.  Even better accuracy can be ')
fprintf('\n obtained using output error in the frequency domain, ')
fprintf('\n at the cost of more computation.  Note also that ')
fprintf('\n the linearized model values were computed from smaller ')
fprintf('\n perturbations than those appearing in the simulated ')
fprintf('\n measured data.  This can also be a source of ')
fprintf('\n mismatch between the estimated model parameters ')
fprintf('\n and the linearized model parameters. ')
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
