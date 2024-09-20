%% import data
clc;
clear;
%%
% globle figure size 
target_figure_width = 8.62/2.0; % [cm]
mag = 2.0;
figure_width  = target_figure_width*mag;
figure_height = figure_width*0.9;
% FontSize = 11*1.5;
FontSize = 8*mag - 2;
FontSize_legend = FontSize - 4;
FontSize_title=12;
LineWidth = 1*mag;
LineWidth_axis = LineWidth - 0.5;
LineWidth_edge = LineWidth - 1.0;
Fighight=0.75;
%%
load('WS2_PL_1.mat');
Int_norm=(Int-min(min(Int)))./(max(max(Int))-min(min(Int)));
figure;
pcolor(theta,E,Int_norm');
shading interp
xlabel('angle/degree')
ylabel('wavelength/nm')
% caxis([-.2 1])
colorbar
% colormap inferno
% colormap gray
grid on
box on
%% UP
[~,fit1]=min(abs(theta+30));
[~,fit2]=min(abs(theta+0));
Lw_up=zeros(1,length(theta));
err_Lwup=zeros(1,length(theta));
Eup=zeros(1,length(theta));
err_Eup=zeros(1,length(theta));
%% fit Up using Gaussian
close all;
Int_fit=Int_norm';
E1=2.04;
E2=2.01;
%%
for i=fit1+11:fit1+15
    % for i=1:length(thetafit)
    [~,sel1]=min(abs(E-E1));
    [~,sel2]=min(abs(E-E2));
    Efit=E(sel1:sel2);
    Intfit=Int_fit(sel1:sel2,i);
    figure
    plot(E,Int_norm(i,:),'color','r');hold on 
    plot(Efit,Intfit+0.1); 
    %%
    ft = fittype(' a1*exp(-((x-b1)/c1)^2)+d1');
    Gaussian = @(a,x) a(1)*exp(-((x-a(2))./a(3)).^2)+a(4);
    options = fitoptions(ft);
    options.StartPoint = [0.278498218867048 0.546881519204984 0.957506835434298 0.157613081677548];
    options.Lower = [-Inf E2-0.01 0 0];
    options.Upper = [0 E1+0.01 0.05 Inf];
    res_fit1=fit(Efit,Intfit,ft,options);
    a=coeffvalues(res_fit1);
    error=confint(res_fit1,0.95);
    Lw_up(i)=a(3)*2000;
    err_Lwup(i)=abs(error(1,3)-error(2,3))*2000;
    Eup(i)=a(2);
    err_Eup(3)=abs(error(1,2)-error(2,2));
    %
    figure;
    plot(Efit,Gaussian(a,Efit),'--','Linewidth',2); hold on
%     plot(E,Rstr,'Linewidth',1); hold on 
    plot(Efit,Intfit,'Linewidth',1); hold on 
%     plot(E,R1,'color','k','Linewidth',1);hold on 
%     plot(E,R(:,i+fit1-1),'color','r','Linewidth',1)
%     xlim([1.5 1.8]);
    xlim([E2 E1]);
    xlabel('Energy')
    ylabel('Reflection')
%     legend('fitted','Location','best','FP background','FP subtracted data')
    legend('fitted','FP subtracted data','Location','best')
    set(gca,'FontSize',12,'fontWeight','bold')
    set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
    set(gca, 'Position', [0.15, 0.15, 0.7, Fighight]);
%     saveas(gcf,sprintf('FIGlp%d.fig',i)); % will create FIG1, FIG2,...
%     saveas(gcf,sprintf('FIGlp%d.png',i)); % will create FIG1, FIG2,...
end
%%
figure;
pcolor(theta,E,Int_norm'); hold on 
shading interp
xlabel('angle/degree')
ylabel('wavelength/nm')
caxis([0 1.2])
colorbar
%colormap gray
% plot(theta,Lw,'Linewidth',2)
errorbar(theta(1,fit1:1:i),Eup(1,fit1:1:i),err_Eup(1,fit1:1:i),'s','Linewidth',10)
xlim([-35 35])
% ylim([1.64 1.70])
%% plot fitted ELP
figure;
% plot(theta,Lw,'Linewidth',2)
errorbar(theta(1,fit1:1:fit2),Eup(1,fit1:1:fit2),err_Eup(1,fit1:1:fit2),'o','Linewidth',2)
xlim([-35 35])
ylim([2.0 2.2])
xlabel('Angle (degree)')
ylabel('Linewidth (meV)')
set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
set(gca, 'Position', [0.15, 0.15, 0.7, Fighight]);

%%
% save('LP.mat','Elp','Lw_lp','err_Elp','err_Lwlp')
%     saveas(gcf, [Files.name(1:end-4) 'Elp' '.fig']);
%     saveas(gcf, [Files.name(1:end-4) 'Elp' '.png']);
    %% plot E
figure;
% plot(theta,Lw,'Linewidth',2)
errorbar(theta(1,fit1:2:fit2),Eup(1,fit1:2:fit2),err_Eup(1,fit1:2:fit2),'o','Linewidth',2)
xlim([-30 30])
xlabel('Angle (degree)')
ylabel('Linewidth (meV)')
set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
set(gca, 'Position', [0.15, 0.15, 0.7, Fighight]);

%% LP
[~,fit3]=min(abs(theta+40));
[~,fit4]=min(abs(theta-40));
%%
Lw_lp=zeros(1,length(theta));
err_lwlp=zeros(1,length(theta));
Elp=zeros(1,length(theta));
err_Elp=zeros(1,length(theta));
%%   
close all;
for i=fit3+61:fit4
%for i=1:length(thetafit)
    E1=2.0;
    E2=1.95;
    [~,sel1]=min(abs(E-E1));
    [~,sel2]=min(abs(E-E2));
    Efit=E(sel1:sel2);
    Intfit=Int_fit(sel1:sel2,i);
    figure
    plot(Efit,Intfit+0.1,'color','b'); hold on
    plot(E,Int_fit(:,i),'color','r');hold on 
    plot(Efit,Intfit); 
    %%
    %高斯函数拟合
    ft = fittype(' a1*exp(-((x-b1)/c1)^2)+d1');
    Gaussian = @(a,x) a(1)*exp(-((x-a(2))./a(3)).^2)+a(4);
    options = fitoptions(ft);
    options.StartPoint = [0.278498218867048 0.546881519204984 0.957506835434298 0.157613081677548];
    options.Lower = [0 E2 0 0];
    options.Upper = [Inf E1 0.05 Inf];
    res_fit1=fit(Efit,Intfit,ft,options);
    a=coeffvalues(res_fit1);
    error=confint(res_fit1,0.95);
    Lw_lp(i)=a(3)*2000;
    err_lwlp(i)=abs(error(1,3)-error(2,3))*2000;
    Elp(i)=a(2);
    err_Elp(i)=abs(error(1,2)-error(2,2));
    %%
    figure;
    plot(Efit,  Gaussian(a,Efit),'--','Linewidth',2); hold on
%     plot(E,Rstr,'Linewidth',1); hold on 
    plot(Efit,Intfit,'Linewidth',1); hold on 
%     plot(E,R1,'color','k','Linewidth',1);hold on 
%     plot(E,R(:,i+fit1-1),'color','r','Linewidth',1)
%     xlim([1.5 1.8]);
    xlim([E2 E1]);
    xlabel('Energy')
    ylabel('Reflection')
%     legend('fitted','Location','best','FP background','FP subtracted data')
    legend('fitted','FP subtracted data','Location','best')
    set(gca,'FontSize',12,'fontWeight','bold')
    set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
   % set(gca, 'Position', [0.15, 0.15, 0.7, Fighight]);
%     saveas(gcf,sprintf('FIGup%d.fig',i)); % will create FIG1, FIG2,...
%     saveas(gcf,sprintf('FIGup%d.png',i)); % will create FIG1, FIG2,...
end
%%
figure;
pcolor(theta,E,Int'); hold on 
shading interp
xlabel('angle/degree')
ylabel('Energy/eV')
% caxis([0 1.2])
colorbar
% colormap gray
% plot(theta,Lw,'Linewidth',2)
errorbar(theta(1,fit3:1:fit4-1),Elp(1,fit3:1:fit4-1),err_Elp(1,fit3:1:fit4-1),'o','Linewidth',2)
% xlim([-35 35])
% ylim([1.58 1.65])

%% save data
% save('Extracted_PL.mat','Elp','Lw_lp','err_Elp','err_Lwlp','fit3','fit4','Eup','fit1','fit2')
save('Extracted_PL.mat','Elp','err_Elp','fit3','fit4','Eup','err_Eup','fit1','fit2')
% load('Extracted.mat');
% save('Extracted_3.mat','fit5','fit6','Elp','err_Elp')
% BB=load('Extracted_2.mat');