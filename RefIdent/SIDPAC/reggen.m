function [xr,xlab,indx] = reggen(x,nord,maxord)
%
%  function [xr,xlab,indx] = reggen(x,nord,maxord)
%
%  Usage: [xr,xlab,indx] = reggen(x,nord,maxord);
%
%  Description:
%
%    Generates a set of regressors in matrix xr, using the 
%    independent variables in columns of x, with maximum independent 
%    variable orders in nord, and maximum order for each model term 
%    in maxord.  The matrix xr does not include the columns of x.
%    Corresponding labels are assembled in rows of matrix xlab.  
%
%  Input:
%    
%         x = matrix of independent variable vectors.
%      nord = vector of maximum independent variable orders.
%    maxord = maximum order of each model term.
%
%  Output:
%
%       xr = matrix of regressor column vectors.
%     xlab = matrix of regressor labels.
%     indx = indices of the generated regressors.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 2000 - Created and debugged, EAM.
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
[npts,nvar]=size(x);
if nvar~=length(nord)
  fprintf('\n  Incorrect length for input vector nord \n\n');
  return
end
maxord=min(maxord,sum(nord));
%
%  Generate regressors.
%
%  Generate indices for all possible regressors.
%
maxindx=0;
for j=1:nvar,
  maxindx=maxindx+nord(j)*10^(j-1);
end
mvord=[0:1:maxindx]';
%
%  Restrict the possible regressors to those that have
%  legal order for the first independent variable.  
%
mvord=mvord(find(rem(mvord,10)<=nord(1)));
%
%  Now check all the independent variable orders 
%  for all the remaining function indices.
%
n=length(mvord);
nreg=0;
for i=1:n,
  lkeep=1;
%
%  Check against nord to determine if mvord(i) is a legal index.
%
  for j=1:nvar,
    if (ordchk(mvord,i,j,nord))==1
      lkeep=0;
    end
  end
%
%  If the ith index is legal, record the index.
%
  if lkeep==1
    if nreg==0
      indx=mvord(i);
    else
      indx=[indx;mvord(i)];
    end
    nreg=nreg+1;
  end
end
%
%  Check the term orders, and eliminate zero and first order terms, 
%  as well as terms with order higher than maxord.
%
mvord=indx;
n=nreg;
nreg=0;
for j=1:n,
  [lmchk,sumindx]=mordchk(mvord,j,nvar,maxord);
  if ((lmchk==0) & (sumindx>1))
    if nreg==0
      indx=mvord(j);
    else
      indx=[indx;mvord(j)];
    end
    nreg=nreg+1;
  end
end
%
%  Now generate the regressors and the corresponding labels, 
%  based on the remaining indices.
%
xr=zeros(npts,nreg);
xlab=char(zeros(nreg,23));
for i=1:nreg,
  xr(:,i)=ones(npts,1);
  tindx=indx(i);
  labstrt=0;
  for j=1:nvar,
    ji=round(rem(tindx,10));
    if ji~=0
      xr(:,i)=xr(:,i).*(x(:,j).^ji);
%
%  Compose the label for the first variable in the ith term.  
%
      if labstrt==0
        labstrt=1;
        if ji>1
          tlab=['X',num2str(j),'^',num2str(ji)];
        else
          tlab=['X',num2str(j)];
        end
      else
%
%  Compose the label for subsequent variables in the ith term.
%
        if ji>1
          tlab=[tlab,'*X',num2str(j),'^',num2str(ji)];
        else
          tlab=[tlab,'*X',num2str(j)];
        end
      end
    end
    tindx=floor(tindx/10);
  end
%
%  Assign the label.
%
  nchar=length(tlab);
  xlab(i,[1:nchar])=tlab;
end
return
