clc;
clear;
clf;
close all;
% 获取文件夹中所有 .asc 格式的文件
filepath = 'C:\Users\a1033\Desktop\mmy\20230908';  %文件路径
files = dir([filepath '\*.asc']);

% 初始化结果矩阵
output = cell(length(files)+1, 3);
% 添加表头
output(1,:) = {'file', 'average', 'max'};

% 遍历每个文件
for i = 1:length(files)
    % 获取文件名
    filename = files(i).name;

    % 读取数据
    mapping = importdata(filename);
    [~, dataname, ~] = fileparts(filename);
    % 设置图窗
    f = figure('numbertitle', 'off', 'name', dataname);     %%调整figure参数
    fpos = get(f, 'Position');      %%获取figure四角位置向量
    fpos(3) = fpos(4) * 1.153;          %%调整figure窗格尺寸
    set(f, 'Position', fpos, 'Color', [1.0, 1.0, 1.0]);     %%调整figure位置、背景色
    subplot('Position', [0.01, 0.01, 0.85, 0.98]);      %%指定子图位置
    % 绘制颜色映射图
    [nrows, ncols] = size(mapping);
    [X, Y] = meshgrid(1:ncols, 1:nrows);        %%建立作图网格
    surf(X, Y, mapping);
    shading interp;
    view(2);        %%用二维形式显示mapping(默认三维)
    colormap('jet');
    axis tight;axis equal;axis off;     %%使图框靠近数据
    % 设置 colorbar 并固定大小
    h = colorbar;
    set(h, 'Position', [0.87, 0.05, 0.04, 0.85]);

    %自动识别图尾号部件
    split_name = split(dataname, '-');      %%把dataname从短横杠处切开
    tail = str2double(split_name{end});     %%取出dataname的短横杠后半部分，并转化为数值类型
    % 自动识别图尾号，根据尾号设置 caxis
    %cnumber_list = [27000, 29000, 30000, 31000, 35000, 37000, 37000];%MESA
    cnumber_list = [33000, 34000, 35000, 36000, 37000, 38000, 39000];%SiO2-MESA
    cnumber = cnumber_list(tail);
    clim([0,cnumber]);      %%设置颜色范围

    %根据尾号图像居中部件
    %根据尾号设置取点数量和画图范围
    topnumber_list = [1945, 5088, 7989, 17855, 31959, 72253, 128666];
    topnumber = topnumber_list(tail);
    axis_list = [46, 72, 80, 126, 150, 222, 295];
    half_size = axis_list(tail);
    %计算数据矩阵中所有位于指定范围内的元素的位置
    x_range = 500:1548;
    y_range = 500:1548;
    centermask = ismember(X, x_range) & ismember(Y, y_range);       %%图像中心区域掩膜
    % 根据这些元素的数值大小进行排序，并取出前topnumber 个元素
    centertopdata = sort(mapping(centermask), 'descend');        %%取出图像中心区域数据
    top_number_data = centertopdata(1:topnumber);       %%取出前topnumber个元素
    topmask = centermask & ismember(mapping, top_number_data);      %%记录所有图像中心区域的数据的位置    
    [idx_y, idx_x] = find(topmask);
    % 计算这些元素的质心
    xaxis_mean = mean(idx_x);
    yaxis_mean = mean(idx_y);
    % 计算显示区域的范围
    x_range = round(xaxis_mean) - half_size : round(xaxis_mean) + half_size;
    y_range = round(yaxis_mean) - half_size : round(yaxis_mean) + half_size;
    % 设置坐标轴的范围，以便只显示指定的区域
    axis([min(x_range), max(x_range), min(y_range), max(y_range)]);
    %输出中心范围内前topnumber个数据的最大值和均值
    mean_of_center = mean(top_number_data);
    max_of_center = max(top_number_data);
   
    % 将结果存储到结果矩阵中
    output{i+1, 1} = filename;
    output{i+1, 2} = round(mean_of_center);
    output{i+1, 3} = max_of_center;

    %比例尺设置
    hold on;
    scaleposition_list = [5, 7.83, 8.70, 13.70, 16.30, 24.13, 32.07];%位置
    scaleposition = scaleposition_list(tail);
    scale_length_list = [18.0448, 27.0672, 27.0672, 45.112, 45.112, 90.224, 90.224];%长度
    scale_length = scale_length_list(tail); 
    scale_name_list = {'2\mum', '3\mum', '3\mum', '5\mum', '5\mum', '10\mum', '10\mum'};
    scale_name = scale_name_list(tail); 
    scaleyax = [min(x_range) + scaleposition, min(x_range) + scaleposition + scale_length];
    scaleyay = [min(y_range) + scaleposition, min(y_range) + scaleposition];
    scaleyaz=[max_of_center,max_of_center]*1.01;
    h_scale=plot3(scaleyax, scaleyay,scaleyaz,'w','LineWidth',3); % 指定颜色为白色
    text(mean(scaleyax), scaleyay(1)+scaleposition,scaleyaz(1), scale_name, ...
        'HorizontalAlignment','center','fontname','Times New Roman','Color','w', ...
        'FontSize', 20, 'FontWeight', 'bold');

    % 保存图像为 xxx 格式，并指定分辨率为每英寸 600 像素
    %print(gcf, sprintf('%s.tif', dataname), '-dtiff', '-r600');
    %print(gcf, sprintf('%s.png', dataname), '-dpng', '-r600');
    print(gcf, sprintf('%s.jpeg', dataname), '-djpeg', '-r1200');

    % 关闭当前图窗
    close(gcf);
end

% 输出结果矩阵
disp(output);
xlswrite('output.xlsx', output);