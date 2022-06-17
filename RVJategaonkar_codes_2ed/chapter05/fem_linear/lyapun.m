function gradP = lyapun(Nx, Ny, dt, Amat, Cmat, Pcov, Kgain, Fmat, RI)
                      
% Compute gradients of covariance matrix P:
% This requires solution of the Lyapunov equations, once for each parameter to be estimated
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Filter error method for linear systems (ml_fem_linear)
%
% Inputs:
%     Nx      Number of state variables
%     Ny      Number of observation variables
%     dt      Sampling time
%     Amat    State matrix (Nx,Nx)
%     Cmat    Observation matrix (Ny,Nx)
%     Pcov    Covariance matrix P, (Nx,Nx)
%     Kgain   Gain matrix (=PC'RI), (Nx,Ny)
%     Fmat    State noise distribution matrix
%     RI      Inverse of measurement noise covariance matrix
%
% Outputs:
%     gradP   Gradient of P, (Nx,Nx,NK)


%--------------------------------------------------------------------------------------
global NA  iA  kA  jA  Abet  NB  iB  kB  jB  Bbet
global NC  iC  kC  jC  Cbet  ND  iD  kD  jD  Dbet
global NF  iF  kF  jF  Fbet
global NALF  NBET  iP  NK


% Compute the matrix AH = A - P*C'*RI*C/dt 
AH = Amat - Pcov*Cmat'*RI*Cmat/dt;                                   % Eq. (5.29)

% Compute eigenvalues and eigenvectors of AH
[eVec,eVal] = eig(AH);

% Similarity transformation of AH: AHT=inv(eigVec)*AH*eVec
E2 = inv(eVec)*AH*eVec;      % by inverse of a matrix                % Eq.(5.31)
%E2 = eVec\(AH*eVec);        % by backslash operator AX=B -> X=A\B

% eVec' and inverse of eVec' for further repeated use
E1 = ( conj(eVec) )';
E3 = inv(E1);

gradP = zeros(Nx,Nx,NK);
dumCH = zeros(Nx,Nx,NBET);

II = 0;
if (NA ~= 0),
    for kk=1:NA,
        I2 = jA(kk);
        if (I2 <= NBET),
            CH = zeros(Nx,Nx);
            I1 = iA(kk);
            I3 = kA(kk);
            gradA = zeros(Nx,Nx);
            gradA(I1,I3) = 1;
            CH = gradA*Pcov;
            II=II+1;
            IWK(II)= I2;
            dumCH(:,:,I2)=CH;
        end
    end
end

IIA = II;
if (NC ~= 0),
    for kk=1:NC,
        I2 = jC(kk);
        if (I2 > 0 & I2 <= NBET),
            CH = zeros(Nx,Nx);
            I1 = iC(kk);
            I3 = kC(kk);
            gradC = zeros(Ny,Nx);
            gradC(I1,I3) = 1;
            CH = -Kgain*gradC*Pcov/dt;
            if(IIA == 0),
                II=II+1;
            else
                for l=1:IIA,
                    if (I2 ~= IWK(l)), II=II+1;  end
                end
             end
            IWK(II)= I2;
            dumCH(:,:,I2)=dumCH(:,:,I2)+CH;
        end
    end
end

% This completes the Eq. (25) for elements of A and C matrices, because
% gradients of other matrices with respect to these elements in A and C are
% zero; hence the last term does not contribute to these terms here. They
% are treated separately later.


for i=1:II,
    I2 = IWK(i);
    if (I2 ~= 0),
        CH = dumCH(:,:,I2);
        [gradP] = axpxat (Nx, NK, I2, CH, eVec, E2, E3, gradP);
    end
end


if (NF ~= 0),
   for kk=1:NF,
       I2 = jF(kk);
       if (I2 <= NBET),
           CH = zeros(Nx,Nx);
           I1 = iF(kk);
           I3 = kF(kk);
           for j=1:Nx,
               if (I1 ~= I3),
                   CH(I1,j)=Fbet(kk)*Fmat(j,I3);
               else
                   CH(I1,j)=Fbet(kk)*Fmat(j,I1);
               end
           end
           [gradP] = axpxat (Nx, NK, I2, CH, eVec, E2, E3, gradP);
       end
    end
end

return
% end of function
