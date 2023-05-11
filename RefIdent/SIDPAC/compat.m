function [y,p,crb,cor,rr] = compat(dsname,p0,u,t,x0,c,z,del,svlim,auto)
%
%  function [y,p,crb,cor,rr] = compat(dsname,p0,u,t,x0,c,z,del,svlim,auto)
%
%  Usage: [y,p,crb,cor,rr] = compat(dsname,p0,u,t,x0,c,z,del,svlim,auto);
%
%  Description:
%
%    Computes the maximum likelihood estimate of parameter vector p,
%    the Cramer-Rao bound matrix crb, the parameter correlation matrix cor,
%    the discrete noise covariance matrix rr, and the model output y using 
%    Modified Newton-Raphson (mnr) optimization.  
%    The dynamic system is specified in the m-file named dsname.  
%    Inputs del, svlim, and auto are optional.  
%
%  Input:
%    
%    dsname = name of the m-file that computes the model outputs.
%        p0 = initial vector of parameter values.
%         u = control vector time history.
%         t = time vector.
%        x0 = state vector initial condition.
%         c = vector of constants passed to dsname.
%         z = measured output vector time history.
%       del = vector of parameter perturbations in fraction of nominal value.
%     svlim = minimum singular value ratio for matrix inversion.
%      auto = flag indicating type of operation:
%             = 1 for automatic  (no user input required).
%             = 0 for manual  (user input required).
%
%  Output:
%
%        y = model output vector time history.
%        p = vector of parameter estimates.
%      crb = matrix of Cramer-Rao lower bounds for the parameters.
%      cor = matrix of parameter correlations based on crb.
%       rr = discrete measurement noise covariance matrix estimate. 
%

%
%    Calls:
%      cvec.m
%      estrr.m
%      mnr.m
%      compcost.m
%      simplex.m
%      misvd.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      8 Dec 1998 - Created and debugged, EAM.
%     28 Oct 2000 - Modified to handle p0 row vector, EAM.
%     29 Oct 2000 - Modified to compute new cost costn 
%                   without re-computing yn, EAM. 
%     22 Nov 2000 - Cleaned up printed output, EAM.
%
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
[fid,message]=fopen('compat.out','w');
if fid < 3
  message,   
  return
end
%
%  Initialization.
%
iter=1;
itercnt=0;
maxitercnt=250;
[npts,no]=size(z);
p0=cvec(p0);
np=length(p0);
if nargin < 10
  auto=1;
end
if nargin < 9
  svlim=eps*npts;
end
if nargin < 8
  del=0.01*ones(np,1);
end
y=eval([dsname,'(p0,u,t,x0,c)']);
rr=estrr(y,z);
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
  [infomat,djdp,cost]=mnr(dsname,p,u,t,x0,c,del,y,z,rr);
  [U,S,V]=svd(infomat);
  fprintf(fid,'\n SINGULAR VALUES: \n');
  svmax=S(1,1);
  for j=1:np,
    fprintf(fid,'     singular value %3.0f = %13.6e \n',j,S(j,j));
    if S(j,j)/svmax < svlim
      S(j,j)=0.0;
      fprintf(fid,' SINGULAR VALUE %3.0f DROPPED \n',j);
      fprintf(1,' SINGULAR VALUE %3.0f DROPPED \n',j);
    else
      S(j,j)=1/S(j,j);
    end
  end
%  crb=inv(infomat);
  crb=V*S*U';
  dp=crb*djdp;
  pn=p+dp;
  [costn,yn]=compcost(dsname,pn,u,t,x0,c,z,rr);
  fprintf(fid,'\n iteration number %4.0f \n',itercnt);
  fprintf(1,'\n iteration number %4.0f \n',itercnt);
  fprintf(fid,'\n   current cost  = %13.6e \n',cost);
  fprintf(1,'\n   current cost  = %13.6e \n',cost);
  fprintf(fid,'   mnr step cost = %13.6e \n',costn);
  fprintf(1,'   mnr step cost = %13.6e \n',costn);
  fprintf(fid,'\n     parameter      update      std. error       djdp    \n');
  fprintf(1,'\n     parameter      update      std. error       djdp    \n');
  fprintf(fid,'     ---------      ------      ----------       ----    \n');
  fprintf(1,'     ---------      ------      ----------       ----    \n');
