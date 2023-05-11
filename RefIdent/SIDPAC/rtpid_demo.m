%
%  script rtpid_demo.m
%
%  Usage: rtpid_demo;
%
%  Description:
%
%    Demonstrates real-time parameter estimation in the 
%    frequency domain using F-16 linear longitudinal dynamics
%    and user input for the elevator deflection.  Output
%    is a set of real-time plot animations.  
%
%  Input:
%
%    fore and aft mouse movements for elevator deflections
%
%  Output:
%
%    graphics:
%      real-time plot animations
%

%
%    Calls:
%      rft.m
%      lesq.m
%      mod.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      15 Dec 1999 - Created and debugged, EAM.
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
if ~exist('t'),
  dt=0.02;
  tmax=20;
  t=[0:dt:tmax]';
else
  tmax=max(t);
  dt=1/round(1/(t(2)-t(1)));
end
npts=length(t);
if ~exist('action'),
  action='init';
end
nplt=6;
%
%  Initialize.
%
if strcmp(action,'init'),
%
%  Simulation initialization.
%
  if ~exist('stabpuh'),
    lstab=1;
  else
    lstab=get(stabpuh,'Value');
  end
  As=[-0.6,0.95;...
      -4.3,-1.2];
  Bs=[-0.115,-5.157]';
  Cs=eye(2,2);
  Ds=zeros(2,1);
  ptrue=[-.60,.95,-0.115,-4.3,-1.2,-5.157]';
  if lstab==2,
    As=[-0.6,0.95;...
         1.0,-1.2];
    ptrue=[-.60,.95,-0.115,1,-1.2,-5.157]';
  end
  [ns,ni]=size(Bs);
  [no,ns]=size(Cs);
  phi=eye(ns,ns)+As*dt+As*As*dt*dt/2;
  gam=(dt*eye(ns,ns)+As*dt*dt/2+As*As*dt*dt*dt/6)*Bs;
  nselev=[0.1;0.1];
  g=32.174;
