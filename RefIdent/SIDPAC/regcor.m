function [reg,cor] = regcor(x)
%
%  function [reg,cor] = regcor(x)
%
%  Usage: [reg,cor] = regcor(x);
%
%  Description:
%
%    Computes normalized regressor correlation matrix 
%    from the input regressor matrix x and finds
%    the highest pairwise correlations between regressors.  
%    The correlation matrix is an indication of the 
%    conditioning of the least squares
%    linear regression parameter estimation problem.  
%    Each row of output reg contains the indices
%    of the correlated regressors (same as their column
%    number in x), and cor is a vector of pairwise correlations.
%    The pairwise correlations are ranked in descending 
%    absolute value and also are output to the screen.  
%
%  Input:
%    
%    x = matrix of column regressors.
%
%  Output:
%
%     reg = matrix of indices for the pairwise correlated 
%           regressors (in each row).  
%     cor = pairwise correlation values in descending absolute
%           value.  The correlated regressors are specified
%           in corresponding rows of reg1 and reg2.  
%
%

%
%    Calls:
%      corx.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      16 Dec 1998 - Created and debugged, EAM.
%      20 Jan 2001 - Added correlation ranking printed output, EAM.
%
%  Copyright (C) 2002  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
corlm=corx(x);
n=length(diag(corlm));
if n <= 1
  cor=1;
  reg=[1,1];
  return
end
%
%  First record all distinct regressor correlations.
%
nc=n*(n-1)/2;
tmp=zeros(nc,1);
cor=zeros(nc,1);
reg=zeros(nc,2);
cnt=1;
for i=1:n-1,
  for j=i+1:n,
    tmp(cnt)=abs(corlm(i,j));
    reg(cnt,:)=[i,j];
    cnt=cnt+1;
  end
end
%
%  Sort the regressor correlations.
%
for i=1:nc,
  [mval,indx]=max(tmp(i:nc));
  indx=indx+i-1;
  mvalreg=reg(indx,:);
  tmp(indx)=tmp(i);
  reg(indx,:)=reg(i,:);
  tmp(i)=mval;
  reg(i,:)=mvalreg;
  cor(i)=corlm(reg(i,1),reg(i,2));
end
%
%  Print out the results.
%
fprintf('\n\n  Reg. No.    Reg. No.     Correlation\n')
fprintf('  --------    -------     -----------\n')
for i=1:nc,
  if cor(i) < 0.0
    fprintf('     %2i         %2i          %6.4f \n',reg(i,1),reg(i,2),cor(i))
  else
    fprintf('     %2i         %2i           %6.4f \n',reg(i,1),reg(i,2),cor(i))
  end
end
fprintf('\n')
return
