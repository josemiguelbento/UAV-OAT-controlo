function [Amat, Bmat, Cmat, Dmat, Fmat, BX, BY, parVal, Nparam] = mod_sysmat(param, Anames,...
                                                                  Bnames, Cnames, Dnames, Fnames,...
                                                                  BXnames, BYnames);
                                                 
% Build up system matrices A, B, C, D, and bias vectors BX, BY from the model
% defined in mDefCasexx.m at the start
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
%     param         information related to parameters appearing in the system
%                   matrices A, B, C, D and of the bias parameters BX and BY.
%                   param.names:   Alphanumerical names of all the parameters 
%                   param.values:  Numerical values of all the parameters
%                   param.flags:   Integer flag to keep parameters fixed or free:
%                    = 0 -> fixed; = 1 -> free (to be estimated)
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
%    parVal        parameter vector (unknown parameters to be estimated)
%    Nparam        number of unknown parameters to be estimated


%--------------------------------------------------------------------------------------
global NA  iA  kA  jA  Abet  NB  iB  kB  jB  Bbet
global NC  iC  kC  jC  Cbet  ND  iD  kD  jD  Dbet
global NF  iF  kF  jF  Fbet
global NALF  NBET  iP  NK  NFVAR
global NBX  iBX  jBX  XGAM  NGAM
global NBY  iBY  jBY  YDEL  NDEL

parVal = param.values;

% Check whether the specified parameter names are unique (repeated names not permitted):
Nnames = size(param.names);
iError = 0;
for i=1:Nnames-1,
    for j=i+1:Nnames,
        iError = strcmp(param.names(i),param.names(j));
        if  iError ~= 0,
            disp ('Error termination:')
            disp ('Parameter names are not unique; repetition is not permitted')
            str1 = param.names(i)
            %par_prnt = sprintf (' %s', str1)
            %error (sprintf('%s is not a valid value for System)', str1) );
            par_prnt = sprintf ('Parameters %i and %i have same names', i,j);
            disp(par_prnt)
            Error
        end
    end
end

% Get the numbers of rows and columns of A, B, C, D, F matrices
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

% Build up the matrices, by checking the Anames specified with those from
% param.names: iA, kA, contain respectively the indices of the rows and
% columns; jA the index of the parameter and Abet the gradient of the
% respective parameter (it is unity). Do this for all matrices.

% A-matrix
iP = 0;
NA = 0;
for i=1:irA,
    for k=1:jcA,
        for j=1:Nnames,
            iStr = strcmp( Anames(i,k), param.names(j) );
            if  iStr == 1,
                NA = NA + 1;
                iP = iP + 1;
                iA(NA) = i;
                kA(NA) = k;
                jA(NA) = j;
                Abet(NA)  = 1;
                Amat(i,k) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            Amat(i,k) = Anames{i,k};
            if  Amat(i,k) ~= 0, 
                NA = NA + 1; 
                iA(NA) = i;
                kA(NA) = k;
                jA(NA) = -1;                     % Non zero element, but fixed
                Abet(NA) = 1;
            end 
        end
    end
end
% NK: number of parameters affecting the gain matrix K (A, C and F matrices)
NK = NA;

% B-matrix
NB = 0;
for i=1:irB,
    for k=1:jcB,
        for j=1:Nnames,
            iStr = strcmp( Bnames(i,k), param.names(j) );
            if  iStr == 1,
                NB = NB + 1;
                iP = iP + 1;
                iB(NB) = i;
                kB(NB) = k;
                jB(NB) = j;
                Bbet(NB)  = 1;
                Bmat(i,k) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            Bmat(i,k) = Bnames{i,k};
            if  Bmat(i,k) ~= 0, 
                NB = NB + 1; 
                iB(NB) = i;
                kB(NB) = k;
                jB(NB) = -1;                     % Non zero element, but fixed
                Bbet(NB) = 1;
            end 
        end
    end
end


