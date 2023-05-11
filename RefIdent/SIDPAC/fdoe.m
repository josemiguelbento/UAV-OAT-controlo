function [Y,p,crb,svv] = fdoe(dsname,p0,U,t,w,c,Z,auto,C0,del,svlim)
%
%  function [Y,p,crb,svv] = fdoe(dsname,p0,U,t,w,c,Z,auto,C0,del,svlim)
%
%  Usage: [Y,p,crb,svv] = fdoe(dsname,p0,U,t,w,c,Z,auto,C0,del,svlim);
%
%  Description:
%
%    Computes the maximum likelihood estimate of parameter vector p,
%    the Cramer-Rao bound matrix crb, the power spectral density of
%    the measuement noise svv, and the model output Y in the frequency
%    domain using Modified Newton-Raphson optimization.  
%    This routine implements the output error formulation 
%    in the frequency domain for linear system parameter estimation.  
%    The dynamic system is specified in the m-file named dsname.  
%    Inputs auto, C0, del, and svlim are optional.  
%
%  Input:
%    
%    dsname = name of the m-file that computes the model outputs.
%        p0 = initial vector of parameter values.
%         U = control vector in the frequency domain.
%         t = time vector, sec.
%         w = frequency vector, rad/sec.
%         c = vector of constants passed to dsname.
%         Z = measured output vector in the frequency domain.
%      auto = flag indicating type of operation:
%             = 1 for automatic  (no user input required).
%             = 0 for manual  (user input required).
%        C0 = inverse parameter covariance matrix for p0.
%       del = vector of parameter perturbations in fraction of nominal value.
%     svlim = minimum singular value ratio for matrix inversion.
%
%  Output:
%
%          Y = model output vector in the frequency domain. 
%          p = vector of parameter estimates.
%        crb = matrix of Cramer-Rao lower bounds for the parameters.
%        svv = power spectral density of the measurement noise.
%

%
%    Calls:
%      estsvv.m
%      mnr.m
%      compcost.m
%      simplex.m
%      misvd.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 May 1999 - Created and debugged, EAM.
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
[fid,message]=fopen('fdoe.out','w');
if fid < 3
  message,   
  return
end
%
%  Initialization.
%
iter=1;
itercnt=0;
maxitercnt=500;
%
%  Switch to the same notation used for the time domain 
%  maximum likelihood estimation code.  Variable x0 is a dummy.
%
u=U;
z=Z;
x0=0;
dt=t(2)-t(1);
[npts,no]=size(z);
np=length(p0);
if nargin < 11
  svlim=eps*npts;
end
if nargin < 10
  del=0.01*ones(np,1);
end
if nargin < 9
  C0=zeros(np,np);
end
if nargin < 8
  auto=1;
end
y=eval([dsname,'(p0,u,w,x0,c)']);
rr=estsvv(y,z,t);
pctrr=100*ones(no,1);
p=p0;
%
%  Optimization loop.
%
while (iter > 0)&(itercnt < maxitercnt),
  iter=iter - 1;
%
%  Modified Newton-Raphson.
%
  [infomat,djdp,cost]=mnr(dsname,p,u,w,x0,c,del,y,z,rr);
  infomat=npts*dt*infomat;
  infomat=infomat+C0;
  djdp=djdp-C0*(p-p0);
  [Usvd,Ssvd,Vsvd]=svd(infomat);
  fprintf(fid,'\n SINGULAR VALUES: \n');
  svmax=Ssvd(1,1);
  for j=1:np,
    fprintf(fid,'     singular value %3.0f = %13.6e \n',j,Ssvd(j,j));
    if Ssvd(j,j)/svmax < svlim
      Ssvd(j,j)=0.0;
      fprintf(fid,' SINGULAR VALUE %3.0f DROPPED \n',j);
      fprintf(1,' SINGULAR VALUE %3.0f DROPPED \n',j);
    else
      Ssvd(j,j)=1/Ssvd(j,j);
    end
  end
