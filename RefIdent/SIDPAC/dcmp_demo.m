%
%  script dcmp_demo.m
%
%  Usage: dcmp_demo;
%
%  Description:
%
%    Demonstrates data compatibility analysis 
%    using flight test data from the NASA
%    F-18 High Alpha Research Vehicle (HARV).  
%
%  Input:
%
%    None
%
%  Output:
%
%    graphics:
%      GUI
%      2D plots
%

%
%    Calls:
%      harv2sid.m
%      sid_dcmp.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      29 Oct 2000 - Created and debugged, EAM.
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
%  Load the flight test data.
%
load 'dcmp_lon_example.mat';
whos
%
%  Convert the data to standard format.
%
[fdata,varlab]=harv2sid(fdata_153b);
%
%  Start the data compatibility GUI.
%
sid_dcmp
echo off;
fprintf('\n\n Press any key to continue ...'),pause,
fprintf('\n\n End of demonstration \n\n')
return
