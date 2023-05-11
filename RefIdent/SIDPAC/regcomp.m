function [xr,xlab] = regcomp(x,ip)
%
%  function [xr,xlab] = regcomp(x,ip)
%
%  Usage: [xr,xlab] = regcomp(x,ip);
%
%  Description:
%
%    Generates a set of regressors in matrix xr, according 
%    to the indices of input vector ip, using the 
%    columns of input matrix x.  Corresponding   
%    labels are assembled in rows of matrix xlab.  
%
%  Input:
%    
%        x = matrix of independent variable vectors.
%       ip = vector of regressor order indices. 
%
%  Output:
%
%       xr = matrix of regressor column vectors.
%     xlab = matrix of regressor labels.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Jun 2002 - Created and debugged, EAM.
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
[npts,nvar]=size(x);
n=length(ip);
%
%  Now generate the regressors and the corresponding labels, 
%  based on the indices in ip.
%
xr=zeros(npts,n);
xlab=char(zeros(n,23));
for i=1:n,
  xr(:,i)=ones(npts,1);
  tindx=ip(i);
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
  if labstrt > 0
    nchar=length(tlab);
    xlab(i,[1:nchar])=tlab;
  end
end
return
