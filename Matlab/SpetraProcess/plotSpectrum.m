%% 信息%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Author: Junjie Xie $    
% $Created: 2023/10/14 $    
% $Modified: 2024/03/14 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%光谱命名格式                                                                                  
% 1样品名 2测量温度 3光源 4功率 5样品结构 6测试位置 
% 7kr空间 8Pinhole 9狭缝大小 10曝光时间 11曝光帧数 
% 12测试日期 13该日第几次测试 14波段 15顶栅电压 16底栅电压 17左右旋/TETM
%举例：20230922-1#-8.22K-532nmLaser-50uW-WS_2(SiO_2/Si)-position2-...
% kspace-100umPinhole-100slit-20s-5frames-...
% (1)-20230922-550to850-5V-n1V-circular0110

%光谱仪信息
%Horiba-graph
%读取数据：importdata
%光谱文件：波段范围*2 mat；第一列：波长；第二列：强度
%Horiba-image
%光谱文件：257*1025 mat
% (1,1)=NaN, 第一列的(2:end)=strip位置, 第二列的(2:end)=波长, 其余=强度

%PI
%读取数据：loadSPE
%光谱文件：struct
%xdim：波段范围
%ydim：strip
%int(ydim*xdim)：强度
%wavelength(波段范围*1)：波长
%expo_time：曝光时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 00 清除缓存
clc;clear;clf;close all;
%% 控制区域%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 01 选择光谱文件
% 选择光谱仪0=Horiba; 1=PI
sw.chooseSpectrameter = 1;
%BL
filepath = 'D:\BaiduSyncdisk\Junjie Xie Backup\plot\BL-K';
%ML
% filepath = 'C:\Users\a1033\Nutstore\1\厦门大学光物质相互作用研究组\Users\Junjie Xie\Spectra\Princeton Instrument\XieJunjie-PI\WS2ML-20230718-3#\20240320\2';
%e
% filepath = 'C:\Users\a1033\Nutstore\1\厦门大学光物质相互作用研究组\Users\Junjie Xie\Spectra\Princeton Instrument\XieJunjie-PI\WS2ML-20230718-3#\20240320\2';
% filepath = 'D:\BaiduSyncdisk\Junjie Xie Backup\plot';% 百度同步空间
% filepath = 'D:\BaiduSyncdisk\Junjie Xie Backup\plot';
% filepath = uigetdir ('*.*','请选择文件夹');
cd(filepath);
% 删除多余文件
sw.deleteFile =         0;      idxArray.deleteFile = [2 4 5];%idxArray.deleteFile = [1 4 5 6 7 8];
%% 02 文件排序
%优先级：electrical>power>...
% 0=不排序；1=以掺杂电压；2=以电场
sw.sortByElectric = 0;  
% 以功率
sw.sortByPower =    0;
% 手动
sw.sortByManual =   0;      idxArray.sort = [1 5 2 3 4];% 以矩阵显示的顺序
%% 03 文件名中的关键字相关
% 标签/标题关键字的idx
idx.name =            6;     
% 补全下划线
sw.editFilename =     1;       
% 手动组合关键字
sw.combineFilename =  0;     idxArray.combineFilename = [4 6 8];% 让指定idx的关键字组合
% ***显示test文件时，将其文件名用0补全到此长度
filenameLengthGuess = 16;
%修改标题
sw.edit_graph_title = 0;
        imageTotalTitle = '';
        graph_title = imageTotalTitle;
%标签显示完整文件名
sw.showEntileLegend = 0;
%% 04 处理intensity/wavelength
% 手动取出噪声尖峰
sw.processRemoveWhiteNoise = 0;

% 手动扣背景
sw.processMinusBackground =  0;      keytag.background = 'Background';%背景文件关键字
%根据积分时间归一化
sw.normalizeByTime =         0;
%差分反射
sw.reflectanceContrast =     0;      keytag.substrate  ='SiO_2';%衬底文件关键字
sw.firstOrderDifferential =  0;
%最大强度归一化
sw.normalizeByMax =          0;


% 选择光谱波长范围
sw.chooseWavelengthRange =  1;
% 取波长范围[a b],或'all'
wavelengthRange =           [667,800];%'all';%[600,650];%[6.109741832228412e+02,6.189106668987079e+02];%'all';%[550 800];'all';%%%;
% 取strip的范围(不可设置1:end),小房间PI最大为1:100，ARS最大为;
spectrumRange   =           '20:80';%'52-3:52+4';
%% 05 输出image
% 纵坐标转换为angle(限image)
sw.ylabelToAngle =            1;       NA = 0.75;
% 横坐标转换为能量
sw.xlabelToEnergy =           0;
% image方向变竖直
sw.showImageVertically =      1; 
sw.showImageUpsidedown =      1;


% 显示image
sw.showImage =                1;
% image以subplot放在一张figure中
sw.showImageInSubplot =       1;
% 在image中显示选取光谱范围
sw.showImageStripRange =   1;      strip_range_color = '--y';       strip_range_linewidth = 1;
% 显示strip-graph(波长方向累加图)
sw.showImageStripGraph =      1;     strip_graph_amlitude_ratio = 0.1;       strip_graph_color = '-g';        strip_graph_linewidth = 1;
% 显示wavelength-graph(strip方向累加图)
sw.showImageWavelengthGraph = 1;        wavelength_graph_amlitude_ratio = 0.2;      wavelength_graph_color = '-r';       wavelength_graph_linewidth = 1;
%
sw.showImageWavelengthGraphEdge = 1;
    Center_WavelengthGraphEdge = 700;
