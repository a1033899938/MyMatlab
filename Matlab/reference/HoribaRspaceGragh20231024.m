clc;
clear;
clf;
close all;
%% 控制区域
nameidx = 5;%文件名关键字位置
sw.normalize = 0;%强度归一化
sw.image = 0;
sw.xlabel = 0;%横坐标转换为能量
sw.background = 1;
sw.contrast = 0;%差分反射
keytag.substrate = 'PDMS';%衬底关键字
keytag.background = 'Background';
sw.interp = 0;%数据平滑
interp_width = 50;%平滑窗口
sw.mapping_dir = 0;%mapping方向变竖直
sw.dif1 = 0;%一阶微分
sw.save =0;%保存图片

%% 文件路径
filepath='E:\0-------------------------Plot-------------------------';
filelist=dir([filepath '\*.txt']);
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
%% 预设
L=length(filename);
NA = 0.75;

%预设矩阵、元胞数组
Intensity = [];
Wavelength = [];
strip = [];
E = [];
Angle = [];

sp = {1,L};
filename_split1 = {1,L};
filename_split2 = {1,L};
j = 1;
%% 穷举文件
for i=1:1:L
    filename{1,i}=(filelist(i).name);
    sp{1,i} = importdata(filename{1,i});     
    Intensity(i,:) = sp{1,i}(1:end,2);
    Wavelength(i,:) = sp{1,i}(1:end,1);
    E(i,:) = 1240./Wavelength(i,:);
end
strip = 1:1:size(sp{1,1},1);
centerstrip = size(sp{1,1},1)/2;
Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
Angle = 180/pi*atan(Angle);

%% 处理数据1
%强度归一化
if sw.normalize
    max_Intensity = max(Intensity,[],2);
    Intensity = Intensity./max_Intensity;
end

%横坐标换为能量
Xlabel = 'Wavelength(nm)';
if sw.xlabel
    Wavelength = E;
    Xlabel = 'Energy(eV)';
end

%分隔文件名
for i = 1:1:L
    filename_split1{1,i} = split(filename{1,i},'#');
    filename_split2{1,i} = split(filename_split1{1,i}{2,1},'-');
    filename_split2{1,i}{1,1} = strcat(filename_split1{1,i}{1,1},'#');
    if i == 1
        filename_split = filename_split2{1,1};
    else
        filename_split = [filename_split filename_split2{1,i}];
    end
end

%% 减背景
if sw.background
    [row1,idx_background] = find(filename,keytag.background);
    background = Intensity(idx_background,:);
    Intensity(idx_background,:) = [];
    Wavelength(idx_background,:) = [];
    filename_split(:,idx_background) = [];
    L = size(Intensity,1);
    for i = 1:1:L
        Intensity(i,:) = Intensity(i,:)-background;
    end
end

%% 差分反射
%纵坐标换为差分反射
Ylabel = 'Intensity(counts)';
%重组文件
if sw.contrast
    Ylabel = 'Contrast reflectance';
    [row2,idx_substrate] = find(strcmp(filename_split,sprintf(keytag.substrate)));
    substrate = Intensity(idx_substrate,:);
    Intensity(idx_substrate,:) = [];
    Wavelength(idx_substrate,:) = [];
    filename_split(:,idx_substrate) = [];
    L = size(Intensity,1);
    for i = 1:1:L
        Intensity(i,:) = (Intensity(i,:)-substrate)./substrate;
    end
end

%% 数据平滑
if sw.interp
    for i =1:1:L
        %滑动中值滤波
        % Intensity(i,:) = medfilt1(Intensity(i,:),interp_width);
        %滑动均值滤波
        % Intensity(i,:) = smoothdata(Intensity(i,:),interp_width);
        %S-G滤波(矩阵，阶数，窗口)
        Intensity(i,:) = sgolayfilt(Intensity(i,:),4,25);
        % Intensity(i,:) = Xfilter(Intensity(i,:),interp_width);
    end
end

