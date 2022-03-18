% UAV-ART // Aerot�c - N�cleo de estudantes de Engenharia Aeroespacial
% Authors: - Hugo Pereira
%          - Pedro Martins
%          - Sim�o Caeiro

% Program that reads the ".txt" file data to the structures array "data"

%2020-05-21_23.07.txt - longitudinal coefficients
%dados_log3crudder.txt - longitudinal + lateral coefficients

function [data] = read_data()

%fid = fopen('2021-05-01_11.44.txt','rt');
%fid = fopen('2021-04-28_22.50.txt','rt');
%fid = fopen('txt_logs_wAero\2021-05-07_19.52.txt','rt'); %logs com forças
%fid = fopen('txt_logs_wAero\2021-05-09_18.49.txt','rt'); %traj.incial
%fid = fopen('txt_logs_wAero\2021-05-12_12.22.txt','rt'); %melhorzinha
%fid = fopen('txt_logs_wAero\2021-05-13_19.13.txt','rt'); %usar esta
%fid = fopen('2020-12-29_23.37_1_0_2.txt','rt');

%%%%%%%%%%%%%%%%% 3211 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fid = fopen('txt_logs_wAeroAccel\2022-03-18_00.29.txt','rt'); %-3<d_e<3
% fid = fopen('txt_logs_wAeroAccel\2022-03-18_19.57.txt','rt'); %-5<d_e<5
% fid = fopen('txt_logs_wAeroAccel\2022-03-18_20.30.txt','rt'); %-20<d_a<20
fid = fopen('txt_logs_wAeroAccel\2022-03-18_21.02.txt','rt'); %-25<d_r<25


if fid < 0
    disp('Error opening the file ".txt"');
else
    i = -1;
    while ~feof(fid)
        line = fgetl(fid);
        i = i + 1;             
        if  i > 0
            [value, remain]  =  strtok(line);
            data(i).time     =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).theta    =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).psi      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).phi      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).q        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).r        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).p        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).lat      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).long     =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).alt      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).u        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).v        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).w        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).Va       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).AoA      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).beta     =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).RCch1    =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).RCch2    =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).RCch3    =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).RCch4    =  str2num(value);
            % acrescentei accel aqui
            %[value, remain]  =  strtok(remain);
            %data(i).u_r      =  str2num(value);
            %[value, remain]  =  strtok(remain);
            %data(i).ax       =  str2num(value);
            %[value, remain]  =  strtok(remain);
            %data(i).ay       =  str2num(value);
            %[value, remain]  =  strtok(remain);
            %data(i).az       =  str2num(value);

% Aerodynamic forces and moments (not used)

            [value, remain]  =  strtok(remain);
            data(i).F_D      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).F_Y      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).F_L      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).fx       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).fy       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).fz       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).l_aero   =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).m_aero   =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).n_aero   =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).l        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).m        =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).n        =  str2num(value);

            % acrescentar accel aqui para o logs_wAeroAccel ()
            [value, remain]  =  strtok(remain);
            data(i).u_r      =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).ax       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).ay       =  str2num(value);
            [value, remain]  =  strtok(remain);
            data(i).az       =  str2num(value);
        end
    end
end

fclose(fid);

end