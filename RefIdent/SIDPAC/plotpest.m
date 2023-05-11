function plotpest(p,serr,xlab,ylab,xtlab,leglab)
%
%  function plotpest(p,serr,xlab,ylab,xtlab,leglab)
%
%  Usage: plotpest(p,serr,xlab,ylab,xtlab,leglab);
%
%
%  Description:
%
%    Plots parameter estimates p with 95 percent 
%    confidence (2 sigma) error bars based on serr.  
%    Inputs xlab, ylab, xtlab, and leglab are optional.  
%
%  Input:
%    
%        p = vector or matrix of parameter estimates.
%     serr = vector or matrix of estimated parameter standard errors.
%     xlab = x axis label. 
%     ylab = y axis label. 
%    xtlab = matrix of x axis tick label rows.
%   leglab = matrix of legend label rows.
%
%  Output:
%
%    graphics:
%      2-D plot
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      02 Mar  2000 - Created and debugged, EAM.
%      04 May  2001 - Added serr bars and legend, EAM.
%      06 Mar  2002 - Repaired axis and tick labeling, EAM.
%      24 July 2002 - Modified for multiple parameter set plotting, EAM.
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
[n,m]=size(p);
indx=[1:n]';
%
%  For multiple parameter vectors,
%  plot the parameter estimates over a 
%  width along the abscissa given by spread, 
%  with spacing del.  
%
if m > 1
  indx=indx*ones(1,m);
  spread=0.2;
  del=spread/(m-1);
  for k=2:m,
    indx(:,k)=indx(:,k)+del;
  end
  indx=indx-spread/2;
end
%
%  Make a new figure window, if necessary.
%
if isempty(get(0,'CurrentFigure'))
  figure('Units','normalized','Position',[.445,.27,.545,.61])
  axes('Position',[.17,.11,.77,.82])
else
  clf,
end
axes('XTick',[1:1:n]')
color=['b';'g';'m';'c';'k';'y'];
symbol=['v';'o';'d';'^';'s';'*'];
hold on,
%
%  Draw symbols first.
%
for j=1:n,
  for k=1:m,
    plot(indx(j,k),p(j,k),[color(k,:),symbol(k,:)],...
         'MarkerSize',6,'MarkerFaceColor',color(k,:))
%    legend('Estimate','2-sigma bound',0)
  end
end
%
%  Add error bars.
%
for j=1:n,
  for k=1:m,
    plot([indx(j,k);indx(j,k)],[p(j,k)-2*serr(j,k);p(j,k)+2*serr(j,k)],'r')
    plot(indx(j,k),p(j,k)-2*serr(j,k),'r^',indx(j,k),p(j,k)+2*serr(j,k),'rv','MarkerSize',3)
  end
end
grid on,
if nargin < 3
  xlab='Index';
end
if nargin < 4
  ylab='Parameter Estimates';
end
%
%  Use centered integers for the x axis 
%  tick labels if xtlab is not supplied.
%
if nargin < 5
  xtlab=reshape([num2str([1:1:n]),'  ']',3,n)';
  xtlab=[' '*ones(n,2),xtlab];
end
if exist('leglab','var')
  legstr=['legend(''',leglab(1,:)];
  if m > 1
    for k=2:m,
      legstr=[legstr,''',''',leglab(k,:)];
    end
  end
  legstr=[legstr,''',0)'];
  eval(legstr);
end
xlabel(xlab);
ylabel(ylab);
v=axis;
axis([0 n+1 v(3) v(4)]);
set(gca,'XTickLabel',xtlab);
hold off,
return
