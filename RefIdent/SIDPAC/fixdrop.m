function [fdata,t] = fixdrop(fdata_flt)
%
%  function [fdata,t] = fixdrop(fdata_flt)
%
%  Usage: [fdata,t] = fixdrop(fdata_flt);
%
%  Description:
%
%    Repairs data dropouts identified in the 
%    input flight test data matrix fdata_flt, 
%    according to user input.  
%
%  Input:
%    
%    fdata_flt = matrix of column vector data.
%
%  Output:
%
%    fdata = matrix of column vector data with 
%            data dropouts repaired.
%        t = time vector corresponding to fdata, sec.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      06 August 1999 - Created and debugged, EAM.
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
time=[0:dt:max(t)]';
t=time;
fdata=fdata_flt;
j=0;
while j >= 0,
  j=4;
  jplt=j;
  while j > 0 & j <=n,
    plot(t,fdata(:,j));grid on;
    xlabel('Time (sec)');ylabel(['Channel ',num2str(j)]);
    title(['Maneuver length = ',num2str(max(t)-min(t)),' sec']);
    zoom on;
    fprintf('\n\nZoom is ON, click plot to find dropout times ');
    j=input('\nPlot channel number (0 to fix dropout, -1 to quit) ');
    if j > 0,
      jplt=j;
    end
  end
  if j==0,
%
%  Initial time.
%
    fprintf('\n\nSelect initial time on the graph ');
    fprintf('\nUse right mouse button for manual input ');
    [ti,y,nb]=ginput(1);
    if nb~=1,
      ti=input('\n\nInput initial time (0 to skip) ');
    end
    if ti < 0 
      ti=0;
    end
    ti=round(ti/dt)*dt;
    fprintf('\n\nSelected initial time = %f',ti);
    indi=max(find(time<=ti));
%
%  Final time.
%
    fprintf('\n\nSelect final time on the graph ');
    fprintf('\nUse right mouse button for manual input ');
    [tf,y,nb]=ginput(1);
    if nb~=1,
      tf=input('\n\nInput final time (0 to skip) ');
    end
    if tf <= 0 | tf > max(time),
      tf=max(time);
    end
    tf=round(tf/dt)*dt;
    fprintf('\n\nSelected final time = %f \n',tf);
    indf=min(find(time>=tf));
%
%  Fix the dropout with a linear interpolation.
%
    indx=[indi:indf]';
    di=(indx-indi)/(max(indx)-indi);
    fdata(indx,:)=ones(length(di),1)*fdata(indi,:)+di*(fdata(indf,:)-fdata(indi,:));
    hold on;
    plot(t,fdata(:,jplt),'r+')
    fprintf('\n\nHit <CR> to continue...')
    pause;
    hold off;
  end
end
zoom off;
return
