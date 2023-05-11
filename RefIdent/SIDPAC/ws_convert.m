%
%  script ws_convert.m
%
%  Calling GUI: sid_ws
%
%  Usage: ws_convert;
%
%  Description:
%
%    Converts units for a plotted workspace variable 
%    according to user input.
%
%  Input:
%    
%    ypltvar = plotted workspace variable.
%
%  Output:
%
%    ypltvar = plotted workspace variable with specified units.
%
%

%
%    Author:  Eugene A. Morelli
%
%    Calls:
%      sid_plot.m
%
%    History:  
%      12 Jan 2000 - Created and debugged, EAM.
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

%
%  Get the unit conversion popupmenu value.
%
ncnv=get(gcbo,'Value');
%
%  Check for a legal conversion.
%
if ncnv <= get(gcbo,'Max')
  cnv=char(varconvlab(ncnv));
%
%  Unit conversion command.
%
  switch cnv
    case 'rad to deg',
      ypltvar=ypltvar*180/pi;
    case 'deg to rad',
      ypltvar=ypltvar*pi/180;
    case 'ft to m',
      ypltvar=ypltvar*0.3048;
    case 'm to ft',
      ypltvar=ypltvar/0.3048;
    case 'ft to in',
      ypltvar=ypltvar*12;
    case 'in to ft',
      ypltvar=ypltvar/12;
    case 'g to ft/sec2',
      ypltvar=ypltvar*32.174;
    case 'ft/sec2 to g',
      ypltvar=ypltvar/32.174;
    case 'ft/sec to kts',
      ypltvar=ypltvar/1.6878;
    case 'kts to ft/sec',
      ypltvar=ypltvar*1.6878;
    case 'slug to lbm',
      ypltvar=ypltvar*32.174;
    case 'lbm to slug',
      ypltvar=ypltvar/32.174;
    case 'kg to slug',
      ypltvar=ypltvar/14.594;
    case 'slug to kg',
      ypltvar=ypltvar*14.594;
    case 'lbf to N',
      ypltvar=ypltvar*4.448222;
    case 'N to lbf',
      ypltvar=ypltvar/4.448222;
    case 'original units',
      ypltvar=eval(ypltlab);
  end
end
%
%  Plot command.
%
sid_plot(xpltvar,ypltvar,xpltlab,ypltlab);
return
