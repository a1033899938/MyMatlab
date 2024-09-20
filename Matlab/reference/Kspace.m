clc;
clear;
clf;
filepath='E:\ZnO\PL 320EX_ TE_gradual size_1#_3.1_1.txt';  %文件路径
filelist=dir([filepath '\*.txt']);
L=length(filelist);       %%文件个数
A={1,L};
B={1,L};
PL={1,L};
C={1,L};
strip=[];
lamda=[];
figure(1);
NA=0.75; %物镜数值孔径
for index=1:L;
cell(1,index)=importdata(filelist(index).name); 
A{1,index}=cell(1,index).data;
M=size(A{1,index},1);  % 行数
N=size(A{1,index},2);  % 列数
C{1,index}=A{1,index}(2,:);    %取出每个文件（cell）的波长数据
B{1,index}=A{1,index}(4:M,:);  %取出每个文件（cell）的强度数据
PL=B{1,index};
D{1,index}= PL(68,:);
PL=PL'; %光强
strip=1:1:(M-3);    %角度范围
strip=linspace(-asind(NA), asind(NA),(M-3));
%lamda=1:1:size((C{1,index})');   %取strip范围
lamda=C{1,index};
lamda=lamda';
subplot(1,L,index);               %图排列
pcolor(strip,lamda,PL);
set(gca,'linewidth',1,'fontsize',24,'fontname','Times'); %调整字体
daspect([1 1.5 1.5]);   % 调整图像的高度和长度比例
shading interp; %平滑
%hold on;
%colormap jet;
 %colormap gray;
axis([strip(1) strip(end) 430 720]);
set(gca,'tickdir','out') 
%set(gca,'xtick',[-60,-30,0,30,60],'tickdir','out')   
%set(gca,'ytick',[],'yticklabel',[])
axis ij;
 ylabel('Wavelength (nm)','FontSize',28);
 xlabel('\theta (degree)','FontSize',28);
% h=subplot(3,5,index);
% set(h,'FontSize',14,'FontName','Time New Roman');%设置X坐标标题字体大小，字型
end

% plot(lamda',D{1,1},lamda',D{1,2},lamda',D{1,3},lamda',D{1,4},lamda',D{1,5});
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% daspect([1 50 50]); 
% ylabel('Intensity (arb.units)','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28);
% %归一化：
% NOR=B{1}./B{2};
% NOR=NOR';
% pcolor(strip,lamda,NOR);
% set(gca,'YDir','reverse')
% set(gca,'linewidth',2,'fontsize',30,'fontname','Times'); %调整字体
% daspect([6 12 12]);   % 调整图像的高度和长度比例
% shading interp;
% % hold on;
% colormap jet;
% axis([strip(1) strip(end) lamda(1) lamda(end)]);
% axis ij;
%  %colormap gray;
%  ylabel('Wavelength (nm)','FontSize',32);
%  xlabel('\theta (degree)','FontSize',32);


