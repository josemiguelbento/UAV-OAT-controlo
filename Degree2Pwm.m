clear all
close all
clc

% Excel name
filename = 'PWM2degree_v3.xlsx';

% Sheet numbers
Ail_esq = 1;
Ele = 2;
Ail_dir = 3;
Rudder = 4;

% Read Data from Excel
for i=1:4
    clear data degree pwm
    data = xlsread(filename,i,'A2:C20');
    degree = data(:,1);
    pwm = data(:,3);
    degree(isnan(degree)) = [];
    pwm(isnan(pwm)) = [];
    DEGREE{i} = [degree];
    PWM{i} = [pwm];

    sPWM{i} = linspace(min(PWM{i}),max(PWM{i}),100);
    sDEGREE{i} = spline(PWM{i},DEGREE{i},sPWM{i});
end


figure(Ail_esq)
plot(PWM{Ail_esq},DEGREE{Ail_esq},'*r')
hold on
plot(sPWM{Ail_esq},sDEGREE{Ail_esq},'-b')
title('Ail_esq', 'Interpreter', 'none')

figure(Ele)
plot(PWM{Ele},DEGREE{Ele},'*r')
hold on
plot(sPWM{Ele},sDEGREE{Ele},'-b')
title('Ele')

figure(Ail_dir)
plot(PWM{Ail_dir},DEGREE{Ail_dir},'*r')
hold on
plot(sPWM{Ail_dir},sDEGREE{Ail_dir},'-b')
title('Ail_dir', 'Interpreter', 'none')

figure(Rudder)
plot(PWM{Rudder},DEGREE{Rudder},'*r')
hold on
plot(sPWM{Rudder},sDEGREE{Rudder},'-b')
title('Rudder')
