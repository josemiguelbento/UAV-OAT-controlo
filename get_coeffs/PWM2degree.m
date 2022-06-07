function [pwm2deg_ail, pwm2deg_el, pwm2deg_rud] = PWM2degree()

% Excel name
filename = 'PWM2degree_v3.xlsx';

% Sheet numbers
Ail_esq = 1;
Ele = 2;
Ail_dir = 3;
Rudder = 4;

rank = 4;

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

%     sPWM{i} = linspace(min(PWM{i}),max(PWM{i}),100);
%     sDEGREE{i} = spline(PWM{i},DEGREE{i},sPWM{i});
end

pwm_ail_esq = PWM{1};
deg_ail_esq = DEGREE{1};

pwm_el = PWM{2};
deg_el = DEGREE{2};

pwm_ail_dir = PWM{3};
deg_ail_dir = DEGREE{3};

pwm_rud = PWM{4};
deg_rud = DEGREE{4};

clearvars -except rank pwm_ail_dir pwm_ail_esq pwm_el pwm_rud ...
                    deg_ail_dir deg_ail_esq deg_el deg_rud
 
%% Aileron Esquerdo

p_ail_esq = polyfix(pwm_ail_esq, deg_ail_esq, rank,...
                [pwm_ail_esq(1), pwm_ail_esq(end-1), pwm_ail_esq(end)],...
                [deg_ail_esq(1), deg_ail_esq(end-1), deg_ail_esq(end)]);

pwm2deg_ail_esq = @(x) p_ail_esq(1).*x.^4 + p_ail_esq(2).*x.^3 + p_ail_esq(3).*x.^2 + p_ail_esq(4).*x + p_ail_esq(5);

%% Aileron Direito
               
p_ail_dir = polyfix(pwm_ail_dir, deg_ail_dir, rank,...
                [pwm_ail_dir(1), pwm_ail_dir(end-1), pwm_ail_dir(end)],...
                [deg_ail_dir(1), deg_ail_dir(end-1), deg_ail_dir(end)]);

pwm2deg_ail_dir = @(x) p_ail_dir(1).*x.^4 + p_ail_dir(2).*x.^3 + p_ail_dir(3).*x.^2 + p_ail_dir(4).*x + p_ail_dir(5);

%% Aileron

pwm2deg_ail = @(x) (pwm2deg_ail_esq(x) + pwm2deg_ail_dir(x)) / 2;

%% Elevator

p_el = polyfix(pwm_el, deg_el, rank,...
                [pwm_el(1), pwm_el(end-1), pwm_el(end)],...
                [deg_el(1), deg_el(end-1), deg_el(end)]);

pwm2deg_el = @(x) p_el(1).*x.^4 + p_el(2).*x.^3 + p_el(3).*x.^2 + p_el(4).*x + p_el(5);

%% Rudder

p_rud = polyfix(pwm_rud, deg_rud, rank,...
                [pwm_rud(1), pwm_rud(2), pwm_rud(5)],...
                [deg_rud(1), deg_rud(2) ,deg_rud(5)]);

pwm2deg_rud = @(x) p_rud(1).*x.^4 + p_rud(2).*x.^3 + p_rud(3).*x.^2 + p_rud(4).*x + p_rud(5);

%% Plots
% 
% figure()
% x_ail_esq = linspace(min(pwm_ail_esq),max(pwm_ail_esq));
% plot(x_ail_esq, pwm2deg_ail_esq(x_ail_esq))
% hold on
% scatter(pwm_ail_esq, deg_ail_esq)
% title('Ail_esq', 'Interpreter', 'none')
% ylabel('Degree', 'Interpreter', 'none')
% xlabel('PWM', 'Interpreter', 'none')
% grid on
% 
% figure()
% x_ail_dir = linspace(min(pwm_ail_dir),max(pwm_ail_dir));
% plot(x_ail_dir, pwm2deg_ail_dir(x_ail_dir))
% hold on
% scatter(pwm_ail_dir, deg_ail_dir)
% title('Ail_dir', 'Interpreter', 'none')
% ylabel('Degree', 'Interpreter', 'none')
% xlabel('PWM', 'Interpreter', 'none')
% grid on
% 
% figure()
% x_el = linspace(min(pwm_el),max(pwm_el));
% plot(x_el, pwm2deg_el(x_el))
% hold on
% scatter(pwm_el, deg_el)
% title('El', 'Interpreter', 'none')
% ylabel('Degree', 'Interpreter', 'none')
% xlabel('PWM', 'Interpreter', 'none')
% grid on
% 
% figure()
% x_rud = linspace(min(pwm_rud),max(pwm_rud));
% plot(x_rud, pwm2deg_rud(x_rud))
% hold on
% scatter(pwm_rud, deg_rud)
% title('Rud', 'Interpreter', 'none')
% ylabel('Degree', 'Interpreter', 'none')
% xlabel('PWM', 'Interpreter', 'none')
% grid on
% 
% figure()
% xx = linspace(-5000,5000);
% plot(xx,pwm2deg_ail_dir(xx),'-b','LineWidth',1.5)
% hold on
% plot(xx,pwm2deg_ail_esq(xx),'-k','LineWidth',1.5)
% plot(xx,pwm2deg_ail(xx),'-r','LineWidth',1.5)
% legend('Ail_dir','Ail_esq','Media','Location','southeast','Interpreter','none')
% ylabel('Degree', 'Interpreter', 'none')
% xlabel('PWM', 'Interpreter', 'none')
% title('Compare Ailerons', 'Interpreter', 'none')
% grid on
end