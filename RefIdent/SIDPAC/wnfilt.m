function [wf,sigab,nseab] = wnfilt(b)
%
%  function [wf,sigab,nseab] = wnfilt(b)
%
%  Usage: [wf,sigab,nseab] = wnfilt(b);
%
%  Description:
%
%    Implements an optimal Wiener filter using the 
%    Lanczos method for spectral estimation.  
%
%  Input:
%    
%    b = vector or matrix of Fourier sine series coefficients 
%        for detrended time histories reflected about the origin.  
%
%  Output:
%
%    wf    = vector or matrix Wiener filter in the frequency domain.
%    sigab = vector or matrix frequency domain model of the
%            absolute Fourier sine coefficients for the 
%            deterministic part of the measured time histories.  
%    nseab = scalar or vector of the constant frequency domain  
%            model of the absolute Fourier sine coefficients for 
%            the random noise part of the measured time histories.  
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 May 1995 - Created and debugged, EAM.
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
[npts,n]=size(b);
%
%  Initialization.
%
maxnmp=15;
nr=4;
nsb=round(npts/10);
arlim=0.10;
nsatlim=2;
nmp=maxnmp*ones(n,1);
ab=abs(b);
ifp=0*ones(n,1);
m=0*ones(n,1);
abmax=0*ones(maxnmp,n);
kabmax=0*ones(maxnmp,n);
dar=0*ones(maxnmp,n);
pctar=0*ones(maxnmp,n);
arb=0*ones(n,1);
dk=0*ones(2,1);
sigab=0*ones(npts,n);
xc=0*ones(nr,n);
yc=0*ones(nr,n);
ccub=0*ones(n,1);
b2=0*ones(n,1);
nseab=0*ones(n,1);
lsb=0*ones(n,1);
wf=0*ones(npts,n);
%
%  Find the prominent Fourier sine series components.
%
for j=1:n,
  nsat=0;
  i=1;
  kabmax(1,j)=1;
  abmax(1,j)=ab(1,j);
  while abmax(nmp(j),j)==0.0,
    i=i+1;
    dk(1)=ab(i,j)-ab(i-1,j);
    dk(2)=ab(i+1,j)-ab(i,j);
    if dk(1)>=0.0 
      if dk(2)<0.0 
        lps=0;
        for k=1:nmp(j),
          if abmax(k,j)<=ab(i,j) 
            if lps==0 
              abmax(k,j)=ab(i,j);
              kabmax(k,j)=i;
              lps=1;
              if k>1 
                dar(k,j)=(kabmax(k,j)-kabmax(k-1,j))*...
                         (abmax(k,j)+abmax(k-1,j))/2.;
                arb(j)=sum(dar([2:k],j));
                nsat=0;
                for ii=2:k,
                  pctar(ii,j)=dar(ii,j)/arb(j);
                  if pctar(ii,j)<=arlim 
                    nsat=nsat+1;
                    if nsat>=nsatlim 
                      if ifp(j)==0 
                        ifp(j)=ii;
                        nmp(j)=ii+1;
                      end
                    end
                  else
                    nsat=0;
                  end
                end
              end
              if k<nmp(j) 
                for li=k+1:nmp(j),
                  abmax(li,j)=0.0;
                  kabmax(li,j)=0;
                  pctar(li,j)=0.0;
                  dar(li,j)=0.0;
                end
              end
            end
          end
        end
      end
    end
  end
  if ifp(j)==0 
    ifp(j)=nmp(j)-1;
  end
  ll=ifp(j)-2;
%
%  Fit a cubic model to the absolute Fourier sine series coefficients.
%
  for k=1:nr,
    xc(k,j)=1./(kabmax(ll+k-1,j)^3);
    yc(k,j)=abmax(ll+k-1,j);
  end
  ccub(j)=xc(:,j)'*yc(:,j)/(xc(:,j)'*xc(:,j));
  for k=1:npts,
    sigab(k,j)=ccub(j)/(k^3);
  end
%
%  Identify the constant amplitude noise model.
%
  ll=kabmax(nmp(j),j);
  for k=1:nsb,
    dk(1)=ab(ll+k,j)-ab(ll+k-1,j);
    dk(2)=ab(ll+k+1,j)-ab(ll+k,j);
    if dk(1)>0.0 
      if dk(2)<0.0 
        b2(j)=b2(j) + b(ll+k,j)^2;
        lsb(j)=lsb(j)+1;
      end
    end
  end
  nseab(j)=sqrt(b2(j)/lsb(j));
%
%  Compute the optimal Wiener filter in the frequency domain.
%
  for i=1:npts,
    wf(i,j)=(sigab(i,j)^2)/(sigab(i,j)^2 + nseab(j)^2);
  end
end
return