%% 06 输出graph
% 显示graph
sw.showGraph =                1;
% graph放在一张图中
sw.showGraphInOnePlot =       1;
% 放在一张瀑布图中%必须开启sw.show_graph_in_one_plot
sw.showGraphInCascadePlot =   0;      offset_pre = 1500;%常见错误：开启归一化以后使用过大的offset（>1）
% 放在一张image中（将多张一维图组合为二维图）
sw.showGraphInOneImage =      0;
%% 07 拟合
%二次输出前的处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 峰值拟合
sw.fit =                      0;
% 拟合方程
fittingEqt =                 'Lorenz 1';
% 显示拟合后的图像
sw.showFitGraph =             0;
% 显示拟合模型
sw.showFitModel =             0;
nPeak = 9;%拟合峰数
% 拟合曲线的线宽、中心波长%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%待完成：根据拟合峰数，调整plot数，输入参数变更为矩阵输入；
sw.showFittingAmplitude =         0;%以拟合的幅度画图
sw.showFittingCenterwavelenth =   0;%以拟合的中心波长画图
sw.showFitLinewidth =             0;%以拟合的线宽画图
        fittingGraphLinewidth = 1.5;%拟合后数据点图的粗细
        fittingGraphColorPeak_1 = 'o--b';%拟合后数据点图的样式-颜色
        fittingGraphColorPeak_2 = '+--c';%拟合后数据点图的样式-颜色
        fitting_ylim_low_weight = 1;%同样会影响原始graph的lim
        fitting_ylim_high_weight = 1.2;
switch fittingEqt
    case 'Lorenz 1'
        fittingEqn = fittype('a1/((x-b1)^2+c1)+d', ...
        'coefficients', {'a1', 'b1', 'c1', 'd'});
        initialGuess = [1e5, 610, 10, 1];% 初始猜测
    case 'Lorenz 2'
        fittingEqn = fittype('a1/((x-b1)^2+c1)+a2/((x-b2)^2+c2)+d', ...
        'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2', 'd'});
        initialGuess = [1e4, 633, 10, 1e4, 703, 10, 1];% 初始猜测
end
    %高斯线形
    % fittingEqn = fittype(sprintf('gauss%d',nPeak));
    % initialGuess = [1e4, 720, 10];% 初始猜测
    %洛伦兹线形(双峰)
    % fittingEqn = fittype('a1/((x-b1)^2+c1)+a2/((x-b2)^2+c2)+d', ...
    %     'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2', 'd'});
    % initialGuess = [8e4, 740, 10, 1e4, 740, 10, 1];% 初始猜测
    %洛伦兹线形(三峰)
    % fittingEqn = fittype('a1/((x-b1)^2+c1)+a2/((x-b2)^2+c2)+a3/((x-b3)^2+c3)+d', ...
        % 'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2', 'a3', 'b3', 'c3', 'd'});
    % %峰值为a/c，中心波长为b，半高宽为2*sqrt(c)
    % initialGuess = [5000, 630, 10, 4300, 680, 10, 4000, 710, 10, 1];% 初始猜测
    %法诺线形
    % fittingEqn 
    % initialGuess
    %Voigt线形
    % fittingEqn = fittype('a1/(1+exp(-b1*(x-c1)))+a2/(1+exp(-b2*(x-c2)))+d',...
    %     'coefficients',{'a1', 'b1', 'c1', 'a2', 'b2', 'c2', 'd'});
    % initialGuess = [2000 630, 630, 1000, 700, 700, 1];% 初始猜测
    
    
%% 08 字体，颜色
%同时显示两组数据(两个关键字不同的光谱(一般一组光谱只有一个关键字不同))
sw.showTwoKindGraph = 0;
    idx.twoKindGraphName = 12;%选取其一关键字
    keytag.twoKindGraphName = '20240131';%不同字段显示不同graph颜色
    graphColor_1 = '-';%- -- : :.
    graphColor_2 = '-';
    graphLinewidth = 1;

%设置默认字体、graph颜色
graphColor = '-';
fontSize_label = 15;
fontSize_title = 15;
fontSize_legend = 15;
fontSize_tick = 10;
% set(0,'defaultaxesfontsize',16);
% set(0,'defaulttextfontsize',16);
% set(0,'defaultaxeslinewidth',2);
% set(0,'defaultlinelinewidth',2);

%三次输出前的处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sw.curve_interp = 0;%数据平滑
    interp_width = 200;%平滑窗口
sw.dif_1 = 0;%一阶微分
sw.dif_2 = 0;%二阶微分
%由于文件名长度位置不一的暂时设定方法%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 其他参数设置
idx.votage_1 =     14;
idx.votage_2 =     15;
idx.power =        4;
idx.acquire_time = 9;
idx.position =     4;
%idx指字段在文件名矩阵中的位置；idx2指第几个文件
% subplot索引
j = 1;
% 保存图片
sw.save =0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 开始运行%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 获取文件名
if sw.chooseSpectrameter%PI
    filelist=dir([filepath '\*.spe']);
else%Horiba
    filelist=dir([filepath '\*.txt']);
