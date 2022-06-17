function [XS, ZS, SY, SYpred] = deScaleIO(Nu, Ny, XS, ZS, SY, SYpred,...
                                          ScaleFac, SCmin, Smin, iScale);

% De-scale the data
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nu          number of inputs
%    Ny          number of outputs
%    XS          scaled input variables (Ndata,Nu)
%    ZS          scaled measured output variables (Ndata,Ny)
%    SY          computed network outputs (during training cycle)
%    SYpred      computed network outputs (prediction cycle)
%    ScaleFac    scale factors for input and output variables
%    SCmin       lower limit for data scaling
%    Smin        minimum values of the input and output variables
%    iScale      integer flag to choose invoke data scaling (> 0: data scaling)
%
% Outputs:
%    XS          de-scaled input variables (Ndata,Nu)
%    ZS          de-scaled measured output variables (Ndata,Ny)
%    SY          de-scaled network outputs (training cycle)
%    SYpred      de-scaled network outputs (prediction cycle)


if iScale > 0,
    
    % De-scale the inputs
    for i1=1:Nu,
        XS(:,i1) = Smin(i1) + (XS(:,i1)-SCmin) / ScaleFac(i1) ;
    end
    
    % De-scale output variables (from training and prediction cycles)
    for i1=1:Ny,
        ZS(:,i1)     = Smin(i1+Nu) + (ZS(:,i1)-SCmin) / ScaleFac(i1+Nu);
        SY(:,i1)     = Smin(i1+Nu) + (SY(:,i1)-SCmin) / ScaleFac(i1+Nu);
        SYpred(:,i1) = Smin(i1+Nu) + (SYpred(:,i1)-SCmin) / ScaleFac(i1+Nu);
    end
        
end

return
% end of function