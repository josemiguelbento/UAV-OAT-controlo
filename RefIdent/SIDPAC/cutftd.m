function [fdata,t] = cutftd(fdata_flt)
%
%  function [fdata,t] = cutftd(fdata_flt)
%
%  Usage: [fdata,t] = cutftd(fdata_flt);
%
%  Description:
%
%    Cuts input flight test data matrix fdata_flt 
%    according to user input.  
%
%  Input:
%    
%    fdata_flt = matrix of column vector data.
%
%  Output:
%
%    fdata = matrix of column vector data cut according to user input.
%        t = time vector corresponding to fdata, sec.
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      06 August 1999 - Created and debugged, EAM.
%      29 August 1999 - Fixed input handling so return input exits, EAM.
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
[npts,n]=size(fdata_flt);
t=fdata_flt(:,1)-fdata_flt(1,1);
dt=1/round(1/(t(2)-t(1)));
time=[0:dt:(npts-1)*dt]';
t=time;
fdata=fdata_flt;
j=0;
while j >= 0,
  j=4;
  while j > 0 & j <=n,
    plot(t,fdata(:,j));grid on;
    xlabel('Time (sec)');ylabel(['Channel ',num2str(j)]);
    title(['Maneuver length = ',num2str(max(t)-min(t)),' sec']);
    j=input('\nPlot channel number (0 to cut, -1 to quit) ');
    if isempty(j),
      j=-1;
    end
  end
  if j==0,
%
%  Initial time input.
%
    fprintf('\n\nSelect initial time on the graph ');
    fprintf('\nUse right mouse button for manual input ');
    [ti,y,nb]=ginput(1);
    if nb~=1,
      ti=input('\n\nInput initial time  ');
      tf=input('\nInput final time  ');
    else
%
%  Final time input.
%
      fprintf('\n\nSelect final time on the graph ');
      [tf,y,nb]=ginput(1);
    end
%
%  Initial time data conditioning.
%
    if ti < 0 
      ti=0;
    end
    ti=round(ti/dt)*dt;
    fprintf('\n\nSelected initial time = %f',ti);
    indi=max(find(time<=ti));
%
%  Final time data conditioning.
%
    if tf <= 0 | tf > max(time),
      tf=max(time);
    end
    tf=round(tf/dt)*dt;
    fprintf('\n\nSelected final time = %f \n',tf);
    indf=min(find(time>=tf));
%
%  Cut the maneuver.
%
    t=time(indi:indf);
    fdata=fdata_flt([indi:indf],:);
  end
end
%
%  Make time vector start at zero.
%
t=t-t(1);
return
