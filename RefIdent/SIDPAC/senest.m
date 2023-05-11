function dydp = senest(dsname,p,u,t,x0,c,del,no,ifd)
%
%  function dydp = senest(dsname,p,u,t,x0,c,del,no,ifd)
%
%  Usage: dydp = senest(dsname,p,u,t,x0,c,del,no,ifd);
%
%  Description:
%
%    Computes the output sensitivities for maximum likelihood 
%    estimation using forward or central finite differences.
%    The dynamic system is specified in the m-file named dsname.  
%
%  Input:
%
%    dsname = name of the m-file that computes the system outputs.
%         p = vector of parameter values.
%         u = control vector time history.
%         t = time vector.
%        x0 = state vector initial condition.
%         c = vector of constants passed to dsname.
%       del = vector of parameter perturbations in percent of nominal value.
%        no = number of outputs.
%       ifd = 1 for central differences.
%             0 for forward differences.
%
%  Output:
%
%    dydp = matrix of output sensitivities: 
%
%           [dy/dp(1),dy/dp(2),...,dy/dp(np)].
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      18 Jan 1997 - Created and debugged, EAM.
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
npts=length(t);
np=length(p);
dydp=zeros(npts,no*np);
po=p;
del=abs(del);
mindp=1.0e-04;
if ifd==1 
  for j=1:np,
    p=po;
    if abs(p(j)) > mindp
      dp=abs(del(j)*po(j));
    else
      dp=mindp;
    end
    dp=0.5*dp;
    p(j)=po(j) + dp;
    y1=eval([dsname,'(p,u,t,x0,c)']);
    p(j)=po(j) - dp;
    y0=eval([dsname,'(p,u,t,x0,c)']);
    dydp(:,[(j-1)*no+1:j*no])=(y1-y0)/(2*dp);
  end
else
  y0=eval([dsname,'(p,u,t,x0,c)']);
  for j=1:np,
    p=po;
    if abs(p(j)) > mindp
      dp=abs(del(j)*po(j));
    else
      dp=mindp;
    end
    p(j)=po(j) + dp;
    y1=eval([dsname,'(p,u,t,x0,c)']);
    dydp(:,[(j-1)*no+1:j*no])=(y1-y0)/dp;
  end
end
return
