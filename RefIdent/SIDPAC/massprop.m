function [mass,xcg,ycg,zcg,ixx,iyy,izz,ixz,c] = massprop(fdata)
%
%  function [mass,xcg,ycg,zcg,ixx,iyy,izz,ixz,c] = massprop(fdata)
%
%  Usage: [mass,xcg,ycg,zcg,ixx,iyy,izz,ixz,c] = massprop(fdata);
%
%  Description:
%
%    Computes mass properties based on 
%    measured flight data from standard data array fdata.
%
%  Input:
%    
%    fdata = flight test data array in standard configuration.
%
%  Output:
%
%    mass = aircraft mass.
%    xcg = X C.G. position, in.
%    ycg = Y C.G. position, in.
%    zcg = Z C.G. position, in.
%    ixx = body axis X moment of inertia, slug-ft2.
%    iyy = body axis Y moment of inertia, slug-ft2.
%    izz = body axis Z moment of inertia, slug-ft2.
%    ixz = body axis X-Z moment of inertia, slug-ft2.
%      c = vector of inertia constants for aircraft
%          nonlinear equations of motion.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      18 Jan 2000 - Created and debugged, EAM.
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
[npts,n]=size(fdata);
xcg=sum(fdata(:,45))/npts;
ycg=sum(fdata(:,46))/npts;
zcg=sum(fdata(:,47))/npts;
mass=sum(fdata(:,48))/npts;
ixx=sum(fdata(:,49))/npts;
iyy=sum(fdata(:,50))/npts;
izz=sum(fdata(:,51))/npts;
ixz=sum(fdata(:,52))/npts;
c=zeros(13,1);
gam=ixx*izz-ixz^2;
c(1)=((iyy-izz)*izz-ixz^2)/gam;
c(2)=(ixx-iyy+izz)*ixz/gam;
c(3)=izz/gam;
c(4)=ixz/gam;
c(5)=(izz-ixx)/iyy;
c(6)=ixz/iyy;
c(7)=1.0/iyy;
c(8)=(ixx*(ixx-iyy)+ixz^2)/gam;
c(9)=ixx/gam;
c(10)=mass;
c(11)=xcg;
c(12)=ycg;
c(13)=zcg;
return
