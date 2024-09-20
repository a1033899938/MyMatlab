%%
clc;
clear;
%%
load('Sample41-mono.mat');
load('Extracted_mono_0308.mat');
A2=load('Extracted_mono_0308_2.mat');
% [~,fit1]=min(abs(theta+22));
% [~,fit2]=min(abs(theta+0));
% [~,fit3]=min(abs(theta+14.48));
% [~,fit4]=min(abs(theta+0));
ii=16;
x1 = -theta(fit1+ii:fit2);
x2 = -theta(fit3:fit4);
jj=20;
y1=Eup(fit1+ii:fit2); err_y1=[err_Eup(fit1+ii:fit2)];
y2=[A2.Emp(fit3:fit3+jj),Emp(fit3+jj+1:fit4)];
err_y2=[A2.err_Emp(fit3:fit3+jj),err_Emp(fit3+jj+1:fit4)];
k1=theta_k_1D(x1,y1);
k2=theta_k_1D(x2,y2);
figure; hold on all
errorbar(x1,y1,err_y1,'o');
errorbar(x2,y2,err_y2,'o');
%%
figure;
pcolor(theta,w,R_gratingV');
 shading interp
  set(gca,'YDir','Reverse')
    caxis([0 1.5])
    xlim([-inf 0])
    box on 
    colormap gray
%%
Ex=1.6432;
g=17.4/1000;
beta0=[1.6155,0.006489,Ex,g];
figure; hold on
plot(k1,y1,'o')
% plot(k,Emp)
plot(k2,y2,'o')
plot(k1,polariton_LP(beta0(1),beta0(2),beta0(3),beta0(4),k1))
plot(k2,polariton_UP(beta0(1),beta0(2),beta0(3),beta0(4),k2))
%%
x_cell = {k1,k2};
y_cell = {y1,y2};
mdl1 = @(b,x) polariton_UP(b(1),b(2),b(3),b(4),x);
mdl2 = @(b,x) polariton_LP(b(1),b(2),b(3),b(4),x);
mdl_cell = {mdl1,mdl2};
% y1=mdl1(beta0,k);
% y2=mdl2(beta0,k);
[beta,r,J,Sigma,mse,errorparam,robustw] = ...
nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
ci = nlparci(beta,r,'Jacobian',J);
error=abs(ci(:,1)-ci(:,2))/2; error=error';
%%
% %%
% kcal=linspace(0,4,1000);
% Ec0=beta(1);
% Eccal=Ec0+kcal.^2*beta(2);
% E1=ones(1,length(kcal))*beta(3);E2=ones(1,length(kcal))*beta(4);
% figure;hold on all
% plot(kcal,Eccal,'k--')
% plot(kcal,dipolariton_LP(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),abs(kcal)));
% plot(kcal,dipolariton_MP(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),abs(kcal)));
% plot(kcal,dipolariton_UP(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),abs(kcal)));
% plot(kcal,E1,'k--');
% plot(kcal,E2,'k--');
% plot(k1,y1,'o');
% plot(k2,y2,'o');
% plot(k3,y3,'o');
% box on 
% xlabel('\theta')
% ylabel('Energy (eV)')
% xlim([0 5])
% for paper fitting positive
spa=2;
kcal=linspace(0,4.5,1000);
E1=ones(1,length(kcal))*beta(3);E2=ones(1,length(kcal))*beta(4);
Eccal=beta(1)+beta(2)*kcal.^2;
figure; hold on all
errorbar(k1(1:spa:end),y1(1:spa:end),err_y1(1:spa:end),'V','Linewidth',1.5,...
    'color',[216,82,24]/255);
errorbar(k2(1:spa:end),y2(1:spa:end),err_y2(1:spa:end),'^','Linewidth',1.5,...
    'color',[216,82,24]/255);
plot(kcal,polariton_LP(beta(1),beta(2),beta(3),beta(4),abs(kcal)),'k-',...
    'Linewidth',1.5);
plot(kcal,polariton_UP(beta(1),beta(2),beta(3),beta(4),abs(kcal)),'k-',...
    'Linewidth',1.5);
plot(kcal,E1,'k--');
plot(kcal,E2,'k--');
plot(kcal,Eccal,'k--');
    xlim([0 3.5])
    ylim([1.58 1.68])
    xlabel('k_{//} (\mum^{-1})')
%     yticks([1.58:0.02:1.68]);
%    xlabel('\theta')
%  xlabel('\theta')
ylabel('Energy (eV)')
box on 
 set(gcf,'Position',[100 100 500 300])
% xticks([0:.5:3.5])
