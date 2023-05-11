%
%  script offit_demo.m
%
%  Usage: offit_demo;
%
%  Description:
%
%    Matlab script to demonstrate orthogonal function
%    modeling using program offit.m.  
%
%

%
%    Calls:
%      x_values.m
%      unstk_data.m
%      buzz.m
%      offit.m
%      rms.m
%      model_disp.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      12 Dec 1999 - Created and debugged, EAM. 
%      16 Nov 2000 - Added and updated text and computations, EAM.
%      25 Apr 2001 - Used model_disp.m to display results, EAM.
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
fprintf('\n\n Multivariate Orthogonal Function Modeling Demo ')
fprintf('\n\n Loading example data...\n')
load 'offit_example.mat'
pause(1);
fprintf('\n\n\n The first independent variable is alpha, ')
fprintf('\n which takes 24 different values (in radians):\n')
alpha,
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The second independent variable is mach,')
fprintf('\n which takes 10 different values:\n')
mach,
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The true functional dependence is:\n\n')
fprintf('     y_true = sin(2*alpha) + mach*alpha^2 - mach^3 + mach*alpha')
y_true = sin(2*x(:,1)) + x(:,2).*x(:,1).^2 - x(:,2).^3 + x(:,2).*x(:,1);
fprintf('\n\n\n Press any key to continue ... '),pause,
%
%  Set up figure window.
%
FgH=figure('Units','normalized',...
           'Position',[.468 .255 .527 .652],...
           'Color',[0.8 0.8 0.8],...
           'Name','Orthogonal Function Modeling',...
           'NumberTitle','off');
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .75 .8],...
         'XGrid','on', 'YGrid','on');
