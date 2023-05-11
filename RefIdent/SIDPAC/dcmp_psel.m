%
%  script dcmp_psel.m
%
%  Calling GUI: sid_dcmp
%
%  Usage: dcmp_psel;
%
%  Description:
%
%    Initializes and selects the instrumentation 
%    error parameters to be estimated for 
%    data compatibility analysis.  
%
%  Input:
%    
%    None
%
%  Output:
%
%    p0c = initial values for the estimated instrumentation 
%          error parameter vector pc.  
%    ipc = index vector indicating which instrumentation 
%          error parameters are to be estimated.  
%  pclab = labels for the instrumentation error parameters.
%    ims = index vector indicating which states 
%          will use measured values.
%    imo = index vector indicating which model outputs
%          will be calculated.  
%     cc = cell structure:
%          cc{1} = p0c = vector of initial parameter values.
%          cc{2} = ipc = index vector to select estimated parameters.
%          cc{3} = ims = index vector to select measured states.
%          cc{4} = imo = index vector to select model outputs.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Oct 2000 - Created and debugged, EAM.
%
%  Copyright (C) 2000  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%

%
%  Initial values for the estimated parameters.
%
%  p0c = [ax_bias, ay_bias,   az_bias,  
%         p_bias,  q_bias,    r_bias, 
%         vt_scf,  beta_scf,  alpha_scf, 
%         phi_scf, the_scf,   psi_scf]
%
p0c=[0,  0,  0,...
     0,  0,  0,...
     0,  0,  0,...
     0,  0,  0];
%
%
%  ipc element = 1 to estimate the corresponding parameter.
%              = 0 to exclude the corresponding parameter from the estimation.
%
ipc=[1,  0,  1,...
     0,  1,  0,...
     0,  0,  1,...
     0,  1,  0];
%
%  Labels for the instrumentation error parameters.
%
pclab=[' ax bias fps2';...
       ' ay bias fps2';...
       ' az bias fps2';...
       '  p bias rps ';...
       '  q bias rps ';...
       '  r bias rps ';...
       '     vt  scf ';...
       '    beta scf ';...
       '   alpha scf ';...
       '     phi scf ';...
       '     the scf ';...
       '     psi scf '];
%
%
%  ims = 1 to use measured values 
%          for the corresponding state.
%      = 0 to use computed model values 
%          for the corresponding state.  
%
%    x = [u,v,w,phi,the,psi]
%
ims=[0,  1,  0,  1,  0,  1];
%
%
%  imo = 1 to select the corresponding output
%          to be included in the model output.
%      = 0 to omit the corresponding output 
%          from the model output. 
%
%    y = [vt,beta,alpha,phi,the,psi]
%
imo=[1,  0,  1,  0,  1,  0];
%
%
%     cc = cell structure:
%          cc{1} = p0c = vector of initial parameter values.
%          cc{2} = ipc = index vector to select estimated parameters.
%          cc{3} = ims = index vector to select measured states.
%          cc{4} = imo = index vector to select model outputs.
%
cc=cell(4,1);
cc{1}=p0c;
cc{2}=ipc;
cc{3}=ims;
cc{4}=imo;
return
