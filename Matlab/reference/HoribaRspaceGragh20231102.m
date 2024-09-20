clc;
clear;
clf;
close all;
%% 控制区域
sw.normalize = 0;%强度归一化
sw.figure = 0;%显示figure
sw.xlabel = 1;%横坐标转换为能量  
    nameidx = 4;%文件名关键字位置
sw.background = 0;%减背景
    keytag.background = 'Backogrund';
sw.contrast = 1;%差分反射
    keytag.substrate  ='PDMS';%衬底关键字
sw.fit = 0;%拟合
    num_peak = 3;%拟合峰数
sw.interp = 1;%数据平滑
    interp_width = 200;%平滑窗口
sw.mapping_dir = 0;%mapping方向变竖直
sw.dif1 = 1;%一阶微分
sw.dif2 = 1;%二阶微分
sw.save =0;%保存图片


%% 文件路径
filepath='E:\1--------------------------------------plot';
filelist=dir([filepath '\*.txt']);
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));

%% 预设
L=length(filename);
NA = 0.75;

%预设矩阵、元胞数组
intensity = [];
wavelength = [];
energy = [];
angleKspace = [];

spectra = {1,L};
filename_split1 = {1,L};
filename_split2 = {1,L};
%% 穷举文件
for iFile = 1:1:L
    filename{1,iFile}=(filelist(iFile).name);
    spectra{1,iFile} = importdata(filename{1,iFile});     
    intensity(iFile,:) = spectra{1,iFile}(1:end,2);
    wavelength(iFile,:) = spectra{1,iFile}(1:end,1);
    energy(iFile,:) = 1240./wavelength(iFile,:);
end
strip = 1:1:size(spectra{1,1},1);
centerstrip = size(spectra{1,1},1)/2;
angleKspace = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
angleKspace = 180/pi*atan(angleKspace);

%% 处理数据1
%强度归一化
if sw.normalize
    max_Intensity = max(intensity,[],2);
    intensity = intensity./max_Intensity;
end

%横坐标换为能量
Xlabel = 'Wavelength(nm)';
if sw.xlabel
    wavelength = energy;
    Xlabel = 'Energy(eV)';
end

%分隔文件名
for iFile = 1:1:L
    filename_split1{1,iFile} = split(filename{1,iFile},'#');
    filename_split2{1,iFile} = split(filename_split1{1,iFile}{2,1},'-');
    filename_split2{1,iFile}{1,1} = strcat(filename_split1{1,iFile}{1,1},'#');
    if iFile == 1
        filename_split = filename_split2{1,1};
    else
        filename_split = [filename_split filename_split2{1,iFile}];
    end
end

%% 减背景
if sw.background
    [row1,idx_background] = find(strcmp(filename_split,sprintf(keytag.background)));
    background = intensity(idx_background,:);
    intensity(idx_background,:) = [];
    wavelength(idx_background,:) = [];
    filename_split(:,idx_background) = [];
    L = size(intensity,1);
    for i = 1:1:L
        intensity(i,:) = intensity(i,:)-background;
    end
end

    %% 差分反射
    %纵坐标换为差分反射
    Ylabel = 'Intensity(counts)';
    %重组文件
    if sw.contrast
        Ylabel = 'Contrast reflectance';
        [row2,idx_substrate] = find(strcmp(filename_split,sprintf(keytag.substrate)));
        substrate = intensity(idx_substrate,:);
        intensity(idx_substrate,:) = [];
        wavelength(idx_substrate,:) = [];
        filename_split(:,idx_substrate) = [];
        L = size(intensity,1);
        for i = 1:1:L
            intensity(i,:) = (intensity(i,:)-substrate)./substrate;
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
        intensity(i,:) = sgolayfilt(intensity(i,:),4,25);
        % Intensity(i,:) = Xfilter(Intensity(i,:),interp_width);
    end
end

%% 作图 graph
iFigure = 1;
figure(iFigure);iFigure = iFigure+1;
subplot(3,1,1);
for iFile = 1:1:L
    Ylabel='origin';%临时
    plot(wavelength(iFile,:),intensity(iFile,:),'LineWidth',2); 
    title(filename_split{1,iFile});
    %图像参数设置
    shading interp; 
    ylabel(sprintf(Ylabel),'Fontname','Times New Roman','FontSize',10);
    xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
    set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    set(gca,'position',[0.15 0.64 0.75 0.27]);
    grid on;
    box off;
    %画图保持
    hold on;
    set(gca,'yticklabel',[]);%不显示x坐标轴刻度
    set(gca,'xticklabel',[]);
    %拟合
    if sw.fit
        [xData,yData] = prepareCurveData(wavelength(iFile,:),intensity(iFile,:));
        [fitresult,gof] = fit(xData,yData,fitEqn,opts);
        half_height = fitresult.a1/2;
        fwhm = zeros(num_peak,1);
        left_idx = zeros(num_peak,1);
        right_idx = zeros(num_peak,1);
        % for k = 1:1:num_peak%半高全宽
        %     half_height(k) = fitresult.(sprintf('a%d',k))/2;
        %     left_idx(k) = find(yData(1:fitresult.(sprintf('b%d',k)))<=half_height(k),1,'last');
        %     right_idx(k) = find(yData(fitresult.(sprintf('b%d',k)):end)<=half_height(k),1,'first')+fitresult.(sprintf('b%d',k))-1;
        %     fwhm(k) = x(right_idx(k))-x(left_idx(k));
        % end
        plot(fitresult,xData,yData);
        hold on;
        % for k = 1:1:num_peak
        %     plot([xData(left_idx(k)) xData(right_idx(k))],[yData(half_height(k)) yData(half_height(k))],'r');
        % end
    end
end
% legend(filename_split{nameidx,:});
if sw.save
    mkdir(datestr(now,0))
    saveas(figure(iFigure), [filename_split{2,i} '-graph.png']);
end

%% 一阶微分(矩阵，阶数，对行/列向量进行操作)
if sw.dif1
    subplot(3,1,2);    
    for iFile = 1:1:L
        %一阶微分
        dif1(iFile,:) = diff(intensity(iFile,:),1,2);
        % dif1(iFile,:) = sgolayfilt(dif1(i,:),5,25);
        dif1(iFile,:) = Xfilter(dif1(iFile,:),25);
        plot(wavelength(iFile,1:end-1),dif1(iFile,:),'LineWidth',2);
        % title('First-order difference');
        shading interp; 
        xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
        ylabel('1st diff','Fontname','Times New Roman','FontSize',10);
        set(gca,'position',[0.15 0.37 0.75 0.27]);
        % set(gca,'yticklabel',[]);%不显示x坐标轴刻度
        % set(gca,'xticklabel',[]);
        set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
        grid on;
        box off;
        hold on;
        if sw.save
            saveas(figure(iFigure), [filename_split{2,iFile} '-graph-diff1.png']);
        end
    end
end

if sw.dif2
    subplot(3,1,3); 
    for iFile = 1:1:L
        %二阶微分
        dif2(iFile,:) = diff(dif1(iFile,:),1,2);
        % dif2(iFile,:) = sgolayfilt(dif2(iFile,:),3,25);
        plot(wavelength(iFile,1:end-2),dif2(iFile,:),'LineWidth',2);
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
            saveas(figure(iFigure), [filename_split{2,iFile} '-graph-diff2.png']);
        end
    end
end