function [Amat, Bmat, Cmat, Dmat, Fmat, BX, BY] = par2sysmat(parVal, Anames,...
                                                     Bnames, Cnames, Dnames, Fnames,...
                                                     BXnames, BYnames);
                                                 
% Construct system matrices and bias vectors from estimated parameters
% in the iterative loop
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
%     parVal        parameter vector (unknown parameters to be estimated)
%                   during the current iteration
%     Anames        Define system state matrix A using alphanumeric names defined
%                   in param.names 
%     Bnames        Define system input matrix B using alphanumeric names defined
%                   in param.names
%     Cnames        Define state output matrix C using alphanumeric names defined
%                   in param.names
%     Dnames        Define input output matrix D using alphanumeric names defined
%                   in param.names
%     Fnames        Define process noise distribution matrix F using alphanumeric names
%                   defined in param.names
%     BXnames       Define state bias vector BX using alphanumeric names defined
%                   in param.names
%     BYnames       Define output bias vector BX using alphanumeric names defined
%                   in param.names
%
% Outputs:
%    Amat          system state matrix
%    Bmat          state input matrix
%    Cmat          state observation matrix
%    Dmat          input matrix
%    Fmat          process noise distribution matrix
%    BX            lumped bias parameters of state equations
%    BY            lumped bias parameters of output equations


%--------------------------------------------------------------------------------------
global NA   iA   kA   jA    Abet  NB  iB  kB  jB  Bbet
global NC   iC   kC   jC    Cbet  ND  iD  kD  jD  Dbet
global NF   iF   kF   jF    Fbet
global NBX  iBX  jBX  XGAM  NGAM
global NBY  iBY  jBY  YDEL  NDEL
global NALF  NBET  iP  NK

% get the numbers of rows and columns of A, B, C, D, F matrices
[irA, jcA] = size(Anames);
[irB, jcB] = size(Bnames);
[irC, jcC] = size(Cnames);
[irD, jcD] = size(Dnames);
[irF, jcF] = size(Fnames);
irBX = size(BXnames);
irBY = size(BYnames);

% Initialize the matrices to set proper size
Amat = zeros(irA, jcA);
Bmat = zeros(irB, jcB);
Cmat = zeros(irC, jcC);
Dmat = zeros(irD, jcD);
Fmat = zeros(irF, jcF);
BX   = zeros(irBX);
BY   = zeros(irBY);

% Decompose parameter vector into system matrices and bias vectors

% A-matrix
if  NA > 0,
    for i=1:NA,
        i1 = iA(i);
        i2 = kA(i);
        i3 = jA(i);
        if  i3 > 0,
            Amat(i1,i2) = Amat(i1,i2) + Abet(i)*parVal(i3);
        else
            Amat(i1,i2) = Amat(i1,i2) + Abet(i);
        end
    end
end


% B-matrix
if  NB > 0,
    for i=1:NB,
        i1 = iB(i);
        i2 = kB(i);
        i3 = jB(i);
        if  i3 > 0,
            Bmat(i1,i2) = Bmat(i1,i2) + Bbet(i)*parVal(i3);
        else
            Bmat(i1,i2) = Bmat(i1,i2) + Bbet(i);
        end
    end
end

% C-matrix
if  NC > 0,
    for i=1:NC,
        i1 = iC(i);
        i2 = kC(i);
        i3 = jC(i);
        if  i3 > 0,
            Cmat(i1,i2) = Cmat(i1,i2) + Cbet(i)*parVal(i3);
        else
            Cmat(i1,i2) = Cmat(i1,i2) + Cbet(i);
        end
    end
end

% D-matrix
if  ND > 0,
    for i=1:ND,
        i1 = iD(i);
        i2 = kD(i);
        i3 = jD(i);
        if  i3 > 0,
            Dmat(i1,i2) = Dmat(i1,i2) + Dbet(i)*parVal(i3);
        else
            Dmat(i1,i2) = Dmat(i1,i2) + Dbet(i);
        end
    end
end

% F-matrix
if  NF > 0,
    for i=1:NF,
        i1 = iF(i);
        i2 = kF(i);
        i3 = jF(i);
        if  i3 > 0,
            Fmat(i1,i2) = Fmat(i1,i2) + Fbet(i)*parVal(i3);
        else
            Fmat(i1,i2) = Fmat(i1,i2) + Fbet(i);
        end
    end
end

% BX bias parameters
if  NGAM > 0,
    for i=1:NGAM,
        i1 = iBX(i);
        i3 = jBX(i);
        if  i3 > 0,
            BX(i1) = XGAM(i)*parVal(i3);
        else
            BX(i1) = XGAM(i1);
        end
    end
end

% BY bias parameters
if  NDEL > 0,
    for i=1:NDEL,
        i1 = iBY(i);
        i3 = jBY(i);
        if  i3 > 0,
            BY(i1) = YDEL(i)*parVal(i3);
        else
            BY(i1) = YDEL(i1);
        end
    end
end

return