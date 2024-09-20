clf
clc
clear all
close all
%% 导入数据
filepath = 'C:\Users\a1033\Desktop\mmy';
da = importdata('工作簿3.xlsx');

%% 提取data中的四列数据
coordinate_x = da.data(:,1);
coordinate_y = da.data(:,2);
origin_z1 = da.data(:,3);
origin_z2 = da.data(:,4);
accumulate_z = origin_z1.*origin_z2;

%% 预处理
%提取mesh中的X向量和Y向量
x = unique(coordinate_x);
y = unique(coordinate_y);
%获取X向量和Y向量的长度，构建空二维矩阵，准备按位置存放z1，z2
len_X = length(x);
len_Y = length(y);
len_z1 = length(origin_z1);
z1 = zeros(len_X,len_Y);
z2 = zeros(len_X,len_Y);
z = zeros(len_X,len_Y);

%% 提取某,构建矩阵。例如在[0.1 0.2 0.3]中0.2的index是2
for i = 1:len_z1
    z1(y == coordinate_x(i),x == coordinate_y(i)) = origin_z1(i);
    z2(y == coordinate_x(i),x == coordinate_y(i)) = origin_z2(i);
    z(y == coordinate_x(i),x == coordinate_y(i)) = accumulate_z(i);
end

%% 建立网格，建立函数
[X,Y]=ndgrid(x,y);
fun=@(x,y)interp2(Y,X,z,x,y);
%% 积分
int_z = integral2(fun,min(x),max(x),min(y),max(y));

%% 作图
%图z1
figure;
mesh(Y,X,z1);
title('z1');
xlabel('x');
ylabel('y');

%图z2
figure;
mesh(Y,X,z2);
title('z2');
xlabel('x');
ylabel('y');

%图z1*z2
figure;
f = mesh(Y,X,z);
title('z1*z2');
xlabel('x');
ylabel('y');

%% 画圆柱标记
hold on
[cylinderX,cylinderY,cylinderZ] = cylinder(3);
cylinderX = cylinderX + 7.5;
cylinderY = cylinderY + 7.5;
h = max(max(z));
cylinderZ = cylinderZ*h;
mesh(cylinderX,cylinderY,cylinderZ,'FaceColor','yellow','EdgeColor', 'none','FaceAlpha',0.5);
shading interp;
% light('Position', [0 0 1], 'Style', 'infinite');%无限远的光源
% light('Position', [0 0 -1], 'Style', 'infinite');
%% 打印结果
fprintf("积分结果为int_z = %d",int_z);