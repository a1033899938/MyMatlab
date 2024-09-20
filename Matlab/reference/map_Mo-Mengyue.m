%data="源文件名";
%文件路径
clc;
clear;
clf;
close all;
%载入数据

filepath = 'C:\Users\a1033\Desktop\mmy\20230908';
filelist=dir([filepath '\*.asc']);
filecell=struct2cell(filelist);
filename = filecell(1,:);
L = length(filename);

for i = 1:1:L
    data = filename{1,i};
    mapping=importdata(data);    
    %基本绘图部件，无扩展功能可把后续全删掉
    %设置图窗
    [~, dataname, ~] = fileparts(data);
    f=figure('numbertitle','off','name', dataname);
    fpos = get(f, 'Position');
    fpos(3) = fpos(4) * 1.153;
    set(f, 'Position', fpos,'Color',[1.0, 1.0, 1.0]);
    subplot('Position', [0.01, 0.01, 0.85, 0.98]);
    %画图
    [nrows,ncols]=size(mapping);
    [X,Y]=meshgrid(1:ncols,1:nrows);
    surf(X,Y,mapping);
    shading interp;
    view(2);
    colormap("jet");
    axis tight;axis equal;axis off;
    %设置colorbar并固定大小
    h = colorbar;
    set(h, 'Position', [0.87,0.05,0.04,0.85]);
    



    %自动识别图尾号部件
    split_name = split(dataname, '-');
    tail = str2double(split_name{end});


    %根据尾号设置caxis，尾号不在1-7的时候把这部分注释
    %cnumber_list = [27000, 29000, 30000, 31000, 35000, 37000, 37000];%MESA
    cnumber_list = [33000, 34000, 35000, 36000, 37000, 38000, 39000];%SiO2-MESA
    cnumber = cnumber_list(tail);
    clim([0,cnumber]);
    
    %根据尾号图像居中部件
    %根据尾号设置取点数量和画图范围
    topnumber_list = [1945, 5088, 7989, 17855, 31959, 72253, 128666];
    topnumber = topnumber_list(tail);
    axis_list = [46, 72, 80, 126, 150, 222, 295];
    half_size = axis_list(tail);
    %计算数据矩阵中所有位于指定范围内的元素的位置
    x_range = 500:1548;
    y_range = 500:1548;
    centermask = ismember(X, x_range) & ismember(Y, y_range);
    % 根据这些元素的数值大小进行排序，并取出前 5000 个元素
    centertopdata = sort(mapping(centermask), 'descend');
    top_number_data = centertopdata(1:topnumber);
    topmask = centermask & ismember(mapping, top_number_data);
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
    disp(['Mean of top ', num2str(topnumber), ' data: ', num2str(mean_of_center)])
    disp(['Max of center_data: ', num2str(max_of_center)])
    
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

    

    frame = getframe(f); % 获取frame
    img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
    imwrite(img,sprintf("%s.png", dataname)); % 保存到工作目录下，名字为"dataname.png"
    close;
end