% C-matrix
NC = 0;
for i=1:irC,
    for k=1:jcC,
        for j=1:Nnames,
            iStr = strcmp( Cnames(i,k), param.names(j) );
            if  iStr == 1,
                NC = NC + 1;
                iC(NC) = i;
                kC(NC) = k;
                jC(NC) = j;
                Cbet(NC)  = 1;
                Cmat(i,k) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            Cmat(i,k) = Cnames{i,k};
            if  Cmat(i,k) ~= 0, 
                NC = NC + 1; 
                iC(NC) = i;
                kC(NC) = k;
                jC(NC)  = -1;                     % Non zero element, but fixed
                Cbet(NC) = 1;
            end 
        end
    end
end



% To find actual number of unknowns, check whether the names in C appear in A as well:
for i=1:NC,
    if  jC(i) > 0,
        for i1=1:irA
            for k1=1:jcA
                iStr = strcmp( param.names(jC(i)), Anames(i1,k1) );
                if iStr == 1, break, end
            end
            if iStr == 1, break, end
        end
        if  iStr ~= 1,
            iP = iP + 1;
            NK = NK + 1;
        end
    end
end


% D-matrix
ND = 0;
for i=1:irD,
    for k=1:jcD,
        for j=1:Nnames,
            iStr = strcmp( Dnames(i,k), param.names(j) );
            if  iStr == 1,
                ND = ND + 1;
                %iP=iP+1;
                iD(ND) = i;
                kD(ND) = k;
                jD(ND) = j;
                Dbet(ND)  = 1;
                Dmat(i,k) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            Dmat(i,k) = Dnames{i,k};
            if  Dmat(i,k) ~= 0, 
                ND = ND + 1; 
                iD(ND) = i;
                kD(ND) = k;
                jD(ND) = -1;                     % Non zero element, but fixed
                Dbet(ND) = 1;
            end 
        end
    end
end

% To find actual number of unknowns, check whether the names in D appear in B as well:
for i=1:ND
    for i1=1:irB
        for k1=1:jcB
            iStr = strcmp( param.names(jD(i)), Bnames(i1,k1) );
            if iStr == 1, break, end
        end
            if iStr == 1, break, end
    end
    if  iStr ~= 1,
        iP = iP + 1;
    end
end


% F-matrix
NF = 0;
for i=1:irF,
    for k=1:jcF,
        for j=1:Nnames,
            iStr = strcmp( Fnames(i,k), param.names(j) );
            if  iStr == 1,
                NF = NF + 1;
                iP = iP + 1;
                NK = NK + 1;
                iF(NF) = i;
                kF(NF) = k;
                jF(NF) = j;
                Fbet(NF)  = 1;
                Fmat(i,k) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            Fmat(i,k) = Fnames{i,k};
            if  Fmat(i,k) ~= 0,
                disp (' ')
                disp ('Error in specification of F-matrix.')
                disp ('Off-diagonal elements are non-zero.')
                disp ('The program assumes diagonal F.')
            end
        end
    end
end

% NALF: number of parameters in the state equations (those from A, B and F)
% NBET: total number of parameters
NALF  = NA + NB + NF;
NBET  = iP;
NFVAR = NF;

%BX = param.values(iP+1:iP+irA);
% BX-parameters (Bias parameters of the state equations)
NBX  = 0;
NGAM = 0;
for i=1:irBX,
        for j=1:Nnames,
            iStr = strcmp( BXnames(i), param.names(j) );
            if  iStr == 1,
                NBX = NBX + 1;
                iBX(NBX)  = i;
                jBX(NBX)  = j;
                XGAM(NBX) = 1;
                BX(NBX) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            BX(i) = BXnames{i};
        end
end
NGAM = NBX;

%BY = param.values(iP+irA+1:end);
% BY-parameters (Bias parameters of the observation equations)
NBY  = 0;
NDEL = 0;
for i=1:irBY,
        for j=1:Nnames,
            iStr = strcmp( BYnames(i), param.names(j) );
            if  iStr == 1,
                NBY = NBY + 1;
                iBY(NBY)  = i;
                jBY(NBY)  = j;
                YDEL(NBY) = 1;
                BY(NBY) = param.values(j);
                break
            end
        end
        if  iStr == 0,
            BY(i) = BYnames{i};
        end
end
NDEL = NBY;

% Total number of parameters
Nparam = NBET + NGAM + NDEL;           % Total number of parameters to be estimated

return