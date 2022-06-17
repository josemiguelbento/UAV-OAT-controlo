% Verify the numerical first-order differentiator with 
% a) digital filters of 2nd, 4th, 8th, and 12th order; 
% b) Lanczos differentiators using 2nd order polynomial with 
%    5 and 9 data points, and
% c) Savitzky-Golay differentiators using 2nd order polynomial
%    with 5 and 9 data points.
%
% Chapter 2 'Data Gathering'
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all

% Generate input signal (sine wave)
dt = 0.01;                           % sampling time
w  = [0:dt:2*pi]';
xsinw = sin(w);

% Analytical differentiation of input 
xcosw = cos(w);

% Generate time derivative by numerical differentiation
Nzi    = 1;
Ndata1 = size(w);
izhf   = Ndata1;

% Filter of second order
xDot2 = xsinw;
xDot2 = ndiff_Filter02(xDot2, Nzi, izhf, dt); 

% Filter of fourth order
xDot4 = xsinw;
xDot4 = ndiff_Filter04(xDot4, Nzi, izhf, dt); 

% Filter of eigth order
xDot8 = xsinw;
xDot8 = ndiff_Filter08(xDot8, Nzi, izhf, dt); 

% Filter of twelfth order (New)
xDot12 = xsinw;
xDot12 = ndiff_Filter12(xDot12, Nzi, izhf, dt); 

% Lanczos differentiator (second order polynomial, 5 data points)
xDotLZ25 = xsinw;
xDotLZ25 = ndiff_Lanczos_p2n5(xDotLZ25, Nzi, izhf, dt); 

% Lanczos differentiator (second order polynomial, 9 data points)
xDotLZ29 = xsinw;
xDotLZ29 = ndiff_Lanczos_p2n9(xDotLZ29, Nzi, izhf, dt); 

% Savitzky-Golay differentiator (second order polynomial, 9 data points)
xDotSG25 = xsinw;
xDotSG25 = ndiff_SGolay_p2n5(xDotSG25, Nzi, izhf, dt); 

% Savitzky-Golay differentiator (second order polynomial, 9 data points)
xDotSG29 = xsinw;
xDotSG29 = ndiff_SGolay_p2n9(xDotSG29, Nzi, izhf, dt); 

% Pavel Holoborodko  mooth noise-robust differentiator (9 data points)
xDotPH25 = xsinw;
xDotPH25 = ndiff_PavelH_p2n5(xDotPH25, Nzi, izhf, dt); 

% Pavel Holoborodko  mooth noise-robust differentiator (9 data points)
xDotPH29 = xsinw;
xDotPH29 = ndiff_PavelH_p2n9(xDotPH29, Nzi, izhf, dt); 


% Plot input and its derivatives
plot(w,xsinw,'m', w,xcosw,'b', w,xDot2,'r',      w,xDot4,'k',...
                               w,xDot8,'g',      w,xDot12,'c',...
                               w,xDotLZ25,'y',   w,xDotLZ29,'m--',...
                               w,xDotSG29,'b--', w,xDotSG29,'r--',...
                               w,xDotPH25,'k--', w,xDotPH29,'c--');
axis([0 7, -1 1]); grid;
legend('Input', 'Analytic diff', 'DiffFilter02',  'DiffFilter04',...
                                 'DiffFilter08',  'DiffFilter12',...
                                 'DiffLanczos25', 'DiffLanczos29',...
                                 'DiffSGolay25',  'DiffSGolay29',...
                                 'DiffPavelH25',  'DiffPavelH29', 1);

% Error between analytical and numerical differentiation
sum02   = mean(xcosw-xDot2);
sum04   = mean(xcosw-xDot4);
sum08   = mean(xcosw-xDot8);
sum12   = mean(xcosw-xDot12);
sumLZ25 = mean(xcosw-xDotLZ25);
sumLZ29 = mean(xcosw-xDotLZ29);
sumSG25 = mean(xcosw-xDotSG25);
sumSG29 = mean(xcosw-xDotSG29);
sumPH25 = mean(xcosw-xDotPH25);
sumPH29 = mean(xcosw-xDotPH29);
disp(['ErrorError between analytical and numerical differentiation:']);
disp(['ndiff_Filer02:  ', num2str(sum02)]);
disp(['ndiff_Filer04:  ', num2str(sum04)]);
disp(['ndiff_Filer08:  ', num2str(sum08)]);
disp(['ndiff_Filer12:  ', num2str(sum12)]);
disp(['ndiff_FilerLZ25:', num2str(sumLZ25)]);
disp(['ndiff_FilerLZ29:', num2str(sumLZ29)]);
disp(['ndiff_FilerSG25:', num2str(sumSG25)]);
disp(['ndiff_FilerSG29:', num2str(sumSG29)]);
disp(['ndiff_FilerPH25:', num2str(sumPH25)]);
disp(['ndiff_FilerPH29:', num2str(sumPH29)]);

