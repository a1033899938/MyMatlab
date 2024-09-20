%% 信息%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Last Last edit time:20231014
%Last edit time:20240104

%光谱命名格式
%1样品名 2光源 3功率 4样品结构 5测试位置 6kr空间 7Pinhole 8狭缝大小 
%9曝光时间 10曝光帧数 11第几次测试 12测试日期 13波段 14电压/掺杂 15 mapping/graph
%举例：20230922-1#-532nmLaser-50uW-WS_2(SiO_2/Si)-position2-kspace-100umPinhole-100slit-20s-5frames-(1)-20230922-550to850-n1V-mapping 

%光谱仪信息
%Horiba-graph
%读取数据：importdata
%光谱文件：波段范围*2 mat；第一列：波长；第二列：强度
%Horiba-image
%光谱文件：257*1025 mat：(1,1)=NaN；第一列的(2:end)：strip位置；第二列的(2:end)：波长；其余：强度

%PI
%读取数据：loadSPE
%光谱文件：struct
%xdim：波段范围
%ydim：strip
%int(ydim*xdim)：强度
%wavelength(波段范围*1)：波长
%expo_time：曝光时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 清除缓存
% function []=plotSPE(filepath)
clc;
clear;
clf;
close all;
%% 控制区域
%设置文件路径
filepath='E:\0-------------------------Plot-------------------------';
%选择光谱仪
sw.spectrameter = 1;%0=Horiba;1=PI
%legend名称
nameidx = 14;%名称在文件名中的位置
%输出图片前的选项
sw.minus_background = 0;%手动扣背景（待完成）
    keytag.background = 'Background';%背景文件关键字
sw.contrast = 0; %差分反射
sw.normalize = 0;%强度归一化（待完成）
    keytag.substrate  ='PDMS';%衬底文件关键字
%输出图片时的选项
sw.xlabel_to_energy = 0;%横坐标转换为能量 
sw.show_image = 0;%显示image
    sw.show_in_subfigure_image = 0;%放在一张figure中
    sw.show_vertically_image = 1;%mapping方向变竖直
sw.show_graph = 1;%显示graph
    sw.show_in_one_graph = 1;%放在一张figure中
    sw.show_in_cascade_graph = 0;%放在一张瀑布图中
spetrum_range = '1:100';%取strip的范围
%二次输出前的处理
sw.fit = 0;%拟合
    num_peak = 3;%拟合峰数
sw.interp = 1;%数据平滑
    interp_width = 200;%平滑窗口
sw.dif_1 = 0;%一阶微分
sw.dif_2 = 0;%二阶微分

%保存图片
sw.save =0;
%% 拟合设置
fitEqn = fittype( sprintf('gauss%d',num_peak));
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [3993.82 632.126 11.7079676041806 3302.75999903016 687.214 12.4141945846841 2810.69838359887 711.442 16.3181111851773];
%% 其他参数设置
NA = 0.75;
j = 1;
%% 开始运行%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 获取文件名
if sw.spectrameter%PI
    filelist=dir([filepath '\*.spe']);
else%Horiba
    filelist=dir([filepath '\*.txt']);
end
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
%% 处理文件名
L=length(filename);
filename_split_1 = {1,L};
filename_split_2 = {1,L};
filename_split_3 = {1,L};
filename_splited = {1,L};
for iFiles = 1:1:L
    filename_split_1{1,iFiles} = split(filename{1,iFiles},'#');
    filename_split_2{1,iFiles} = split(filename_split_1{1,iFiles}{2,1},'-');
    filename_split_2{1,iFiles}{1,1} = strcat(filename_split_1{1,iFiles}{1,1},'#');
    filename_splited{1,iFiles} =  filename_split_2{1,iFiles};%后续改进
end
%% 导入数据
%mapping{1,i} = strip数*波段范围
%intensity{1,i} = 1*波段范围
%wavelenth{1,i} = 波段范围*1
%strip = 1*n
mapping = {1,L};
wavelength = {1,L};
intensity = {1,L};
energy = {1,L};
if sw.spectrameter%PI
    for iFiles=1:1:L
        spnow = loadSPE(filename{1,iFiles});
        mapping{1,iFiles} = spnow.int;
        wavelength{1,iFiles} = spnow.wavelength;
        eval(sprintf('intensity{1,iFiles} = sum(spnow.int(%s,:),1)',spetrum_range));
        energy{1,iFiles} = 1240./wavelength{1,iFiles};
    end
    strip = 1:1:spnow.ydim;
    centerstrip = spnow.ydim/2;
    Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
    Angle = 180/pi*atan(Angle);
else%Horiba
        for iFiles=1:1:L
            spnow = importdata(filename{1,iFile});
            if filename_splited{1,iFiles}{1,15} == 'mapping'
                mapping{1,iFiles} = spnow(2:end,2:end);
                wavelength{1,iFiles} = spnow(1,2:end);
                eval(sprintf('intensity{1,iFile} = sum(mapping{1,iFile}(%s,:),1)',spetrum_range));
                energy{1,iFiles} = 1240./wavelength{1,iFiles};
            else 
                wavelength{1,iFiles} = spnow(1:end,1);
                intensity{1,iFiles} = spnow(1:end,2);
                energy{1,iFiles} = 1240./wavelength{1,iFiles};
            end
        end
        strip = 1:1:256;
        centerstrip = spnow.ydim/2;
        Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
        Angle = 180/pi*atan(Angle);
