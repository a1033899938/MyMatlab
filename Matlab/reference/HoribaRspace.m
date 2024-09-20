clc;
clear;
clf;
close all;
filepath='E:\0-------------------------Plot-------------------------';     %文件路径
filelist=dir([filepath '\*.txt']);      %获取文件中所有文件信息
filecell=struct2cell(filelist);

filename = sort_nat(filecell(1,:));
L=length(filename);     %文件个数
    
A={1,L};B={1,L};C={1,L};
strip=[];


for i=1:L
    A{1,i}=importdata(filename{1,i});
    M=size(A{1,i},1);       %行数
    N=size(A{1,i},2);       %列数
    B{1,i}= A{1,i}(1:M,1);     %提取每一个cell中的波长数值
    C{1,i}= A{1,i}(1:M,2);     %提取每一个cell中强度的数值
end

% for i=1:L
%     if i <= 2
%         C{1,i}=C{1,i}-C{1,3};
%     end
% end

%差分
back_number = L;
substrate_number = L-1;
for i=1:1:L-2
%     C{1,i}=(C{1,i}-C{1,substrate_number})./(-(C{1,back_number}-C{1,substrate_number}));
    C{1,i}=(C{1,i}-C{1,substrate_number})./C{1,substrate_number};
end
% SC = 3;
%平滑
% for i=1
for i = 1:1:L-2
    Intensity{1,i}=C{1,i};
    wavelen{1,i}=B{1,i};
    E{1,i}=1240./B{1,i};
    strip=linspace(1,256,M-1);
    strip=strip';
    wavelen{1,i}=wavelen{1,i}';
    E{1,i}=E{1,i}';
    % f=figure;
%     subplot(2,2,i);
%     plot(wavelen,Intensity,'LineWidth',2);
    plot(E{1,i},Intensity{1,i},'LineWidth',2);
    % pcolor(wavelen,strip,Intensity);
    
    shading interp; %平滑
    % colorbar;
    % colormap;
    % colormap gray;
    % axis([555 600 1 256]); 
    axis ij;
    ylabel('Intensity(counts)');
    % xlabel('Wavelength (nm)');
    xlabel('energy(eV)');
    set(gca,'YDir','normal');
    % title(filename{1,i},'Interpreter', 'none');
    hold on;
    grid on;
    box off;
    % saveas(f, ['interp' sprintf('%s',filename{1,i}) '.png']);
    
    % saveas(C{1,i}),['C' '.txt'];
    
    % legend(char(filename{2:end}));
    % legend('BL WS_2(air)','BL WS_2(SiO_2/Si)');
end
Intensity_Xfilter_medianened = {1,L};
Intensity_Xfilter_medianened_diff1 = {1,L};

figure;
for i = 1:1:L-2
%     subplot(2,2,i);
    Intensity_Xfilter_medianened{1,i}=Xfilter_median(Intensity{1,i},3*i);
    plot(E{1,i},Intensity_Xfilter_medianened{1,i},'LineWidth',2);
    title(sprintf('3*%s',num2str(i)));
end
% 
% figure;
% for i =1:1:4
%     subplot(2,2,i);
%     Intensity_Xfilter_medianened_diff1{1,i}=diff(Intensity_Xfilter_medianened{1,i});
%     plot(E(1:end-1),Intensity_Xfilter_medianened_diff1{1,i},'LineWidth',2);
% end
% 
% % figure;
% % for i=1:1:4
% %     subplot(2,2,i);
% %     Intensity_Xfilter_medianened_diff1_Xfilter_medianened{1,i} = Xfilter_median(Intensity_Xfilter_medianened_diff1{1,i},2);
% % end
% 
% E2 = {1,L};
% for i =1:1:3
%     idx1 = find(Intensity_Xfilter_medianened_diff1{1,i}==0);
%     Intensity_Xfilter_medianened_diff1{1,i}(idx1) =[];
%     E2{1,i} = E(1:end-1);
%     E2{1,i}(idx1) = [];
% end
% 
% figure;
% for i = 1:1:3
%     subplot(2,2,i);
%     plot(E2{1,i},Intensity_Xfilter_medianened_diff1{1,i},'LineWidth',2);
% end
% 
% Intensity_Xfilter_medianened_diff1_medianened = {1,L};
% figure;
% for i = 1:1:3
%     subplot(2,2,i);
%     Intensity_Xfilter_medianened_diff1_medianened{1,i} = Xfilter_median(Intensity_Xfilter_medianened_diff1{1,i},3);
%     plot(E2{1,i},Intensity_Xfilter_medianened_diff1_medianened{1,i},'LineWidth',2);
% end
% 
% figure;
% for i = 1:1:3
%     subplot(2,2,i);
%     Intensity_Xfilter_medianened_diff2{1,i} = diff(Intensity_Xfilter_medianened_diff1_medianened{1,i});
%     plot(E2{1,i}(1:end-1),Intensity_Xfilter_medianened_diff2{1,i},'LineWidth',2);
% end

% figure;
% for i =1:1:4
%     subplot(2,2,i);
%     Intensity_Xfilter_medianened_diff1_medianened{1,i}=Xfilter_median(Intensity_Xfilter_medianened_diff1,3);
%     plot(E2{1,i},Intensity_Xfilter_medianened_diff1_medianened{1,i},'LineWidth',2);
% end

% figure;
% for i =1:1:4
%     subplot(2,2,i);
%     Intensity_Xfilter_medianened_diff2{1,i}=diff(Intensity_Xfilter_medianened_diff1{1,i});
%     % hold on;
%     plot(E(1:end-2),Intensity_Xfilter_medianened_diff2{1,i},'LineWidth',2);
%     % H_Intensity_Xfilter_medianened_diff1{1,i}=hilbert(Intensity_Xfilter_medianened_diff1{1,i});  
%     % plot(abs(H_Intensity_Xfilter_medianened_diff1{1,i}));
%     % hold off;
% end