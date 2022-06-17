function [tFTR, sxftr, sxftrstd] = ftr_mod(Z, Unip, dt, Uprate, OmegaHz,...
                                           Ny, Nu, Nx, Ndata);

% Frequency Transform Regression (FTR) function for parameter estimation
%
% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Z             measured outputs (Ndata,Ny)
%    Uinp          measured inputs (Ndata,Nu) 
%    dt            sampling time
%    Uprate        update rate for FFT
%    OmegaHz       range of frequency in Hz
%    Ny            number of output variables
%    Nu            number of input variables
%    Nx            number of state variables
%    Ndata         number of data points
%
% Outputs:
%    tFTR          time 
%    sxftr         time histories of estimated parameters
%    sxftrstd      standard deviations of estimated parameters


%--------------------------------------------------------------------------
% Initialization
npar = Nx + Nu;  
ns   = Uprate/dt;                     
    
% Remove the trim values (average of first 10 points) from measured x and u
for iy=1:Ny,                           % NX = Ny assumed here!!!!
    x(:,iy) = Z(:,iy) - mean(Z(1:10,iy));
end
for iu=1:Nu,
    u(:,iu) = Unip(:,iu) - mean(Unip(1:10,iu));
end
    
% frequency vector Omega in rad/s
w  = OmegaHz * 2*pi;                    %  Hz to rad/s
nw = length(w);

% initialize discrete Fourier transforms of x and u:
X_w  = zeros(nw,Nx);
U_w  = zeros(nw,Nu);

% compute constant factor
fact = exp(-j*w*dt*Uprate); 
eexp = ones(size(fact));
step = 0;

% --- Recursive FTR -----------------------------------------------------------
% loop over time interval
for it=2:Uprate:Ndata

    % Recursive update of discrete Fourier transform
    eexp = eexp.*fact;
    X_w = X_w + (ones(nw,1)*x(it,:)) .* (eexp*ones(1,Nx));
    U_w = U_w + (ones(nw,1)*u(it,:)) .* (eexp*ones(1,Nu));

    % --- Equation Error PID
    if rem(it,ns) == 0                    % do only every 1 second
        step = step + 1;

        YY = j*w*ones(1,Nx).*X_w;
        XX = [X_w U_w];

        % estimate the parameters by least squares method:
        InvXTX = inv(real(XX'*XX));
        param  = InvXTX * real(XX'*YY);
      
        % estimate equation error variance
        eq_err = YY - XX*param;
        sigma2 = real(diag( eq_err' * eq_err )).' / (nw-npar);
        % estimate parameter covariance matrix
        for k=1:length(sigma2),
            cov_par = sigma2(k) * InvXTX;
            std_err(:,k,step) = sqrt(diag(cov_par));         
        end

        % Save t, estimates and their standard deviations for plotting
        tFTR(step)      = step;
        sxftr(step,:)   = [param(:,1)' param(:,2)'];
        sxftrstd(step,:)= [std_err(:,1,step)' std_err(:,2,step)'];
        
    end
   
end

return
% end of the function
