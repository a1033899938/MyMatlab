clc;
clear;

%% load bunch of files
Files = dir('pvk-500@650nm.SPE');
for iFile = 1:length(Files)
    Data=loadSPE([Files(iFile).name]);
    t_grating=Data.expo_time;
    w=Data.wavelength;
    Int=Data.int/t_grating;
    %% change to angle
    centerstrip=55;
% centerstrip=140;
    NA=0.55;
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
%     set(gca,'YDir','Reverse')
    set(gca,'YDir','Normal')
    grid on
    box on
    saveas(100, [Files(iFile).name(1:end-4) '.fig']);
    saveas(100, [Files(iFile).name(1:end-4) '.png']);
end