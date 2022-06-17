function [XS, ZS, ScaleFac, Smin] = scaleIO(Nu, Ny, X, Z, SCmin, SCmax, iScale);

% Scale the data
% Scaling is optional, and will be performed when the flag iScale is nonzero.
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
%    X           array of measured input variables (Ndata,Nu)
%    Z           array of measured output variables (Ndata,Ny)
%    SCmin       lower limit for data scaling
%    SCmax       upper limit for data scaling
%    iScale      integer flag to choose invoke data scaling (> 0: data scaling)
%
% Outputs:
%    XS          scaled input variables (Ndata,Nu)
%    ZS          scaled measured output variables (Ndata,Ny)
%    ScaleFac    scale factors for input and output variables
%    Smin        minimum values of the input and output variables


if iScale > 0,
    
    % Determine the maximum and minimum 
    Smin = min([X Z]);
    Smax = max([X Z]);

    % Scale factors
    ScaleFac = (SCmax-SCmin)./(Smax-Smin);
        
    % Scale the input and output variables
    for i1=1:Nu,
        XS(:,i1) = SCmin + (X(:,i1)-Smin(i1)) * ScaleFac(i1);
    end
    for i1=1:Ny,
        ZS(:,i1) = SCmin + (Z(:,i1)-Smin(i1+Nu)) * ScaleFac(i1+Nu);
    end
    
else 
    
    XS = X;
    ZS = Z;
    Smin = 0;
    ScaleFac = 1;
    
end

return
% end of function