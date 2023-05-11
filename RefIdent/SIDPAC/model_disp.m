function modelstr = model_disp(p,serr,ip,xnames)
%
%  function modelstr = model_disp(p,serr,ip,xnames)
%
%  Usage: modelstr = model_disp(p,serr,ip,xnames);
%
%  Description:
%
%    Displays the functional form of the model defined 
%    by inputs p, serr, and ip.  The output string is 
%    stored in the string variable modelstr.  If optional 
%    input xnames is provided, the names of the independent 
%    variables corresponding to the indices in ip 
%    are displayed.
%
%
%  Input:
%    
%       p = parameter vector for ordinary polynomial function expansion.
%    serr = vector of estimated parameter standard errors.
%      ip = vector of integer indices (optional).
%  xnames = names of the independent variables (optional).
%
%
%  Output:
%
%      modelstr = string containing the analytic model expression.  
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Feb  2001 - Created and debugged, EAM.
%      01 Oct  2001 - Removed x matrix input, EAM.
%      12 July 2002 - Upgraded the printed output, EAM.
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

%
%  Generate the integer index if necessary.
%
if nargin < 3
  ip=[1:length(p)]';
end
%
%  Generate the model string.
%
modelstr=[' y = '];
nterms=length(ip);
%
%  Loop over the model terms.
%
for k=1:nterms,
  indx=ip(k);
  modelstr=[modelstr,'p(',num2str(k),')'];
%
%  The independent variable index is j.
%  Number of independent variables is nvar.
%
  j=0;
  nvar=0;
  while indx > 0,
    j=j+1;
    ji=round(rem(indx,10));
    if ji~=0
      modelstr=[modelstr,'*x',num2str(j)];
      if ji > 1
        modelstr=[modelstr,'^',num2str(ji)];
      end
    end
    indx=floor(indx/10);
  end
  if j > nvar
    nvar=j;
  end
  if k < nterms
    modelstr=[modelstr,' + '];
  end
end
fprintf('\n\n')
disp(modelstr)
fprintf('\n\n')
%
%  Print out the headings.
%
fprintf(' Parameter    Estimate     Std Error  %% Error   95 %% Confidence Interval   Index\n')
fprintf(' ---------    --------     ---------  -------   ------------------------   -----\n')
%
%  Find percent errors.  Use the absolute error
%  if the parameter estimate is zero.  
%
perr=zeros(nterms,1);
for j=1:nterms,
  if p(j)~=0
    perr(j)=100*serr(j)./abs(p(j));
  else
    perr(j)=serr(j);
  end
end
%
%  Print out the parameter estimate information
%  in tabular format.
%
for k=1:nterms,
  if k < 10
    fprintf('  p( %i ) ',k)
  else
    fprintf(' p( %i ) ',k)
  end
  if p(k) >= 0.0
    fprintf(' ')
  end
  fprintf(['   %10.3e   %10.3e   %5.1f    [ %8.3f , %8.3f ]',...
           '     %',num2str(nvar),'i\n'], ...
          p(k),serr(k),perr(k),p(k)-2*serr(k),p(k)+2*serr(k),ip(k))
end
%
%  Print out the independent variable names.
%
fprintf('\n\n')
if nargin > 3
  nvar=size(xnames,1);
  for k=1:nvar,
    disp([' x',num2str(k),' = ',xnames(k,:)]);
  end
  fprintf('\n')
end
return
