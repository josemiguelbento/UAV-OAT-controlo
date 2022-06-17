function gradX = sgl7(Nx, x12, u12, Phi, Chi, gradX)

% Compute the gradients of the state variables gradXT(i,j) = dxtilde(i)/dtheta(j)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%     Nx          Number of state variables
%     x12         average of xt(k+1) and xh(k)
%     u12         average of u(k+1) and u(k)
%     Phi         State transition matrix
%     Chi         Integral of state transition matrix
%     gradX       Gradient of state vector d(xh)/d(theta), (Nx,Nparam)
%
% Outputs
%     gradX      gradient of state vector d(xtilde)/d(theta), (Nx,Nparam)
%


global NA  iA  kA  jA  Abet  NB  iB  kB  jB  Bbet
global NALF  NBET  iP  NK  NFVAR
global NBX  iBX  jBX  XGAM  NGAM
global NBY  iBY  jBY  YDEL  NDEL

% Compute the state sensitivity matrix d(xtilde)/d(theta); equation (5.xx)
gradX = Phi*gradX;

if  NBET ~= 0,
    
    if  NA ~= 0,
        for k=1:NA,
            I1 = jA(k);
            if  I1 <= NBET & I1 > 0,
                I2 = iA(k);
                I3 = kA(k);
                for i=1:Nx,
                    gradX(i,I1) = gradX(i,I1) + x12(I3)*Abet(k)*Chi(i,I2);
                end
            end
        end
    end
    
    if  NB ~= 0,
        for k=1:NB,
            I1 = jB(k);
            if  I1 <= NBET & I1 > 0,
                I2 = iB(k);
                I3 = kB(k);
                for i=1:Nx,
                    gradX(i,I1) = gradX(i,I1) + u12(I3)*Bbet(k)*Chi(i,I2);
                end
            end
        end
    end
    
end

%
if  Nx ~= 0,
    for k=1:Nx,
        I1 = jBX(k);
        if  I1 <= Nx + NBET;
            I1 = NBET + k;
            I2 = iBX(k);
            for i=1:Nx,
                gradX(i,I1) = gradX(i,I1) + XGAM(k)*Chi(i,I2);
            end
        end
    end
end

return
