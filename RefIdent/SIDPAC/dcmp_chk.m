%
%  script dcmp_chk.m
%
%  Calling GUI: sid_dcmp
%
%  Usage: dcmp_chk;
%
%  Description:
%
%    Computes model outputs for data compatibility analysis,
%    according to user input.  
%
%  Input:
%    
%    fdata = matrix of measured flight data in standard configuration.
%        t = time vector, sec.
%       cc = cell structure:
%            cc{1} = p0c = vector of initial parameter values.
%            cc{2} = ipc = index vector to select estimated parameters.
%            cc{3} = ims = index vector to select measured states.
%            cc{4} = imo = index vector to select model outputs.
%
%  Output:
%
%     yc = data compatibility model output vector time history.
%     pc = estimated instrumentation error parameter vector.
%   crbc = estimated parameter covariance matrix.
%    rrc = discrete noise matrix estimate.  
%

%
%    Calls:
%      xsmep.m
%      dcmp_psel.m
%      dcmp.m
%      dcmp_plot.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Oct 2000 - Created and debugged, EAM.
%      28 Oct 2000 - Added general model structure capability, EAM.
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
%  Initialization.
%
dtr=pi/180.;
g=32.174;
[npts,n]=size(fdata);
dt=t(2)-t(1);
%
%  Assemble the input and output data matrices.  
%
zc=[fdata(:,2),fdata(:,3)*dtr,fdata(:,4)*dtr,...
    fdata(:,8)*dtr,fdata(:,9)*dtr,fdata(:,10)*dtr];
ca=cos(fdata(:,4)*dtr);
cb=cos(fdata(:,3)*dtr);
sa=sin(fdata(:,4)*dtr);
sb=sin(fdata(:,3)*dtr);
uc=[fdata(:,11)*g,fdata(:,12)*g,fdata(:,13)*g,...
    fdata(:,5)*dtr,fdata(:,6)*dtr,fdata(:,7)*dtr,...
    fdata(:,2).*ca.*cb,fdata(:,2).*sb,fdata(:,2).*sa.*cb,...
    fdata(:,[8:10])*dtr];
%
%  Find smoothed initial states 
%  from the measurements.  
%
xsc=xsmep(uc(:,[7:12]),2.0,dt);
x0c=xsc(1,:)';
%
%  Initialize the parameter vector and 
%  select the parameters to be estimated.  
%
dcmp_psel;
%
%  Use the estimated parameter vector
%  if it exists.  Otherwise, use the 
%  defined initial values from p0c.  
%
p0c=cc{1};
ipc=cc{2};
ims=cc{3};
imo=cc{4};
pc=p0c(find(ipc==1));
%
%  Compute all data compatibility outputs,
%  but retain information about which 
%  model outputs should be used in the 
%  parameter estimation.  
%
cc{4}=ones(1,6);
yc=dcmp(pc,uc,t,x0c,cc);
cc{4}=imo;
%
%  Plot the results.
%
dcmp_plot;
%
%  Clean up the workspace.
%
clear g dtr n xsc ca cb sa sb;
return
