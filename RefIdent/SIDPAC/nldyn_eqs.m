function [xd,accel] = nldyn_eqs(p,u,x,c)
%
%  function [xd,accel] = nldyn_eqs(p,u,x,c)
%
%  Usage: [xd,accel] = nldyn_eqs(p,u,x,c);
%
%  Description:
%
%    Computes the state vector derivatives 
%    and acceleration outputs, using full 
%    full nonlinear aircraft dynamics 
%    for output error parameter estimation.  
%
%  Input:
%    
%      p = vector of parameter values.
%      u = input vector.
%      x = state vector = [vt,beta,alfa,p,q,r,phi,the,psi]'.
%      c = cell structure:
%          c{1} = p0oe  = vector of initial parameter values.
%          c{2} = ipoe  = index vector to select estimated parameters.
%          c{3} = ims   = index vector to select measured states.
%          c{4} = imo   = index vector to select model outputs.
%          c{5} = x0    = initial state vector.
%          c{6} = u0    = initial control vector.
%          c{7} = fdata = measured flight test data, 
%                         geometry, and mass/inertia properties.  
%
%  Output:
%
%       xd = time derivative of the state vector.
%    accel = vector of acceleration outputs = [ax,ay,az,pdot,qdot,rdot]'.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:
%      07 Oct  2001 - Created and debugged, EAM.
%      14 Oct  2001 - Modified to use numerical integration routines, EAM.
%      23 July 2002 - Added acceleration outputs, EAM.
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
xd=zeros(length(x),1);
accel=zeros(6,1);
%
%  Initialization.
%
p0oe=c{1};
ipoe=c{2};
ims=c{3};
x0=c{5};
u0=c{6};
ni=length(u0);
%
%  The fdata information was appended to u, to 
%  accommodate the numerical integration.
%  Use transpose to make fdata a row vector.  
%
fdata=u([ni+1:length(u)])';
%
%  State and control vector indices in fdata.
%
xindx=[2:10]';
uindx=[14:16]';
%
%  Assign the estimated parameter vector 
%  elements in p to the proper dynamic model 
%  parameter vector elements in poe.  
%
poe=p0oe;
pindx=find(ipoe==1);
np=length(pindx);
if np > 0
  poe(pindx)=p;
end
%
%  Substitute measured values for states 
%  as indicated by ims.
%
msindx=find(ims==1);
nms=length(msindx);
if nms > 0
%
%  Convert all states to radians.
%
  x(msindx)=fdata(xindx(msindx))*pi/180;
%
%  Except vt.
%
  if any(msindx)==1
    x(1)=x(1)*180/pi;
  end
end
%
%  Nonlinear aircraft dynamics differential equations 
%  for output error parameter estimation.
%
%  Assign constants.
%
sarea=fdata(77);
bspan=fdata(78);
cbar=fdata(79);
xcg=fdata(45)/12;
heng=0.0;
g=32.174;
%
%  Mass property calculations work even when 
%  the input fdata matrix has only one row, 
%  as in this case.  
%
[mass,xcg,ycg,zcg,ixx,iyy,izz,ixz,ci]=massprop(fdata);
%
%  Assign state and control variables.
%
vt=x(1);
beta=x(2);
alfa=x(3);
p=x(4);
q=x(5);
r=x(6);
%phat=p*bspan/(2*vt);
%qhat=q*cbar/(2*vt);
%rhat=r*bspan/(2*vt);
phat=fdata(71);
qhat=fdata(72);
rhat=fdata(73);
phi=x(7);
the=x(8);
psi=x(9);
el=u(1);
ail=u(2);
rdr=u(3);
%
%  Air data.
%
mach=fdata(28);
qbar=fdata(27);
%
%  Engine thrust.
%
thrust=fdata(38)+fdata(39);
%
%  Aerodynamic force and moment coefficient models.
%
%  CX
%
cx=fdata(61);
%cx=poe(1)*(vt-x0(1))/x0(1) + poe(2)*(alfa-x0(3)) + poe(3)*qhat ...
%   + poe(4)*(el-u0(1));
%
%  CY
%
cy=fdata(62);
%cy=poe(11)*(beta-x0(2)) + poe(12)*phat + poe(13)*rhat ...
%   + poe(14)*(ail-u0(2)) + poe(15)*(rdr-u0(3));
%
%  CZ
%
%cz=fdata(63);
cz=poe(21)*(vt-x0(1))/x0(1) + poe(22)*(alfa-x0(3)) + poe(23)*qhat ...
   + poe(24)*(el-u0(1)) + poe(29);
%
%  Cl
%
cl=fdata(64);
%cl=poe(31)*(beta-x0(2)) + poe(32)*phat + poe(33)*rhat ...
%   + poe(34)*(ail-u0(2)) + poe(35)*(rdr-u0(3)) + poe(39);
%
%  Cm
%
%cm=fdata(65);
cm=poe(41)*(vt-x0(1))/x0(1) + poe(42)*(alfa-x0(3)) + poe(43)*qhat ...
   + poe(44)*(el-u0(1)) + poe(49);
%
%  Cn
%
cn=fdata(66);
%cn=poe(51)*(beta-x0(2)) + poe(52)*phat + poe(53)*rhat ...
%   + poe(54)*(ail-u0(2)) + poe(55)*(rdr-u0(3)) + poe(59);
%
%  Compute quantities used often in the state equations. 
%
cb=cos(beta);
us=vt*cos(alfa)*cb;
vs=vt*sin(beta);
ws=vt*sin(alfa)*cb;
sth=sin(the);  cth=cos(the);
sph=sin(phi);  cph=cos(phi);
sps=sin(psi);  cps=cos(psi);
qs=qbar*sarea; qsb=qs*bspan;
%
%  Translational acceleration.
%
accel(1)=(qs*cx + thrust)/ci(10);
accel(2)=qs*cy/ci(10);
accel(3)=qs*cz/ci(10);
%
%  Force equations.
%
udot=r*vs-q*ws-g*sth + accel(1);
vdot=p*ws-r*us+g*cth*sph + accel(2);
wdot=q*us-p*vs+g*cth*cph + accel(3);
%
%  vt equation.
%
xd(1)=(us*udot+vs*vdot+ws*wdot)/vt + poe(10);
%
%  beta equation.
%
xd(2)=(vt*vdot-vs*xd(1))/(cb*vt*vt) + poe(20);
%
%  alfa equation.
%
xd(3)=(wdot*us-ws*udot)/(us*us+ws*ws) + poe(30);
%
%  Moment equations.
%
%  p equation.
%
xd(4)=(ci(2)*p+ci(1)*r+ci(4)*heng)*q + qsb*(ci(3)*cl+ci(4)*cn) + poe(40);
%
%  q equation.
%
xd(5)=(ci(5)*p-ci(7)*heng)*r + ci(6)*(r*r-p*p) + qs*cbar*ci(7)*cm + poe(50);
%
%  r equation.
%
xd(6)=(ci(8)*p-ci(2)*r+ci(9)*heng)*q + qsb*(ci(4)*cl + ci(9)*cn) + poe(60);
%
%  Kinematic equations.
%
%  psi equation.
%
xd(9)=(q*sph+r*cph)/cth + poe(63);
%
%  phi equation.
%
xd(7)=p + sth*xd(9) + poe(61);
%
%  the equation.
%
xd(8)=q*cph-r*sph + poe(62);
%
%  Angular acceleration.
%
accel(4:6)=xd(4:6);
return
