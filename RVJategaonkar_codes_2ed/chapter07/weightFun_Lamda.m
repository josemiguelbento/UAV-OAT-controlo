% Exponential weighting function with forgetting factor for RLS
% Chapter 7, Figure 7.1

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

Ndata = 1000;
x = 1:Ndata;

lamda = 1;
% for i=1:Ndata, ff1(i) = lamda.^(Ndata-i); end
ff1 = lamda.^x(end:-1:1);

lamda = 0.999;
% for i=1:Ndata, ff2(i) = lamda.^(Ndata-i); end
ff2 = lamda.^x(end:-1:1);

lamda = 0.99;
% for i=1:Ndata, ff3(i) = lamda.^(Ndata-i); end
ff3 = lamda.^x(end:-1:1);

lamda = 0.98;
% for i=1:Ndata, ff4(i) = lamda.^(Ndata-i); end
ff4 = lamda.^x(end:-1:1);

lamda = 0.97;
% for i=1:Ndata, ff5(i) = lamda.^(Ndata-i); end
ff5 = lamda.^x(end:-1:1);

lamda = 0.96;
% for i=1:Ndata, ff6(i) = lamda.^(Ndata-i); end
ff6 = lamda.^x(end:-1:1);

lamda = 0.95;
% for i=1:Ndata, ff7(i) = lamda.^(Ndata-i); end
ff7 = lamda.^x(end:-1:1);

% Plot the weighting functions with different forgetting factors
plot(x,ff1,'b', x,ff2,'m', x,ff3,'g', x,ff4,'c', x,ff5,'y', x,ff6,'k', x,ff7,'r' );
xlabel('number of data points'), ylabel('Weighting function')