%
%  Print out the current data for the estimated parameters.  
%  Line up the numbers accounting for any negative signs.  
%
  for j=1:np,
    if p(j) < 0.0
      fprintf(fid,'  %11.4e',p(j));
      fprintf(1,'  %11.4e',p(j));
    else
      fprintf(fid,'   %11.4e',p(j));
      fprintf(1,'   %11.4e',p(j));
    end
    if dp(j) < 0.0
      fprintf(fid,'  %11.4e',dp(j));
      fprintf(1,'  %11.4e',dp(j));
    else
      fprintf(fid,'   %11.4e',dp(j));
      fprintf(1,'   %11.4e',dp(j));
    end
    fprintf(fid,'   %11.4e',sqrt(crb(j,j)));
    fprintf(1,'   %11.4e',sqrt(crb(j,j)));
    if djdp(j) < 0.0
      fprintf(fid,'   %11.4e   \n',djdp(j));
      fprintf(1,'   %11.4e   \n',djdp(j));
    else
      fprintf(fid,'    %11.4e   \n',djdp(j));
      fprintf(1,'    %11.4e   \n',djdp(j));
    end
%    fprintf(fid,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
%                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
%    fprintf(1,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
%                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
  end
  fprintf(fid,'\n');
  fprintf(1,'\n');
%
%  If Modified Newton-Raphson diverges, switch to simplex.
%
  if abs(costn) > 1.01*abs(cost)
    fprintf(fid,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    fprintf(1,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    [costn,yn,pn]=simplex(dsname,p,u,t,x0,c,del,z,rr,fid);
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
    if (krr==no)&(kp==np)&(kslp==np)&(kj==1)
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
      iter=input(' NUMBER OF ADDITIONAL ITERATIONS (0 to quit) ');
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
          rrn=estrr(yn,z);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
%
%  Print out the current data for the estimated noise covariance matrix.  
%  Line up the numbers accounting for any negative signs.  
%
          for j=1:no,
            fprintf(fid,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            fprintf(1,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            if pctrr(j) < 0.0
              fprintf(fid,'   %11.4e   \n', pctrr(j));
              fprintf(1,'   %11.4e   \n', pctrr(j));
            else
              fprintf(fid,'    %11.4e   \n', pctrr(j));
              fprintf(1,'    %11.4e   \n', pctrr(j));
            end
%            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
%            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          fprintf(fid,'\n');
          fprintf(1,'\n');
%
%  Compute the cost for yn and pn.
%
          vv=inv(rr);
          costn=0.0;
          v=z-yn;
%
%  The operator .' means transpose without complex conjugation.
%
          for i=1:npts,
            costn=costn + conj(v(i,:))*vv*v(i,:).';
          end
%
%  Get rid of imaginary round-off error.
%
          costn=0.5*real(costn);
        end
      end
    else
%
%  Automatic operation.
%
      if (kp==np)&(kslp==np)&(kj==1)
        if (krr~=no)
          rrn=estrr(yn,z);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
%
%  Print out the current data for the estimated noise covariance matrix.  
%  Line up the numbers accounting for any negative signs.  
%
          for j=1:no,
            fprintf(fid,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            fprintf(1,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            if pctrr(j) < 0.0
              fprintf(fid,'   %11.4e   \n', pctrr(j));
              fprintf(1,'   %11.4e   \n', pctrr(j));
            else
              fprintf(fid,'    %11.4e   \n', pctrr(j));
              fprintf(1,'    %11.4e   \n', pctrr(j));
            end
%            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
%            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          fprintf(fid,'\n');
          fprintf(1,'\n');
%
%  Compute the cost for yn and pn.
%
          vv=inv(rr);
          costn=0.0;
          v=z-yn;
%
%  The operator .' means transpose without complex conjugation.
%
          for i=1:npts,
            costn=costn + conj(v(i,:))*vv*v(i,:).';
          end
%
%  Get rid of imaginary round-off error.
%
          costn=0.5*real(costn);
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
rr=estrr(y,z);
[infomat,djdp,cost]=mnr(dsname,p,u,t,x0,c,del,y,z,rr);
%crb=inv(infomat);
crb=misvd(infomat);
cor=crb;
for i=1:np,
  cor(:,i)=cor(:,i)/sqrt(crb(i,i));
  cor(i,:)=cor(i,:)/sqrt(crb(i,i));
end
fclose(fid);
return
