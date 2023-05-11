%
%  script clear_rtpid_demo_fig.m
%
%  Usage: clear_rtpid_demo_fig;
%
%  Description:
%
%    Clears the figure window and removes workspace 
%    variables related to the figure drawn for 
%    rtpid_demo.  
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 Dec 1999 - Created and debugged, EAM.
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
set(gcf,'WindowButtonMotionFcn','');
clear figh puh phdl head tail pemark sebar;
clear startHndl resetHndl stopHndl closeHndl idpuh stabpuh;
clear action ans btnHt btnLen btnNumber btnPos btnWid;
clear callbackStr dC icnt indx j k labelStr labmat axmat;
clear ni nplt npstp nstp popupStr plti puPos1 puPos3 puPos5;
clear rect spacing xPos yPos yiPos ul ll;
close(gcf);
return
