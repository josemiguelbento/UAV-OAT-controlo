function [w1, w2, SY, SYpred, costFun] = hLayer(Nu, Ny, Ndata, T, XS, ZS, itMax,...
                                                gamma1, gamma2, Nhlneurons, mu, Omega,... 
                                                w1, w2, trainALG, tolR, NdataPred)

% Training of feed forward neural network with one hidden layer, followed
% by prediction cycle
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nu          Number of inputs
%    Ny          Number of outputs
%    Ndata       Number of data points for training
%    T           vector of time
%    XS          Array of input variables (Ndata,Nu)
%    ZS          Array of output variables (Ndata,Ny)
%    itMax       Maximum number of training iterations (typically between 50 and 100)
%    gamma1      nonlinear function slope factor (gain) from input to hidden layer
%    gamma2      nonlinear function slope factor (gain) from hidden layer to output
%    Nhlneurons  number of neurons in the hidden layer
%    mu          learning rate parameter (< 1; typically between 01. to 0.3)
%    Omega       momentum parameter (< 1; typically between 0.3 and 0.5)
%    w1          Initial weights for input layer, (Nhlneurons,Nu+1)
%    w2          Initial weights for hidden layer, (Ny,Nhlneurons+1)
%    trainALG    Flag for training algorithm (= 0: Standard BP; = 1: BP with Kalman gain)
%    tolR        Convergence limit in terms of relative change in the error function
%    NdataPred   Number of data points for prediction
%
% Outputs
%    w1          Estimated weights for input layer, (Nhlneurons,Nu+1)
%    w2          Estimated weights for hidden layer, (Ny,Nhlneurons+1)
%    SY          Network outputs (during training cycle)
%    SYpred      Network outputs through prediction (i.e., after training)
%    costFun     Value of cost function (det(r) over iterations - for plot purposes)


%---------------------------------------------------------------------------------------
% Initialization
detRprev = 1.0e+8;

% Initialize covariance matrices
pcov1 = 100*eye(Nu+1);
pcov2 = 200*eye(Nhlneurons+1);

%---------------------------------------------------------------------------------------
% Train the FFNN by back propagation algorithm

% Loop over iterations 
for iter=1:itMax,
    
    % Initialization of w1p and w2p (previous step weights)
    w1p = w1;  w2p = w2;    
    SZMY2 = zeros(Ny,1);

    % Loop over data points
    for  k=1:Ndata
        
        % Propagation from input layer to hidden layer
        Uinb = [XS(k,:) 1]';                     % Control inputs including bias
        y1   = w1*Uinb;                          % y1 = W1*u0 + W10; Eq. (6)
        [u1, fprime1] = ffprime(y1, gamma1);     % u1 = f(y1) & fprime(y1); Eqs. (7 & 20)

        % Propagation from hidden layer to output layer
        u1b = [u1; 1];                           % Hidden layer outputs including bias
        y2  = w2*u1b;                            % y2 = W2*u1 + W20; Eq. (9)
        [u2, fprime2] = ffprime(y2,gamma2);      % u2 = f(y2) & fprime(y2); Eqs. (10 & 20)
        
        % Save estimated outputs in SY and sum of Error^2 in SZMY2
        zm    = ZS(k,:)';                        % Output variables
        SY(k,:) = u2';                           % Save output variables
        SZMY2   = SZMY2 + (zm-u2).^2;            % Sum of error^2

        % Compute Kalman gain and update covariance matrix
        if trainALG == 1,
            %ff1=1; ff2=1;                       % TC23, convergence ca. 297 iterations
            %ff1=0.9999; ff2=0.9999;
            ff1=0.999; ff2=0.999;
            [kGain1, pcov1] = kGainPcov(pcov1, Uinb, ff1);
            [kGain2, pcov2] = kGainPcov(pcov2, u1b,  ff2);
        end

        % Back propagation of error signals for output and hidden layers
        e2b = fprime2.*(zm-u2);                       % Error signal for the output layer
        e1b = (w2(1:Ny,1:Nhlneurons)'*e2b).*fprime1;  % Error for the hidden layer

        % Remember weights from previous step for updating w1p and w2p reqd in momentum term
        w1pS = w1;  w2pS = w2; 

        % Update weighting matrices
        if trainALG == 0,
            w1 = w1 + mu*e1b*Uinb' + Omega*(w1-w1p);        % Standard BP, steepest descent
            w2 = w2 + mu*e2b*u1b'  + Omega*(w2-w2p);
        else
            w1 = w1 + mu*e1b*kGain1';                       % Extended BP, Kalman gain
            d2 = log( abs((1+zm)./(1-zm)) ) / gamma2;
            w2 = w2 + (d2 - y2)* kGain2';
        end
        
        % Weights from previous step         
        w1p = w1pS;  w2p = w2pS;
        
    end % end of data loop
    
    % Standard deviations, covariance matrix (and determinant) of output errors
    sd   = sqrt(SZMY2/Ndata);
    covR = SZMY2/Ndata;
    detR = det(diag(covR));
    relerror = abs((detR-detRprev)/detR);
    costFun(iter) = detR;
    par_prnt = sprintf('Iteration %4i    Residual error: det(R) = %13.5e    Relative change = %13.5e', iter, detR, relerror);
    disp(par_prnt)

    % Check convergence: relative change in the cost function
    if relerror < tolR,
        disp('Convergence criterion is satisfied: Relative change less than tolR');
        break;
    end
    detRprev = detR;
    
end; % end of iteration loop

if iter == itMax,
    disp('Training is terminated after itMax iterations; the convergence to tolR may not be achieved.');
end   

%---------------------------------------------------------------------------------------
% prediction cycle

if NdataPred > 0, 
    
    SZMY2pred = zeros(Ny,1);
    
    for k=1:NdataPred,
        
        % Propagation from input layer to hidden layer
        Uinb = [XS(k,:) 1]';                     % Control inputs including bias
        y1   = w1*Uinb;                          % y1 = W1*u0 + W10; Eq. (6)
        [u1, fprime1] = ffprime(y1, gamma1);     % u1 = f(y1) & fprime(y1); Eqs.(7 & 20)

        % Propagation from hidden layer to output layer
        u1b = [u1; 1];                           % Hidden layer outputs including bias
        y2  = w2*u1b;                            % y2 = W2*u1 + W20; Eq. (9)
        [u2, fprime2] = ffprime(y2,gamma2);      % u2 = f(y2) & fprime(y2); Eqs.(10 & 20)
                
        % Save estimated outputs in SY and sum of Error^2 in SZMY2
        zm = ZS(k,:)';                           % Output variables
        SYpred(k,:) = u2';                       % Save output variables
        SZMY2pred   = SZMY2pred + (zm-u2).^2;    % Sum of error^2

    end % end of data prediction loop
    
    % Standard deviations of the errors in the output variables
    sd   = sqrt(SZMY2pred/Ndata);
    covR = SZMY2pred/Ndata;
    detR = det(diag(covR));
    disp(' ')
    % par_prnt = sprintf('Iteration %4i    Residual error: det(R) = %13.5e', iter, detR);
    par_prnt = sprintf('Prediction step:  Residual error: det(R) = %13.5e', detR);
    disp(par_prnt)
    disp(' ')
    disp('NOTE: The residual error after the training phase differs from the')
    disp('      residual error after the prediction step on the same data used in')
    disp('      the training. This is because the weights are altered recursively')
    disp('      for each point during training, whereas during the prediction step')
    disp('      the estimated weights are kept fixed for all data points. It is')
    disp('      for this reason that the prediction step needs to be performed to')
    disp('      verify the performance over the complete data of points.')
    
end

return
% end of function