%% 作图 graph
figure(j);j = j+1;
for i = 1:1:L
    % figure(j);j = j+1;
    % subplot(3,1,1);Ylabel='origin';%临时
    plot(Wavelength(i,:),Intensity(i,:),'LineWidth',2); 
    title(filename_split{1,i});
    %图像参数设置
    shading interp; 
    ylabel(sprintf(Ylabel),'Fontname','Times New Roman','FontSize',10);
    xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
    set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    grid on;
    box off;
    %画图保持
    hold on;
    % set(gca,'yticklabel',[]);%不显示x坐标轴刻度
    % set(gca,'xticklabel',[]);
end
legend(filename_split{nameidx,:});
if sw.save
    mkdir(datestr(now,0))
    saveas(figure(j), [filename_split{2,i} '-graph.png']);
end

% %% 一阶微分(矩阵，阶数，对行/列向量进行操作)
% if sw.dif1
%     %一阶微分
%     dif1 = diff(Intensity,1,2);
%     % dif1(i,:) = sgolayfilt(dif1(i,:),5,25);
%     dif1(i,:) = Xfilter(dif1(i,:),100);
%     figure(j);j = j+1;
%     plot(Wavelength(i,1:end-1),dif1(i,:),'LineWidth',2);
%     title('First-order difference');
%     shading interp; 
%     ylabel('Intensity(counts)','Fontname','Times New Roman','FontSize',15);
%     xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
%     set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
%     grid on;
%     box off;
%     hold on;
%     if sw.save
%         saveas(figure(j), [filename_split{2,i} '-graph-diff1.png']);
%     end
% 
%     %二阶微分
%     dif2(i,:) = diff(dif1,1,2);
%     % dif2(i,:) = sgolayfilt(dif2(i,:),3,25);
%     % figure(j);j = j+1;
%     plot(Wavelength(i,1:end-2),dif2(i,:),'LineWidth',2);
%     title('Second-order difference');
%     shading interp; 
%     ylabel('Intensity(counts)','Fontname','Times New Roman','FontSize',15);
%     xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
%     set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
%     grid on;
%     box off;
%     hold on;
%     if sw.save
%         saveas(figure(j), [filename_split{2,i} '-graph-diff2.png']);
%     end
% end

%% 一阶微分(矩阵，阶数，对行/列向量进行操作)
if sw.dif1
    %一阶微分
    dif1 = diff(Intensity,1,2);
    % dif1(i,:) = sgolayfilt(dif1(i,:),5,25);
    dif1(i,:) = Xfilter(dif1(i,:),25);
    % figure(j);j = j+1;
    subplot(3,1,2);
    plot(Wavelength(i,1:end-1),dif1(i,:),'LineWidth',2);
    % title('First-order difference');
    shading interp; 
    ylabel('1st diff','Fontname','Times New Roman','FontSize',10);
    set(gca,'position',[0.15 0.37 0.75 0.27]);
    set(gca,'yticklabel',[]);%不显示x坐标轴刻度
    set(gca,'xticklabel',[]);
    % xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
    set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    grid on;
    box off;
    hold on;
    if sw.save
        saveas(figure(j), [filename_split{2,i} '-graph-diff1.png']);
    end

    %二阶微分
    dif2(i,:) = diff(dif1,1,2);
    % dif2(i,:) = sgolayfilt(dif2(i,:),3,25);
    % figure(j);j = j+1;
    subplot(3,1,3);
    plot(Wavelength(i,1:end-2),dif2(i,:),'LineWidth',2);
    % title('Second-order difference');
    shading interp; 
set(gca,'position',[0.15 0.1 0.75 0.27]);
set(gca,'yticklabel',[]);%不显示x坐标轴刻度
    ylabel('2nd diff','Fontname','Times New Roman','FontSize',10);
    xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
    set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    grid on;
    box off;
    hold on;
    if sw.save
        saveas(figure(j), [filename_split{2,i} '-graph-diff2.png']);
    end
end