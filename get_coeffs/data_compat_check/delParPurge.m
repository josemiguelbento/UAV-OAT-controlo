function delPar = delParPurge(GH, Nparam, Nx, Nzi, i_State, parFlag, parFlagX0, ...
                              NbX, parFlagBX) 

% The Deltas (in workspace GH) in minf_quad with line search are computed for full 
% length of parameter vector (NParam+Nzi*Nx*Nzi*NbX). However, the functipn
% parUpdate requires delPar for free parameter only. The function
% parUpdate is common for all methgods (GN, BVGN and LM), and the method GN
% and LM yieds delPar for free parameter only.
% 
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    GH            Deltas (workspace) for full length parameters
%    Nparam        total number of parameters appearing in the postulated model
%    Nx            number of state variables
%    Nzi           number of time segments being analyzed simultaneously
%    i_State       active set
%    parFlag       flags for free and fixed parameters (=1, free; 0=, fixed)
%    parFlagX0     flags for free and fixed initial conditions
%    NbX
%    parFlaBX
%
% Outputs:
%    delPar        parameter update (delta-Theta) full size

iPar = 0;
for ip=1:Nparam,
%     if i_State(ip) == 0  & parFlag(ip) ~= 0,   %29-01-2009
    if parFlag(ip) ~= 0,
        iPar = iPar + 1;
        delPar(iPar,1) = GH(ip,1);
    end
end

for i2=1:Nzi,
    for i1=1:Nx,
        if (parFlagX0(i1,i2) > 0),
            iPar = iPar + 1;
            delPar(iPar,1) = GH(Nparam+(i2-1)*Nx+i1);
        end
    end
end

for i2=1:Nzi,
    for i1=1:NbX,
        if (parFlagBX(i1,i2) > 0),
            iPar = iPar + 1;
            delPar(iPar,1) = GH(Nparam+Nzi*Nx+(i2-1)*NbX+i1);
        end
    end
end

return
% end of function