fprintf('\n\n\n Measured output values are arranged in a column ')
fprintf('\n vector z, with the associated independent variable ')
fprintf('\n values in columns of the matrix x.  For example, ')
fprintf('\n row 1 of matrix x holds the independent variable ')
fprintf('\n values [alpha,mach] for measured output z(1).  ')
fprintf('\n There are 240 total data points (24 alpha values ')
fprintf('\n times 10 mach values).')
%
%  Z is a matrix of the values of y_true, Z is a 
%  matrix of the values of z, etc.  This is necessary
%  for Matlab 3-D plotting.
%
[xval,nval]=x_values(x);
Y_TRUE=unstk_data(y_true,x,xval,nval);
mesh(alpha,mach,Y_TRUE)
xlabel('alpha')
ylabel('mach')
zlabel('y true')
pause(2),
fprintf('\n\n\n The figure shows a plot of the true output y_true,')
fprintf('\n which might be lift coefficient, for example. ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now plot the simulated measured output z, which is')
fprintf('\n the true output y_true with 5%% random noise added.')
z=buzz(y_true,0.05);
Z=unstk_data(z,x,xval,nval);
mesh(alpha,mach,Z)
xlabel('alpha')
ylabel('mach')
zlabel('z')
pause(2)
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The model for the dependent variable z is identified')
fprintf('\n in terms of orthogonal functions generated from the ')
fprintf('\n independent variable data.  The method for generating')
fprintf('\n the orthogonal functions will be demonstrated now.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The first orthogonal function p1 is chosen')
fprintf('\n as a vector of ones, p1=ones(length(z),1).')
p1=ones(length(z),1);
fprintf('\n\n The next orthogonal function is chosen to be similar ')
fprintf('\n to the first independent variable (alpha) raised to the ')
fprintf('\n first power, so p2=x(:,1)=x(:,1).*p1.  But p2 will not in ')
fprintf('\n general be orthogonal to p1, so we adjust p2 to force the ')
fprintf('\n orthogonality using p2=x(:,1).*p1 - gam21*p1, where ')
fprintf('\n gam21 is a scalar to be found.  Multiplying the last ')
fprintf('\n expression by p1 transpose on both sides and using the')
fprintf('\n orthogonality condition p1''*p2=0, we can solve for')
fprintf('\n gam21 as:') 
fprintf('\n\n gam21=(p1''*(x(:,1).*p1))/(p1''*p1) \n')
gam21=(p1'*(x(:,1).*p1))/(p1'*p1),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now that gam21 is known, p2 can be computed from')
fprintf('\n p2=x(:,1).*p1-gam21*p1.  Note that the term gam21*p1 ')
fprintf('\n removes the part of p2 that is along the p1 direction, ')
fprintf('\n so p2 is now orthogonal to p1, and p1''*p2 should be zero.\n')
p2=x(:,1).*p1-gam21*p1;
fprintf('\n The inner product of p1 and p2 is: \n\n')
p1_transpose_times_p2=p1'*p2,
fprintf('\n which is numerically zero.')
fprintf('\n\n\n Press any key to continue ... '),pause,
plot(rn,[p1,p2]),grid on;axis([0 max(rn) -1 1.5]),legend('p1','p2');
fprintf('\n\n\n The figure shows a plot of orthogonal functions p1 and p2.')
fprintf('\n\n In this simple case, p2 (based on alpha to the first power)')
fprintf('\n has been made orthogonal to a p1 (a constant vector of ones)')
fprintf('\n by removing a constant bias from the alpha values in x(:,1).')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The procedure can be continued using arbitrary multiplications')
fprintf('\n of the independent variables.  For example, if the next ')
fprintf('\n orthogonal function is to be similar to alpha.*mach, then')
fprintf('\n we write p3=x(:,2).*p2-gam32*p2-gam31*p1.  The scalars gam32')
fprintf('\n and gam31 are found by multiplying both sides of the last')
fprintf('\n equation by p2 transpose and p1 transpose, respectively, and ')
fprintf('\n invoking the orthogonality conditions that p2''*p3=0,')
fprintf('\n p2''*p1=0, p1''*p3=0, and p1''*p2=0:\n\n')
gam32=(p2'*(x(:,2).*p2))/(p2'*p2),
gam31=(p1'*(x(:,2).*p2))/(p1'*p1),
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now that gam32 and gam31 are known, p3 can be computed from')
fprintf('\n p3=x(:,2).*p2-gam32*p2-gam31*p1.  Again, the terms gam32*p2 ')
fprintf('\n and gam31*p1 remove the parts of p3 that are along the p2 ')
fprintf('\n and p1 directions, so p1, p2, and p3 are mutually orthogonal.')
p3=x(:,2).*p2-gam32*p2-gam31*p1;
fprintf('\n\n\n Arranging p1, p2, and p3 as columns of a matrix P, and then')
fprintf('\n computing P''*P, the orthogonality of p1, p2, and p3')
fprintf('\n can be demonstrated:\n')
P_transpose_times_P=[p1,p2,p3]'*[p1,p2,p3],
fprintf('\n where the diagonal elements of the matrix above are the ')
fprintf('\n inner products of the orthogonal functions p1, p2, and p3')
fprintf('\n with themselves.')
fprintf('\n\n Press any key to continue ... '),pause,
plot(rn,[p1,p2,p3]),grid on;axis([0 max(rn) -1 1.5]),legend('p1','p2','p3');
fprintf('\n\n\n A plot of orthogonal polynomials p1, p2, and p3 is shown in ')
fprintf('\n the figure.  Although orthogonal function p3 looks strange,')
fprintf('\n it has of course been generated by linear combinations of ')
fprintf('\n ordinary polynomials, just like all the other orthogonal ')
fprintf('\n functions.  Using orthogonal functions for the modeling ')
fprintf('\n decouples the model parameter estimation problem, because')
fprintf('\n each modeling function is unique in its ability to explain ')
fprintf('\n variations in the dependent variable, due to the ')
fprintf('\n orthogonality.  This makes it easy to choose which ')
fprintf('\n orthogonal modeling function(s) should be included ')
fprintf('\n as part of the model.  Subsequently, each retained ')
fprintf('\n orthogonal modeling function can be decomposed ')
fprintf('\n into ordinary polynomial functions (from which ')
fprintf('\n they came), to arrive finally at an ordinary multivariate ')
fprintf('\n polynomial model in the independent variables. ')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now run program offit with input parameters nord and maxord,')
fprintf('\n which are the maximum independent variable orders for')
fprintf('\n each individual orthogonal function, and the maximum ')
fprintf('\n order for each orthogonal function, respectively.\n')
nord,maxord,
fprintf('\n For example, an orthogonal function similar to alpha.*mach.^4 ')
fprintf('\n would be an allowable term, but not mach.^5 (which ')
fprintf('\n exceeds maximum order for independent variable')
fprintf('\n number 2, nord(2)=4), and not (alpha.^3).*(mach.^4) (which ')
fprintf('\n exceeds maximum order for each term, maxord=6).')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Enter the value 7 or just type a carriage return ')
fprintf('\n when prompted by program offit for the number ')
fprintf('\n of orthogonal functions to keep.')
fprintf('\n\n This number of orthogonal functions corresponds to the ')
fprintf('\n minimum prediction error (pe), as will be shown in the')
fprintf('\n far right of the display on the screen. ')
fprintf('\n\n Press any key to continue ... '),pause,
[y,ap,iap,s2ap,pse,xp]=offit(x,z,nord,maxord);
fprintf('\n\n In the figure, simulated noisy measured output z ')
fprintf('\n is plotted as a wire mesh, and the fitted ')
fprintf('\n model y as a smooth surface. The fit can be examined')
fprintf('\n more thoroughly using the Rotate 3D button on the ')
fprintf('\n figure window toolbar.')
mesh(alpha,mach,Z)
xlabel('alpha')
ylabel('mach')
zlabel('z, y')
hold on
Y=unstk_data(y,x,xval,nval);
surf(alpha,mach,Y)
hold off
pause(2)
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Plot the residual:')
fprintf('\n\n residual = measured output z - model output y')
res=z-y;
plot(rn,res),ylabel('Model Residual'),xlabel('Data Point'),grid on;
fprintf('\n\n\n Notice that the residual is nearly white noise, indicating')
fprintf('\n that the model has captured the functional dependence.')
fprintf('\n The small deterministic trend in the residuals results from')
fprintf('\n the fact that the transcendental sine function can only be')
fprintf('\n approximated using a finite polynomial expansion.')
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Now compare with the true residual, \n')
fprintf('\n\n residual_true = measured output z - true model output y_true.')
clf
subplot(2,1,1),plot(rn,res),ylabel('Model Residual')
grid on;hold on;v=axis;
res_true=z-y_true;
subplot(2,1,2),plot(rn,res_true),ylabel('True Residual')
xlabel('Data Point'),grid on;hold off;axis(v);
fprintf('\n\n\n These plots show that the model residuals are similar ')
fprintf('\n to the true residuals, which means that the model')
fprintf('\n has accurately identified the deterministic functional ')
fprintf('\n dependence. ')
pause(2)
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The identified multivariate polynomial model is described by ')
fprintf('\n vector ap, which holds the parameter estimates for each term ')
fprintf('\n in the model, and vector iap, which indicates the form of each ')
fprintf('\n model term.  Elements of vector iap hold the integer powers of ')
fprintf('\n the independent variables for each term in the model.')
fprintf('\n For example, iap(3)=12 means the third model term has the form ')
fprintf('\n ap(3)*mach*alpha^2.  Notice that the exponent of the first ')
fprintf('\n independent variable is in the ones place of iap(3), and the ')
fprintf('\n exponent of the second independent variable is in the tens')
fprintf('\n place (and so on, for more independent variables).')
fprintf('\n The identified multivariate polynomial model for the 7 ')
fprintf('\n retained orthogonal functions is:\n')
serr=sqrt(s2ap);
model_disp(ap,serr,iap,['alpha';'Mach ']);
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Note that offit did NOT produce the original ')
fprintf('\n nonlinear function, but rather an equivalent low order ')
fprintf('\n polynomial with nearly the same surface contour.')
fprintf('\n The figure shows a plot of true y (mesh) and y identified ')
fprintf('\n by offit (surface) using the simulated noisy data.')
clf;
mesh(alpha,mach,Y_TRUE);
xlabel('alpha')
ylabel('mach')
zlabel('y true, y')
hold on;
surf(alpha,mach,Y);
hold off;
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n The magnitude of the model residual ')
fprintf('\n (z-y) is similar to the magnitude of the modeling')
fprintf('\n error (y_true-y), as shown in the figure.')
clf
subplot(2,1,1),plot(rn,res),ylabel('Model Residual')
grid on;hold on;v=axis;
subplot(2,1,2),plot(rn,y_true-y),ylabel('Modeling Error')
xlabel('Data Point'),grid on;hold off;axis(v);
fprintf('\n\n Press any key to continue ... '),pause,
fprintf('\n\n\n Program offit identified the nonlinear surface contour')
fprintf('\n to within the noise level, which was 5%% in this case.')
fprintf('\n\n rms(z-y)/rms(y_true) = %6.3f',rms(z-y_true)/rms(y_true))
fprintf('\n\n rms(y-y_true)/rms(y_true) = %6.3f',rms(y_true-y)/rms(y_true))
clear i;
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
return
