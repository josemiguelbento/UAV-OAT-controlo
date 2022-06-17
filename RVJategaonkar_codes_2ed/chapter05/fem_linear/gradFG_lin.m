function [gradY, grd1J, grd2J] = gradFG_lin(Ny, Nx, Nu, Nparam, Ndata, NZI, kzi, kk, ...
                                      xh, xt, u1, Uinp, Cmat, Kgain, Phi, Chi, gradX, gradK, ...
                                      RI, zmy, grd1J, grd2J)

% Compute the sensitivity matrix gradY(i,j) = dy(i)/dTheta(j); as well as
% the information matrix F = gradY'*RI*gradY and gradient G = gradY'*RI*(z-y)
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
%    Ny            number of output variables
%    Nx            number of state variables
%    Nu            number of input variables
%    Nparam        total number of parameters appearing in the postulated model
%    Ndata         number of data points
%    NZI           number of time segments analyzed simultaneously
%    kzi           index of the time segment being currently processed 
%    kk            index of the data point currently being processed
%    xh            corrected state vector xhat
%    xt            predicted state vector xtilde
%    u1            input vector
%    Uinp          measured inputs (Ndata,Nu) 
%    Cmat          state observation matrix
%    Kgain         Kalman gain matrix, (Nx,Ny)
%    Phi           State transition matrix
%    Chi           Integral of state transition matrix
%    gradX         Gradient of state vector d(xtilde)/d(theta), (Nx,Nparam)
%    gradK         Gradient of gain matrix 
%    RI            inverse of covariance matrix
%    zmy           residuals (Ny)
%    grd1J         gradient vector G
%    grd2J         information matrix F (matrix of second gradients)
%
% Outputs:
%    gradY         sensitivity matrix dy/dTheta, (Ny,Nparam)
%    grd1J         gradient vector G
%    grd2J         information matrix F (matrix of second gradients)


%--------------------------------------------------------------------------------------
global NC  iC  kC  jC  Cbet  ND  iD  kD  jD  Dbet
global NALF  NBET  iP  NK  NFVAR
global NBX  iBX  jBX  XGAM  NGAM
global NBY  iBY  jBY  YDEL  NDEL

% Computation of the sensitivity matrix gradY , Eq. (5.xx) (20 of FB 87-20)
gradY(1:Ny,1:Nparam) = 0;
if  NALF ~= NFVAR,
    gradY(:,1:NBET) = Cmat * gradX(:,1:NBET);
end


if  NBET ~= 0,
    
    if  NC ~= 0,
        for k=1:NC,
            I2 = jC(k);
            if  I2 <= NBET & I2 > 0,
                I1 = iC(k);
                I3 = kC(k);
                gradY(I1,I2) = gradY(I1,I2) + Cbet(k)*xt(I3);
            end
        end
    end
    
    if  ND ~= 0,
        for k=1:ND,
            I2 = jD(k);
            if  I2 <= NBET & I2 > 0,
                I1 = iD(k);
                I3 = kD(k);
                gradY(I1,I2) = gradY(I1,I2) + Dbet(k)*u1(I3);
            end
        end
    end

end


if  NGAM ~= 0  |  NC ~= 0,
    J1 = NBET + (kzi-1)*NGAM;
    for j=1:NGAM,
        J1 = J1 + 1;
        I1 = J1;
        for jj=1:NC
            i = iC(jj);
            k = kC(jj);
            gradY(i,J1) = gradY(i,J1) + Cmat(i,k)*gradX(k,I1);
        end
    end
end


if  NBY ~= 0,

    J2 = NBET + NZI*NGAM + (kzi-1)*NDEL;
    J3 = NBET + (kzi-1)*NGAM;
    if  NC ~= 0,
        for j=1:NDEL,
            J1 = J2 + j;
            I1 = J1;
            for jj=1:NC,
                i = iC(jj);
                k = kC(jj);
                gradY(i,J1) = gradY(i,J1) + Cmat(i,k)*gradX(k,I1);
            end
        end
    end
    
    J1 = NDEL + 1;
    for k=1:NBY;
        I2 = jBY(k);
        if  I2 ~= J1,
            I1 = iBY(k);
            gradY(I1,I2) = gradY(I1,I2) + YDEL(k);
        end 
    end
        
end

%--------------------------------------------------------------------------------------
% Compute first and second gradients of the cost function
grd1J   = grd1J + gradY' * RI * zmy';                      % Eq. (5.20)
grd2J   = grd2J + gradY' * RI * gradY;                     % Eq. (5.19)

return
% end of function
