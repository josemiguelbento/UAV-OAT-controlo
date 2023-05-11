function chkplot(y,chksize,xval,nval)
%
%  function chkplot(y,chksize,xval,nval)
%
%  Usage: chkplot(y,chksize,xval,nval);
%
%  Description:
%
%    Plots columns of matrix y in row chunks of size chksize.
%
%  Input:
%    
%        y = matrix of column vectors to be plotted.
%  chksize = size of sections to be plotted.
%     xval = array of independent variable values.
%     nval = integer vector with an element for each independent variable
%            that contains the number of values for that independent variable.
%
%  Output:
%
%    text:
%      section number
%      xval index for each independent variable
%
%    graphics:
%      2-D plots
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 Sept 1995 - Created and debugged, EAM.
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
[npts,m]=size(y);
[mval,nvar]=size(xval);
if nvar~=length(nval)
  fprintf('\n Input xval not consistent with input nval \n\n');
  return
end
if prod(nval)~=npts
  fprintf('\n Input nval not consistent with input y \n\n');
  return
end
nplots=fix(npts/chksize);
%
%  Compute number of plots needed to change the independent
%  variable value indices by one count.  The vector nswitch
%  contains these numbers.  
%
nswitch=ones(nvar,1);
nswitch(1)=nval(1);
if nvar > 1
  for j=2:nvar,
    nswitch(j)=nval(j)*nswitch(j-1);
  end
end
%
%  Plot the data in chunks of size chksize against the row index.
%
indx=ones(nvar,1);
jl=1;
jh=chksize;
for i=1:nplots,
  plot([jl:jh],y([jl:jh],:));
  nsect=fix(jh/nswitch(1));
  fprintf(1,'\n Section number = %4.0f \n',nsect);
  if nvar > 1
    cnt=jl;
    for k=nvar:-1:2,
%
%  Compute the index for each independent variable.
%
      kindx=fix(cnt/nswitch(k-1)) + 1;
%
%  Subtract the value associated with variable k
%  from the row index count for the current plot of y.
%
      cnt=cnt-nswitch(k-1)*(kindx-1);
%
%  Recycle the index according to nval(k).
%
      kindx=mod(kindx,nval(k));
      if kindx==0
        kindx=nval(k);
      end
      indx(k)=kindx;
    end
%
%  Print out the indices for the independent variables when
%  the number of independent variables is greater than one.  
%  The values for the first independent variable are plotted
%  on the abscissa of the current graph.  
%
    for k=2:nvar,
      fprintf(1,'\n ind. var. %2.0f = value number %2.0f',k,indx(k));
      fprintf(1,' = %10.3e',xval(indx(k),k));
    end
  end
  fprintf('\n');
  reply=input('Enter section number to plot, (ret) to cont, or 0 to quit ');
  if reply<=0
    return
  end
  if isempty(reply)
    jl=jl+chksize;
    jh=jh+chksize;
  else
    reply=round(reply);
    if reply > nplots
      fprintf('\n Maximum legal input = %4.0f \n\n',nplots);
      reply=nplots;
    end
    jl=1+(reply-1)*chksize;
    jh=reply*chksize;
  end
end
fprintf('\n');
return
