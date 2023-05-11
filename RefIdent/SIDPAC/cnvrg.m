function lstop = cnvrg(f,x,fp,xp,tol)
%
%  function lstop = cnvrg(f,x,fp,xp,tol)
%
%  Usage: lstop = cnvrg(f,x,fp,xp,tol);
%
%  Description:
%
%    Computes the optimization stopping criteria logical variable lstop.
%
%  Input:
%    
%    f   = cost value for current minimizing parameter vector.
%    x   = current minimizing parameter vector.
%    fp  = cost value for past minimizing parameter vector.
%    xp  = past minimizing parameter vector.
%    tol = distance in parameter space that defines convergence.
%
%  Output:
%
%    lstop = 1 when the stopping criteria are satisfied.
%            0 otherwise.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      26 Apr 1995 - Created and debugged, EAM.
%
%
%  Copyright (C) 2000  Eugene A. Morelli
%
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
lstop=0;
tol=abs(tol);
if norm(x-xp,inf)<tol | norm(f-fp,inf)<tol
  lstop=1;
end
return
