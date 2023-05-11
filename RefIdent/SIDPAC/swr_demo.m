%
%  script swr_demo.m
%
%  Usage: swr_demo;
%
%  Description:
%
%    Matlab script to demonstrate stepwise regression
%    modeling using program swr.m.  
%
%

%
%    Calls:
%      buzz.m
%      swr.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 Jan 2001 - Created and debugged, EAM. 
%
%  Copyright (C) 2001  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@larc.nasa.gov
%
fprintf('\n\n Stepwise Regression Modeling Demo ')
fprintf('\n\n Loading example data...\n')
load 'swr_example.mat'
pause(1);
fprintf('\n\n\n The candidate modeling functions (called regressors)')
fprintf('\n are in the columns of x.  The plot shows these regressors.')
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.469 .279 .526 .628],...
           'Color',[0.8 0.8 0.8],...
           'Name','Stepwise Regression Modeling',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .75 .8],...
         'XGrid','on', 'YGrid','on',...
         'Tag','Axes1');
[npts,nr]=size(x);
t=[1:npts]';
plot(t,x),grid on,legend('Regressor 1','Regressor 2','Regressor 3','Regressor 4'),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Measured output values are arranged in a column ')
fprintf('\n vector z, with the associated regressor ')
fprintf('\n values in the columns of matrix x.  For example, ')
fprintf('\n row 1 of matrix x holds the regressor ')
fprintf('\n values [reg1(1),reg2(1),reg3(1),reg4(1)] ')
fprintf('\n for measured output z(1).  Note that the ')
fprintf('\n candidate regressor matrix does not include a constant ')
fprintf('\n regressor, because swr automatically includes that ')
fprintf('\n regressor (a vector of ones) in the model.')
fprintf('\n\n There are 500 total data points.')
fprintf('\n\n The true functional dependence is:\n')
fprintf('\n     y_true = -1*reg1 + 2*reg2 + 3*reg4 - 0.5')
y_true = [x,ones(npts,1)]*p_true;
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The plot shows the measured output values z, ')
fprintf('\n which are the y_true values with 5 percent ')
fprintf('\n random noise added.')
nselev=0.05;
z=buzz(y_true,nselev);
plot(t,z),grid on,ylabel('z'),xlabel('index')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The regressor pairwise correlations are ')
fprintf('\n the off-diagonal elements of the correlation ')
fprintf('\n matrix computed by program corx:\n')
corlm=corx(x);
corlm,
fprintf('\n\n The regressor pairwise correlations are low,')
fprintf('\n except for the correlation between regressors 3 and 4,')
fprintf('\n so the stepwise regression should be well-conditioned.')
fprintf('\n\n Now use program swr to determine the best')
fprintf('\n model from the pool of regressors in the columns of x.')
fprintf('\n Once program swr starts, the regressors can ')
fprintf('\n be swapped in and out of the model by entering ')
fprintf('\n the regressor number.  Use the highest partial correlation ')
fprintf('\n to choose the next candidate regressor to enter the ')
fprintf('\n model, then keep only those regressors whose partial F ratio')
fprintf('\n exceeds the cut-off value.  The other statistical metrics')
fprintf('\n and the plots can also be used to help determine an ')
fprintf('\n adequate model structure.  It should be clear that ')
fprintf('\n regressors 1, 2, and 4 should be part of the model, ')
fprintf('\n but regressor 3 should not.  (During the run, type ')
fprintf('\n these numbers at the prompts: 2 1 4 3 3 0)')
fprintf('\n\n Press any key to continue ... '),pause,
[y,p,cvar,s2,xm,pindx]=swr(x,z,1);
serr=sqrt(diag(cvar));
fprintf('\n\n\n The estimated model parameters ')
fprintf('\n compared to the true values are:\n')
fprintf('\n       p                      p_true ')
fprintf('\n     -----                    ------ ')
np=length(p);
k=0;
for j=1:np,
  if any(pindx==j)
    k=k+1;
    fprintf('\n   %7.3f  +/-%7.3f       %7.3f',p(j),2*serr(k),p_true(j))
  else
    fprintf('\n   %7.3f  +/-%7.3f       %7.3f',0,0,p_true(j))
  end
end
fprintf('\n\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Output s2 is the output variance estimate, ')
fprintf('\n columns of output matrix xm are the selected regressors ')
fprintf('\n for the model, and pindx is the index vector')
fprintf('\n of the regressors selected for the model.')
fprintf('\n\n Output y is computed from y=xm*p(pindx).  Standard errors ')
fprintf('\n for the model parameters are computed from:\n')
fprintf('\n     serr=sqrt(diag(cvar))\n')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now compare the model residual with the true residual,\n')
fprintf('\n      res = measured output z minus identified model output y.')
fprintf('\n res_true = measured output z minus true model output y_true.')
clf
res=z-y;
subplot(2,1,1),plot(t,res),ylabel('Model Residual')
grid on;hold on;v=axis;
res_true=z-y_true;
subplot(2,1,2),plot(t,res_true),ylabel('True Residual')
xlabel('Data Point'),grid on;hold off;axis(v);
fprintf('\n\n\n These plots show that the model residuals are nearly the ')
fprintf('\n same as the true residuals, which means that program swr')
fprintf('\n has accurately identified the deterministic functional ')
fprintf('\n dependence. ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Usually, the model will not be this good, ')
fprintf('\n because the candidate regressors in x ')
fprintf('\n can only provide an approximation to the ')
fprintf('\n real functional dependence.  In this example case,')
fprintf('\n the candidate regressor pool (columns of x) included')
fprintf('\n exactly the right regressors for modeling z.')
clear j k v np;
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
