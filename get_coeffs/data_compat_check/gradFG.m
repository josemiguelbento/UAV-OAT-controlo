function [F, G, XGST] = gradFG(Ny, Nparam, NparID, Ndata, Nu, Nx, Nzi, izhf, ...
                        Z, Y, RI, param, parFlag, par_del, par_delX0, state_eq,Uinp, ...
                        obser_eq, times, x0, iArtifStab, StabMat, integMethod, ...
                        parFlagX0, NX0ID, XGST, paramX0BX, ...
                        NbX, NBXID, bXpar, parFlagBX, par_delbX)
% 
% Compute the information matrix (i.e. matrix of second gradients) F and 
% the gradient vector G
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Ny            number of output variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Ndata         number of data points
%    Nu            number of input variables
%    Nx            number of state variables
%    Nzi           number of time segments being analyzed simultaneously
%    izhf          Cumulative index at which the concatenated time segments end
%    dt            sampling time
%    Z             measured outputs (Ndata,Ny)
%    Y             computed (model) outputs for unperturbed parameters (Ndata,Ny)
%    RI            inverse of covariance matrix
%    param         parameter vector
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    par_del       param perturbations to numerically approximate response gradients
%    par_delX0     X0 perturbations to numerically approximate response gradients
%    state_eq      function coding the state equations
%    Uinp          measured inputs (Ndata,Nu) 
%    obser_eq      function coding the observation equations
%    times         time vector
%    x0            initial conditions
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%    integMethod   integration method
%    parFlagX0     flags for free and fixed initial conditions
%    NX0ID         total number of initial conditons to be estimated (free x0's)
%    XGST          work space to store propagated perturbed states for
%                  re-initialization
%    paramX0BX     vector of system parameters, initial conditons and bias parameters
%    NbX
%    NBXID
%    bXpar
%    parFlagBX
%    par_delbX
%
% Outputs:
%    F             information matrix 
%    G             gradient vector 
%    XGST



global kk  kzi  LF         % temporary for tc05 model; reqd for timeDelay (14.01.2009)
global iPar  dt            % for timeDelay function (14.01.2009)
global ts  tCur             % required for timeDelay function (14.01.2009)

%--------------------------------------------------------------------------
% Simulation for nominal parameter values:
% Array Y contains system responses for unperturbed parameters 

%--------------------------------------------------------------------------
% Initialize F and G to zero
F = zeros([NparID+NX0ID+NBXID, NparID+NX0ID+NBXID]);
G = zeros([NparID+NX0ID+NBXID, 1]);

kzi = 0;
kk  = 1;
LF  = 1;

while kzi < Nzi;                       % Loop for Nzi time segments
    kzi  = kzi + 1;
    kend = izhf(kzi);
    if kzi > 1, LF = izhf(kzi-1) + 1; end   % Starting data-point index of the 
                                            % current time segment 
    if isempty(x0),                    % xp   = x0(:,kzi);
        XGST = x0;                     % This is not yet checked!!!
    else
        for i1=1:NparID+NX0ID+NBXID,
            XGST(:,i1) = x0(:,kzi);    % get initial conditions for the time segment
        end
    end
    
    if isempty(bXpar),
        bXparV = bXpar;
    else
        bXparV = bXpar(:,kzi);         % bias parameters bX for the kzi-th segment
    end                                

    
    H = zeros([Ny, NparID+NX0ID+NBXID]);    % Initialize H here

    while kk <= kend,                  % Loop for data points of kzi-th time segment
        iPar = 0;
        ts = times(kk);
        tCur = ts;
        
        % Compute response gradients (H) for system parameters 
        for ip=1:Nparam,                         % Loop over all parameters
            if  parFlag(ip) > 0,                 % do it for free parameters only
                iPar = iPar + 1;
                paramp    = param;
                paramp(ip)= paramp(ip) + par_del(ip);
                [H, XGST] = gradrespH(iPar, kk, kend, Nx, Nu, paramp, ...
                                      par_del(ip), dt, H, XGST, Z, Y, Uinp, ...
                                      obser_eq, state_eq, ts, iArtifStab, ...
                                      StabMat, integMethod, bXparV);
            end
        end

        % Compute response gradients (H) for initial conditions x0
        if NX0ID > 0,
            if kzi == 1,
                iParX  = NparID;
                iParX0 = NparID;
            else
                iParX  = NparID + size(find(parFlagX0(:,1:kzi-1)~=0),1);
                iParX0 = NparID + size(find(parFlagX0(:,1:kzi-1)~=0),1);
            end

            for ip=1:Nx,                         % Loop over all initial conditions
                % x0 (in XGST) to be perturbed only for the first point of each segment
                if kk == LF, 
                    if parFlagX0(ip,kzi) > 0,    % do it for free x0 only
                        iParX0 = iParX0 + 1;
                        XGST(ip,iParX0) = XGST(ip,iParX0) + par_delX0(ip,kzi);
                    end
                end
            
                if parFlagX0(ip,kzi) > 0,        % do it for free x0 only
                    iParX = iParX + 1;
                    iPar  = iParX;                
                    % system parameters unperturbed, because of perturbation of x0/XGST
                    paramp    = param;
                    [H, XGST] = gradrespH(iPar, kk, kend, Nx, Nu, paramp,...
                                          par_delX0(ip,kzi), dt, H, XGST, Z, Y,...
                                          Uinp, obser_eq, state_eq, ts, ...
                                          iArtifStab, StabMat, integMethod, ...
                                          bXparV);
                end
            end
        end

        % Compute response gradients (H) for bias parameters bXpar
        if NBXID > 0,
            if kzi == 1,
                iParBX  = NparID+NX0ID;
            else
                iParBX  = NparID + NX0ID + size(find(parFlagBX(:,1:kzi-1)~=0),1);
            end
            for ip=1:NbX,                        % Loop over all bX parameters
                if  parFlagBX(ip,kzi) > 0,       % do it for free bX parameters only
                    iParBX  = iParBX + 1;
                    iPar    = iParBX;
                    bXparVp = bXparV;
                    bXparVp(ip) = bXparV(ip) + par_delbX(ip,kzi);
                    [H, XGST]   = gradrespH(iPar, kk, kend, Nx, Nu, param, ...
                                            par_delbX(ip,kzi), dt, H, XGST, Z, Y,...
                                            Uinp, obser_eq, state_eq, ts, ...
                                            iArtifStab, StabMat, integMethod, ...
                                            bXparVp);
                end
            end
        end
        
        % compute G and F (first and second gradients) of the cost function J
        zmy = Z(kk,:) - Y(kk,:);       % response error  
        zmy = zmy(:);
        G = G - H' * RI * zmy;         % gradient vector, Eq. (4.30)
        F = F + H' * RI * H;           % information matrix, Eq. (4.30)

        kk = kk + 1;                   % Increment data point index
        
    end                                % End of kk-Loop for points of kzi-th segment

end                                    % End of Nzi-Loop for time segments

return
%end of function