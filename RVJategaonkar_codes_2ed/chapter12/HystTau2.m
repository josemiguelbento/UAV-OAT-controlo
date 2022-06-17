% HystTau2: Compute quasi-steady flow separation point and corresponding lift coefficient
%
% Chapter 12, Selected Advanced Examples
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


clear all;
close all;

%--------------------------------------------------------------------------
CL0  = 0.6;
CLAL = 4.5;

alDeg = 0:0.1:40;
alRad = alDeg*pi/180;

Vtas   = 100; 
cbar   = 3.16; 
AlStar = 20*pi/180;
Tau2   = 5*cbar/Vtas;
A1     = 20;
alDot  = [-20 -10 0 10 20]'*pi/180;%

for k=1:size(alDot,1),
    xFS(k,:)   = 0.5 * ( 1 - tanh(A1.*(alRad - Tau2*alDot(k) - AlStar) ) );
    CLift(k,:) = CL0 + CLAL*alRad.*( (1+sqrt(xFS(k,:)))/2 ).^2;
end

%--------------------------------------------------------------------------
% plot
figure(1)
subplot(211),plot(alDeg,CLift,'m'); ylabel('CL'); grid;
subplot(212),plot(alDeg,xFS,'b');   ylabel('X');  grid;
xlabel('Angle of attack, (deg)');