end
%% 输出图片前的处理
%消除背景基线
% ba = (sum(Intensity(1,1:850))-sum(Intensity(2,1:850)))/850;
% Intensity(2,:)=Intensity(2,:)+ba;

%手动扣背景（待完成）

%差分反射（待完成）
if sw.contrast
    [row2,idx_substrate] = find(strcmp(filename_split,sprintf(keytag)));
    substrate = intensity(idx_substrate,:);
    intensity(idx_substrate,:) = [];
    wavelength(idx_substrate,:) = [];
    filename_split(:,idx_substrate) = [];
    L = size(intensity,1);
    for i = 1:1:L
        intensity(i,:) = (intensity(i,:)-substrate)./substrate;
    end
end

%强度归一化（待完成）
if sw.normalize
    max_Intensity = max(intensity,[],2);
    intensity = intensity./max_Intensity;
end
%% 输出图片时的选项
%横坐标换为能量
Xlabel = 'Wavelength(nm)';
font_size_label = 15;
if sw.xlabel_to_energy
    wavelength = energy;
    Xlabel = 'Energy(eV)';
end

%输出image
if sw.show_image
    Ylabel = 'Angle(degree)';
    for iFiles = 1:1:L
        if ~sw.show_in_subfigure_image%一张谱显示为一张图
            figure(j);j=j+1;
        end
        if sw.show_vertically_image%输出竖直方向的image
            pcolor(Angle,wavelength{1,iFiles},mapping{1,iFiles}');
            xlabel(Ylabel,'Fontname','Times New Roman','FontSize',font_size_label);
            ylabel(Xlabel,'Fontname','Times New Roman','FontSize',font_size_label);
            % title(filename_splited{1,iFiles}{1,14});%需手动
            figure_setting;
        else%输出水平方向的image
            pcolor(wavelength{1,iFiles},Angle,mapping{1,iFiles});
            xlabel(Xlabel,'Fontname','Times New Roman','FontSize',font_size_label);
            ylabel(Ylabel,'Fontname','Times New Roman','FontSize',font_size_label);
            % title(filename_splited{1,iFiles}{1,14});%需手动
            figure_setting;
        end
        if ~sw.show_in_subfigure_image && sw.save%如果一张谱显示为一张图，则每显示一次就保存
            saveas(figure(j), [filename_splited{2,iFiles} '-mapping.png']);
        end
    end
    if sw.show_in_subfigure_image && sw.save%如果所有谱显示在一张图上，则显示完再保存
            saveas(figure(j), [filename_splited{2,iFiles} '-mapping.png']);
    end
end

%输出graph
if sw.show_graph
    if sw.contrast
        Ylabel = 'Differential reflectance(a.u.)';
    elseif sw.normalize
        Ylabel = 'Normalized intensity(a.u.)';
    else
        Ylabel = 'Intensity(counts)';
    end
    for iFiles = 1:1:L
        if ~sw.show_in_one_graph%一张谱显示为一张图
            figure(j);j=j+1;
        end
        plot(wavelength{1,iFiles},intensity{1,iFiles},'LineWidth',2);
        xlabel(Xlabel,'Fontname','Times New Roman','FontSize',font_size_label);
        ylabel(Ylabel,'Fontname','Times New Roman','FontSize',font_size_label);
        title(filename_splited{1,iFiles}{1});%需手动
        legend(filename_splited{1,iFiles}{14});%需手动
        figure_setting;
        if sw.show_in_one_graph
            hold on 
        end

    end
end


%% 数据平滑
% if sw.interp
%     for i =1:1:L
%         %滑动中值滤波
%         % Intensity(i,:) = medfilt1(Intensity(i,:),10);
%         %滑动均值滤波
%         % Intensity(i,:) = smoothdata(Intensity(i,:),5);
%         %S-G滤波(矩阵，阶数，窗口)
%         % Intensity(i,:) = sgolayfilt(Intensity(i,:),5,25);
%         intensity(i,:) = Xfilter(intensity(i,:),interp_width);
%     end
% end

%% 一阶微分(矩阵，阶数，对行/列向量进行操作)
% if sw.dif_1
%     %一阶微分
%     dif1 = diff(intensity,1,2);
%     % dif1(i,:) = medfilt1(dif1(i,:),7);
%     % dif1(i,:) = Xfilter(dif1(i,:),20);
%     figure(j);j = j+1;
%     plot(wavelength(i,1:end-1),dif1(i,:),'LineWidth',2);
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
%     figure(j);j = j+1;
%     plot(wavelength(i,1:end-2),dif2(i,:),'LineWidth',2);
%     title(filename_split{1,i},'diff1');
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

%% 寻找零点位置
% c = zeros(size(dif2));
% before = dif2(1,1);
% for i = 2:1:length(dif1)
%     if (dif1(1,i)*before)<=0
%         c(i) = max(Intensity);
%     end
%     before = dif1(1,i);
% end
% %临时
% plot(Wavelength(1,1:end-2),c,'LineWidth',0.1);
% shading interp; 
% ylabel('Intensity(counts)','Fontname','Times New Roman','FontSize',15);
% xlabel(sprintf(Xlabel),'Fontname','Times New Roman','FontSize',15);
% set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
% grid on;
% box off;
% %临时

%%
%fileparts
%title(sprintf("%d次多项式最小二乘拟合", i
    % % 计算显示区域的范围
    % x_range = round(xaxis_mean) - half_size : round(xaxis_mean) + half_size;
    % y_range = round(yaxis_mean) - half_size : round(yaxis_mean) +
    % half_size;