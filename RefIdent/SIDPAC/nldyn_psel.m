%
%  script nldyn_psel.m
%
%  Usage: nldyn_psel;
%
%  Description:
%
%    Initializes and selects the model 
%    parameters to be estimated for 
%    output error parameter estimation.
%
%  Input:
%
%    None
%
%  Output:
%
%   p0oe = initial values for the output error model parameters.
%   ipoe = index vector indicating which output error model 
%          parameters are to be estimated.  
%   plab = labels for the model parameters.
%    ims = index vector indicating which states 
%          will use measured values.
%    imo = index vector indicating which model outputs
%          will be calculated.  
%     cc = cell structure:
%          cc{1} = p0oe  = vector of initial parameter values.
%          cc{2} = ipoe  = index vector to select estimated parameters.
%          cc{3} = ims   = index vector to select measured states.
%          cc{4} = imo   = index vector to select model outputs.
%          cc{5} = x0    = initial state vector.
%          cc{6} = u0    = initial control vector.
%          cc{7} = fdata = array of measured flight test data, 
%                          geometry, and mass/inertia properties.  
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      07 Oct  2001 - Created and debugged, EAM.
%      04 Nov  2001 - Removed checks for prior variable definitions, EAM.
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

%
%  Initial values for the estimated parameters.
%
%    p0oe(1:10)  =  CX parameters
%    p0oe(11:20) =  CY parameters
%    p0oe(21:30) =  CZ parameters
%    p0oe(31:40) =  Cl parameters
%    p0oe(41:50) =  Cm parameters
%    p0oe(51:60) =  Cn parameters
%    p0oe(61:70) =  spare parameters
%
%      1  2  3  4  5  6  7  8  9  10
p0oe=[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % CX
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % CY
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % CZ
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % Cl
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % Cm
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % Cn
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0]';   % spare
%
%
%  ipoe element = 1 to estimate the corresponding parameter.
%               = 0 to exclude the corresponding parameter from the estimation.
%
%
%      1  2  3  4  5  6  7  8  9  10
ipoe=[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % CX
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % CY
       0, 1, 0, 1, 0, 0, 0, 0, 1, 0,...  % CZ
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % Cl
       0, 1, 1, 1, 0, 0, 0, 0, 1, 0,...  % Cm
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...  % Cn
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0]';   % spare
%
%  Labels for the instrumentation error parameters.
%
plab=[ 'CX1 ';'CX2 ';'CX3 ';'CX4 ';'CX5 ';'CX6 ';'CX7 ';'CX8 ';'CX9 ';'CX10';...
       'CY1 ';'CY2 ';'CY3 ';'CY4 ';'CY5 ';'CY6 ';'CY7 ';'CY8 ';'CY9 ';'CY10';...
       'CZ1 ';'CZ2 ';'CZ3 ';'CZ4 ';'CZ5 ';'CZ6 ';'CZ7 ';'CZ8 ';'CZ9 ';'CZ10';...
       'Cl1 ';'Cl2 ';'Cl3 ';'Cl4 ';'Cl5 ';'Cl6 ';'Cl7 ';'Cl8 ';'Cl9 ';'Cl10';...
       'Cm1 ';'Cm2 ';'Cm3 ';'Cm4 ';'Cm5 ';'Cm6 ';'Cm7 ';'Cm8 ';'Cm9 ';'Cm10';...
       'Cn1 ';'Cn2 ';'Cn3 ';'Cn4 ';'Cn5 ';'Cn6 ';'Cn7 ';'Cn8 ';'Cn9 ';'Cn10';...
       'phib';'theb';'psib';'    ';'    ';'    ';'    ';'    ';'    ';'    '];
%
%
%  ims = 1 to use measured values 
%          for the corresponding state.
%      = 0 to use computed model values 
%          for the corresponding state.  
%
%  x = [vt,beta,alfa,p,q,r,phi,the,psi]
%
ims=[   1,  1,   0,  1,0,1, 1,  1,  1];
%
%
%  imo = 1 to select the corresponding output
%          to be included in the model output.
%      = 0 to omit the corresponding output 
%          from the model output. 
%
%  y = [vt,beta,alfa,p,q,r,phi,the,psi,ax,ay,az,pdot,qdot,rdot]
%
imo=[   0,  0,   1,  0,1,0, 0,  0,  0, 0, 0, 1,  0,   0,   0  ];
%
%
%   x0 = initial state vector.  
%
%    x = [vt,beta,alfa,p,q,r,phi,the,psi]'
%
x0=[fdata(1,2),fdata(1,[3:10])*pi/180]';
%
%
%   u0 = initial control vector.  
%
%    u = [el,ail,rdr]'
%
u0=[fdata(1,[14:16])*pi/180]';
%
%
%   cc = cell structure:
%        cc{1} =  p0oe  = vector of initial parameter values.
%        cc{2} =  ipoe  = index vector to select estimated parameters.
%        cc{3} =  ims   = index vector to select measured states.
%        cc{4} =  imo   = index vector to select model outputs.
%        cc{5} =  x0    = initial state vector.
%        cc{6} =  u0    = initial control vector.
%        cc{7} =  fdata = array of measured flight test data, 
%                         geometry, and mass/inertia properties.  
%
cc=cell(7,1);
cc{1}=p0oe;
cc{2}=ipoe;
cc{3}=ims;
cc{4}=imo;
cc{5}=x0;
cc{6}=u0;
cc{7}=fdata;
return
