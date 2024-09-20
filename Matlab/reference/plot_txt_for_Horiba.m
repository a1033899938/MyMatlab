clc;
clear;
clf;
filepath='E:\0-------------------------Plot-------------------------';  %文件路径
if ~exist(filepath,'dir'); mkdir(filepath); end
filelist=dir([filepath '\*.txt']);
listFiles={};              %文件列表
L=length(filelist);       %%文件个数
A={1,L};B={1,L};Intensity={1,L};lamda={1,L};
fig = figure('Name','异质结'); %图窗命名
LW = 1.5; MS = 3; FS=12; % LW定义曲线的宽度 MS标记大小 FS字体大小
color_str =jet(L); %L条曲线颜色定义
le_str = cell(L,1); 
Position=1:L; %定义测量的不同位置
%%
for index=1:L
A{1,index}=importdata(filelist(index).name); 
lamda{1,index}=A{1,index}(1,:);    %取出每个文件（cell）的波长数据
Intensity{1,index}=A{1,index}((size(A{1,index},1)/2)-3:(size(A{1,index},1)/2)+3,:);  %取出每个文件（cell）的强度数据
Intensity{1,index}=sum(Intensity{1,index});
 plot(lamda{1,index},Intensity{1,index},'color',color_str(index,:),'LineWidth',LW,'MarkerSize',MS);
 %le_str{index} = ['P ',num2str(Position(index))]; %将位置信息转化成数字字符串
hold on
end
% set(hl,'box','off')
set(gca,'linewidth',1,'fontsize',20,'fontname','Times');
ylabel('Intensity (arb.units)','FontSize',20);
xlabel('Wavelength (nm)','FontSize',20);
%title('the reflection of lung cancer of mouse');
% set(gca,'tickdir','out');
% %set(gca,'xtick',[]) %去掉x轴的刻度 
% %set(gca,'ytick',[]) %去掉y轴的刻度  
% %set(gca,'xtick',[],'ytick',[]) %同时去掉x轴和y轴的刻度
%% 添加图例和设置
lgd = legend(le_str,'Location','northeast','box','off'); %添加图例
%lgd.Title.String = 'position'; % 给图例加标题
lgd.Title.FontSize = FS;     % 用数字指定标题的字体大小
lgd.FontSize = FS-2;         % 图例字体的大小
lgd.FontName = 'Times New Roman'; % 图例的字体
%% 保存数据
print(fig, ['hetero_',num2str(date),'.png' ], '-dpng', '-r2000');
%saveas(fig,['Song_',num2str(date),'.png' ],'png')
saveas(gcf,['hetero_',num2str(date),'.fig' ],'fig');
%close(fig)
%% 荧光

% plot(lamda{1,1},Intensity{1,1},'r-o');
% %legend('\sigma^+','\sigma^-');
% hl=legend('532 EX from hetero 3s');
% set(hl,'box','off')
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% ylabel('Intensity (arb.units)','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%反射谱
% Intensity1=(Intensity{1,2}-Intensity{1,1})./(Intensity{1,1});
% %Intensity2=(Intensity{1,4}-Intensity{1,2})./(Intensity{1,2});
% plot(lamda{1,1},Intensity1);
% %legend('\sigma^+','\sigma^-');
% hl=legend('supper-continuum white light reflectence');
% set(hl,'box','off')
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% ylabel('(R_{sample}-R_{Ag})/R_{Ag}','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28)

%% %%%%%%%%%%%%%%%%%%圆偏度2：
% figure(2)
% Y=(B{1,1}'-B{1,2}')./(B{1,1}'+B{1,2}');
% pcolor(strip,lamda,Y);
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% daspect([1 2 2]);   % 调整图像的高度和长度比例
% shading interp; %平滑
% axis([strip(1) strip(end) lamda(1) lamda(end)]);
% set(gca,'tickdir','out');
% axis ij;
% ylabel('Wavelength (nm)','FontSize',24);
% xlabel('\theta (degree)','FontSize',24);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3)
% plot(strip',D{1,1},'r-o',strip',D{1,2},'b-o');
% legend('\sigma^+','\sigma^-');
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% daspect([1 600 600]); 
% ylabel('Intensity (arb.units)','FontSize',28);
% xlabel('\theta (degree)','FontSize',28);

%%归一化：%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3)
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


