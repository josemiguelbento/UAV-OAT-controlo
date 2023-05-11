function [x,xeng,xscl,nfp] = dox(ivar,ivr,xtype)
%
%  function [x,xeng,xscl,nfp] = dox(ivar,ivr,xtype)
%
%  Usage: [x,xeng,xscl,nfp] = dox(ivar,ivr,xtype);
%
%  Description:
%
%    Generates independent variable settings for statistical 
%    experiment design to collect data for response surface modeling.  
%    Input ivar is a vector of indices that select which of the 
%    independent variable ranges in ivr are to be used in the 
%    experiment design.  Input xtype selects either a full 
%    two-level factorial experiment design, a face-centered 
%    central composite design, or a spherical central composite 
%    design with or without corner points.  Each row of output 
%    matrix x contains normalized settings for the independent variables, 
%    and the corresponding rows of xeng give the independent 
%    variable settings in engineering units.  
%
%
%  Input:
%
%   ivar = vector of indices for the selected independent variables.
%
%    ivr = independent variable ranges:
%      row 1  = beta = sideslip angle, deg.
%      row 2  = alf  = angle of attack, deg.
%      row 3  = mach = mach number.
%      row 4  = phat = non-dimensional roll rate.
%      row 5  = qhat = non-dimensional pitch rate.
%      row 6  = rhat = non-dimensional yaw rate.
%      row 7  = dssy = symmetric stabilator deflection, deg.
%      row 8  = daas = asymmetric aileron deflection, deg.
%      row 9  = dras = asymmetric rudder deflection, deg.
%      row 10 = dnsy = symmetric leading edge flap deflection, deg.
%      row 11 = dfsy = symmetric trailing edge flap deflection, deg.
%      row 12 = alt  = altitude, ft.
%
%  xtype = experiment type (optional):
%          = 0 for two-level full factorial design (default).
%          = 1 for face-centered central composite design.
%          = 2 for spherical central composite design (CCD). 
%          = 3 for spherical CCD inside the hyper-cube, with corner points.
%          = 4 for face-centered CCD with Box-Behnken points
%              (same as 3-level factorial design).
%
%
%  Output:
%
%      x = array of normalized values for the k independent 
%          variables for the experiment design.  Each row 
%          contains the settings for one run.  
%
%   xeng = x array converted to engineering units.  
%
%   xscl = vector of independent variable scaling factors 
%          to convert values in x to engineering units.   
%
%    nfp = number of factorial points in the top rows of x and xeng.
%
%

%
%    Calls:
%      cvec.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Mar 2001 - Created and debugged, EAM.
%      23 Apr 2001 - Added spherical CCD, 
%                    with optional corner points, EAM.
%      10 Mar 2002 - Added nesting, EAM.
%      17 Jun 2002 - Added 3-level factorial design, EAM.
%      19 Jun 2002 - Removed nesting and added nfp output, EAM.
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
ivar=cvec(ivar);
nvar=length(ivar);
%
%  Set experiment type.
%
if nargin < 3 | isempty(xtype)
  xtype=0;
end
%
%  Find the scaling values.
%
xscl=(ivr(ivar,3)-ivr(ivar,1))/2;
%
%  Find the center values.
%
xctr=(ivr(ivar,3)+ivr(ivar,1))/2;
%
%  Two-level full factorial design.
%
npts=2^nvar;
nfp=npts;
%
%  Alpha for rotatable CCD.
%
%alf=npts^0.25;
%
%  Alpha for spherical CCD.
%
alf=sqrt(nvar);
%
%  Binary representation of decimal integers
%  are the basis of the two-level full factorial
%  experiment design.  
%
irun=[0:1:npts-1]';
%
%  Convert decimal integers in vector irun 
%  to scaled integer array for the two-level
%  full factorial experiment design.  
%
x=zeros(npts,nvar);
for i=1:npts,
  for k=1:nvar
    if bitget(irun(i),k)==1
      x(i,k)=1;
    else
      x(i,k)=-1;
    end
  end
end
%
%  Save the two-level full factorial design points.
%
xf=x;
%
%  Add a center point.  Normally, there would be more than 
%  one of these to quantify the variance for repeated 
%  measurements.  
%
x=[x;zeros(1,nvar)];
npts=npts+1;
%
%  Add the face-centered points to get a 
%  face-centered central composite design or star points
%  to get a spherical central composite design. 
%
if xtype>0
  x=[x;zeros(2*nvar,nvar)];
  for j=1:nvar,
    if xtype==1 | xtype==4
      x(npts+2*(j-1)+1,j)=-1;
      x(npts+2*(j-1)+2,j)=1;
    else
      x(npts+2*(j-1)+1,j)=-alf;
      x(npts+2*(j-1)+2,j)=alf;
    end
  end
  npts=npts+2*nvar;
end
%
%  For a spherical CCD inside the hyper-cube, 
%  place all points within the independent 
%  variable subspace by scaling the star points 
%  to +/- 1.  
%
if xtype==3
  x=x/alf;
%
%  Add corner points to the spherical CCD
%  for a spherical CCD inside the hyper-cube.
%
  x=[x;xf];
  npts=npts + 2^nvar;
end
%
%  Add Box-Behnken points for the 
%  3-level factorial design.  
%
if xtype==4
%
%  For each independent variable,
%  change the factorial points on 
%  the lower level face to mid-level. 
%  Doing this for all independent variables
%  generates all the Box-Behnken points.
%
%  Box-Behnken points are already included
%  in a face-centered CCD for less than three
%  independent variables.  
%
  if nvar > 2
    for j=1:nvar,
%
%  Start with the factorial points.
%
      xbb=xf;
      indx=find(xf(:,j)==-1);
      xbb(indx,j)=zeros(length(indx),1);
      x=[x;xbb(indx,:)];
      npts=npts+length(indx);
    end
  end
end
%
%  Compute the x array in engineering units.
%
%npts=size(x,1);
xeng=x;
for j=1:nvar,
  xeng(:,j)=x(:,j)*xscl(j) + xctr(j)*ones(npts,1);
end
return