end
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
% %% 处理文件名
L=length(filename);
filename_split_1 = cell(1,L);
filename_split_2 = cell(1,L);
filename_splited = cell(1,L);
filename_splited_mat = cell(1,L);
for iFiles = 1:1:L
    if sw.chooseSpectrameter
        filename{1,iFiles} = replace(filename{1,iFiles},'.spe','');
    else
        filename{1,iFiles} = replace(filename{1,iFiles},'.txt','');
    end
    if ~contains(filename{1,iFiles},'#')%以文件名中是否包含"#"来判断是不是标准命名格式的光谱文件
        filename_splited_mat(1:filenameLengthGuess-1,iFiles) = num2cell(zeros(1,filenameLengthGuess-1));
        filename_splited_mat{filenameLengthGuess,iFiles} = filename{1,iFiles};
        for iFilename = 1:1:filenameLengthGuess
            filename_splited_mat{filenameLengthGuess,iFiles} = num2str(filename_splited_mat{filenameLengthGuess,iFiles});
        end
    else
        filename_split_1{1,iFiles} = split(filename{1,iFiles},'#');
        filename_split_2{1,iFiles} = split(filename_split_1{1,iFiles}{2,1},'-');
        filename_split_2{1,iFiles}{1,1} = strcat(filename_split_1{1,iFiles}{1,1},'#');
    end
    if sw.sortByElectric%可修改（添加）
        filename_split_2{1,iFiles}{idx.votage_1,1} = replace(filename_split_2{1,iFiles}{idx.votage_1,1},'n','-');%将文件名中的"n"换为"-"
        filename_split_2{1,iFiles}{idx.votage_2,1} = replace(filename_split_2{1,iFiles}{idx.votage_2,1},'n','-');
        filename_split_2{1,iFiles}{idx.votage_1,1} = replace(filename_split_2{1,iFiles}{idx.votage_1,1},'V','');%去掉文件名中的"V"
        filename_split_2{1,iFiles}{idx.votage_2,1} = replace(filename_split_2{1,iFiles}{idx.votage_2,1},'V','');
    elseif sw.sortByPower
        filename_split_2{1,iFiles}{idx.power,1} = replace(filename_split_2{1,iFiles}{idx.power,1},'nW','*1e-3');%去掉文件名中的"nW"
        filename_split_2{1,iFiles}{idx.power,1} = replace(filename_split_2{1,iFiles}{idx.power,1},'uW','');%去掉文件名中的"uW"
        filename_split_2{1,iFiles}{idx.power,1} = replace(filename_split_2{1,iFiles}{idx.power,1},'mW','*1e3');%去掉文件名中的"mW"
    else
    end
    filename_splited{1,iFiles} =  filename_split_2{1,iFiles};%便于后续改进
    filename_length = length(filename_splited{1,iFiles});
    filename_splited_mat(1:filename_length,iFiles) = filename_splited{1,iFiles};
end


%手动选择去除文件
if sw.deleteFile
    filelist(idxArray.deleteFile,:) = [];
    filecell(:,idxArray.deleteFile) = [];
    filename(idxArray.deleteFile) = [];
    filename_splited(idxArray.deleteFile) = [];
    filename_splited_mat(:,idxArray.deleteFile) = [];
    L = length(filename);
end

%变功率
if sw.sortByPower
    Power = str2double(char(filename_splited_mat(idx.power,:)));%将功率由字符转换为数值
    [~,sort_idx] = sort(Power);%根据激发功率获取排序后，文件的索引
    filename_splited_mat = filename_splited_mat(:,sort_idx);%根据激发功率, 对分隔文件名矩阵重新排序
    filename = filename(sort_idx);%根据激发功率, 对文件名矩阵重新排序
    Power = Power(sort_idx); %对激发功率矩阵重新排序
    power_str = cell(1,L);
    %补回激发功率后的"uW"
    for iFiles = 1:1:L
        power_str{1,iFiles} =num2str(Power(iFiles),'%.2f');%保留两位有效数字
    end
    for iFiles = 1:1:L
        if contains(filename_splited_mat{idx.power,iFiles},'*1e3')
            filename_splited_mat{idx.power,iFiles} = replace(filename_splited_mat{idx.power,iFiles},'*1e3','mW');%补回单位
        elseif contains(filename_splited_mat{idx.power,iFiles},'*1e-3')
            filename_splited_mat{idx.power,iFiles} = replace(filename_splited_mat{idx.power,iFiles},'*1e-3','nW');%补回单位
        else
            filename_splited_mat{idx.power,iFiles} = strcat(filename_splited_mat{idx.power,iFiles},'uW');%原分隔文件名矩阵
        end
    end
end

%变电压：掺杂/电场
if sw.sortByElectric
    votageTop = str2double(filename_splited_mat(idx.votage_1,:));%将电压如'n1V'由字符转换为数值-1
    votageBot = str2double(filename_splited_mat(idx.votage_2,:));%将电压如'n1V'由字符转换为数值-1
    votageAdd = votageTop + votageBot;
    votageMin = votageTop - votageBot;
    idxVotage0 = intersect(find(votageAdd == 0),find(votageMin == 0));
    idx.ElectricEp0 = setdiff(find(votageAdd == 0),idxVotage0);
    idx.DopeEp0 = setdiff(find(votageMin == 0),idxVotage0);
    % idxVotage0 = intersect(idxVotage0,find(filename_splited_mat(12,:) ~= '(1)'));
    %删除掺杂/电场文件
    if sw.sortByElectric == 1
        filelist(idx.ElectricEp0,:) = [];
        filecell(:,idx.ElectricEp0) = [];
        filename(idx.ElectricEp0) = [];
        filename_splited(idx.ElectricEp0) = [];
        filename_splited_mat(:,idx.ElectricEp0) = [];
        L = length(filename);
    elseif sw.sortByElectric == 2 
        filelist(idx.DopeEp0,:) = [];
        filecell(:,idx.DopeEp0) = [];
        filename(idx.DopeEp0) = [];
        filename_splited(idx.DopeEp0) = [];
        filename_splited_mat(:,idx.DopeEp0) = [];
        L = length(filename);
    else
        sprintf('error');
    end
    %可修改（添加）：以其他值来排序，比如功率，温度
    if sw.sortByElectric == 1
        votage = votageAdd(find(votageMin==0));%dope
        [~,sort_idx] = sort(votage);%根据电场电压获取排序后，文件的索引
    elseif sw.sortByElectric == 2
        votage = votageMin(find(votageAdd==0));%field
        [~,sort_idx] = sort(votage);%根据dope电压获取排序后，文件的索引
    else
    end
    filename_splited_mat = filename_splited_mat(:,sort_idx);%根据电压值, 对分隔文件名矩阵重新排序
    filename = filename(sort_idx);%根据电压值, 对文件名矩阵重新排序
    votage = votage(sort_idx); %对电压值矩阵重新排序
    votage_str = cell(1,L);
    %补回电压值后的"V"
    for iFiles = 1:1:L
        votage_str{1,iFiles} =num2str(votage(iFiles),'%.1f');%保留一位有效数字
    end
    for iFiles = 1:1:L
        filename_splited_mat{idx.votage_1,iFiles} = strcat(filename_splited_mat{idx.votage_1,iFiles},'V');%原分隔文件名矩阵
        filename_splited_mat{idx.votage_2,iFiles} = strcat(filename_splited_mat{idx.votage_2,iFiles},'V');
        if sw.sortByElectric
            electrical_label = 'electrical field';
        else
            electrical_label = 'dope';
        end
        votage_str{1,iFiles} = strcat(votage_str{1,iFiles},['V-' electrical_label]);
    end
