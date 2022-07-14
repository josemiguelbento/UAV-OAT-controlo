function [dParam, lamda] = LMmethod(integMethod, state_eq, obser_eq, Ndata,...
                                    Ny, Nu, Nzi, Nx, Nparam, NparID, lamda, ...
                                    param, parFlag, times, x0, Uinp, Z, izhf,...
                                    F, G, eps_zf, cCost0, iArtifStab, StabMat, ...
                                    NX0ID, paramX0BX, parFlagX0, ...
                                    NBXID, NbX, bXpar, parFlagBX)

% Optimization of cost function applying Levenberg-Marquardt method
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    integMethod   integration method
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    Ndata         number of data points
%    Ny            number of output variables
%    Nu            number of input variables
%    Nzi           number of time segments being analyzed simultaneously
%    Nx            number of state variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    lamda         Levenberg-Marquardt parameter 
%    param         parameter vector
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    times         time vector
%    x0            initial conditions
%    Uinp          measured inputs (Ndata,Nu) 
%    Z             measured outputs (Ndata,Ny)
%    izhf          Cumulative index at which the concatenated time segments end
%    F             information matrix 
%    G             gradient vector 
%    eps_zf        convergence limit in terms of relative change in the cost function
%    cCost0        previous cost function value
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%    NX0ID         total number of initial conditons to be estimated (free x0's)
%    paramX0BX     vector of system parameters and initial conditions
%    parFlagX0     flags for free and fixed initial conditions
%    NBXID
%    bXpar
%    parFlagBX
%
% Outputs:
%    dParam        parameter update (delta-Theta) 
%    lamda         Levenberg-Marquardt parameter 


global dt        % required for timeDelay function (14.01.2009)

%--------------------------------------------------------------------------
% compute the scale factors: square root of diagonal elements
sfac = 1./sqrt(diag(F));

% Scale G and F: Eq. (4.69) and (4.70)
G = G.*sfac;
for i1=1:NparID+NX0ID+NBXID, 
    for j1=1:NparID+NX0ID+NBXID, 
        Fscal(i1,j1) = F(i1,j1)*sfac(i1)*sfac(j1); 
    end, 
end

% Add lamda to the diagonal elements of scaled F, Eq. (4.68)
F1 = Fscal + lamda*eye(NparID+NX0ID+NBXID);


%--------------------------------------------------------------------------
idum = -1;                                  % Switch for jump back condition
% jump back address
while idum <= 0;

    % Compute parameter update vector 
    uptF1 = chol(F1);                       % Cholesky factorization: F=uptF'*uptF
    dPar1 = -uptF1 \ ( uptF1' \ G );

    % Unscale parameter updates corresponding to lamda and compute new parameters
    % and new initial conditions
    dPar1 = dPar1.*sfac;
%     [paramStp1, x0Stp1, paramX0BXStp1, bXparStp1] = ...
%                             parStepLM(Nparam, NparID, Nx, Nzi, ...
%                                       parFlag, parFlagX0, param, x0, dPar1, ...
%                                       NX0ID, NbX, bXpar, parFlagBX); 
    [paramStp1, x0Stp1, paramX0BXStp1] = ...
                            parStepLM(Nparam, NparID, Nx, Nzi, ...
                                      parFlag, parFlagX0, param, x0, dPar1, ...
                                      NX0ID, NbX, bXpar, parFlagBX); 

    % Compute the cost function at lamda
    [cCost1, R, RI, Y] = costfun_oem (integMethod, state_eq, obser_eq, Ndata, ...
                                      Ny, Nu, Nzi, Nx, times, x0Stp1, Uinp, ...
                                      Z, izhf, iArtifStab, StabMat, ...
                                      Nparam, paramX0BXStp1, NbX);

    % Add lamda/10 to the diagonal of Fscal
    F2 = Fscal + lamda*0.1*eye(NparID+NX0ID+NBXID);
    
    % Compute parameter update vector for reduced LM-parameter
    uptF2  = chol(F2);                      % Cholesky factorization: F2=uptF'*uptF
    dParam = -uptF2 \ ( uptF2' \ G );
    
    % Unscale parameter updates corresponding to lamda and compute new parameters
    % and new initial conditions
    dParam = dParam.*sfac;
%     [paramStp2, x0Stp2, paramX0BXStp2, bXparStp2] = ...
%                             parStepLM(Nparam, NparID, Nx, Nzi, ...
%                                       parFlag, parFlagX0, param, x0, dParam, ...
%                                       NX0ID, NbX, bXpar, parFlagBX);
    [paramStp2, x0Stp2, paramX0BXStp2] = ...
                            parStepLM(Nparam, NparID, Nx, Nzi, ...
                                      parFlag, parFlagX0, param, x0, dParam, ...
                                      NX0ID, NbX, bXpar, parFlagBX);

    % Compute the cost function at lamda/10
    [cCost2, R, RI, Y] = costfun_oem (integMethod, state_eq, obser_eq, Ndata, ...
                                      Ny, Nu, Nzi, Nx, times, x0Stp2, Uinp, ...
                                      Z, izhf, iArtifStab, StabMat, ...
                                      Nparam, paramX0BXStp2, NbX);
   
    % Evaluate the results
    costDiff2 = cCost2 - cCost0;
    costDiff1 = cCost1 - cCost0;

    if (costDiff2 <= 0),                    % condition 1
    
        % reduce lamda-parameter and accept the new point  
        currentCost = cCost2;
        %cCost0 = cCost2;
        lamda = lamda*0.1;
        i_lm  = 1;
        par_prnt = sprintf('%3i %-12s  %7.2e   %10.4e', i_lm, 'LM1: Lamda=',lamda, cCost2);
        disp(par_prnt)
        % Overwrite F with unscaled F2 prior to returning 
        for i1=1:NparID+NX0ID+NBXID, 
            for j1=1:NparID+NX0ID+NBXID, 
                F(i1,j1) = F2(i1,j1)/sfac(i1)/sfac(j1); 
            end, 
        end
        idum = 1;                           % set switch to 1 for return
        
    else
        dum4 = costDiff1 - eps_zf*cCost0;
        
        if (costDiff2 > 0  & costDiff1 <= 0) | dum4 <= 0,
            
            % Keep current lamda and accept new point
            currentCost = cCost1;
            %cCost0 = cCost1;
            i_lm = 2;
            par_prnt = sprintf('%3i %-12s  %7.2e   %10.4e', i_lm, 'LM2: Lamda=',lamda, cCost1);
            disp(par_prnt)
            % Prior to returning, get dParam for the current lamda and unscale F
            dParam = dPar1;
            for i1=1:NparID+NX0ID+NBXID, 
                for j1=1:NparID+NX0ID+NBXID, 
                    F(i1,j1) = F1(i1,j1)/sfac(i1)/sfac(j1); 
                end, 
            end
            idum = 1;                       % set switch to 1 for return

        else
        
            % Increase lamda and reject new point and loop back
            lamda = lamda*10;
            i_lm  = 3;
            par_prnt = sprintf('%3i %-12s  %7.2e   %10.4e', i_lm, 'LM3: Lamda=',lamda, cCost2);
            disp(par_prnt)
            % Add new lamda to the diagonal of scaled F and jump back  
            F1 = Fscal + lamda*eye(NparID+NX0ID+NBXID);

        end
    
    end
    
end

return
% end of function