clc;
clear;

%% load bunch of files
Files = dir('DBR@900#white R_ cavity_1S_2.SPE');
for iFile = 1:length(Files)
    Data=loadSPE([Files(iFile).name]);
    t_grating=Data.expo_time;
    w=Data.wavelength;
    Int=Data.int/t_grating;
    Int=Int./max(max(Int));
    %% change to angle
    centerstrip=70;
% centerstrip=140;
    NA=0.5;
    thetamax=asin(NA);
    theta=zeros(1,Data.ydim);
    strip=1:Data.ydim;
    stripmax=110;
    stripmin=0;
    for i=1:Data.ydim
        theta(i)=tan(asin(NA))*((strip(i)-centerstrip)/(centerstrip-stripmin));
        theta(i)=180/pi*atan(theta(i));
    end
    %%  plot the grating
    figure(100);
    E=1240./w;
    pcolor(theta,E,Int');
%     pcolor(1:256,1:1024,R_gratingV');
    shading interp
%     title('Angle Resolved Reflectance of Device')
%     legend(Files(iFile).name(1:end-4),'Location','northoutside');
    xlabel('\theta({\circ})')
%      ylabel('Energy /eV')
    ylabel('Energy (eV)')
    colormap('gray')
    colorbar
    caxis([-.1 1.2])
%     set(gca,'YDir','Reverse')
    set(gca,'YDir','Normal')
    grid on
    box on
    saveas(100, [Files(iFile).name(1:end-4) '.fig']);
    saveas(100, [Files(iFile).name(1:end-4) '.png']);
    
    %% 1D data
       figure(101)
    [~,pick1]=min(abs(theta+12));
    [~,pick2]=min(abs(theta+13));
    Intcut=Int(pick2:pick1,:);
    Int1D=sum(Intcut,1);
    % plot(w,R_subV(:,pick),w,R_gratingV(:,pick),'Linewidth',2)
%     plot(w,Int1D);
    plot(E,Int1D);
    % title('Reflectance from degree of 12')
     xlim([1.42,1.5])
%     xlim([810,850]);
%     ylim([0,1.2])
     xlabel('Energy/eV')
%     xlabel('wavelength/nm')
    ylabel('Reflectance')
    legend(Files(iFile).name(1:end-4),'Location','northoutside');
    % legend('Experiment','Location','Northeast')
%     set(gca,'FontSize',12,'fontWeight','normal')
%     set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','normal')
%     saveas(101, [Files(iFile).name(1:end-4) '1D' '.fig']);
%     saveas(101, [Files(iFile).name(1:end-4) '1D''.png']); 
    
end