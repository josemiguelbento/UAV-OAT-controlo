function [corfac,endcor] = ficor(h,t,w)
%
%  function [corfac,endcor] = ficor(h,t,w)
%
%  Usage: [corfac,endcor] = ficor(h,t,w);
%
%  Description:
%
%    Generates multiplicative and endpoint corrections for evaluating
%    the Fourier integral h(t)*exp(-jay*w*t) over the time defined
%    by vector t, using the discrete zoom Fourier transform.  
%
%  Input:
%    
%     h = vector time history in the Fourier integral.
%     t = time vector.
%     w = frequency vector for the zoom Fourier transform, rad/sec.
%
%  Output:
%
%    corfac = multiplicative correction factor 
%             for the discrete Fourier transform.
%    endcor = additive correction for the endpoints. 
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      08 May 1996 - Created and debugged, EAM.
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
t=t(:,1);
%
%  Define constants and check for illegal inputs.
%
npts=length(t);
dt=t(2)-t(1);
a=t(1);
b=t(npts);
n=length(w);
th=w*dt;
if a > b | min(th) < 0.0 | max(th) > pi
  fprintf(1,'\n Bad input arguments to ficor \n\n');
  return
end
cval=0.1;
jay=sqrt(-1);
alf=zeros(n,4);
h=h(:,1);
hl=h(1:4);
hr=h(npts:-1:npts-3);
uvec=ones(n,1);
lindx=find(abs(th)<cval);
hindx=find(abs(th)>=cval);
%
%  Use the series approximations for small th.
%
if isempty(hindx)
  t2=th.*th;
  t4=t2.*t2;
  t6=t4.*t2;
  corfac=uvec-(11/720)*t4+(23/15120)*t6;
  alf(:,1)=(-2/3)*uvec+t2/45+(103/15120)*t4-(169/226800)*t6 ...
           - jay*th.*((2/45)*uvec+(2/105)*t2-(8/2835)*t4+(86/467775)*t6);
  alf(:,2)=(7/24)*uvec-(7/180)*t2+(5/3456)*t4-(7/259200)*t6 ...
           - jay*th.*((7/72)*uvec-t2/168+(11/72576)*t4-(13/5987520)*t6);
  alf(:,3)=(-1/6)*uvec+t2/45-(5/6048)*t4+t6/64800 ...
           - jay*th.*((-7/90)*uvec+t2/210-(11/90720)*t4+(13/7484400)*t6);
  alf(:,4)=(1/24)*uvec-t2/180+(5/24192)*t4-t6/259200 ...
           - jay*th.*((7/360)*uvec-t2/840+(11/362880)*t4-(13/29937600)*t6);
%
%  Use the analytic expressions for large th.
%
elseif isempty(lindx)
  t2=th.*th;
  t3=th.*t2;
  t4=t2.*t2;
  ct=cos(th);
  ctt=cos(2*th);
  st=sin(th);
  stt=sin(2*th);
  corfac=((6*uvec+t2)./(3*t4)).*(3*uvec-4*ct+ctt);
  alf(:,1)=((-42*uvec+5*t2)+(6*uvec+t2).*(8*ct-ctt))./(6*t4) ...
           - jay*((-12*th+6*t3)+(6*uvec+t2).*stt)./(6*t4);
  alf(:,2)=(14*(3*uvec-t2)-7*(6*uvec+t2).*ct)./(6*t4) ...
           - jay*(30*th-5*(6*uvec+t2).*st)./(6*t4);
  alf(:,3)=(-4*(3*uvec-t2)+2*(6*uvec+t2).*ct)./(3*t4) ...
           - jay*(-12*th+2*(6*uvec+t2).*st)./(3*t4);
  alf(:,4)=(2*(3*uvec-t2)-(6*uvec+t2).*ct)./(6*t4) ...
           - jay*(6*th-(6*uvec+t2).*st)./(6*t4);
else
%
%  Otherwise, use the appropriate expression for the size of each th element.
%
  th=w(lindx)*dt;
  uvec=ones(length(lindx),1);
  t2=th.*th;
  t4=t2.*t2;
  t6=t4.*t2;
  corfac(lindx,1)=uvec-(11/720)*t4+(23/15120)*t6;
  alf(lindx,1)=(-2/3)*uvec+t2/45+(103/15120)*t4-(169/226800)*t6 ...
               - jay*th.*((2/45)*uvec+(2/105)*t2-(8/2835)*t4+(86/467775)*t6);
  alf(lindx,2)=(7/24)*uvec-(7/180)*t2+(5/3456)*t4-(7/259200)*t6 ...
               - jay*th.*((7/72)*uvec-t2/168+(11/72576)*t4-(13/5987520)*t6);
  alf(lindx,3)=(-1/6)*uvec+t2/45-(5/6048)*t4+t6/64800 ...
               - jay*th.*((-7/90)*uvec+t2/210-(11/90720)*t4+(13/7484400)*t6);
  alf(lindx,4)=(1/24)*uvec-t2/180+(5/24192)*t4-t6/259200 ...
               - jay*th.*((7/360)*uvec-t2/840+(11/362880)*t4-(13/29937600)*t6);
%
%  Use the analytic expressions for large th.
%
  th=w(hindx)*dt;
  uvec=ones(length(hindx),1);
  t2=th.*th;
  t3=th.*t2;
  t4=t2.*t2;
  ct=cos(th);
  ctt=cos(2*th);
  st=sin(th);
  stt=sin(2*th);
  corfac(hindx,1)=((6*uvec+t2)./(3*t4)).*(3*uvec-4*ct+ctt);
  alf(hindx,1)=((-42*uvec+5*t2)+(6*uvec+t2).*(8*ct-ctt))./(6*t4) ...
               - jay*((-12*th+6*t3)+(6*uvec+t2).*stt)./(6*t4);
  alf(hindx,2)=(14*(3*uvec-t2)-7*(6*uvec+t2).*ct)./(6*t4) ...
               - jay*(30*th-5*(6*uvec+t2).*st)./(6*t4);
  alf(hindx,3)=(-4*(3*uvec-t2)+2*(6*uvec+t2).*ct)./(3*t4) ...
               - jay*(-12*th+2*(6*uvec+t2).*st)./(3*t4);
  alf(hindx,4)=(2*(3*uvec-t2)-(6*uvec+t2).*ct)./(6*t4) ...
               - jay*(6*th-(6*uvec+t2).*st)./(6*t4);
end
endcor=alf*hl + exp(-jay*w*(b-a)).*(conj(alf)*hr);
return
