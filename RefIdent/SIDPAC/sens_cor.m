function [zcor,ucor,fdatacor] = sens_cor(pc,uc,zc,x0c,cc,fdata)
%
%  function [zcor,ucor,fdatacor] = sens_cor(pc,uc,zc,x0c,cc,fdata)
%
%  Usage: [zcor,ucor,fdatacor] = sens_cor(pc,uc,zc,x0c,cc,fdata);
%
%  Description:
%
%    Applies measured data corrections using the 
%    estimated instrumentation error parameters 
%    from data compatibility analysis.  
%
%  Input:
%
%      pc = vector of estimated instrumentation error parameter values.
%      uc = matrix of column vector inputs = [ax,ay,az,p,q,r].
%     x0c = state vector initial condition for data compatibility analysis.
%      cc = cell structure:
%            cc{1} = p0c = vector of initial parameter values.
%            cc{2} = ipc = index vector to select estimated parameters.
%            cc{3} = ims = index vector to select measured states.
%            cc{4} = imo = index vector to select model outputs.
%      zc = matrix of column vector measured outputs = [vt,beta,alpha,phi,the,psi].
%   fdata = flight test data array in standard configuration.
%
%  Output:
%
%       zcor = corrected matrix of column vector outputs = [vt,beta,alpha,phi,the,psi].
%       ucor = corrected matrix of column vector inputs = [ax,ay,az,p,q,r].
%   fdatacor = corrected flight test data array in standard configuration.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      02 Jan 2001 - Created and debugged, EAM.
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
%  Initialization.
%
zcor=zc;
ucor=uc(:,[1:6]);
fdatacor=fdata;
dtr=pi/180.;
g=32.174;
p0c=cc{1};
ipc=cc{2};
%
%  Assign the estimated parameter vector 
%  elements in p to the proper data compatibility 
%  parameter vector elements in pc.  
%
pcindx=find(ipc==1);
np=length(pcindx);
for j=1:np,
  switch pcindx(j)
%
%  Accelerometer biases.
%
    case 1,
      ucor(:,1)=uc(:,1) + pc(j);
    case 2,
      ucor(:,2)=uc(:,2) + pc(j);
    case 3,
      ucor(:,3)=uc(:,3) + pc(j);
%
%  Rate gyro biases.
%
    case 4,
      ucor(:,4)=uc(:,4) + pc(j);
    case 5,
      ucor(:,5)=uc(:,5) + pc(j);
    case 6,
      ucor(:,6)=uc(:,6) + pc(j);
%
%  Air data scale factors.
%
    case 7,
      vt0=sqrt(x0c(1)*x0c(1) + x0c(2)*x0c(2) + x0c(3)*x0c(3));
      zcor(:,1)=(zc(:,1)-vt0)/(1.0 + pc(j)) + vt0;
    case 8,
      vt0=sqrt(x0c(1)*x0c(1) + x0c(2)*x0c(2) + x0c(3)*x0c(3));
      beta0=asin(x0c(2)/vt0);
      zcor(:,2)=(zc(:,2)-beta0)/(1.0 + pc(j)) + beta0;
    case 9,
      alpha0=atan(x0c(3)/x0c(1));
      zcor(:,3)=(zc(:,3)-alpha0)/(1.0 + pc(j)) + alpha0;
%
%  Euler angle scale factors.
%
    case 10,
      phi0=x0c(4);
      zcor(:,4)=(zc(:,4)-phi0)/(1.0 + pc(j)) + phi0;
    case 11,
      the0=x0c(5);
      zcor(:,5)=(zc(:,5)-the0)/(1.0 + pc(j)) + the0;
    case 12,
      psi0=x0c(6);
      zcor(:,6)=(zc(:,6)-psi0)/(1.0 + pc(j)) + psi0;
  end
end
%
%  Now update the measured flight test data matrix.
%
if nargin > 5
  fdatacor(:,[11:13])=ucor(:,[1:3])/g;
  fdatacor(:,[5:7])=ucor(:,[4:6])/dtr;
  fdatacor(:,2)=zcor(:,1);
  fdatacor(:,[3:4])=zcor(:,[2:3])/dtr;
  fdatacor(:,[8:10])=zcor(:,[4:6])/dtr;
else
  fdatacor=[];
end
return
