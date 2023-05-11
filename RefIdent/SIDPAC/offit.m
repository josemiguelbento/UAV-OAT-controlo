function [y,ap,iap,s2ap,pse,xp,a,ia,psi] = offit(x,z,nord,maxord,sig2,auto,lplot,ivar)
%
%  function [y,ap,iap,s2ap,pse,xp,a,ia,psi] = offit(x,z,nord,maxord,sig2,auto,lplot,ivar)
%
%  Usage: [y,ap,iap,s2ap,pse,xp,a,ia,psi] = offit(x,z,nord,maxord,sig2,auto,lplot,ivar);
%
%  Description:
%
%    Identifies polynomial models from measured input-output data 
%    using multivariate orthogonal functions.
%
%    Reference:  Morelli, E.A., "Global Nonlinear Aerodynamic Modeling
%                using Mulitvariate Orthogonal Functions",  
%                J. of Aircraft, Vol. 32, No. 2, March-April 1995, pp. 270-7.
%
%  Input:
%
%       x = matrix of independent variable vectors.
%       z = dependent variable vector.
%    nord = vector of maximum independent variable orders.
%  maxord = maximum order of each model term.
%    sig2 = dependent variable noise variance (optional)
%           =  0 or omit this input for the default value.
%           = -1 to use a linear model fit to estimate sig2.
%           =  a positive, independently-estimated noise variance.
%    auto = flag indicating type of operation (optional):
%           = 1 for automatic  (no user input required).
%           = 0 for manual  (user input required, default).
%   lplot = flag for model structure metric plots (optional):
%           = 1 for plots.
%           = 0 to skip the plots (default). 
%    ivar = x array column number of the independent variable
%           to be used for the orthogonal function generation seed (optional)
%           (use zero or omit this input for a constant function seed). 
%
%  Output:
%
%     y = dependent variable vector computed from the identified model.
%    ap = parameter vector for ordinary polynomial function expansion.
%   iap = vector of integer indices for ordinary polynomial functions.
%  s2ap = variances of the estimated parameters in the ap vector.
%   pse = predicted squared error.  
%    xp = matrix of vector polynomial functions. 
%     a = parameter vector for the orthogonal function expansion.
%    ia = vector of integer indices for the orthogonal functions.
%   psi = matrix of vector orthogonal functions. 
%

%
%    Calls:
%      sclx.m
%      lesq.m
%      ordchk.m
%      repchk.m
%      rms.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      10 Dec  1992 - Created and debugged, EAM.
%      15 Sept 2000 - Upgraded printed output, added automatic mode, EAM.
%      21 Nov  2000 - Added optional sig2 input, EAM.
%      27 Dec  2000 - Added plot option, EAM.
%      29 Dec  2000 - Added internal x scaling, EAM.
%      22 Apr  2001 - Made sig2 options available from the command line, EAM.
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
if nargin < 8,
  ivar=0;
end
if nargin < 7,
  lplot=0;
end
if nargin < 6,
  auto=0;
end
if nargin < 5 
  sig2=0;
else
  if isempty(sig2)
    sig2=0;
  end
end
max_order=8;
max_ofcns=200;
rmsd=1.0e+08;
z=z(:,1);
[npts,nvar]=size(x);
%
%  Scale the independent variables to prevent
%  numerical problems with the decomposition
%  of orthogonal functions into ordinary polynomial functions.
%
[xs,xsf]=sclx(x);
%
%  svlim = minimum singular value ratio for matrix inversion.
%  ztol = maximum absolute value considered different from zero.
%  pfztol = maximum absolute value for retaining polynomial function
%           components for each orthogonal function expansion.  
%
svlim=eps*npts;
ztol=1.0e-06;
pfztol=1.0e-08;
%
%  Open the output file.
%
[fid,message]=fopen('offit.out','w');
if fid < 3
  message,
  return
