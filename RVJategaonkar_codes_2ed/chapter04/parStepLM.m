function [paramStp, x0Stp, paramX0BXStp] = ...
                                    parStepLM(Nparam, NparID, Nx, Nzi, parFlag, ...
                                              parFlagX0, param, x0, dParam, ...
                                              NX0ID, NbX, bXpar, parFlagBX) 
% function [paramStp, x0Stp, paramX0BXStp, bXparStp] = ...
%                                     parStepLM(Nparam, NparID, Nx, Nzi, parFlag, ...
%                                               parFlagX0, param, x0, dParam, ...
%                                               NX0ID, NbX, bXpar, parFlagBX) 
% 
% Compute updated system parameters and initial conditions for given step size
% of Levenberg-Marquardt method.
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        total number of parameters to be estimated
%    Nx            number of state variables
%    Nzi           number of time segments being analyzed simultaneously
%    parFlag       flags for free and fixed parameters (=1, free; 0=, fixed)
%    parFlagX0     flags for free and fixed initial conditions
%    param         system parameter vector
%    x0            initial conditions
%    dParam        parameter update (delta-Theta) 
%    bXpar
%    parFlagBX
%
% Outputs:
%   paramStp       updated system parameters
%   x0Stp          updated initail conditions
%   paramX0BXStp   vector of system parameters and initial conditons
%   bXparStp


%-----------------------------------------------------------------------------------
iPar   = 0;
for i1=1:Nparam,
    if  parFlag(i1) > 0,
        iPar = iPar + 1;
        paramStp(i1,1) = param(i1) + dParam(iPar);              % for free param
    else
        paramStp(i1,1) = param(i1);                             % fixed parameters
    end
end

delX0Stp = dParam(NparID+1:NparID+NX0ID);
iPar = 0;
for i2=1:Nzi,
    for i1=1:Nx,
        if (parFlagX0(i1,i2) > 0),
            iPar = iPar + 1;
            x0Stp(i1,i2) = x0(i1,i2) + delX0Stp(iPar);          % for free x0
        else
            x0Stp(i1,i2) = x0(i1,i2);                           % fixed x0
        end
    end
end

delBXStp = dParam(NparID+NX0ID+1:end);
iPar = 0;   
for i2=1:Nzi,                        
    for i1=1:NbX,
        if (parFlagBX(i1,i2) > 0),
            iPar = iPar + 1;
            bXparStp(i1,i2) = bXpar(i1,i2) + delBXStp(iPar);    % for free bXpar
        else
            bXparStp(i1,i2) = bXpar(i1,i2);                     % for fixed bXpar
        end
    end
end


% Build up combined paramX0BXStp1 from updated paramStp1, x0Stp1 and bXparStp
paramX0BXStp = paramStp;

if ~isempty(x0),
    for kzi=1:Nzi,
        paramX0BXStp = [paramX0BXStp; x0Stp(:,kzi)];
   end
end

if ~isempty(bXpar),
    for kzi=1:Nzi,
        paramX0BXStp = [paramX0BXStp; bXparStp(:,kzi)];
    end
end

return
% end of function