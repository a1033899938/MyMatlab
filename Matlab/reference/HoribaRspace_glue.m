%%%%%%%%%%%%%%%%%
%（0）使用前在左侧打开光谱文件文件夹%%%
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
%（1）获取文件路径
clc;
clear;
clf;
close all;
filepath='E:\Spectra\Horiba\XieJunjie\homo';     %文件路径
filelist=dir([filepath '\*.txt']);      %获取文件中所有文件信息
%listFiles={};
L=length(filelist);     %文件个数
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
%（2）顺序读取文件用，不修改%%%%
% train_num = length(train);
% data_all=[]
% 
% sort_nat_name=sort_nat({filelist.name});     %使用sort_nat进行排序
%  
% for i:train_num 
%   [data,text] = xlsread([trainPath sort_nat_name{i}]); 
%   %  取sort_nat_name元胞中第i个元素作为文件名，构成文件的真实地址
%   data_all=[data_all;data];         %   纵向拼接
% end
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
%（3）创建存放强度、波长等数据的cell
A={1,L};B={1,L};Intensity={1,L};C={1,L};    %创建空cell数组，A放每个文件的数据，
fname = {1,L};      %创建空cell数组，存放每个文件的文件名（带后缀）
fName= {1,L};       %创建空cell数组，存放每个文件的文件名（不带后缀）
%strip = [];
%wavelen = [];
NA=0.75; %物镜数值孔径
K=[];
color=[1 0 0;0 1 0;0 0 1;0.5 1 1;1 1 0.5;1 0.5 1; 0 0 0.5; 0.5 0 0;0 0.5 0;1 0.5 0.5; 0.5 1 0.5;0.5 0.5 1;1 1 0;0 1 1;1 0 1];       %定义作图颜色矩阵
Position_Title = 21;
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
%（4）穷举每个文件，依次画图
for i=1:1:L         %穷举每个文件
    fname{1,i}=(filelist(i).name);       %当前文件的文件名
    fName{1,i}=fname{1,i}(Position_Title+2:end-4);      %当前文件的文件名(去除后缀)
    A{1,i}=importdata(fname{1,i});       %导入当前文件数据
    M=size(A{1,i},1);       %当前数据行数
    N=size(A{1,i},2);       %当前数据列数
    B{1,i}= A{1,i}(1:M,1);      %提取当前数据的第一列（波长）
    C{1,i}= A{1,i}(1:M,2);      %提取当前数据的第二列（PL强度）

    Intensity=C{1,i};       %在本次循环阶段中把PL强度赋给“Intensity”
    Wavelenth=B{1,i};      %在本次循环阶段中把波长赋给“Wavelenth”
    E=1240/Wavelenth;       %将波长（nm）换算成能量（eV）
    %figure;       %注释则只打印一张图，不注释则打印多张图
    %plot(Wavelenth,Intensity,'LineWidth',2,'color',color(i,:));        %以"Wavelenth”为横，“Intensity”为纵坐标，曲线磅数为2画图
    plot(Wavelenth,Intensity,'LineWidth',2);        %以“Wavelenth”为横，“Intensity”为纵坐标，曲线磅数为2画图
    title('WS_2 homobilayer',[fname{1,i}(1:Position_Title),]);     %图命名格式：fname的前几位字符+引号内字符
    %以下内容一般不改动%
    shading interp; %平滑
    ylabel('Intensity','Fontname','Times New Roman','FontSize',15);
    xlabel('Wavelength (nm)','Fontname','Times New Roman','FontSize',15);
    set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    grid on;
    box on;
    %以上内容一般不改动%
hold on;        %画图保持
end
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
%（5）注记
legend(char(fname{:}));    %把cell数组转为char数组，一并作为legend的多个参数输入：多条曲线的图例。以文件名为注记
    %legend(char(fName{:}));
    %%把cell数组转为char数组，一并作为legend的多个参数输入：多条曲线的图例。以fName定义的文件名部分为注记
    %legend('WS_2-hole','Si','SiO2','WS_2');
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% 
%接谱
%1、先run一遍“HoribaRspace”，看看哪些数据要一起接谱，记住他们的序号（有顺序），记住他们分为了几组。  
%%%%%%%%%%%%%%%%%
