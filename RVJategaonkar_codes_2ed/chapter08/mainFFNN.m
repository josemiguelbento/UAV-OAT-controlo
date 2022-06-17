% Feed Forward Neural Network with one hidden layer
% Training algorithms: 1) Standard back propagation;  2)Back propagation with
% momentum term, and 3) Modified back propagation with Kalman gain.
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

clear all;
close all;

% Select the test case to be analyzed:
% test_case = 4;                        % HFB-320, Longitudinal motion (Data with turbulence)
% test_case = 23;                       % ATTAS, Lateral-directional motion
test_case = 27;                       % ATTAS, Quasi-steady stall longitudinal mode only

%---------------------------------------------------------------------------------------
% Definition of data (input/output); number of input and output variables etc.
if (test_case == 4),
    [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase04(test_case);
elseif (test_case == 23),
    [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase23(test_case);
elseif (test_case == 27),
    [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase27(test_case);
else
    disp('Error Termination in mainFFNN:');
    disp('Wrong specification of test_case.');
    break;
end 

%---------------------------------------------------------------------------------------
disp(' ');
disp('Modeling using feed forward neural network with one hidden layer');

% Specify Neural network parameters:
gamma1 = 0.85;               % gain factor gamma1 
gamma2 = 0.6;                % gain factor gamma2 
mu     = 0.125;              % Learning rate, step size 
Omega  = 0.5;                % momentum term coefficient 

if (test_case == 4),
    % Following values for TC04, figure 
    gamma1 = 0.5;              % gain factor gamma1 
    gamma2 = 0.5;              % gain factor gamma2 
    mu     = 0.125;            % Learning rate, step size 
    Omega  = 0.5;              % momentum term coefficient 
elseif (test_case == 27),
    % Following values for TC27, figure 
    gamma1 = 0.1;              % gain factor gamma1 
    gamma2 = 0.1;              % gain factor gamma2 
    mu     = 0.3;              % Learning rate, step size 
    Omega  = 0.5;              % momentum term coefficient 
end

%---------------------------------------------------------------------------------------
% Scaling of the input and output signals (optional)
iScale =  1;                   % Flag for scaling (= 1 scale the data; = 0 No scaling)
SCmin  = -0.5;
SCmax  =  0.5;
[XS, ZS, ScaleFac, Smin] = scaleIO(Nu, Ny, Xin, Zout, SCmin, SCmax, iScale);

%---------------------------------------------------------------------------------------
% Specify the number of hidden layer neurons:
NnHL1  = input('number of neurons in the hidden layer NnHL1 = ');

% Initialize the weighting matrices randomly:
w1 = 0.3*randn(NnHL1,Nu+1);              % 0.1*??
w2 = 0.3*randn(Ny,NnHL1+1);

% Specify the number of training cycles (iterations):
itMax = input('maximum number of training iterations itMax = ');

% Specify the training algorithm (standard BP or Extended BP using Kalman gain)
trainALG = input('Training algorithm (0: Standard BP, 1: Modified BP with Kalman gain;  trainALG = ');

% Convergence limit in terms of relative change in the cost function
tolR = 1.0e-8;

%---------------------------------------------------------------------------------------
% Training and prediction using FFNN with one hidden layer
[w1, w2, SY, SYpred, costFun] = hLayer1(Nu, Ny, Ndata, T, XS, ZS, itMax, gamma1, gamma2,... 
                                        NnHL1, mu, Omega, w1, w2, trainALG, tolR, NdataPred);

%---------------------------------------------------------------------------------------
% De-scale the data (measured and model outputs)
[XS, ZS, SY, SYpred] = deScaleIO(Nu, Ny, XS, ZS, SY, SYpred,...
                                 ScaleFac, SCmin, Smin, iScale);

%---------------------------------------------------------------------------------------
% Plots of measured and estimated time histories of outputs and inputs 
% Training cycle and prediction cycle
if (test_case == 4),  
    [T] = plots_TC04_ffnn_hfb(T, Ndata, NdataPred, XS, ZS, SY, SYpred);
elseif (test_case == 23),  
    [T] = plots_TC23_ffnn_Lat(T, Ndata, NdataPred, XS, ZS, SY, SYpred);
elseif (test_case == 27),  
    [T] = plots_TC27_ffnn_regQStall(T, Ndata, NdataPred, XS, ZS, SY, SYpred);
end

% END of mainFFNN