end
%补回filename的文件名后缀
for iFiles = 1:1:L
    if sw.chooseSpectrameter
            filename{1,iFiles} = strcat(filename{1,iFiles},'.spe');
        else
            filename{1,iFiles} = strcat(filename{1,iFiles},'.txt');
    end
end

if sw.sortByManual
    filename = filename(:,idxArray.sort);
    filename_splited_mat = filename_splited_mat(:,idxArray.sort);
end
%% 文件名修改(补下划线等等)
if sw.editFilename
    for iFiles = 1:1:L
        for iRows = 1:1:size(filename_splited_mat,1)
            if isempty(filename_splited_mat{iRows,iFiles})
                continue
            end
            filename_splited_mat{iRows,iFiles} =  regexprep(filename_splited_mat{iRows,iFiles},'ws2','WS_2','ignorecase');
            filename_splited_mat{iRows,iFiles} =  regexprep(filename_splited_mat{iRows,iFiles},'wse2','WSe_2','ignorecase');
            filename_splited_mat{iRows,iFiles} =  regexprep(filename_splited_mat{iRows,iFiles},'mos2','MoS_2','ignorecase');
            filename_splited_mat{iRows,iFiles} =  regexprep(filename_splited_mat{iRows,iFiles},'mose2','MoSe_2','ignorecase');
            filename_splited_mat{iRows,iFiles} =  regexprep(filename_splited_mat{iRows,iFiles},'sio2','SiO_2','ignorecase');
        end
    end
end
%% 手动自由组合标签
filename_legend_combined = [];
if sw.combineFilename
    nLegend_combine = width(idxArray.combineFilename);
    filename_legend_combine_1 = {nLegend_combine,L};
    filename_legend_combined = cell(1,L);
    for iFiles = 1:1:L
        for iLegend_combine = 1:1:nLegend_combine
            filename_legend_combine_1{iLegend_combine,iFiles} = filename_splited_mat{idxArray.combineFilename(iLegend_combine),iFiles};
        end
    end
    for iFiles = 1:1:L
        for iLegend_combine = 1:1:nLegend_combine
            if iLegend_combine == 1
                filename_legend_combined{1,iFiles} = filename_legend_combine_1{iLegend_combine,iFiles};
            else
                filename_legend_combined{1,iFiles} = strcat(filename_legend_combined{1,iFiles},'-',filename_legend_combine_1{iLegend_combine,iFiles});
            end
        end
    end
end
%可考虑用append组合cell来实现
%% 获取subplot参数
column_subplot = ceil(sqrt(L));
row_subplot = ceil(L/column_subplot);
if L > 16%设置子图数目上限为4*4=16张
    column_subplot = 4;
    row_subplot = 4;
end
%% 导入数据
%mapping{1,i} = strip数*波段范围
%intensity{1,i} = 1*波段范围
%wavelenth{1,i} = 波段范围*1
%strip = 1*n
mapping = cell(1,L);
wavelength = cell(1,L);
intensity = cell(1,L);
energy = cell(1,L);
strip_graph = cell(1,L);
wavelength_graph = cell(1,L);
sp = cell(1,L);
if sw.chooseSpectrameter%PI
    for iFiles=1:1:L
        spnow = loadSPE(filename{1,iFiles});
        sp{1,iFiles} = spnow;
        mapping{1,iFiles} = spnow.int;
        wavelength{1,iFiles} = spnow.wavelength;
        eval(sprintf('intensity{1,iFiles} = sum(spnow.int(%s,:),1)',spectrumRange));
        energy{1,iFiles} = 1240./wavelength{1,iFiles};
        if sw.processRemoveWhiteNoise
            [noise_x, noise_y] = find(mapping{1,iFiles}>3000);
            mapping{1,iFiles}(noise_x, noise_y) = min(min(mapping{1,iFiles}));
        end
        if sw.xlabelToEnergy
            wavelength{1,iFiles} = 1240./wavelength{1,iFiles};
        end
        wavelength{1,iFiles} = sort(wavelength{1,iFiles});%为了防止光谱中的波长/能量是从大到小，导致wavelength_range获取的上下限idx大小是相反的
        strip_graph{1,iFiles} = sum(spnow.int,2)';
        wavelength_graph{1,iFiles} = sum(spnow.int,1);
        if sw.chooseWavelengthRange
            if strcmp(wavelengthRange,'all')
                wavelength_range_idx = '1:end';
            else
                [~,wavelength_range_start] = min(abs((wavelengthRange(1)-wavelength{1,iFiles})));
                [~,wavelength_range_end] = min(abs((wavelengthRange(2)-wavelength{1,iFiles})));
                wavelength_range_idx = sprintf('%d:%d',wavelength_range_start,wavelength_range_end);
            end
            eval(sprintf('mapping{1,iFiles} = mapping{1,iFiles}(:,%s)',wavelength_range_idx));
            eval(sprintf('wavelength{1,iFiles} = wavelength{1,iFiles}(%s,1)',wavelength_range_idx));
            eval(sprintf('intensity{1,iFiles} = intensity{1,iFiles}(1,%s)',wavelength_range_idx));
            eval(sprintf('wavelength_graph{1,iFiles} = wavelength_graph{1,iFiles}(1,%s)',wavelength_range_idx));
        end
    end
    strip = 1:1:spnow.ydim;
    centerstrip = spnow.ydim/2;
    Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
    Angle = 180/pi*atan(Angle);
