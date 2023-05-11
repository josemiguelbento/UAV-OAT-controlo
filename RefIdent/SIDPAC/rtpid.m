function [y,p,crb,ph,seh,S,Xh,Uh,f] = rtpid(u,t,c,z,w)
%
%  function [y,p,crb,ph,seh,S,Xh,Uh,f] = rtpid(u,t,c,z,w)
%
%  Usage: [y,p,crb,ph,seh,S,Xh,Uh,f] = rtpid(u,t,c,z,w);
%
%  Description:
%
%    Real-time parameter estimation using state 
%    space equation error in the frequency domain.  
%
%  Input:
%    
%     u = input time history vector.
%     t = time vector.
%     c = vector of constants.  
%     z = matrix of measured output time history column vectors.
%     w = frequency vector, rad/sec.
%
%  Output:
%
%     y = model output using final estimated parameter values.
%     p = estimated parameter vector.
%   crb = estimated parameter covariance matrix.
%    ph = estimated parameter vector sequence.  
%   seh = estimated parameter standard error sequence.
%     S = system matrix = [A,B;C,D].
%    Xh = measured output Fourier transform time history.
%    Uh = measured input Fourier transform time history.
%     f = frequency vector, Hz.
%

%
%    Calls:
%      rft.m
%      lesq.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      20 September 1999 - Created and debugged, EAM.
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
[npts,no]=size(z);
ns=no;
[npts,ni]=size(u);
%
%  Initialization.
%
jay=sqrt(-1);
dt=t(2)-t(1);
f=w/(2*pi);
df=f(2)-f(1);
nw=length(w);
%
%  Fourth order low pass butterworth filter coefficients.
%
fc=0.05;
fn=1/(2*dt);
ford=4;
[b,a]=butter(ford,fc/fn);
%
%  Parameter idstp equals the number of data points skipped 
%  between data points used in the identification calculations. 
%
idstp=1;
mpts=npts-idstp-1;
%
%  Initial time delay before any parameter estimation.
%
td=2;
ntd=round(td/dt);
%
%  Time interval between parameter estimation updates.
%
ti=1;
nti=round(ti/dt);
%
%  More initialization.
%
g=32.174;
np=ns*ns+ns*ni;
%np=length(ptrue);
ph=zeros(mpts,np);
seh=zeros(mpts,np);
%perrh=zeros(mpts,np);
%etah=zeros(mpts,np);
%ptrue=c;
X0=zeros(no,nw);
Xh=zeros(mpts,no,nw);
U0=zeros(ni,nw);
Uh=zeros(mpts,ni,nw);
C0=exp(-jay*w'*t(1));
dC=exp(-jay*w'*(idstp+1)*dt);
nstp=0;
icnt=0;
%
%  Use initial values for the trim offset.
%
alf0=z(1,1);
el0=u(1,1);
%
%  Real-time parameter estimation loop starts here.
%
while nstp <= mpts,
  nstp=nstp+idstp+1;
  zn=z(nstp,:)';
  un=u(nstp,:)';
%
%  Compute the low pass filtered values of alpha and el, 
%  and subtract them off before computing the Fourier 
%  transform.  This is done to prevent pollution of 
%  the frequency content by large biases in the time 
%  domain data.  
%
  zn(1)=zn(1)-alf0;
  un(1)=un(1)-el0;
%
%  Recursive Fourier transform calculation.
%
  [X,C]=rft(zn,dC,X0,C0);
  Xh(nstp,:,:)=X;
  X0=X;
  [U,C]=rft(un,dC,U0,C0);
  Uh(nstp,:,:)=U;
  U0=U;
  C0=C;
%
%  Check if it is time for a parameter estimation calculation. 
%
  if ((nstp >= ntd) & (mod(nstp,nti)==0))
%
%  Do equation error parameter estimation in the 
%  frequency domain every ti seconds.
%
    icnt=icnt+1;
    Xe=[X.',U.'];
    Ze=[jay*w(:,ones(1,no)).*X.'];
%
%  Estimate model parameters using equation error 
%  in the frequency domain.
%
%  Longitudinal short period equations.
%
    indx=[1,2,3];
    [Y1,P1,CVAR1]=lesq([Xe(:,indx)],Ze(:,1));
    [Y2,P2,CVAR2]=lesq([Xe(:,indx)],Ze(:,2));
%
%  Lateral / Directional equations.
%
%    indx=[5,11];
%    sa=sin(z(nstp,2));
%    ca=cos(z(nstp,2));
%    gt=g/z(nstp,1);
%    [Y3,P3,CVAR3]=lesq(Xe(:,indx),Ze(:,5)-Xe(:,[6:8])*[sa,-ca,gt]');
%    indx=[5,6,7,10,11];
%    [Y4,P4,CVAR4]=lesq(Xe(:,indx),Ze(:,6));
%    [Y5,P5,CVAR5]=lesq(Xe(:,indx),Ze(:,7));
%
%  Compute and record results.
%
    p=[P1;P2];
%    p=[P1;P2;P3;P4;P5];
    ph(icnt,:)=p';
    serr=[sqrt(diag(CVAR1));sqrt(diag(CVAR2))];
%    serr=[sqrt(diag(CVAR1));sqrt(diag(CVAR2));sqrt(diag(CVAR3));...
%          sqrt(diag(CVAR4));sqrt(diag(CVAR5))];
    seh(icnt,:)=serr';
%    perr=100*(p-ptrue)./ptrue;
%    perrh(:,icnt)=perr;
%    eta=(p-ptrue)./serr;
%    etah(:,icnt)=eta;
%    fprintf(1,'\n     ptrue        p        serr       perr       eta ');
%    fprintf(1,'\n     -----       ---       ----       ----       --- ');
%    for j=1:np,
%      fprintf(1,'\n  %9.5f  %9.5f  %8.5f  %10.2e  %8.5f',...
%                 ptrue(j),p(j),serr(j),perr(j),eta(j));
%    end
%    fprintf(1,'\n');
  end
end
ph=ph([1:icnt],:);
seh=seh([1:icnt],:);
%perrh=perrh(:,[1:icnt]);
%etah=etah(:,[1:icnt]);
%
%  Compute the final estimated parameter covariance matrix.
%
crb=[CVAR1,zeros(3,3);zeros(3,3),CVAR2];
%
%  Assemble state space matrices.
%
A=[p(1),p(2);p(4),p(5)];
B=[p(3);p(6)];
%A=[p(1),p(2),0,0,0,0;...
%   p(4),p(5),0,0,0,0;...
%   0,0,p(7),sin(mean(z(:,2))),-cos(mean(z(:,2))),g/mean(z(:,1));...
%   0,0,p(9),p(10),p(11),0;...
%   0,0,p(14),p(15),p(16),0;...
%   0,0,0,1,tan(mean(z(:,4))),0];
%B=[p(3),0,0;...
%   p(6),0,0;...
%   0,0,p(8);...
%   0,p(12),p(13);...
%   0,p(17),p(18);...
%   0,0,0];
C=eye(size(A,1),size(A,2));
D=zeros(size(B,1),size(B,2));
S=[A,B;C,D];
y=lsim(A,B,C,D,u-ones(length(t),1)*u(1,:),t);
return
