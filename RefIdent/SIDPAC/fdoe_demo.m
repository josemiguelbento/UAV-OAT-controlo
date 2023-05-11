%
%  script fdoe_demo.m
%
%  Usage: fdoe_demo;
%
%  Description:
%
%    Demonstrates frequency domain parameter 
%    estimation program fdoe.m using 
%    noisy data from a supersonic transport simulation. 
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
%      tfsim.m
%      buzz.m
%      loest.m
%      model_disp.m
%      bodecmp.m
%      fint.m
%      fdoe.m
%      
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      30 Aug 2002 - Created and debugged, EAM.
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
fprintf('\n\n Frequency Domain Parameter Estimation Demo ')
fprintf('\n\n Loading example data...\n')
load 'fdoe_example.mat'
pause(1);
fprintf('\n\n For longitudinal short period motion, the input ')
fprintf('\n for the closed-loop low order equivalent system ')
fprintf('\n model is longitudinal stick deflection in cm,')
fprintf('\n and the output is pitch rate in deg/sec.')
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.469 .247 .528 .659],...
           'Color',[0.8 0.8 0.8],...
           'Name','Frequency Domain Parameter Estimation',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .75 .8],...
         'XGrid','on', 'YGrid','on',...
         'Tag','Axes1');
fprintf('\n\n The true transfer function model is: \n')
sys=tf(num,den),
fprintf(' with an equivalent time delay of %6.3f sec',tautrue),
ytrue=tfsim(numtrue,dentrue,tautrue,u,t);
z=buzz(ytrue,0.10);
fprintf('\n\n The plots show the input and output time histories from')
fprintf('\n the supersonic transport simulation using a frequency sweep')
fprintf('\n input.  The pitch rate response has 10 percent Gaussian noise')
fprintf('\n added to the values from the simulation.  ')
subplot(2,1,2),plot(t,z),grid on,xlabel('Time (sec)'),ylabel('Pitch Rate (dps)'),
subplot(2,1,1),plot(t,u),grid on,ylabel('Longitudinal Stick (cm)'),
title('\itSimulated Measured Data','FontSize',12,'FontWeight','bold'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n For the frequency domain analysis, use ')
fprintf('\n the frequency vector w = 2*pi*[0.02:0.02:1.0] (rad/sec). ')
w=2*pi*[0.02:0.02:1.0]';
fprintf('\n\n Using program loest.m, identify a 1/2 order transfer function')
fprintf('\n model with an equivalent time delay on the input ')
fprintf('\n for the pitch rate response to longitudinal stick input.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Working...')
[y,num,den,tau,p,crb,s2,zr,xr,f,cost]=loest(u,z,t,1,2,w,0.1);
clf,
subplot(2,1,1),plot(t,z,t,y),
grid on,legend('Data','Model'),xlabel('Time (sec)'),ylabel('Pitch Rate (dps)'),
subplot(2,1,2),plot(t,z-y),
grid on,xlabel('Time (sec)'),ylabel('Residual (dps)'),
serr=sqrt(diag(crb));
model_disp(p,serr);
fprintf('\n\n The true parameter values are: \n')
ptrue,
fprintf('\n\n The parameter estimation results and the plots ')
fprintf('\n show that the model matches the simulated measured ')
fprintf('\n data and the parameter estimates are accurate.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n The Bode plot shows that the match to the true dynamical ')
fprintf('\n system in the frequency domain is excellent.  ')
bodecmp([numtrue;num],[dentrue;den],[tautrue;tau],1);
legend('True System','Identified Model');
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n Program loest.m uses equation-error in the ')
fprintf('\n frequency domain, and a relaxation technique to ')
fprintf('\n estimate the equivalent time delay, which is a ')
fprintf('\n nonlinear model parameter.  ')
fprintf('\n\n It is also possible to use program fdoe.m ')
fprintf('\n to estimate the low order equivalent system ')
fprintf('\n model parameters.  Program fdoe.m can use the ')
fprintf('\n same equation-error formulation in the ')
fprintf('\n frequency domain used by loest.m, or an ')
fprintf('\n output-error formulation in the frequency domain.  ')
fprintf('\n Both approaches are demonstrated next.  ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n To use fdoe.m, first transform the time domain ')
fprintf('\n data to the frequency domain using fint.m ')
fprintf('\n and the same frequency vector used before. ')
U=fint(u,t,w);
Z=fint(z,t,w);
fprintf('\n For the equation-error formulation, the ')
fprintf('\n second derivative of the output is matched, ')
fprintf('\n rather than the output itself.  In the frequency ')
fprintf('\n domain, derivatives are computed with simple ')
fprintf('\n multiplications by sqrt(-1)*w.  Now use ')
fprintf('\n fdoe.m to estimate low order equivalent system ')
fprintf('\n model parameters using the equation-error ')
fprintf('\n formulation in the frequency domain. ')
jw=sqrt(-1)*w;
dZ=jw.*Z;
d2Z=jw.*dZ;
fprintf('\n\n Press any key to continue ... '),pause,
[Y1,p1,crb1,svv1]=fdoe('flontf',zeros(5,1),U,t,w,Z,d2Z);
num1=p1(1:2)';
den1=[1,p1(3:4)'];
tau1=p1(5);
y1=tfsim(num1,den1,tau1,u,t);
subplot(2,1,1),plot(t,z,t,y1),
grid on,legend('Data','Model'),xlabel('Time (sec)'),ylabel('Pitch Rate (dps)'),
subplot(2,1,2),plot(t,z-y1),
grid on,xlabel('Time (sec)'),ylabel('Residual (dps)'),
serr1=sqrt(diag(crb1));
model_disp(p1,serr1);
fprintf('\n\n The true parameter values are: \n')
ptrue,
fprintf('\n\n The results are very similar, but not identical,')
fprintf('\n to the results obtained with loest.m.  The reasons ')
fprintf('\n for the small differences are that the two methods ')
fprintf('\n use different optimization techniques and convergence ')
fprintf('\n criteria, and loest.m includes frequency scaling.  ')
fprintf('\n\n Now use fdoe.m with an output-error formulation ')
fprintf('\n in the frequency domain. ')
fprintf('\n\n Press any key to continue ... '),pause,
[Y2,p2,crb2,svv2]=fdoe('flontf',p1,U,t,w,0,Z);
num2=p2(1:2)';
den2=[1,p2(3:4)'];
tau2=p2(5);
y2=tfsim(num2,den2,tau2,u,t);
subplot(2,1,1),plot(t,z,t,y2),
grid on,legend('Data','Model'),xlabel('Time (sec)'),ylabel('Pitch Rate (dps)'),
subplot(2,1,2),plot(t,z-y2),
grid on,xlabel('Time (sec)'),ylabel('Residual (dps)'),
serr2=sqrt(diag(crb2));
model_disp(p2,serr2);
fprintf('\n\n The true parameter values are: \n')
ptrue,
fprintf('\n\n\n Note that fdoe.m runs very fast, compared to ')
fprintf('\n oe.m and compat.m.  This is because the analysis is ')
fprintf('\n done in the frequency domain, where the number of ')
fprintf('\n data points is low, and the numerical integrations ')
fprintf('\n are replaced with equivalent algebraic vector operations.  ')
fprintf('\n\n The parameter estimation results and the plots ')
fprintf('\n show that the results obtained using the output-error ')
fprintf('\n formulation in the frequency domain are extremely accurate.  ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n The Bode plot shows that the match to the true dynamical ')
fprintf('\n system in the frequency domain is excellent.  ')
bodecmp([numtrue;num2],[dentrue;den2],[tautrue;tau2],1);
legend('True System','Identified Model');
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
