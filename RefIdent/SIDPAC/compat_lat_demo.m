%
%  script compat_lat_demo.m
%
%  Usage: compat_lat_demo;
%
%  Description:
%
%    Demonstrates lateral/directional data compatibility  
%    analysis using program compat.m and flight test data 
%    from the NASA F-18 High Alpha Research Vehicle (HARV).  
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
%      harv2sid.m
%      dcmp_psel.m
%      compat.m
%      xsmep.m
%      dcmp.m or equivalent mex file
%      sens_cor.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 Jan 2001 - Created and debugged, EAM.
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
fprintf('\n\n Data Compatibility Analysis Demo ')
fprintf('\n\n Loading lateral/directional example data...\n\n\n')
load 'compat_lat_example.mat'
pause(1);
fprintf(' For lateral/directional data compatibility analysis,')
fprintf('\n the state variables are: \n')
x_names,
fprintf('\n\n The output variables are: \n')
z_names,
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.453 .221 .542 .685],...
           'Color',[0.8 0.8 0.8],...
           'Name','Data Compatibility Analysis',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .9 .8],...
         'XGrid','on', 'YGrid','on');
subplot(3,1,1),plot(t,z(:,1)),grid on;ylabel('beta (rad)'),
title('\itMeasured Outputs','FontSize',12,'FontWeight','bold'),
subplot(3,1,2),plot(t,z(:,2)),grid on;ylabel('phi (rad)'),
subplot(3,1,3),plot(t,z(:,3)),grid on;ylabel('psi (rad)'),xlabel('Time (sec)'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The input variables are: \n')
u_names,
subplot(3,2,2),plot(t,u(:,4)),grid on;ylabel('p (rps)'),
subplot(3,2,4),plot(t,u(:,5)),grid on;ylabel('q (rps)'),
subplot(3,2,6),plot(t,u(:,6)),grid on;ylabel('r (rps)'),xlabel('Time (sec)'),
subplot(3,2,5),plot(t,u(:,3)),grid on;ylabel('az (fps^2)'),xlabel('Time (sec)'),
subplot(3,2,3),plot(t,u(:,2)),grid on;ylabel('ay (fps^2)'),
subplot(3,2,1),plot(t,u(:,1)),grid on;ylabel('ax (fps^2)'),
text(0.8,1.2,'\itMeasured Inputs','Units','normalized','FontSize',12,'FontWeight','bold'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The kinematic differential equations, output ')
fprintf('\n equations, and model parameterization ')
fprintf('\n are defined in dcmp_eqs.m and dcmp_out.m. ')
fprintf('\n The model parameterization, outputs, and ')
fprintf('\n measured states can be selected using simple')
fprintf('\n edits inside the file dcmp_psel.m, ')
fprintf('\n then running dcmp_psel.m to implement the settings ')
fprintf('\n in the cell structure cc.  An alternate method is to ')
fprintf('\n modify the cell structure cc directly, as in this script.')
fprintf('\n Explanation of the settings for the variables ')
fprintf('\n can be found in dcmp_psel.m. ')
fprintf('\n\n\n Press any key to continue ... '),pause,
fprintf('\n\n')
p0c=[0,  0,  0,...
     0,  0,  0,...
     0,  0,  0,...
     0,  0,  0],
ipc=[0,  1,  0,...
     1,  0,  1,...
     0,  1,  0,...
     1,  0,  1],
ims=[1,  0,  1,  0,  1,  0],
imo=[0,  1,  0,  1,  0,  1],
cc{1}=p0c;
cc{2}=ipc;
cc{3}=ims;
cc{4}=imo;
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Assemble the inputs and outputs from the flight ')
fprintf('\n test data, and find the smoothed initial state ')
fprintf('\n values from the measurements.\n')
dtr=pi/180.;
g=32.174;
fdata=harv2sid(fdata_342l);
zc=[fdata(:,2),fdata(:,3)*dtr,fdata(:,4)*dtr,...
    fdata(:,8)*dtr,fdata(:,9)*dtr,fdata(:,10)*dtr];
ca=cos(fdata(:,4)*dtr);
cb=cos(fdata(:,3)*dtr);
sa=sin(fdata(:,4)*dtr);
sb=sin(fdata(:,3)*dtr);
uc=[fdata(:,11)*g,fdata(:,12)*g,fdata(:,13)*g,...
    fdata(:,5)*dtr,fdata(:,6)*dtr,fdata(:,7)*dtr,...
    fdata(:,2).*ca.*cb,fdata(:,2).*sb,fdata(:,2).*sa.*cb,...
    fdata(:,[8:10])*dtr];
xsc=xsmep(uc(:,[7:12]),2.0,dt);
x0c=xsc(1,:)',
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Check the mismatch between measured outputs')
fprintf('\n and computed outputs using zeros for the ')
fprintf('\n instrumentation error parameters:\n\n')
p0=p0c(find(ipc==1))',
yc0=dcmp(p0,uc,t,x0c,cc);
%
%  Plot the results.
%
clf,
zindx=find(imo==1);
z=zc(:,zindx);
subplot(3,1,1),plot(t,[z(:,1),yc0(:,1)]),grid on;ylabel('beta (rad)'),
title('\itOutputs','FontSize',12,'FontWeight','bold'),
legend('Measured','Model',0),
subplot(3,1,2),plot(t,[z(:,2),yc0(:,2)]),grid on;ylabel('phi (rad)'),
subplot(3,1,3),plot(t,[z(:,3),yc0(:,3)]),grid on;ylabel('psi (rad)'),xlabel('Time (sec)'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now run the data compatibility program compat.m ')
fprintf('\n to estimate the selected instrumentation error parameters.')
fprintf('\n\n\n Press any key to continue ... '),pause,
fprintf('\n\n Starting data compatibility compat ...\n')
[yc,pc,crbc,corc,rrc]=compat('dcmp',p0,uc,t,x0c,cc,z);
%
%  Plot the results.
%
clf,
subplot(3,1,1),plot(t,[z(:,1),yc(:,1)]),grid on;ylabel('beta (rad)'),
title('\itOutputs','FontSize',12,'FontWeight','bold'),
legend('Measured','Model',0),
subplot(3,1,2),plot(t,[z(:,2),yc(:,2)]),grid on;ylabel('phi (rad)'),
subplot(3,1,3),plot(t,[z(:,3),yc(:,3)]),grid on;ylabel('psi (rad)'),xlabel('Time (sec)'),
fprintf('\n\n ay bias = %8.4f  +/- %8.4f \n',pc(1),sqrt(crbc(1,1)))
fprintf('\n p bias = %8.4f  +/- %8.4f \n',pc(2),sqrt(crbc(2,2)))
fprintf('\n r bias = %8.4f  +/- %8.4f \n',pc(3),sqrt(crbc(3,3)))
fprintf('\n beta scale factor = %8.4f  +/- %8.4f \n',pc(4),sqrt(crbc(4,4)))
fprintf('\n phi scale factor = %8.4f  +/- %8.4f \n',pc(5),sqrt(crbc(5,5)))
fprintf('\n psi scale factor = %8.4f  +/- %8.4f \n',pc(6),sqrt(crbc(6,6)))
fprintf('\n\n The results above and the plots show that the ')
fprintf('\n data compatibility analysis identified reasonable ')
fprintf('\n instrumentation error parameters, and the model ')
fprintf('\n outputs match the measured outputs very well. ')
fprintf('\n\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The measured values are corrected using program dcmp_cor.')
fprintf('\n\n The plots now show the original and corrected measured ')
fprintf('\n time histories.  The corrections are small, because')
fprintf('\n the instrumentation on this aircraft was very good.')
[zcor,ucor,fdatacor]=sens_cor(pc,uc,zc,x0c,cc,fdata);
subplot(3,1,1),plot(t,[zc(:,2),zcor(:,2)]),grid on;ylabel('beta (rad)'),
title('\itMeasured Outputs','FontSize',12,'FontWeight','bold'),
legend('Measured','Corrected',0);
subplot(3,1,2),plot(t,[zc(:,4),zcor(:,4)]),grid on;ylabel('phi (rad)'),
subplot(3,1,3),plot(t,[zc(:,6),zcor(:,6)]),grid on;ylabel('psi (rad)'),xlabel('Time (sec)'),
fprintf('\n\n\n Press any key to continue ... '),pause,
subplot(3,1,1),plot(t,[uc(:,2),ucor(:,2)]),grid on;ylabel('ay (fps^2)'),
title('\itMeasured Inputs','FontSize',12,'FontWeight','bold'),
legend('Measured','Corrected',0);
subplot(3,1,2),plot(t,[u(:,4),ucor(:,4)]),grid on;ylabel('p (rps)'),
subplot(3,1,3),plot(t,[uc(:,6),ucor(:,6)]),grid on;ylabel('r (rps)'),xlabel('Time (sec)'),
clear ans i xsc ca cb sa sb;
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
