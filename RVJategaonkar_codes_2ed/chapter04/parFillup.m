function GH = parFillup(Nparam, Nx, Nzi, i_State, parFlag, parFlagX0, delPar, ...
                        NbX, parFlagBX) 

% delPar are computed in "improv" or available in chk_update for Npar_free; 
% Arrange them appropriately for Nparam parameters using i_State; 
% and then fill up with free x0's
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nparam        total number of parameters appearing in the postulated model
%    Nx            number of state variables
%    Nzi           number of time segments being analyzed simultaneously
%    i_State       active set
%    parFlag       flags for free and fixed parameters (=1, free; 0=, fixed)
%    parFlagX0    flags for free and fixed initial conditions
%    delPar        parameter update (delta-Theta) 
%    NbX
%    parFlagBX
%
% Outputs:
%    GH            parameter update (delta-Theta) full size


%--------------------------------------------------------------------------
iPar = 0;
for ip=1:Nparam,
    if i_State(ip) == 0  &  parFlag(ip) ~= 0,
        iPar = iPar + 1;
        GH(ip,1) = delPar(iPar);
    else
        GH(ip,1) = 0.0;
    end
end

for i2=1:Nzi,
    for i1=1:Nx,
        if (parFlagX0(i1,i2) > 0),
            iPar = iPar + 1;
            GH(Nparam+(i2-1)*Nx+i1) = delPar(iPar);
        else
            GH(Nparam+(i2-1)*Nx+i1) = 0.0;
        end
    end
end

for i2=1:Nzi,
    for i1=1:NbX,
        if (parFlagBX(i1,i2) > 0),
            iPar = iPar + 1;
            GH(Nparam+Nzi*Nx+(i2-1)*NbX+i1) = delPar(iPar);
        else
            GH(Nparam+Nzi*Nx+(i2-1)*NbX+i1) = 0.0;
        end
    end
end

return
% end of function