end
%
%  Check input variables nord and maxord.
%
if length(nord) ~= nvar
  fprintf(1,'\n  Incorrect length for input vector nord \n\n');
  fprintf(fid,'\n  Incorrect length for input vector nord \n\n');
  return
end
maxord=abs(maxord);
ksum=0;
for j=1:nvar,
  if nord(j) > max_order
    nord(j)=max_order;
  end
  ksum=ksum + nord(j);
end
if maxord > ksum
  maxord=ksum;
end
%
%  Record maxord and nord in the output file.
%
fprintf(fid,'\n\n Maximum order per term, maxord = %2.0f',maxord);
fprintf(fid,'\n\n Maximum order per variable, nord = [ %2.0f',nord(1));
for j=2:nvar,
  fprintf(fid,', %2.0f',nord(j));
end
fprintf(fid,' ] \n\n\n');
%
%  Assign a legal value to input variable ivar.
%
if ivar < 0
  ivar=0;
end
if ivar > nvar
  ivar=nvar;
end
ivar=round(ivar);
svlim=abs(svlim);
ztol=abs(ztol);
mvord=zeros(max_ofcns,1);
a=zeros(max_ofcns,1);
psi=zeros(npts,max_ofcns);
p2=zeros(max_ofcns,1);
ar=zeros(max_ofcns,1);
nf=zeros(maxord+1,1);
ntf=0;
%
%  Compute quantities dependent on the measured output data.
%
zbar=mean(z);
if sig2==0
%
%  Default is to compute the maximum variance assuming
%  a constant model for z and a uniform error distribution.
%
  sig2max=(z-zbar*ones(npts,1))'*(z-zbar*ones(npts,1))/(2.0*npts);
elseif sig2==-1
%
%  Compute the maximum variance assuming a linear 
%  model for z in terms of the independent variable
%  columns of x.  Make the maximum variance sig2max 
%  correspond to 2 times the estimated standard 
%  deviation, (2*sqrt(s2lin))^2.  The factor is 
%  only 2 here because any nonlinearity will inflate the 
%  value of s2lin.  Otherwise, the factor would be 5, 
%  as it is below for an independent estimate of sig2.
%
  [ylin,plin,cvarlin,s2lin]=lesq([ones(npts,1),xs],z);
  sig2max=2*2*s2lin;
else
%
%  If sig2 is input, then make the maximum variance 
%  sig2max correspond to 5 times the estimated 
%  standard deviation, sig2max=(5*sqrt(sig2))^2.
%
  sig2max=5*5*sig2;