else%Horiba
        for iFiles=1:1:L
            spnow = importdata(filename{1,iFiles});
            % if number_splitname == 15 && filename_splited{1,iFiles}{1,15} == 'mapping'
            if 0
                mapping{1,iFiles} = spnow(2:end,2:end);
                wavelength{1,iFiles} = spnow(1,2:end);
                eval(sprintf('intensity{1,iFiles} = sum(mapping{1,iFiles}(%s,:),1)',spectrumRange));
                energy{1,iFiles} = 1240./wavelength{1,iFiles};
            else 
                wavelength{1,iFiles} = spnow(1:end,1);
                intensity{1,iFiles} = spnow(1:end,2)';
                energy{1,iFiles} = 1240./wavelength{1,iFiles};
            end
        end
        strip = 1:1:256;
        centerstrip = 256/2;
        %若ccd收集角为θ，则tan(θ) = h/x;第n条strip的角度为a,有 tan(a) = h'/x
        %则tan(a)/tan(θ) = h'/h,tan(a) = tan(θ)*h'/h
        %若ccd收集角θ=asin(NA)，则有tan(a) = Angle
        Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
        Angle = 180/pi*atan(Angle);
end
%% 输出图片前的处理
%消除背景基线
% ba = (sum(Intensity(1,1:850))-sum(Intensity(2,1:850)))/850;
% intensity(2,:)=intensity(2,:)+ba;

% for iFiles = 1:1:L
%         intensity{1,iFiles} = intensity{1,iFiles}+150;%%先去掉积分时间中的"s"，再将其转化为数值类型,再将积分强度除以积分时间
% end

%根据积分时间归一化
if sw.normalizeByTime
    for iFiles = 1:1:L
        intensity{1,iFiles} = intensity{1,iFiles}/str2double(replace(filename_splited_mat(idx.acquire_time,iFiles),'s',''));%%先去掉积分时间中的"s"，再将其转化为数值类型,再将积分强度除以积分时间
        wavelength_graph{1,iFiles} = wavelength_graph{1,iFiles}/str2double(replace(filename_splited_mat(idx.acquire_time,iFiles),'s',''));
    end
end


%手动扣背景
if sw.processMinusBackground
    idx2.background_file = find(strcmp(filename_splited_mat(idx.name,:),keytag.background));
    background = intensity(idx2.background_file);
    intensity(idx2.background_file) = [];
    wavelength(idx2.background_file) = [];
    filename_splited(idx2.background_file) = [];
    filename_splited_mat(:,idx2.background_file) = [];
    L = length(intensity);%重新定义L
    for iFiles = 1:1:L
        intensity{1,iFiles} = intensity{1,iFiles}-background{1,1};
    end
end

%差分反射
if sw.reflectanceContrast
    idx2.substrate_file = find(strcmp(filename_splited_mat(idx.name,:),keytag.substrate));%idx指在文件名中的位置，idx2指文件的位置
    substrate = intensity{idx2.substrate_file};
    intensity(idx2.substrate_file) = [];
    wavelength(idx2.substrate_file) = [];
    filename_splited(idx2.substrate_file) = [];
    filename_splited_mat(:,idx2.substrate_file) = [];
    if sw.combineFilename
        filename_legend_combined(idx2.substrate_file) = [];
    end
    L = length(intensity);
    for iFiles = 1:1:L
        intensity{1,iFiles} = -(intensity{1,iFiles}-substrate)./substrate;
    end
end

%强度归一化
if sw.normalizeByMax
    for iFiles = 1:1:L
        int_Intensity = sum(intensity{1,iFiles});
        intensity{1,iFiles} = intensity{1,iFiles}./int_Intensity;
    end
