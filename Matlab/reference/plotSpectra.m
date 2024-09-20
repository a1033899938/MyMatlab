clc;
clear;
clf;
close all;
%% 控制区域
sw.spectra = 1;%处理SPE文件/txt文件
%数据处理
sw.normalize = 1;%强度归一化
%作图
sw.figure = 0;%显示figure
sw.xlabel = 1;%横坐标转换为能量  
    nameidx = 4;%文件名关键字位置
sw.background = 0;%减背景
    keytag.background = 'WS2ML(PDMS)';
sw.contrast = 1;%差分反射
    keytag.substrate  ='substrate(PDMS)';%衬底关键字
sw.fit = 0;%拟合
    num_peak = 3;%拟合峰数
sw.interp = 1;%数据平滑
    interp_width = 200;%平滑窗口
sw.mapping_dir = 0;%mapping方向变竖直
sw.dif1 = 1;%一阶微分
sw.dif2 = 1;%二阶微分
sw.save =0;%保存图片

%% 文件路径
filepath='E:\0-------------------------Plot-------------------------';     
if sw.spectra
    filelist=dir([filepath '\*.spe']);
else
    filelist=dir([filepath '\*.txt']);
end
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
%% 预设
%预设文件名、光谱文件、强度、波长、能量、k空间角度的元胞数组
L=length(filename);
filename = {1,L};
spectra = {1,L};
mapping = {1,L};
intensity = {1,L};
wavelength = {1,L};
energy = {1,L};

NA = 0.75;
Xlabel = 'Wavelength(nm)';
Ylabel = 'Intensity(counts)';


filename_split1 = {1,L};
filename_split2 = {1,L};

%% 穷举文件
if sw.spectra
    for iFile = 1:1:L
        filename{iFile}=(filelist(iFile).name);
        spectra{iFile} = loadSPE(filename{iFile});
        mapping{iFile} = spectra{iFile}.int;
        intensity{iFile} = sum(spectra{iFile}.int(1:end,:),1)';
        wavelength{iFile} = spectra{iFile}.wavelength;
        energy{iFile} = 1240./wavelength{iFile};
    end
else
    for iFile = 1:1:L        
        filename{iFile}=(filelist(iFile).name);
        spectra{iFile} = importdata(filename{iFile});     
        intensity{iFile} = spectra{iFile}(1:end,2);
        wavelength{iFile} = spectra{iFile}(1:end,1);
        energy{iFile} = 1240./wavelength{iFile};
    end
end

%% 数据处理
%% 强度归一化
if sw.normalize
    max_intensity = max(cell2mat(intensity),[],1);
    intensity = mat2cell(cell2mat(intensity)./max_intensity,[size(intensity{1,1},1)],ones(1,size(intensity,2)));
end

%% 分隔文件名(减背景、差分反射)
for iFile = 1:1:L
    filename_split1{iFile} = split(filename{iFile},'#');%以#分开文件名头与尾
    filename_split2{iFile} = split(filename_split1{iFile}{2,1},'-');%以-分开文件名尾
    filename_split2{iFile}{1,1} = strcat(filename_split1{iFile}{1,1},'#');%将文件名头与尾的各部分组合
    if iFile == 1%组合各个文件的文件名分裂
        filename_split = filename_split2{1,1};
    else
        filename_split = [filename_split filename_split2{iFile}];
    end
end

%% 减背景
if sw.background
    [row1,idx_background] = find(strcmp(filename_split,sprintf(keytag.background)));%查找背景列数
    background = intensity(idx_background);
    intensity(idx_background) = [];%将intensity、wavelength、filename_split中的背景项删除
    wavelength(idx_background) = [];
    filename_split(:,idx_background) = [];
    intensity = mat2cell(cell2mat(intensity) - cell2mat(background),[size(intensity{1,1},1)],ones(1,size(intensity,2)));%减背景
end

%% 差分反射
%重组文件
if sw.contrast
    Ylabel = 'Contrast reflectance';
    [row2,idx_substrate] = find(strcmp(filename_split,sprintf(keytag.substrate)));%查找衬底列数
    substrate = intensity(idx_substrate);
    intensity(idx_substrate) = [];
    wavelength(idx_substrate) = [];
    filename_split(:,idx_substrate) = [];
    intensity = mat2cell((cell2mat(intensity) - cell2mat(substrate))./cell2mat(substrate),[size(intensity{1,1},1)],ones(1,size(intensity,2)));%减背景
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
%% 作图
% if sw.xlabel
%     wavelength = E;
%     Xlabel = 'Energy(eV)';
% end




