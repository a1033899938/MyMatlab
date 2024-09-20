% 在命令行中输入 data = "xxx"
%data = "xxx";

%要修改的信息我放在这里，只改这里就好
Targetwavelength = 469.8;%目标波长，用于画特征波长强度占比
Filteringstandards=400;%峰值强度低于这个值的点的信号将被忽略，滤掉噪音
Minstrength=440; Maxstrength=500;%光谱强度积分的左右范围，积分强度映射为由Minstrength到Maxstrength


% 构造数据文件和头文件的文件名
data_file = data + "_envi.img";
header_file = data + "_envi.hdr";
% 读取高光谱数据
hcube = hypercube(data_file, header_file);
[m,n,b] = size(hcube.DataCube);
% 构建峰值波长矩阵
peak_wavelengths = zeros(m,n);
% 构建光谱强度积分矩阵
integrated_intensity = zeros(m,n);
% 构建峰值强度矩阵
peak_intensity = zeros(m,n);
% 构建半峰全宽矩阵
fwhm = zeros(m,n);
% 创建一个Targetwavelength比例矩阵，只包含峰值强度大于某的点的比值
intensity_ratio_gt = zeros(m, n);

% 找到最接近Targetwavelength的两个波长索引并获取相应波长的强度
[~, idx] = sort(abs(hcube.Wavelength - Targetwavelength));
idx1 = idx(1);idx2 = idx(2);
intensity1 = squeeze(hcube.DataCube(:,:,idx1));
intensity2 = squeeze(hcube.DataCube(:,:,idx2));


%计算开始
for i = 1:m
    for j = 1:n
        % 获取该像素点的光谱数据
        spectrum = double(squeeze(hcube.DataCube(i,j,:)));
        
        % 计算某范围内光谱强度积分
          wavelength_range = (hcube.Wavelength >= Minstrength) & (hcube.Wavelength <= Maxstrength);
          integrated_intensity(i,j) = sum(spectrum(wavelength_range));
        
        % 计算全波段强度积分
        %integrated_intensity(i,j) = sum(spectrum);
        
        % 找到峰值波长
        [peak_value, peak_index] = max(spectrum);
        peak_wavelength = hcube.Wavelength(peak_index);
        
        % 只考虑峰值强度大于Filteringstandards的像素点
        if peak_value > Filteringstandards
           peak_wavelengths(i,j) = peak_wavelength;
           peak_intensity(i,j) = peak_value;
           
           % 计算半峰全宽（使用半高作为寻峰标准）
           [pks, locs, w, p] = findpeaks(spectrum, hcube.Wavelength, 'NPeaks', 1, ...
               'SortStr', 'descend', 'MinPeakHeight', Filteringstandards, 'WidthReference', 'halfheight');
           fwhm(i,j) = w;

           % 计算Targetwavelength波长的强度
           intensity_Targetwavelength_ij = interp1([hcube.Wavelength(idx1), hcube.Wavelength(idx2)], ...
               [double(intensity1(i,j)), double(intensity2(i,j))], Targetwavelength);
           % 计算每个像素点上，469nm 波长的强度除以 440-520nm 范围内的积分的比值
           intensity_ratio_gt(i,j) = intensity_Targetwavelength_ij / integrated_intensity(i,j);
        end
    end
end

%设置图窗
f=figure('numbertitle','off','name', data, 'Color',[1.0, 1.0, 1.0]);

% 绘制峰值波长映射图
subplot('Position', [0.01 0.51 0.4 0.45]);
surf(peak_wavelengths);
shading interp;
view(2);colorbar;axis tight;axis off;colormap("jet");
title('Peak Wavelengths');
pbaspect([n m 1]);
peak_wavelengths_gt_Filteringstandards = peak_wavelengths(peak_intensity > Filteringstandards);
avg_peak_wavelength = mean(peak_wavelengths_gt_Filteringstandards(:));
clim([avg_peak_wavelength-2, avg_peak_wavelength+2]); % 设置 clim 范围

% 绘制峰值强度映射图
subplot('Position', [0.51 0.51 0.4 0.45]);
surf(peak_intensity);
shading interp;
view(2);colorbar;axis tight;axis off;colormap("jet");
title('Peak Intensity');
pbaspect([n m 1]);

% 绘制半峰全宽映射图
subplot('Position', [0.01 0.01 0.4 0.45]);
surf(fwhm);
shading interp;
view(2);colorbar;axis tight;axis off;colormap("jet");
title('FWHM');
pbaspect([n m 1]);
clim([13, 18]);

% 绘制Targetwavelength比值图
subplot('Position', [0.51 0.01 0.4 0.45]);
surf(intensity_ratio_gt);
shading interp;
view(2);colorbar;axis tight;axis off;colormap("jet");
title(['Intensity Ratio (' num2str(Targetwavelength) 'nm / Integrated)']);%标题在这里改
pbaspect([n m 1]);
clim([0.06,0.066]);