end
R2den=z'*z-npts*zbar*zbar;
z_rms=rms(z);
%
%  Orthogonal function generation.
%
for n=1:maxord+1,
  if rmsd > ztol
    if n==1
      if ivar > 0
        mvord(n)=10^(ivar-1);
        psi(:,n)=xs(:,ivar);
        nf(n)=1;
        p2(n)=psi(:,n)'*psi(:,n);
        a(n)=z'*psi(:,n)/p2(n);
      else
        mvord(n)=0;
        psi(:,n)=ones(npts,1);
        nf(n)=1;
        p2(n)=psi(:,n)'*psi(:,n);
        a(n)=z'*psi(:,n)/p2(n);
      end
    else
      ll=0;
      for i=nf(n-1):-1:1,
        for j=1:nvar,
          mvord(ntf+ll+1)=mvord(ntf-i+1) + 10^(j-1);
          lord=ordchk(mvord,ntf+ll+1,j,nord);
          lrep=repchk(mvord,ntf+ll+1);
          if lord+lrep == 0
            if n <= 3
              jff=1;
            else
              jff=ntf-nf(n-1)-nf(n-2)+1;
            end
            for ii=jff:ntf+ll,
              ar(ii)=sum(xs(:,j).*psi(:,ntf-i+1).*psi(:,ii))/p2(ii);
            end
            psi(:,ntf+ll+1)=xs(:,j).*psi(:,ntf-i+1);
            psi(:,ntf+ll+1)=psi(:,ntf+ll+1)-psi(:,[jff:ntf+ll])*ar(jff:ntf+ll);
            p2(ntf+ll+1)=psi(:,ntf+ll+1)'*psi(:,ntf+ll+1);
            a(ntf+ll+1)=z'*psi(:,ntf+ll+1)/p2(ntf+ll+1);
            ll=ll+1;
          end
        end
      end
      nf(n)=ll;
    end
    ntf=ntf+nf(n);
    y=psi(:,[1:ntf])*a(1:ntf);
    rmsd=sqrt((z-y)'*(z-y)/npts);
  end
end
mvord=mvord(1:ntf);
a=a(1:ntf);
psi=psi(:,[1:ntf]);
p2=p2(1:ntf);
%
%  Check for generated functions that are not orthogonal.  This
%  usually indicates a problem related to information content of the data.
%  Variable nnof contains a count of non-orthogonal function pairs, and 
%  variable mof contains the number of orthogonal functions generated
%  before a non-orthogonal function is encountered.  The number of 
%  orthogonal functions chosen for the model should be less than mof
%  to avoid violating the theory underlying the modeling process
%  using multivariate orthogonal functions.    
%
ptp=psi'*psi;
nnof=0;
mof=ntf;
for i=1:ntf-1,
  for j=i+1:ntf,
    if ptp(i,j) > ztol
      fprintf(fid,'\n non-orthogonal measure: ');
      fprintf(fid,'ptp(%3.0f ,%3.0f ) = %13.6e \n',i,j,ptp(i,j));
      if mof >= j
        mof=j-1;
      end
      nnof=nnof+1;
    end
  end
end
%
%  Print out guidance for orthogonal function selection to the analyst.
%
fprintf(1,'\n\n Dependent variable rms value = %12.4e \n',z_rms);
fprintf(1,'\n Number of non-orthogonal function pairs = %4.0f \n',nnof);
fprintf(1,'\n Orthogonality intact through function number %4.0f \n\n',mof);
fprintf(fid,'\n\n Dependent variable rms value = %4.0f \n',z_rms);
fprintf(fid,'\n Number of non-orthogonal function pairs = %4.0f \n',nnof);
fprintf(fid,'\n Orthogonality intact through function number %4.0f \n\n',mof);
%
%  Order the orthogonal functions from most to least effective
%  in terms of reducing rms fit error.
%
ia=mvord;
nterms=[1:1:ntf]';
dcost=-p2.*a.*a;
dpse=dcost + 2*sig2max*nterms/npts;
%[dpse,sindx]=sort(dpse);
%dcost=dcost(sindx);
[dcost,sindx]=sort(dcost);
dpse=dpse(sindx);
a=a(sindx);
ia=ia(sindx);
nterms=nterms(sindx);
p2=p2(sindx);
psi=psi(:,sindx);
%
%  Orthogonal function selection for the model.  
%
ofrmsd=1000.*ones(ntf,1);
drmsd=zeros(ntf,1);
R2=zeros(ntf,1);
pse=zeros(ntf,1);
mse=zeros(ntf,1);
ofp=zeros(ntf,1);
y=zeros(npts,1);
fprintf(1,'\n o.f. #     index      ofrmsd');
fprintf(1,'         drmsd      pct. error    R2       pe ');
fprintf(1,'\n ------     -----      ------');
fprintf(1,'         -----      ----------    --       -- ');
fprintf(fid,'\n o.f. #     index      ofrmsd');
fprintf(fid,'         drmsd      pct. error    R2       pe ');
fprintf(fid,'\n ------     -----      ------');
fprintf(fid,'         -----      ----------    --       -- ');
for j=1:ntf,
  y=psi(:,[1:j])*a(1:j);
  ofrmsd(j)=sqrt((z-y)'*(z-y)/npts);
  if j > 1
    drmsd(j)=ofrmsd(j)-ofrmsd(j-1);
  end
  R2(j)=100*(y'*y-npts*zbar*zbar)/R2den;
%
%  Factor of two in the complexity penalty term accounts 
%  for incorrect model structure during the model structure determination.
%
%  pse(j)=(z-y)'*(z-y)/npts + 2.0*sig2max*max(nterms(1:j))/npts;
  pse(j)=(z-y)'*(z-y)/npts + 2.0*sig2max*j/npts;
%  mse(j)=(z-y)'*(z-y)/npts;
%  ofp(j)=2.0*sig2max*j/npts;
  fprintf(1,'\n  %3.0f    %8.0f',j,ia(j));
  fprintf(fid,'\n  %3.0f    %8.0f',j,ia(j));
  if drmsd(j)>=0.0,
    fprintf(1,'    %10.3e     %10.3e     %5.1f     %5.1f   %10.3e',...
              ofrmsd(j),drmsd(j),100*ofrmsd(j)/z_rms,R2(j),sqrt(pse(j)));
    fprintf(fid,'    %10.3e     %10.3e     %5.1f     %5.1f   %10.3e',...
              ofrmsd(j),drmsd(j),100*ofrmsd(j)/z_rms,R2(j),sqrt(pse(j)));
  else
    fprintf(1,'    %10.3e    %10.3e     %5.1f     %5.1f   %10.3e',...
              ofrmsd(j),drmsd(j),100*ofrmsd(j)/z_rms,R2(j),sqrt(pse(j)));
    fprintf(fid,'    %10.3e    %10.3e     %5.1f     %5.1f   %10.3e',...
              ofrmsd(j),drmsd(j),100*ofrmsd(j)/z_rms,R2(j),sqrt(pse(j)));
  end
  if ((mod(j,20)==0) & (auto==0)),
    fprintf('\n\n');
    dummy=input('  more...        (type CR to continue) ');
    fprintf('\n');
  end
end
[minpse,jmin]=min(pse);
if lplot > 0
  clf,
  subplot(2,1,1),plot([2:ntf]',sqrt(pse(2:ntf))),
  grid on;ylabel('Prediction Error'),title('Model Structure Determination'),
  hold on;subplot(2,1,1),
  plot(jmin,sqrt(minpse),'rd','MarkerSize',7,'MarkerFaceColor','r'),
  hold off;
  subplot(2,1,2),plot([2:ntf]',R2(2:ntf)),
  grid on;ylabel('R Squared'),xlabel('Number of Orthogonal Functions'),
  hold on;subplot(2,1,2),
  plot(jmin,R2(jmin),'rd','MarkerSize',7,'MarkerFaceColor','r'),
  hold off;
end
fprintf(1,'\n\n\n    Minimum pe at orthogonal function number %4.0f \n\n',...
          jmin);
fprintf(fid,'\n\n\n    Minimum pe at orthogonal function number %4.0f \n\n',...
            jmin);
nkf=jmin;
if auto==0,
  nkf=input(' Enter the number of orthogonal functions to keep ');
  if isempty(nkf)
    nkf=jmin;
  end
end
if nkf <= 0
  return
end
fprintf(fid,'\n\n Number of retained orthogonal functions is %4.0f \n\n',nkf);
R2=R2(nkf);
pse=pse(nkf);
y=psi(:,[1:nkf])*a(1:nkf);
sig2=((z-y)'*(z-y))/(npts-nkf);
fprintf(1,'\n\n For the %4.0f retained orthogonal functions: \n\n',nkf);
fprintf(fid,'\n\n For the %4.0f retained orthogonal functions: \n\n',nkf);
rmsd=sqrt((z-y)'*(z-y)/npts);
prmsd=100*rmsd/z_rms;
fprintf(1,'   rms dev. = %11.4e      pct. error = %11.4e \n',rmsd,prmsd);
fprintf(fid,'   rms dev. = %11.4e      pct. error = %11.4e \n',rmsd,prmsd);
%
%  Break down each orthogonal function retained in the model
%  using ordinary polynomial terms and combine results.
%
ntpf=0;
[maxterms,j]=max(nterms(1:nkf));
ap=zeros(maxterms,1);
iap=zeros(maxterms,1);
s2ap=zeros(maxterms,1);
%
%  Loop for breaking down each retained orthogonal function.
%
for k=1:nkf
  xr=ones(npts,nterms(k));
  xrsf=ones(nterms(k),1);
  ipar=mvord(1:nterms(k));
  for i=1:nterms(k)
    indx=mvord(i);
    for j=1:nvar
      ji=round(rem(indx,10));
      if ji~=0
        xr(:,i)=xr(:,i).*(xs(:,j).^ji);
        xrsf(i)=xrsf(i)/(xsf(j)^ji);
      end
      indx=floor(indx/10);
    end
  end
  [yr,par]=lesq(xr,psi(:,k),svlim);
%
%  Adjust parameters using xrsf to get an expansion 
%  in terms of regressors using the original 
%  independent variable data.
%
  par=par.*xrsf;
%
%  Collect results from decomposition of 
%  each retained orthogonal function. 
%
  if ntpf==0
    for j=1:nterms(k)
      if abs(par(j)*a(k)) > pfztol
        ntpf=ntpf+1;
        iap(ntpf)=ipar(j);
        ap(ntpf)=par(j)*a(k);
        s2ap(ntpf)=(par(j)^2)*sig2/p2(k);
      end
    end
  else
    for j=1:nterms(k)
      if abs(par(j)*a(k)) > pfztol
        jprev=0;
        for ji=1:ntpf
          if ipar(j)==iap(ji)
            jprev=ji;
          end
        end
        if jprev~=0
          ap(jprev)=ap(jprev) + par(j)*a(k);
          s2ap(jprev)=s2ap(jprev) + (par(j)^2)*sig2/p2(k);
        else
          ntpf=ntpf+1;
          iap(ntpf)=ipar(j);
          ap(ntpf)=par(j)*a(k);
          s2ap(ntpf)=(par(j)^2)*sig2/p2(k);
        end
      end
    end
  end
end
ap=ap(1:ntpf);
iap=iap(1:ntpf);
s2ap=s2ap(1:ntpf);
%
%  Generate the polynomial function matrix and the final model
%  output based on the polynomial functions.
%
xp=ones(npts,ntpf);
for i=1:ntpf,
  indx=iap(i);
  for j=1:nvar
    ji=round(rem(indx,10));
    if ji~=0
      xp(:,i)=xp(:,i).*(x(:,j).^ji);
    end
    indx=floor(indx/10);
  end
end
%
%  Drop any terms that contribute less than 0.1 percent of the 
%  rms model magnitude.  
%
prms=ones(ntpf,1);
for j=1:ntpf,
  prms(j)=rms(ap(j)*xp(:,j))/z_rms;
end
indx=find(prms > 0.001);
ap=ap(indx);
iap=iap(indx);
s2ap=s2ap(indx);
xp=xp(:,[indx']);
ntpf=length(ap);
%
%  Compute final model results.
%
y=xp*ap;
fprintf(1,'\n\n For the %4.0f retained polynomial functions: \n\n',ntpf);
fprintf(fid,'\n\n For the %4.0f retained polynomial functions: \n\n',ntpf);
rmsd=sqrt((z-y)'*(z-y)/npts);
prmsd=100*rmsd/z_rms;
fprintf(1,'   rms dev. = %11.4e      pct. error = %11.4e \n',rmsd,prmsd);
fprintf(1,'\n\n');
fprintf(fid,'   rms dev. = %11.4e      pct. error = %11.4e \n',rmsd,prmsd);
fprintf(fid,'\n\n');
fclose(fid);
return