end
%% 输出图片时的选项
%输出image
%分配变量
idxWavelength_graph_edge_low = zeros(1,L);
idxWavelength_graph_edge_high = zeros(1,L);
wavelengthGraphRange = cell(1,L);
if sw.showImage
    idx.subplot = 1;%子图索引,每部分使用前先初始化
    figure(j);j=j+1;
    for iFiles = 1:1:L
        if sw.showImageInSubplot
            subplot(row_subplot,column_subplot,idx.subplot);idx.subplot = idx.subplot +1;
        end
        %显示所取的strip范围
        if sw.showImageStripRange
            strip_range_num = str2num(spectrumRange);
            strip_start = strip_range_num(1);
            strip_end = strip_range_num(end);
        end
        %在mapping图上显示每条strip的强度累加graph
        if sw.showImageStripGraph
            %以image的strip范围重置wavelength_graph的幅度，strip_graph同理
            strip_graph_amplitude_des = strip_graph_amlitude_ratio * (max(wavelength{1,iFiles}) - min(wavelength{1,iFiles}));%目标幅度
            strip_graph_amplitude_now = max(strip_graph{1,iFiles}) - min(strip_graph{1,iFiles});%当前幅度
            ratio_strip_graph_now_to_des = strip_graph_amplitude_des / strip_graph_amplitude_now;%比率
            strip_graph_min_des = min(wavelength{1,iFiles});%目标最小值位置
            strip_graph_min_now = min(strip_graph{1,iFiles} * ratio_strip_graph_now_to_des);%当前最小值位置。注意，乘以比率以后，"当前"最小值位置也变了
            diff_strip_graph_now_to_des = strip_graph_min_des - strip_graph_min_now;%差值
            % 重置strip_graph位置
            strip_graph{1,iFiles} = strip_graph{1,iFiles} * ratio_strip_graph_now_to_des + diff_strip_graph_now_to_des; 
        end
        if sw.showImageWavelengthGraph
            wavelength_graph_amplitude_des = wavelength_graph_amlitude_ratio * spnow.ydim;%目标幅度
            wavelength_graph_amplitude_now = max(wavelength_graph{1,iFiles}) - min(wavelength_graph{1,iFiles});%当前幅度
            ratio_wavelength_graph_now_to_des = wavelength_graph_amplitude_des / wavelength_graph_amplitude_now;%比率
            wavelength_graph_min_des = 1;%目标最小值位置
            wavelength_graph_min_now = min(wavelength_graph{1,iFiles} * ratio_wavelength_graph_now_to_des);%当前最小值位置。注意，乘以比率以后，"当前"最小值位置也变了
            diff_wavelength_graph_now_to_des = wavelength_graph_min_des - wavelength_graph_min_now;%差值
            % 重置wavelength_graph位置
            wavelength_graph{1,iFiles} = wavelength_graph{1,iFiles} * ratio_wavelength_graph_now_to_des + diff_wavelength_graph_now_to_des; 
        end
        if sw.ylabelToAngle
            strip = Angle;
            strip_start_angle = 180/pi*atan(tan(asin(NA))*((strip_start-centerstrip)/(centerstrip-1)));
            strip_end_angle = 180/pi*atan(tan(asin(NA))*((strip_end-centerstrip)/(centerstrip-1)));
        end
        if sw.showImageVertically%输出竖直方向的image
            pcolor(strip,wavelength{1,iFiles},mapping{1,iFiles}');
            if sw.showImageStripGraph
                hold on 
                plot(strip,strip_graph{1,iFiles},strip_graph_color,'LineWidth',strip_graph_linewidth);
            end
            if sw.showImageWavelengthGraph
                hold on 
                plot(wavelength_graph{1,iFiles},wavelength{1,iFiles},wavelength_graph_color,'LineWidth',wavelength_graph_linewidth);  
                if sw.showImageWavelengthGraphEdge
                    %分配变量
                    [~,idx.Center_WavelengthGraphEdge] = min(abs(wavelength{1,iFiles} - Center_WavelengthGraphEdge));
                    wavelength_graph_edge_value = max(wavelength_graph{1,iFiles})/exp(1);
                    [~,idxWavelength_graph_edge_low(iFiles)] = min(abs(wavelength_graph{1,iFiles}(1:idx.Center_WavelengthGraphEdge) - wavelength_graph_edge_value));
                    [~,idxWavelength_graph_edge_high(iFiles)] = min(abs(wavelength_graph{1,iFiles}(idx.Center_WavelengthGraphEdge:end) - wavelength_graph_edge_value));
                    idxWavelength_graph_edge_high(iFiles) = idxWavelength_graph_edge_high(iFiles) + idx.Center_WavelengthGraphEdge;
                    hold on
                    % yline(wavelength{1,iFiles}(idx.Center_WavelengthGraphEdge),'-g','LineWidth',2);
                    hold on 
                    yline(wavelength{1,iFiles}(idxWavelength_graph_edge_low(iFiles)),'--y','LineWidth',2);
                    hold on 
                    yline(wavelength{1,iFiles}(idxWavelength_graph_edge_high(iFiles)),'--y','LineWidth',2);
                    wavelengthGraphRange{1,iFiles} = [wavelength{1,iFiles}(idxWavelength_graph_edge_low(iFiles)), wavelength{1,iFiles}(idxWavelength_graph_edge_high(iFiles))];
                end
            end
            if sw.showImageStripRange
                if sw.ylabelToAngle
                    hold on
                    xline(strip_start_angle,strip_range_color,'LineWidth',strip_range_linewidth);
                    hold on
                    xline(strip_end_angle,strip_range_color,'LineWidth',strip_range_linewidth);
                else
                    hold on
                    xline(strip_start,strip_range_color,'LineWidth',strip_range_linewidth);
                    hold on
                    xline(strip_end,strip_range_color,'LineWidth',strip_range_linewidth);
                end
            end
        else%输出正常水平方向的image
            pcolor(wavelength{1,iFiles},strip,mapping{1,iFiles});
            if sw.showImageStripGraph
                hold on 
                plot(strip_graph{1,iFiles},strip,strip_graph_color,'LineWidth',wavelength_graph_linewidth);
            end
            if sw.showImageWavelengthGraph
                hold on 
                plot(wavelength{1,iFiles},wavelength_graph{1,iFiles},wavelength_graph_color,'LineWidth',wavelength_graph_linewidth);
                if sw.showImageWavelengthGraphEdge
                    [~,idx.Center_WavelengthGraphEdge] = min(abs(wavelength{1,iFiles} - Center_WavelengthGraphEdge));
                    wavelength_graph_edge_value = max(wavelength_graph{1,iFiles})/exp(1);
                    [~,idxWavelength_graph_edge_low(iFiles)] = min(abs(wavelength_graph{1,iFiles}(1:idx.Center_WavelengthGraphEdge) - wavelength_graph_edge_value));
                    [~,idxWavelength_graph_edge_high(iFiles)] = min(abs(wavelength_graph{1,iFiles}(idx.Center_WavelengthGraphEdge:end) - wavelength_graph_edge_value));
                    idxWavelength_graph_edge_high(iFiles) = idxWavelength_graph_edge_high(iFiles) + idx.Center_WavelengthGraphEdge;
                    hold on
                    % xline(wavelength{1,iFiles}(idx.Center_WavelengthGraphEdge),'-g','LineWidth',2);
                    hold on 
                    xline(wavelength{1,iFiles}(idxWavelength_graph_edge_low(iFiles)),'--y','LineWidth',2);
                    hold on 
                    xline(wavelength{1,iFiles}(idxWavelength_graph_edge_high(iFiles)),'--y','LineWidth',2);
                    wavelengthGraphRange{1,iFiles} = [wavelength{1,iFiles}(idxWavelength_graph_edge_low(iFiles)), wavelength{1,iFiles}(idxWavelength_graph_edge_high(iFiles))];
                end
            end
            if sw.showImageStripRange
                if sw.ylabelToAngle
                    hold on
                    yline(strip_start_angle,strip_range_color,'LineWidth',strip_range_linewidth);
                    hold on
                    yline(strip_end_angle,strip_range_color,'LineWidth',strip_range_linewidth);
                else
                    hold on
                    yline(strip_start,strip_range_color,'LineWidth',strip_range_linewidth);
                    hold on
                    yline(strip_end,strip_range_color,'LineWidth',strip_range_linewidth);
                end
            end
        end
            xlabel(smartItem('image','x'),'Fontname','Times New Roman','FontSize',fontSize_label);
            ylabel(smartItem('image','y'),'Fontname','Times New Roman','FontSize',fontSize_label);
            colorbar;
            figure_setting;
            if sw.showImageUpsidedown
                set(gca,'YDir','reverse')%y轴方向为常用（从左到右递增）
            end
        if ~sw.showImageInSubplot && sw.save%如果一张谱显示为一张图，则每显示一次就保存
            title(smartItem('image','t'),'FontSize',fontSize_title);
            saveas(figure(j), [filename_splited_mat(idx.name,iFiles) '-mapping.png']);
        elseif ~sw.showImageInSubplot%一张谱显示为一张图
                title(smartItem('image','t'),'FontSize',fontSize_title);
            if iFiles ~=L
                figure(j);j=j+1;
            end
        else 
            title(smartItem('image','t'),'FontSize',fontSize_title);  
        end
        if idx.subplot == 17 && L > 16
            idx.subplot = 1;
            if iFiles ~=L
                figure(j);j=j+1;
            end
        end
    end
    %图片保存
    if sw.showImageInSubplot && sw.save%如果所有谱显示在一张图上，则显示完再保存
        saveas(figure(j), '名字待改-mapping.png');
    elseif sw.showImageInSubplot
        sgtitle(imageTotalTitle,'FontSize',fontSize_title);
    else
    end
end

%输出graph
if sw.showGraphInCascadePlot
    offset = 0:offset_pre:offset_pre*L;
else 
    offset = zeros(1,L);
end
if sw.showGraph
    figure(j);j=j+1;
    for iFiles = 1:1:L
        if sw.showTwoKindGraph
            if filename_splited_mat{idx.twoKindGraphName,iFiles} == keytag.twoKindGraphName
                graphColor = graphColor_1;
            else
                graphColor = graphColor_2;
            end
        end
        plot(wavelength{1,iFiles},intensity{1,iFiles}+offset(iFiles),graphColor,'LineWidth',graphLinewidth);
        xlabel(smartItem('graph','x'),'Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel(smartItem('graph','y'),'Fontname','Times New Roman','FontSize',fontSize_label);
        figure_setting;
        if sw.showGraphInOnePlot
            hold on 
        end
        if ~sw.showGraphInOnePlot%一张谱显示为一张图
            title(smartItem('image','t'),'FontSize',fontSize_title);
            if iFiles ~=L
                figure(j);j=j+1;      
            end
        end
    end
    % set(gca,'yticklabel',[]);
    title(smartItem('graph','t'),'FontSize',fontSize_title);
    if sw.showGraphInCascadePlot || sw.showGraphInOnePlot%仅在一张图多个graph或瀑布图中才显示每条graph的标签
        legend(smartItem('graph','l'),'FontSize',fontSize_legend);
        if sw.edit_graph_title
            title(graph_title);
        end
    end
end
%% 数据拟合
fittingGraphLinewidth = 0.5;%拟合曲线的粗细
fittingGraphColor = 'b';%拟合曲线的样式-颜色
if sw.fit
    fittingCoefficients = zeros(L,length(initialGuess));%创建mat保存拟合系数
    for iFiles = 1:1:L%将拟合曲线与原始数据画在一起
        fittingModel = fit(wavelength{1,iFiles}, intensity{1,iFiles}', fittingEqn, 'StartPoint', initialGuess);% 进行曲线拟合
        if sw.showFitModel    
            disp(fittingModel);% 显示拟合结果（置信边界）
        end
        xFit = linspace(min(wavelength{1,iFiles}), max(wavelength{1,iFiles}), 200);% 生成拟合曲线的 x 值
        yFit = feval(fittingModel, xFit);% 计算拟合曲线的 y 值
        fittingCoefficients(iFiles,:) = coeffvalues(fittingModel);
        if sw.showFitGraph
            if iFiles == 1
                plot(xFit,yFit+offset(iFiles),fittingGraphColor,'HandleVisibility','on','LineWidth',fittingGraphLinewidth);
            else
                plot(xFit,yFit+offset(iFiles),fittingGraphColor,'HandleVisibility','off','LineWidth',fittingGraphLinewidth);
            end
        end
        figure_setting;
        hold on;
    end
    if sw.sortByElectric
        legend([votage_str,'fitting curve'],'FontSize',fontSize_legend);
    end
end
%% 拟
if sw.sortByElectric
        EleorPow = votage;
elseif sw.sortByPower
        EleorPow = Power;
    else
        EleorPow = 1:1:L;
end
%% 拟合后的数据画图
if sw.fit
    nSubfigure = sw.showFittingAmplitude+sw.showFittingCenterwavelenth+sw.showFitLinewidth;%子图数量
    idx.subplot = 1;%子图索引,每部分使用前先初始化    
    %电压-幅度曲线
    if sw.showFittingAmplitude || sw.showFittingCenterwavelenth || sw.showFitLinewidth
        hold off
        figure(j);j=j+1;
    end
    if sw.showFittingAmplitude
        subplot(nSubfigure,1,idx.subplot);idx.subplot=idx.subplot+1;
        fittingAmplitudePeak_1 = fittingCoefficients(:,1)./fittingCoefficients(:,3);
        fittingAmplitudePeak_2 = fittingCoefficients(:,4)./fittingCoefficients(:,6);%计算峰值
        plot(EleorPow,fittingAmplitudePeak_1,fittingGraphColorPeak_1,'LineWidth',fittingGraphLinewidth);%峰一
        hold on
        plot(EleorPow,fittingAmplitudePeak_2,fittingGraphColorPeak_2,'LineWidth',fittingGraphLinewidth); %峰二
        xlabel('Votage(V)','Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel('Peak intensity(counts)','Fontname','Times New Roman','FontSize',fontSize_label);
        % ylim(fitting_ylim_low_weight*min(fitting_amplitude_1,fitting_amplitude_2),fitting_ylim_high_weight*max(fitting_amplitude_1,fitting_amplitude_2));
        title('Votage-dependent peak intensity','FontSize',fontSize_title);
        legend('Peak_1','Peak_2','FontSize',fontSize_legend);
        figure_setting;
    end
    
    %电压-中心波长曲线
    if sw.showFittingCenterwavelenth
        subplot(nSubfigure,1,idx.subplot);idx.subplot=idx.subplot+1;
        fittingCenterwavelenthPeak_1 = fittingCoefficients(:,2);
        fittingCenterwavelenthPeak_2 = fittingCoefficients(:,5);
        
        plot(EleorPow,fittingCenterwavelenthPeak_1,fittingGraphColorPeak_1,'LineWidth',fittingGraphLinewidth);%峰一
        hold on
        plot(EleorPow,fittingCenterwavelenthPeak_2,fittingGraphColorPeak_2,'LineWidth',fittingGraphLinewidth);%峰二
        xlabel('Votage(V)','Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel('Center wavelength(nm)','Fontname','Times New Roman','FontSize',fontSize_label);
        title('Votage-dependent center wavelength','FontSize',fontSize_title);
        legend('Peak_1','Peak_2','FontSize',fontSize_legend);
        figure_setting;   
    end
    
    %电压-线宽曲线
    if sw.showFitLinewidth
        subplot(nSubfigure,1,idx.subplot);
        fittingLinewidthPeak_1 = 2*sqrt(fittingCoefficients(:,3));
        fittingLinewidthPeak_2 = 2*sqrt(fittingCoefficients(:,6));%计算线宽
        
        plot(EleorPow,fittingLinewidthPeak_1,fittingGraphColorPeak_1,'LineWidth',fittingGraphLinewidth);%峰一
        hold on
        plot(EleorPow,fittingLinewidthPeak_2,fittingGraphColorPeak_2,'LineWidth',fittingGraphLinewidth);%峰二
        xlabel('Votage(V)','Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel('linewidth(nm)','Fontname','Times New Roman','FontSize',fontSize_label);
        title('Votage-dependent linewidth','FontSize',fontSize_title);
        legend('Peak_1','Peak_2','FontSize',fontSize_legend);
        figure_setting;
        % 把线宽转换为能量(TMM法拟合用)
        if sw.showFittingCenterwavelenth
            fittingLinewidthInEnergyPeak_1 = 1240./(fittingCenterwavelenthPeak_1 - fittingLinewidthPeak_1/2) - ...
                1240./(fittingCenterwavelenthPeak_1 + fittingLinewidthPeak_1/2);
            fittingLinewidthInEnergyPeak_2 = 1240./(fittingCenterwavelenthPeak_2 - fittingLinewidthPeak_2/2) - ...
                1240./(fittingCenterwavelenthPeak_2 + fittingLinewidthPeak_2/2);
        end
    end
end
%% 多graph组成image
if sw.showGraphInOneImage
    figure(j);j=j+1;
    graph_in_one_image = cell2mat(intensity');
    if sw.showImageVertically
        pcolor(EleorPow,wavelength{1,1},graph_in_one_image');
        colorbar;
        figure_setting;
    else
        pcolor(wavelength{1,1},EleorPow,graph_in_one_image);
        colorbar;
        figure_setting;
    end
        xlabel(smartItem('graph','x'),'Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel(smartItem('graph','y'),'Fontname','Times New Roman','FontSize',fontSize_label);
        title(smartItem('graph','t'),'FontSize',fontSize_title);
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
%% 一阶微分
if sw.firstOrderDifferential
    wavelength_fisrt_order_differential = cell(1,L);
    intensity_fisrt_order_differential = cell(1,L);
    figure;j=j+1;
    for iFiles = 1:1:L
        intensity_fit_eqt = polyfit(wavelength{1,iFiles},intensity{iFiles},50);
        intensity_fit{1,iFiles} = polyval(intensity_fit_eqt,wavelength{1,iFiles});
        intensity_fisrt_order_differential{1,iFiles} = diff(intensity_fit{1,iFiles});
        wavelength_fisrt_order_differential{1,iFiles} = wavelength{1,iFiles}(1:end-1);

        plot(wavelength_fisrt_order_differential{1,iFiles},intensity_fisrt_order_differential{1,iFiles}+offset(iFiles),graphColor,'LineWidth',graphLinewidth);
        xlabel(smartItem('graph','x'),'Fontname','Times New Roman','FontSize',fontSize_label);
        ylabel(smartItem('graph','y'),'Fontname','Times New Roman','FontSize',fontSize_label);
        figure_setting;
        if sw.showGraphInOnePlot
            hold on
        end
        if ~sw.showGraphInOnePlot%一张谱显示为一张图
            title(smartItem('image','t'),'FontSize',fontSize_title);
        end
    end
    title(smartItem('graph','t'),'FontSize',fontSize_title);
    if sw.showGraphInCascadePlot || sw.showGraphInOnePlot%仅在一张图多个graph或瀑布图中才显示每条graph的标签
        legend(smartItem('graph','l'),'FontSize',fontSize_legend);
        if sw.edit_graph_title
            title(graph_title);
        end
    end
end
%% 显示已开功能
swnames = fieldnames(sw);
swvalues = cell(1,length(swnames));
for iSwnames = 1:1:length(swnames)
    swvalues{iSwnames} = getfield(sw,swnames{iSwnames});
end
[~,idx.swnameEQ1] = find(cell2mat(swvalues) == 1);
swnames{idx.swnameEQ1};
disp('Open switch: ');
for iSwnames1 = 1:1:length(idx.swnameEQ1)
    disp([swnames{idx.swnameEQ1(iSwnames1)}]);
end
%%
figure;
%累加所有选定波长
iFiles = 1;
% idxWavelength_graph_edge_low(iFiles) = 2* idx.Center_WavelengthGraphEdge- idxWavelength_graph_edge_high(iFiles);
chosenMapping = mapping{1,iFiles}(:,idxWavelength_graph_edge_low(iFiles):idxWavelength_graph_edge_high(iFiles));
add_wave = sum(chosenMapping,2);
plot(linspace(strip_start_angle,strip_end_angle,strip_end-strip_start+1),add_wave(strip_start:strip_end));