%  crb=inv(infomat);
  crb=Vsvd*Ssvd*Usvd';
  dp=crb*djdp;
  pn=p+dp;
  [costn,yn]=compcost(dsname,pn,u,w,x0,c,z,rr);
  fprintf(fid,'\n iteration number %4.0f \n',itercnt);
  fprintf(1,'\n iteration number %4.0f \n',itercnt);
  fprintf(fid,'\n\n   current cost  = %13.6e \n',cost);
  fprintf(1,'\n\n   current cost  = %13.6e \n',cost);
  fprintf(fid,'   mnr step cost = %13.6e \n',costn);
  fprintf(1,'   mnr step cost = %13.6e \n',costn);
  fprintf(fid,'\n     parameter      update      std. error       djdp    \n');
  fprintf(1,'\n     parameter      update      std. error       djdp    \n');
  fprintf(fid,'     ---------      ------      ----------       ----    \n');
  fprintf(1,'     ---------      ------      ----------       ----    \n');
  for j=1:np,
    fprintf(fid,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
    fprintf(1,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
  end
%
%  If Modified Newton-Raphson diverges, switch to simplex.
%
  if abs(costn) > 1.01*abs(cost)
    fprintf(fid,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    fprintf(1,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    [costn,yn,pn]=simplex(dsname,p,u,w,x0,c,del,z,rr,fid);
  end
%
%  Check convergence criteria at decision point (iter=0).
%
  if iter <= 0
%
%  Discrete noise covariance matrix estimate.
%
    krr=0;
    for j=1:no,
      if abs(pctrr(j))<=5.0
        krr=krr + 1;
      end
    end
%
%  Parameter estimates and cost gradient.
%
    kp=0;
    kslp=0;
    for j=1:np,
      if abs(dp(j)) < 0.0001
        kp=kp + 1;
      end
      if abs(djdp(j)) < 0.05
        kslp=kslp + 1;
      end
    end
%
%  Cost.
%
    kj=0;
    if abs((costn-cost)/cost) < 0.001
      kj=1;
    end
    if (krr==no)&((kp==np)|(kslp==np))&(kj==1)
      fprintf(fid,'\n\n CONVERGENCE CRITERIA SATISFIED \n');
      fprintf(1,'\n\n CONVERGENCE CRITERIA SATISFIED \n');
    end
%
%  Manual operation.
%
    if auto~=1
%
%  Prompt user for more parameter estimation iterations.
%
      iter=input('\n NUMBER OF ADDITIONAL ITERATIONS (0 to quit) ');
      iter=round(iter);
      if iter > 1000
        iter=1000;
      end
%
%  Prompt user for a dicrete noise covariance matrix estimation.
%
      if iter > 0
        ans=input(' UPDATE THE RR MATRIX ?  (y/n) ','s');
        if (ans=='y')|(ans=='Y')
          rrn=estsvv(yn,z,t);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
          for j=1:no,
            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          [costn,yn]=compcost(dsname,pn,u,w,x0,c,z,rr);
        end
      end
    else
%
%  Automatic operation.
%
      if ((kp==np)|(kslp==np))&(kj==1)
        if (krr~=no)
          rrn=estsvv(yn,z,t);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
          for j=1:no,
            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          [costn,yn]=compcost(dsname,pn,u,w,x0,c,z,rr);
          iter=5;
        else
          iter=0;
        end
      else
        iter=2;
      end
    end
  end
  y=yn;
  p=pn;
  cost=costn;
  itercnt=itercnt + 1;
end
rr=estsvv(y,z,t);
[infomat,djdp,cost]=mnr(dsname,p,u,w,x0,c,del,y,z,rr);
infomat=npts*dt*infomat;
infomat=infomat+C0;
djdp=djdp-C0*(p-p0);
Y=y;
%crb=inv(infomat);
crb=misvd(infomat);
svv=rr;
fclose(fid);
return
