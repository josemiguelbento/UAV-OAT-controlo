function [y,p,crb,s2,xm,pindx] = swr(x,z,lplt,svlim)
%
%  function [y,p,crb,s2,xm,pindx] = swr(x,z,lplt,svlim)
%
%  Usage: [y,p,crb,s2,xm,pindx] = swr(x,z,lplt,svlim);
%
%  Description:
%
%    Computes interactive stepwise regression estimate 
%    of parameter vector p, the estimated parameter covariance 
%    matrix crb, the model output y, the model error variance 
%    estimate s2, and the model regressor matrix xm, using 
%    least squares with singular value decomposition inversion 
%    of the information matrix.  The output y is 
%    computed from y=xm*p(pindx).  A constant term 
%    is included in the model automatically in the last 
%    position of the model regressor matrix xm and the 
%    corresponding positions in the output parameter estimate 
%    vector p and covariance matrix crb.  This routine works 
%    for real or complex data.  Input svlim is optional.
%
%  Input:
%
%      x = matrix of column regressors.
%      z = measured output vector.
%   lplt = plot flag (optional):
%          = 0 for no plots (default)
%          = 1 for plots
%  svlim = minimum singular value ratio 
%          for matrix inversion (optional).
%
%  Output:
%
%      y = model output vector.
%      p = vector of parameter estimates.
%    crb = covariance matrix for the parameter estimates.
%     s2 = model error variance estimate.
%     xm = matrix of column regressors retained in the model.  
%  pindx = vector of parameter vector indices for retained regressors.
%

%
%    Calls:
%      corrcoeff.m
%      corlm.m
%      lesq.m
%      regsel.m
%      pfstat.m
%      press.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 July 1996 - Created and debugged, EAM.
%      08 Sept 2000 - Added plot option and pindx, EAM.
%      09 May  2001 - Modified plotting for complex numbers, EAM.
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
[npts,np]=size(x);
if nargin<4
  svlim=eps*npts;
end
if nargin<3
  lplt=0;
end
z=z(:,1);
z_rms=rms(z);
t=[1:1:npts]';
%
%  Initialization.
%
%  R squared quantities.
%
zbar=mean(z);
R2den=z'*z - npts*zbar*zbar;
R2=0.0;
%
%  Open the output file.
%
[fid,message]=fopen('swr.out','w');
if fid < 3
  message,
  return
end
%
%  F statistic value to retain a single regressor 
%  with 95 percent confidence, including a safety factor of 5.
%
%[Fm,Fv]=fstat(1,npts-2);
%Fval=5*(Fm+2*sqrt(Fv));
%
%  Conservative constant value.
%
Fval=5*4;
%
%  Parameter estimates and associated quantities.
%
y=zbar*ones(npts,1);
p=zeros(np+1,1);
p(np+1)=zbar;
crb=cov(z);
s2=R2den/(npts-1);
xm=ones(npts,1);
plst=zeros(np+1,1);
dp=zeros(np+1,1);
%
%  Compute the partial correlation coefficients (parc) with z 
%  for all regressors in x.  Initialize all partial F ratios 
%  (parf) to zero.  
%
corlm=corrcoef([x,z]);
parc=corlm([1:np],np+1);
parf=zeros(np,1);
%
%  Prediction error quantities.
%
sig2max=s2/2.0;
pse=(z-y)'*(z-y)/npts + 2.0*sig2max/npts;
P=press(xm,y,z);
%
%  Regressor selection quantities.
%
parin=zeros(np,1);
nsp=1;
nr=0;
%
%  Stepwise regression loop starts here.
%
while nsp~=0 
  plst=p;
%
%  Plot the current modeling results.
%
  if lplt==1
    if isreal(z)
      subplot(2,1,1),plot(t,[z,y],'LineWidth',2),
    else
      subplot(2,1,1),plot(t,abs([z,y]),'LineWidth',2),
    end
    title('Plots for Stepwise Regression Modeling'),
    grid on,legend('data ','model',0),
    if isreal(z)
      subplot(2,1,2),plot(t,z-y,'LineWidth',2),
    else
      subplot(2,1,2),plot(t,abs(z-y),'LineWidth',2),
    end
    ylabel('Residual, z - y'),xlabel('index'),
    grid on,
  end
%
%  Screen output.
%
  fprintf(1,'\n                                                     Squared ');
  fprintf(1,'\n       Parameters                      F ratio      Part. Corr. \n');
  fprintf(1,'\n No.    Estimate        Change           In            Out    \n');
  fprintf(1,' ---    --------        ------           --            ---   \n');
  fprintf(fid,'\n                                                     Squared ');
  fprintf(fid,'\n       Parameters                      F ratio      Part. Corr. \n');
  fprintf(fid,'\n No.    Estimate        Change           In            Out    \n');
  fprintf(fid,' ---    --------        ------           --            ---   \n');
  for j=1:np,
%  Regressor number.
    fprintf(1,'%3.0f',j);
    fprintf(fid,'%3.0f',j);
%  Parameter estimate.
    if p(j)<0
      fprintf(1,'  %11.4e',p(j));
      fprintf(fid,'  %11.4e',p(j));
    else
      fprintf(1,'   %11.4e',p(j));
      fprintf(fid,'   %11.4e',p(j));
    end
%  Parameter estimate change.
    if dp(j)<0
      fprintf(1,'   %11.4e',dp(j));
      fprintf(fid,'   %11.4e',dp(j));
    else
      fprintf(1,'    %11.4e',dp(j));
      fprintf(fid,'    %11.4e',dp(j));
    end