%
%  Estimation initialization.
%
  jay=sqrt(-1);
  f=[0.1:.04:1.5]';
  df=f(2)-f(1);
  w=2*pi*f;
  nw=length(w);
  nstp=1;
  td=1;
  ntd=round(td/dt);
  ti=1;
  nti=round(ti/dt);
  np=length(ptrue);
  ph=zeros(np,npts);
  serrh=zeros(np,npts);
  perrh=zeros(np,npts);
  etah=zeros(np,npts);
  X0=zeros(no,nw);
  Xh=zeros(npts,no,nw);
  U0=zeros(ni,nw);
  Uh=zeros(npts,ni,nw);
  C0=exp(-jay*w'*t(1));
  dC=exp(-jay*w'*nstp*dt);
%
%  Figure initialization.
%
  npstp=1;
  labmat=['Za ';'Zq ';'Zde';'Ma ';'Mq ';'Mde'];
  axmat=[[0 20 -4 4];[0 20 -4 4];[0 20 -4 4];...
         [0 20 -8 0];[0 20 -4 4];[0 20 -10 -2]];
  if lstab==2,
    axmat=[[0 20 -4 4];[0 20 -4 4];[0 20 -4 4];...
           [0 20 -2 6];[0 20 -4 4];[0 20 -10 -2]];
  end
  if ~exist('puh'),
    plti=[1,4,6]';
  else
    plti(1)=get(puh(1),'Value');
    plti(2)=get(puh(3),'Value');
    plti(3)=get(puh(5),'Value');
  end
  if ~exist('idpuh'),
    lid=1;
  else
    lid=get(idpuh,'Value');
  end
  figh=figure(1);
  clf;
  rect=[.025 .05 .95 .85];
  set(figh,'Name','Real-Time PID Demo', ...
           'Units','normalized', ...
           'Position',rect, ...
           'NumberTitle','off', ...
           'Visible','on', ...
           'NextPlot','add');
%
%  Set up popup menus to select estimated parameter plots.
%
  btnWid=0.05;
  btnHt=0.05;
  xPos=0.01;
  yPos=0.78;
  spacing=0.29;
  puh=zeros(nplt,1);
%
%  Plot 1 popup menu initialization.
%
  puPos1=[xPos yPos btnWid btnHt];
  popupStr=reshape(' 1  2  3  4  5  6 ',3,6)';
  puh(1)=uicontrol( 'Style','popup', ...
                    'Units','normalized', ...
                    'Position',puPos1, ...
                    'String',popupStr);
  set(puh(1),'Value',plti(1));
%
%  Plot 3 popup menu initialization.
%
  puPos3=[xPos yPos-spacing btnWid btnHt];
  popupStr=reshape(' 1  2  3  4  5  6 ',3,6)';
  puh(3)=uicontrol( 'Style','popup', ...
                    'Units','normalized', ...
                    'Position',puPos3, ...
                    'String',popupStr);
  set(puh(3),'Value',plti(2));
%
%  Plot 5 popup menu initialization.
%
  puPos5=[xPos yPos-2*spacing btnWid btnHt];
  popupStr=reshape(' 1  2  3  4  5  6 ',3,6)';
  puh(5)=uicontrol( 'Style','popup', ...
                    'Units','normalized', ...
                    'Position',puPos5, ...
                    'String',popupStr);
  set(puh(5),'Value',plti(3));
%
%  Set up 3x2 subplots with labels.
%
  phdl=zeros(nplt,1);
  head=zeros(nplt,1);
  tail=zeros(nplt,1);
  pemark=zeros(nplt,1);
  sebar=zeros(nplt,1);
%
%  Plot 1 initialization.
%
  phdl(1)=subplot(3,2,1);
  plot(t,ptrue(plti(1))*ones(npts,1),'b--')
  axis(axmat(plti(1),:));grid on;
  ylabel(labmat(plti(1),:),'FontSize',14)
  head(1) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(1)=line( 'color','g', ...
                'LineStyle','-', ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
  pemark(1) = line( 'color','r', ...
                    'Marker','d', ...
                    'markersize',5, ...
                    'erase','none', ...
                    'xdata',[],'ydata',[]);
  sebar(1) = line( 'color','r', ...
                   'erase','none', ...
                   'xdata',[],'ydata',[]);
%
%  Plot 3 initialization.
%
  phdl(3)=subplot(3,2,3);
  plot(t,ptrue(plti(2))*ones(npts,1),'b--')
  axis(axmat(plti(2),:));grid on;
  ylabel(labmat(plti(2),:),'FontSize',14)
  head(3) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(3)=line( 'color','g', ...
                'LineStyle','-', ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
  pemark(3) = line( 'color','r', ...
                    'Marker','d', ...
                    'markersize',5, ...
                    'erase','none', ...
                    'xdata',[],'ydata',[]);
  sebar(3) = line( 'color','r', ...
                   'erase','none', ...
                   'xdata',[],'ydata',[]);
%
%  Plot 5 initialization.
%
  phdl(5)=subplot(3,2,5);
  plot(t,ptrue(plti(3))*ones(npts,1),'b--')
  axis(axmat(plti(3),:));grid on;
  ylabel(labmat(plti(3),:),'FontSize',14)
  head(5) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(5)=line( 'color','g', ...
                'LineStyle','-', ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
  pemark(5) = line( 'color','r', ...
                    'Marker','d', ...
                    'markersize',5, ...
                    'erase','none', ...
                    'xdata',[],'ydata',[]);
  sebar(5) = line( 'color','r', ...
                   'erase','none', ...
                   'xdata',[],'ydata',[]);
%
%  Plot 2 initialization.
%
  phdl(2)=subplot(3,2,2);
  axis([0 20 -4 4]);grid on;
  ylabel('de (deg)','FontSize',14)
  head(2) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(2)=line( 'color','g', ...
                'LineStyle','-', ...
                'LineWidth',1.5, ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
%
%  Plot 4 initialization.
%
  phdl(4)=subplot(3,2,4);
  axis([0 20 -4 4]);grid on;
  ylabel('alpha (deg)','FontSize',14)
  head(4) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(4)=line( 'color','g', ...
                'LineStyle','-', ...
                'LineWidth',1.5, ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
%
%  Plot 6 initialization.
%
  phdl(6)=subplot(3,2,6);
  axis([0 20 -6 6]);grid on;
  set(gca,'YTick',[-6 -4 -2 0 2 4 6]);
  ylabel('q (dps)','FontSize',14)
  head(6) = line( 'color','r', ...
                  'Marker','.', ...
                  'markersize',20, ...
                  'erase','xor', ...
                  'xdata',[],'ydata',[]);
  tail(6)=line( 'color','g', ...
                'LineStyle','-', ...
                'LineWidth',1.5, ...
                'erase','none', ...
                'xdata',[],'ydata',[]);
  set(phdl,'Drawmode','fast', ...
           'Visible','on', ...
           'NextPlot','add');
%
%  Information for all buttons.
%
  yiPos=0.70;
  xPos=0.92;
  btnLen=0.07;
  btnWid=0.06;
  spacing=0.03;
%
%  Start button.
%
  btnNumber=1;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  labelStr='Start';
  callbackStr='action=''play'';rtpid_demo;';
  btnPos=[xPos yPos-spacing btnLen btnWid];
  startHndl=uicontrol( 'Style','pushbutton', ...
                       'Units','normalized', ...
                       'Position',btnPos, ...
                       'String',labelStr, ...
                       'Interruptible','on', ...
                       'Callback',callbackStr);
%
%  Reset button.
%
  btnNumber=2;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  labelStr='Reset';
  callbackStr='action=''init'';rtpid_demo;';
  btnPos=[xPos yPos-spacing btnLen btnWid];
  resetHndl=uicontrol( 'Style','pushbutton', ...
                       'Units','normalized', ...
                       'Position',btnPos, ...
                       'Enable','off', ...
                       'String',labelStr, ...
                       'Callback',callbackStr);
%
%  Stop button.
%
  btnNumber=3;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  labelStr='Stop';
  callbackStr='action=''stop'';';
  btnPos=[xPos yPos-spacing btnLen btnWid];
  stopHndl=uicontrol( 'Style','pushbutton', ...
                      'Units','normalized', ...
                      'Position',btnPos, ...
                      'Enable','off', ...
                      'String',labelStr, ...
                      'Callback',callbackStr);
%
%  Close button.
%
  btnNumber=4;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  labelStr='Close';
  callbackStr='clear_rtpid_demo_fig;';
  btnPos=[xPos yPos-spacing btnLen btnWid];
  closeHndl=uicontrol( 'Style','pushbutton', ...
                       'Units','normalized', ...
                       'Position',btnPos, ...
                       'Enable','on', ...
                       'String',labelStr, ...
                       'Callback',callbackStr);
%
%  ID button popup menu initialization.  
%
  btnNumber=5;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  btnPos=[xPos yPos-spacing btnLen btnWid];
  popupStr=reshape(' ID on   ID off ',8,2)';
  idpuh=uicontrol( 'Style','popup', ...
                   'Units','normalized', ...
                   'Position',btnPos, ...
                   'String',popupStr);
  set(idpuh,'Value',lid);
%
%  System stability button popup menu initialization.  
%
  btnNumber=6;
  yPos=yiPos-(btnNumber-1)*(btnWid+spacing);
  btnPos=[xPos yPos-spacing btnLen btnWid];
  popupStr=reshape(' Stable Unstable',8,2)';
  stabpuh=uicontrol( 'Style','popup', ...
                     'Units','normalized', ...
                     'Position',btnPos, ...
                     'String',popupStr, ...
                     'FontSize',7);
  set(stabpuh,'Value',lstab);
%
%  Get the x-y cursor position continuously in 
%  variable pt when the cursor is over the figure window.  
%
  set(figh,'WindowButtonMotionFcn','pt=get(figh,''CurrentPoint'');');
%
%  Run the simulation.
%
elseif strcmp(action,'play'),
  tic;
  set(resetHndl,'Enable','on');
  set(stopHndl,'Enable','on');
  set(closeHndl,'Enable','off');
  pt=get(figh,'CurrentPoint');
  u0=pt;
%
%  The time step is dt.
%
  y=zeros(npts,nplt);
  u=zeros(npts,1);
  j=1;
  ys=zeros(ns,1);
  icnt=0;
%
%  The main simulation loop.
%
  while ((action=='play')&((j<=npts)*ones(1,4))),
%
%  Initial state.
%
    x0=ys;
%
%  Control input from the user.
%
    y(j,2)=(pt(2)-u0(2))*10;
    u(j)=y(j,2);
%
%  Compute simulation outputs.
%
    ys=phi*x0+gam*u(j);
%
%  Add measurement noise.
%
    nse=nselev.*randn(2,1);
    y(j,4)=ys(1)+nse(1);
    y(j,6)=ys(2)+nse(2);
%
%  Insert delay here for fast computers.
%  Need 0.02 sec delay for a 1.0 GHz computer.
%
    pause(0.02);
%
%  Real-time parameter estimation code.
%
%  Sample rate for the recursive Fourier transform data is dt*nstp.
%
    if ((lid==1) & (mod(j-1,nstp)==0)),
%
%  Sample data for the recursive Fourier transform.
%
      zn=[y(j,4),y(j,6)]';
      un=y(j,2);
%
%  Recursive Fourier transform calculation.
%
      [X,C]=rft(zn,dC,X0,C0);
      Xh(j,:,:)=X;
      X0=X;
      [U,C]=rft(un,dC,U0,C0);
      Uh(j,:,:)=U;
      U0=U;
      C0=C;
%
%  Check if it is time for a parameter estimation calculation. 
%
      if ((j-1 >= ntd) & (mod(j-1,nti)==0)),
%
%  Do equation error parameter estimation in the frequency 
%  domain every ti seconds.
%
        icnt=icnt+1;
        Xe=[X.',U.'];
        Ze=[jay*w(:,ones(1,no)).*X.'];
%
%  Estimate model parameters using equation error in the frequency domain.
%
%  Longitudinal short period equations.
%
        indx=[1,2,3];
        [Y1,P1,CVAR1]=lesq([Xe(:,indx)],Ze(:,1));
        [Y2,P2,CVAR2]=lesq([Xe(:,indx)],Ze(:,2));
%
%  Compute and record results.
%
        p=[P1;P2];
        ph(:,icnt)=p;
        serr=[sqrt(diag(CVAR1));sqrt(diag(CVAR2))];
        serrh(:,icnt)=serr;
        perr=100*(p-ptrue)./ptrue;
        perrh(:,icnt)=perr;
%
%  Don't update eta if any serr is zero.
%
        if all(serr)
          eta=(p-ptrue)./serr;
          etah(:,icnt)=eta;
        end
%
%  Plot parameter estimates and standard errors.
%
        set(pemark(1),'xdata',t(j),'ydata',ph(plti(1),icnt));
        ll=ph(plti(1),icnt)-2*serrh(plti(1),icnt);
        ul=ph(plti(1),icnt)+2*serrh(plti(1),icnt);
        set(sebar(1),'xdata',[t(j);t(j)],'ydata',[ll;ul]);
        set(pemark(3),'xdata',t(j),'ydata',ph(plti(2),icnt));
        ll=ph(plti(2),icnt)-2*serrh(plti(2),icnt);
        ul=ph(plti(2),icnt)+2*serrh(plti(2),icnt);
        set(sebar(3),'xdata',[t(j);t(j)],'ydata',[ll;ul]);
        set(pemark(5),'xdata',t(j),'ydata',ph(plti(3),icnt));
        ll=ph(plti(3),icnt)-2*serrh(plti(3),icnt);
        ul=ph(plti(3),icnt)+2*serrh(plti(3),icnt);
        set(sebar(5),'xdata',[t(j);t(j)],'ydata',[ll;ul]);
      end
    end
%
%  Draw lines on the plots.
%
    if ((mod(j-1,npstp)==0))
      for k=2:2:nplt,
        set(head(k),'xdata',t(j),'ydata',y(j,k));
        set(tail(k),'xdata',t(j),'ydata',y(j,k));
        drawnow;
      end
    end
    j=j+1;
  end
  ph=ph(:,[1:icnt]);
  serrh=serrh(:,[1:icnt]);
  perrh=perrh(:,[1:icnt]);
  etah=etah(:,[1:icnt]);
  set(closeHndl,'Enable','on');
  action='init';
  toc,
end
return
