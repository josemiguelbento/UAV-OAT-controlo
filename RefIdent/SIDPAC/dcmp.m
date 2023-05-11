function [y,x] = dcmp(p,u,t,x0,c)
%
%  function [y,x] = dcmp(p,u,t,x0,c)
%
%  Usage: [y,x] = dcmp(p,u,t,x0,c);
%
%  Description:
%
%    Matlab m-file to compute the output vector 
%    time history for data compatibility analysis.  
%
%  Input:
%
%      p = vector of parameter values.
%      u = input vector time history = [ax,ay,az,p,q,r,u,v,w,phi,the,psi].
%      t = time vector.
%     x0 = initial state vector.
%      c = cell structure:
%          c{1} = p0c = vector of initial parameter values.
%          c{2} = ipc = index vector to select estimated parameters.
%          c{3} = ims = index vector to select measured states.
%          c{4} = imo = index vector to select model outputs.
%
%  Output:
%
%    y = model output vector time history = [vt,alpha,beta,phi,the,psi].
%    x = model state vector time history = [u,v,w,phi,the,psi].
%

%
%    Calls:
%      adamb3.m
%      runk2.m
%      dcmp_eqs.m
%      dcmp_out.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Oct 2000 - Created and debugged, EAM.
%      28 Oct 2000 - Added general model structure capability, EAM.
%      29 Nov 2000 - Switched numerical integration 
%                    to 3rd order Adams-Bashforth, EAM.
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

%
%  Compute state vector time history.  
%
%x=runk2('dcmp_eqs',p,u,t,x0,c);
x=adamb3('dcmp_eqs',p,u,t,x0,c);
%[t,x]=ode23('fdcmp_eqs',t',x0',[],p,u,c);
%
%  Compute output vector time history. 
%
y=dcmp_out(p,u,x,c);
return
