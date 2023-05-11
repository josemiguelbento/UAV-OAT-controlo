function model_results(fname,p,crb)
%
%  function model_results(fname,p,crb)
%
%  Usage: model_results(fname,p,crb);
%
%  Description:
%
%    Writes the modeling results p and standard errors 
%    computed from crb to an ASCII text file called fname, 
%    with the data delimited by spaces.  The data in   
%    output file fname can be read directly into an Excel 
%    spreadsheet using the File\Open command.  From there, 
%    the data can be cut and pasted into a Word table or an 
%    Excel table template, using the Paste Special command 
%    and selecting only the value for pasting, to preserve
%    the template formatting.  The resulting Excel table 
%    can be cut and pasted directly into a Word document.  
%
%
%  Input:
%    
%   fname = name of ASCII output data file.
%       p = parameter vector for ordinary polynomial function expansion.
%     crb = Cramer-Rao bound matrix.
%
%
%  Output:
%
%     ASCII file called fname
%
%

%
%    Calls:
%      cvar.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      18 Feb 2002 - Created and debugged, EAM.
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
p=cvec(p);
np=length(p);
%
%  Loop over the model terms.
%
serr=sqrt(diag(crb));
A=[[1:1:np]',p,serr];
dlmwrite(fname,A,' ');
fprintf('\n Data written to file %s \n\n',fname)
return