%  Partial F ratios and partial correlation coefficients.
    if parin(j)~=0
      fprintf(1,'    %11.4e     %8.5f \n',parf(j),0.0);
      fprintf(fid,'    %11.4e     %8.5f \n',parf(j),0.0);
    else
      fprintf(1,'    %11.4e     %8.5f \n',0.0,parc(j)*parc(j));
      fprintf(fid,'    %11.4e     %8.5f \n',0.0,parc(j)*parc(j));
    end
  end
  fprintf(1,'\n   constant term  = %11.4e     F cut-off value = %6.2f \n',...
          p(np+1),Fval);
  fprintf(1,'\n\n   dependent variable rms value = %12.4e \n',z_rms);
  fprintf(1,'\n   fit error  = %13.6e  or %6.2f percent',...
          sqrt(s2),100*sqrt(s2)/rms(z));
  fprintf(1,'\n\n   R squared  = %6.2f %%        PRESS =  %9.4e',R2,P);   
  fprintf(1,'\n                                  PSE =  %9.4e',pse);
  fprintf(fid,'\n   constant term  = %11.4e     F cut-off value = %6.2f \n',...
          p(np+1),Fval);
  fprintf(fid,'\n\n   dependent variable rms value = %12.4e \n',z_rms);
  fprintf(fid,'\n   fit error  = %13.6e  or %6.2f percent',...
          sqrt(s2),100*sqrt(s2)/rms(z));
  fprintf(fid,'\n\n   R squared  = %6.2f %%        PRESS =  %9.4e',R2,P);   
  fprintf(fid,'\n                                  PSE =  %9.4e',pse);
%
%  Prompt user for more stepwise regression iterations.
%
  nsp=input('\n\n   NUMBER OF REGRESSOR TO MOVE (0 to quit) ');
%
%  Assemble the new regressor matrix.
%
  if isempty(nsp)
    nsp=0;
  else
    nsp=round(nsp);
    nsp=min(np,max(0,nsp));
  end
  fprintf(fid,'\n\n   SELECTED REGRESSOR TO MOVE = %3i',nsp);
%
%  Do calculations unless quit command was given.
%
  if nsp > 0
%
%  Selected regressor not in the current model -> put it in.
%
%    parin(x matrix regressor number) = 1 to include this regressor
%                                     = 0 to exclude this regressor
%
    if parin(nsp)==0
      parin(nsp)=1;
      nr=nr+1;
    else
%
%  Selected regressor in the current model -> take it out.
%
      parin(nsp)=0;
      nr=nr-1;
    end
  end
%
%  Assemble the regressor matrix when number of the regressors
%  in the model is positive.  The parin vector selects the 
%  regressors from the x matrix for inclusion in the current model.
%
%    parin(x matrix regressor number) = 1 to include this regressor
%                                     = 0 to exclude this regressor
%
  if nr > 0
    xm=ones(npts,1);
    for j=1:np,
      if parin(j)==1
        xm=[xm,x(:,j)];
      end
    end
%
%  Re-arrange the regressors so that the constant term is last.
%
    [npts,nm]=size(xm);
    xm=[xm(:,[2:nm]),xm(:,1)];
%
%  Least squares parameter estimation.
%
    [y,pm,crb,s2]=lesq(xm,z);
%
%  Parameter vector update.  Parameter vector length is np+1
%  to accomodate the constant term in the model equation. 
%  Compute partial F ratios for all regressors retained in the model.
%
    p=zeros(np+1,1);
%
%  Record the estimated parameter for the constant term 
%  in the model equation.
%
    p(np+1)=pm(nm);
%
%  Reset the partial F ratios and the partial correlations.
%
    parf=zeros(np,1);
    parc=zeros(np,1);
%
%  Condition the measured output on the model regressors.
%
    z1=lesq(xm,z);
    zc=z-z1;
    j=1;
    for i=1:np,
      if parin(i)~=0
%
%  Regressor is retained in the model -> compute partial F ratios.
%
        p(i)=pm(j);
        [xr,xj]=regsel(xm,j);
        parf(i)=pfstat(xr,xj,z);
        j=j+1;
      else
%
%  Regressor is omitted from the model -> compute partial correlation.
%
        x1=lesq(xm,x(:,i));
        xc=x(:,i)-x1;
        corlm=corrcoef([xc,zc]);
        parc(i)=corlm(1,2);
      end
    end
    R2=100*(pm'*xm'*z - npts*zbar*zbar)/R2den;
    pse=(z-y)'*(z-y)/npts + 2.0*sig2max*(nr+1)/npts;
    P=press(xm,y,z);
  else
%
%  No regressors in the model.
%
    y=zbar*ones(npts,1);
    p=zeros(np+1,1);
    p(np+1)=zbar;
    crb=cov(z);
    s2=R2den/(npts-1);
    xm=ones(npts,1);
    R2=0.0;
%
%  Compute the partial correlation coefficient with z 
%  for all regressors in x.
%
    corlm=corrcoef([x,z]);
    parc=corlm([1:np],np+1);
    parf=zeros(np,1);
%
%  Compute prediction error quantities.
%
    pse=(z-y)'*(z-y)/npts + 2.0*sig2max/npts;
    P=press(xm,y,z);
  end
%
%  Update the parameter change vector.
%
  dp=p-plst;
end
%
%  Find the indices of the selected parameters, 
%  and add the constant term.  
%
pindx=find(parin==1);
pindx=[pindx;np+1];
fclose(fid);
return
