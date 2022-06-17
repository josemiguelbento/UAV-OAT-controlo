function [X, iFA, fStore] = ...
             minf_quad(fStore, X, S, alfa, iFA, maxFA, epsF, epsX,...
                       integMethod, state_eq, obser_eq,...
                       Ndata, Ny, Nu, Nzi, Nx, times, x0,... 
                       Uinp, Z, izhf, iArtifStab, StabMat, Nparam, NbX); 

% One dimensional line search, i.e., determination of a step size alfa 
% in the search direction S, without using directional derivatives.
% Procedure: The line search starts with a function comparison procedure
% using doubling and halving steps; this is followed by a function 
% approximation by second order polynominals. 
% Reference: G.E. Forsythe, M.A. Malcolm, and C.B. Moler
%            Computer Methods for Mathematical Computations, 
%            Chapters 7 and 8; Prentice-Hall, Englewood Cliffs, 1977,  
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    fStore     cost function value
%    X          parameter vector
%    S          direction of search
%    alfa       intial step size
%    iFA        number of function calls
%    maxFA      maximum number of fucntion calls allowed
%    epsF       convergence criterion, change in cost function value
%    epsX       convergence criterion, change in paramete values
%    Rest of the input variables are model relevant and specific to 
%    the interface: (integMethod, state_eq, obser_eq, Ndata, Ny, Nu, 
%    Nzi, Nx, dt, times, x0, Uinp, Z, izhf, iArtifStab, StabMat); 
%
% Outputs:
%    X          parameter vector
%    iFA        number of function calls
%    fStore     cost function value


global dt        % required for timeDelay function (14.01.2009)

%--------------------------------------------------------------------------
TRUE = 1;  FALSE = 0;

% Initialization
F(1:5,1) = fStore;
A(1:5,1) = 0;
A(5,1)   = alfa;

k   = 2;
kf  = k + 3;
iz2 = 0;
iz1 = 0;
iz3 = 0;
jmp1100 = TRUE;
jmp2000 = TRUE;

%--------------------------------------------------------------------------
% while jmp1100  & iFA <= maxFA,
while jmp1100,           % 28.01.2009 (for iFA=maxFA, before returning values were not set)
    
    if (iFA > maxFA),    % 28.01.2009
        fStore = F(3)
        alfa   = A(3)
        X      = X + alfa * S;
    end
    
    XT  = X + A(kf)*S;

    iFA = iFA + 1;
    iz1 = iz1 + 1;

    [F(kf), R, RI, Y] = ...
                costfun_oem (integMethod, state_eq, obser_eq, Ndata,...
                             Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                             izhf,        iArtifStab, StabMat, Nparam, XT, NbX); 
    
    absmxX = max( abs(X) );
    absmxS = max( abs(S) );
    
    if F(kf) == F(3)  &  abs(A(kf)*absmxS) > epsX *absmxX,
        fStore = F(3)
        alfa   = A(3)
        X      = X + alfa * S;
        return
    else
        if F(kf) < F(3),
           i1    = 3 - k;
           F(i1) = F(3);
           A(i1) = A(3);
           i1    = 3 + k;
           F(3)  = F(i1);
           A(3)  = A(i1);
           A(kf) = 3.16D0 * A(kf);
        elseif F(kf) > F(3)  &  F(3) >= F(1),
           k     = -2;
           kf    =  k + 3;
           A(1)  = -A(5);
           jmp1100 = FALSE;
        else
           jmp1100 = FALSE; 
        end
    end

end % while ~jmp1100       % 28.01.2009 (for iFA=maxFA, before returning values were not set)
% end % while ~jmp1100  & iFA <= maxFA

%--------------------------------------------------------------------------
% INTERPOLATION
while jmp2000,
    
    alf   = ( A(3) - A(1) ) / ( A(5) - A(1) );
    alfa  = alf;
    Zcurv = F(1) - F(3) + alfa * ( F(5)-F(1) );
      
    if Zcurv ~= 0.D0,
      
        alfa = 0.5D0 * (F(1) - F(3) + alfa*alfa * (F(5)-F(1)) ) / Zcurv;

        if alfa == alf, 
            fStore = F(3);
            alfa   = A(3);
            X      = X + alfa * S;
            return
        end

        if alfa > alf,
            k  = 1;
            kf = k + 3;
        else
            k  = -1;
            kf =  k + 3;
        end
  
        if alfa < 1.D0 & alfa > 0.D0,
             
            alfa = A(1) + alfa * ( A(5) - A(1) );
            XT   = X + alfa * S;
            iz3  = iz3 + 1;
            [fStore, R, RI, Y] = ...
                costfun_oem (integMethod, state_eq, obser_eq, Ndata,...
                             Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                             izhf,        iArtifStab, StabMat, Nparam, XT, NbX); 

            iFA = iFA + 1;

            if fStore > F(3),
                F(kf)  = fStore;
                A(kf)  = alfa;
                kkf    = k + kf;
                A(kkf) = alfa;
                F(kkf) = fStore;
            else
                F(3)   = fStore;
                A(3)   = alfa;
                fStore = F(3);
                alfa   = A(3);
                X      = X + alfa * S;
                return
            end
        end

    end

    %--------------------------------------------------------------------------
    if abs(A(1)-A(3))  <  abs(A(3)-A(5)),
        k  = 1;
        kf = k + 3;
    else
        k  = -1;
        kf =  k + 3;
    end
    
    i1    = kf;
    A(i1) = 0.5D0 * ( A(i1+1) + A(i1-1) );
    XT    = X + A(i1) * S;

    [F(i1), R, RI, Y] = ...
                costfun_oem (integMethod, state_eq, obser_eq, Ndata,...
                             Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                             izhf,        iArtifStab, StabMat, Nparam, XT, NbX); 

    iFA   = iFA + 1;
    iz2   = iz2 + 1;
    
    %--------------------------------------------------------------------------
    k     = 0;
    kf    = k + 3;
    Zcurv = F(3);
    for i1=2:2:4,
        if F(i1) < Zcurv,
            Zcurv = F(i1);
            k     = i1 - 3;
            kf    = k + 3;
        end
    end
    
    for i1=1:3,
        if i1 == 1,
            j1 = -1;
        elseif i1 == 2,
            j1 =  1;
        else 
            j1 =  0;
        end
        jj    =  j1 + j1 + 3;
        kj    =  kf + j1;
        F(jj) = F(kj);
        A(jj) = A(kj);
    end
          
    for j1=1:2:3,
        i1    = j1 + 1;
        ii    = j1 + j1 - 1;
        F(i1) = F(ii);
        A(i1) = A(ii);
    end

    MAXF = F(1);
    if F(5) > MAXF, MAXF = F(5); end
    if abs(MAXF - Zcurv) <= epsF*abs(Zcurv) | iFA >= maxFA, jmp2000 = FALSE; end

end  % while jmp2000

fStore = F(3);
alfa   = A(3);
X      = X + alfa * S;

return
% end of function
