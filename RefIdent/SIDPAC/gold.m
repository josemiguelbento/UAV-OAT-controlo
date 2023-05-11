function [tmin,fmin] = gold(dsname,U,Z,nord,dord,p,w,ta,tb,tc,fb,tol);
%
%  function [tmin,fmin] = gold(dsname,U,Z,nord,dord,p,w,ta,tb,tc,fb,tol)
%
%  Usage: [tmin,fmin] = gold(dsname,U,Z,nord,dord,p,w,ta,tb,tc,fb,tol);
%
%  Description:
%
%    Implements a line search for a minimum given an input
%    interval containing the minimum (icm), using a 
%    golden section search method.  
%
%  Input:
%    
%   dsname = name of the m-file that computes the system outputs.
%        U = control vector.
%        Z = measued output vector.
%     nord = numerator order.
%     dord = denominator order.
%        p = vector of constant parameters passed to dsname.
%        w = frequency vector, rad/sec.
%       ta = boundary of the icm.
%       tb = interior point in the icm.
%       tc = boundary of the icm.
%       fb = cost value for tb.
%      tol = distance in parameter space that defines convergence.
%
%  Output:
%
%    tmin = minimizing parameter vector.
%    fmin = cost value for the minimizing parameter vector.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      03 Aug 1999 - Created and debugged, EAM.
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
gratio=0.381966;
maxloops=100;
tol=abs(tol);
t0=ta;
t3=tc;
if norm(tc-tb,2) > norm(tb-ta,2)
  t1=tb;
  f1=fb;
  t2=tb + gratio*(tc-tb);
  f2=eval([dsname,'(t2,U,Z,nord,dord,p,w)']);
else
  t1=tb - gratio*(tb-ta);
  f1=eval([dsname,'(t1,U,Z,nord,dord,p,w)']);
  t2=tb;
  f2=fb;
end
nloops=0;
while nloops<=maxloops & norm(t3-t0,2)>tol*(norm(t1,2)+norm(t2,2)),
  if f2 < f1
    t0=t1;
    t1=t2;
    f1=f2;
    t2=t1 + gratio*(t3-t1);
    f2=eval([dsname,'(t2,U,Z,nord,dord,p,w)']);
  else
    t3=t2;
    t2=t1;
    f2=f1;
    t1=t2 - gratio*(t2-t0);
    f1=eval([dsname,'(t1,U,Z,nord,dord,p,w)']);
  end
  nloops=nloops + 1;
end
if f1 < f2
  tmin=t1;
  fmin=f1;
else
  tmin=t2;
  fmin=f2;
end
return
