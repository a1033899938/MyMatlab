clear;
clc;
nm=10^(-9);
hba=6.63*10^(-34)/2/pi;
eV=1.6*10^(-19);
meV=1.6*10^(-22);
c=3*10^8;
strip1=121;
strip2=142;
%% background
sp2D_bg=loadSPE('hBN-Sapphire.SPE');
Int_bg2D=sp2D_bg.int'./sp2D_bg.expo_time;
%% load bunch of files
Files = dir('Hetero-11.SPE');
for iFile = 1:length(Files)
    sp2D=loadSPE([Files(iFile).name]);
    Int_com=zeros(length(sp2D.wavelength),length(Files));
    t_expo=sp2D.expo_time;
    w=sp2D.wavelength;
    E=1240./w;
    %% normalization 
%     [~,sel2]=min(abs(E-1.65));
%     [~,sel1]=min(abs(E-1.8));
%     Int=sp2D_gV.int'-min(min(sp2D_gV.int));
%     Int_nor=Int/max(max(Int((sel1:sel2),:)));
    %%  plot the grating
    strip=1:256;
    figure(100);
    %     subplot(2,1,1)
    pcolor(strip,E,sp2D.int'/t_expo);
    %     
    shading interp
    legend(Files(iFile).name(1:end-4),'Location','northoutside');
    %     xlim([-30 30])

    %     ylim([1.7 1.85 ])
    xlabel('\theta')
    ylabel('Energy (eV)')
    %      ylabel('wavelength(nm)')
    %     caxis([0,0.1])
    %     set(gca,'YDir','normal')
    %      set(gca,'YDir','reverse')
    %      colorbar
    %      colormap(gray)
    grid on
    box on
    set(gca,'FontSize',12,'fontWeight','normal')
    set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','normal')
    %     pause(1);
    %     saveas(100, [Files(iFile).name(1:end-4) '.fig']);
    %     saveas(100, [Files(iFile).name(1:end-4) '.png']);
    
    
    %% plot 1D figure
    figure(101)
    pick=112:152;
    pickback=pick+70;
    Int=sp2D.int';
    % plot(w,R_subV(:,pick),w,R_gratingV(:,pick),'Linewidth',2)
    AA=Int(:,pick);
    BB=Int(:,pickback);
    Int_com(:,iFile)=(sum(AA,2)-sum(BB,2))/t_expo;
    plot(E,Int_com(:,iFile),'Linewidth',2)
    % title('Reflectance from degree of 12')
%     xlim([1.4,1.8]);
    % ylim([0,0.3])
    xlabel('wavelength/nm')
    ylabel('Reflectance')
    % legend('Experiment','Location','Northeast')
    set(gca,'FontSize',12,'fontWeight','normal')
    set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','normal')
%     saveas(101, [Files(iFile).name(1:end-4) '1D' '.fig']);
%     saveas(101, [Files(iFile).name(1:end-4) '1D''.png']);

end
%%  hBN/sapphire backgroud 1D 
    AA_bg=Int_bg2D(:,pick);BB_bg=Int_bg2D(:,pickback);
    Int_bg=sum(AA_bg,2)-sum(BB_bg,2);
%%
    figure(102); hold on all
    Con=(Int_com-Int_bg)./Int_bg;
    % Con2=(-Int_com(:,length(Files))+Int_com(:,2))./Int_com(:,length(Files));
    plot(E,Con,'Linewidth',2,'color','r'); 
    % plot(E,Con2,'Linewidth',2,'color','b'); 
    % xlim([580,800])
    xlabel('Energy/eV')
    ylabel('R contrast')
    set(gca,'FontSize',12,'fontWeight','normal')
    set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','normal')
    saveas(102, [Files(iFile).name(1:end-4) 'Rcontrast' '.fig']);
    saveas(102, [Files(iFile).name(1:end-4) 'Rcontrast''.png']);

%% Double check the original spectra
% figure;
% plot(E,Int_com(:,1),'Linewidth',2,'color','r'); hold on
% plot(E,Int_bg,'Linewidth',2,'color','b'); 

