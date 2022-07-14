function [param, x0, bXpar, paramX0BX] = parUpdate(paramX0BX, x0, bXpar, delPar, ...
                                                   parFlag, parFlagX0, parFlagBX,...
                                                   Nzi, Nx, Nparam, NbX, NparID, NX0ID)

% update parameter vector param, initial conditions x0, and 
% bias parameters bX; Eq. (4.29)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    paramX0BX     parameter vector (before update) 
%    x0            initial conditions
%    bXpar         bias parameters
%    delPar        parameter update (delta-Theta) 
%    parFlagX0    flags for free and fixed initial conditions
%    parFlagBX
%    Nzi           number of time segments being analyzed simultaneously
%    Nx            number of state variables
%    Nparam        total number of system parameters in the postulated model
%    NbX
%    parFlag
%
% Outputs:
%    param         system parameters (after update)
%    x0            initial conditions
%    bXpar         bias parameters
%    paramX0BX     system parameters, initial conditions and bias parameters


%--------------------------------------------------------------------------
% System parameters
param(1:Nparam,1) = paramX0BX(1:Nparam,1);
iPar = 0;
for ip=1:Nparam,
    if  parFlag(ip) > 0,
        iPar = iPar + 1;
         param(ip) = param(ip) + delPar(iPar);
    end
end

% Initial conditons X0
iPar = 0;
for i2=1:Nzi, 
    for i1=1:Nx,
        if (parFlagX0(i1,i2) > 0),
            iPar = iPar + 1;
            x0(i1,i2) = x0(i1,i2) + delPar(NparID+iPar);
         end
    end
end

% bias parameters bXpar
iPar = 0;     
for i2=1:Nzi,                        
    for i1=1:NbX,
        if (parFlagBX(i1,i2) > 0),
            iPar = iPar + 1;
            bXpar(i1,i2) = bXpar(i1,i2) + delPar(NparID+NX0ID+iPar);
        end
    end
end


% Build up the combined paramX0BX from updated param, x0, and bXpar
paramX0BX = param;
if ~isempty(x0),
    for kzi=1:Nzi,
        paramX0BX = [paramX0BX; x0(:,kzi)];
    end
end
if ~isempty(bXpar),
    for kzi=1:Nzi,
        paramX0BX = [paramX0BX; bXpar(:,kzi)];
    end
end

return
% end of function