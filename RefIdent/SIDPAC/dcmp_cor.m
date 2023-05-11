%
%  script dcmp_cor.m
%
%  Calling GUI: sid_dcmp
%
%  Usage: dcmp_cor;
%
%  Description:
%
%    Implements systematic instrumentation error 
%    corrections using the results of data 
%    compatibility analysis.  
%
%  Input:
%    
%    None
%
%  Output:
%
%    fdata = p0c = initial values for the estimated instrumentation 
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
%      sens_cor.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      03 Feb 2001 - Created and debugged, EAM.
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%

%
%  Only implement the corrections if the 
%  instrumentation error parameters have been
%  defined or estimated.  
%
if exist('pc','var')
  fdatao = fdata;
  [zcor,ucor,fdata] = sens_cor(pc,uc,zc,x0c,cc,fdata);
  fprintf('\n\n Corrections complete \n\n')
  fprintf('\n Original data in fdatao \n')
  fprintf('\n Corrected data in fdata \n\n')
end
return
