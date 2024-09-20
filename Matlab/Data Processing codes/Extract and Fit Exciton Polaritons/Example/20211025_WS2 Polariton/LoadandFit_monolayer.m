%%
clc;
clear;
%%
load('Extracted_PL.mat');
load('WS2_PL_1.mat');
%%
figure;
pcolor(theta,E,Int');
 shading interp
    box on 
    colormap gray
    %%
   x1=theta(fit3:fit4-1);
   y1=Elp(fit3:fit4-1);
    k1=theta_k_1D(x1,y1);
    figure;
    plot(k1,y1,'o');
%%
Ex=2.0;
g=20.4/1000;
beta0=[1.96,0.0016489,Ex,g];
figure; hold on
plot(k1,y1,'o')
% plot(k,Emp)
% plot(k2,y2,'o')
plot(k1,polariton_LP(beta0(1),beta0(2),beta0(3),beta0(4),k1))
% plot(k2,polariton_UP(beta0(1),beta0(2),beta0(3),beta0(4),k2))
 %%
% x_cell = {k1,k2};
% y_cell = {y1,y2};
x_cell = {k1};
y_cell = {y1};
% mdl1 = @(b,x) polariton_UP(b(1),b(2),b(3),b(4),x);
mdl1 = @(b,x) polariton_LP(b(1),b(2),b(3),b(4),x);
mdl_cell = {mdl1};
% y1=mdl1(beta0,k);
% y2=mdl2(beta0,k);
[beta,r,J,Sigma,mse,errorparam,robustw] = ...
nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
ci = nlparci(beta,r,'Jacobian',J);
error=abs(ci(:,1)-ci(:,2))/2; error=error';
%%
k=theta_k(theta,E);
kcal=linspace(-7,7,1000);
Ecal=polariton_LP(beta(1),beta(2),beta(3),beta(4),kcal);
figure; hold on all
% pcolor(k',E,Int');
%  shading interp
%     box on 
%     colormap gray
    plot(kcal,Ecal);
    plot(k1,y1,'o')
    %%
