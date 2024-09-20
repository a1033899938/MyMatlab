clc;
clear;
clf;
filepath='E:\0-------------------------Plot-------------------------';  %�ļ�·��
if ~exist(filepath,'dir'); mkdir(filepath); end
filelist=dir([filepath '\*.txt']);
listFiles={};              %�ļ��б�
L=length(filelist);       %%�ļ�����
A={1,L};B={1,L};Intensity={1,L};lamda={1,L};
fig = figure('Name','���ʽ�'); %ͼ������
LW = 1.5; MS = 3; FS=12; % LW�������ߵĿ�� MS��Ǵ�С FS�����С
color_str =jet(L); %L��������ɫ����
le_str = cell(L,1); 
Position=1:L; %��������Ĳ�ͬλ��
%%
for index=1:L
A{1,index}=importdata(filelist(index).name); 
lamda{1,index}=A{1,index}(1,:);    %ȡ��ÿ���ļ���cell���Ĳ�������
Intensity{1,index}=A{1,index}((size(A{1,index},1)/2)-3:(size(A{1,index},1)/2)+3,:);  %ȡ��ÿ���ļ���cell����ǿ������
Intensity{1,index}=sum(Intensity{1,index});
 plot(lamda{1,index},Intensity{1,index},'color',color_str(index,:),'LineWidth',LW,'MarkerSize',MS);
 %le_str{index} = ['P ',num2str(Position(index))]; %��λ����Ϣת���������ַ���
hold on
end
% set(hl,'box','off')
set(gca,'linewidth',1,'fontsize',20,'fontname','Times');
ylabel('Intensity (arb.units)','FontSize',20);
xlabel('Wavelength (nm)','FontSize',20);
%title('the reflection of lung cancer of mouse');
% set(gca,'tickdir','out');
% %set(gca,'xtick',[]) %ȥ��x��Ŀ̶� 
% %set(gca,'ytick',[]) %ȥ��y��Ŀ̶�  
% %set(gca,'xtick',[],'ytick',[]) %ͬʱȥ��x���y��Ŀ̶�
%% ���ͼ��������
lgd = legend(le_str,'Location','northeast','box','off'); %���ͼ��
%lgd.Title.String = 'position'; % ��ͼ���ӱ���
lgd.Title.FontSize = FS;     % ������ָ������������С
lgd.FontSize = FS-2;         % ͼ������Ĵ�С
lgd.FontName = 'Times New Roman'; % ͼ��������
%% ��������
print(fig, ['hetero_',num2str(date),'.png' ], '-dpng', '-r2000');
%saveas(fig,['Song_',num2str(date),'.png' ],'png')
saveas(gcf,['hetero_',num2str(date),'.fig' ],'fig');
%close(fig)
%% ӫ��

% plot(lamda{1,1},Intensity{1,1},'r-o');
% %legend('\sigma^+','\sigma^-');
% hl=legend('532 EX from hetero 3s');
% set(hl,'box','off')
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% ylabel('Intensity (arb.units)','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������
% Intensity1=(Intensity{1,2}-Intensity{1,1})./(Intensity{1,1});
% %Intensity2=(Intensity{1,4}-Intensity{1,2})./(Intensity{1,2});
% plot(lamda{1,1},Intensity1);
% %legend('\sigma^+','\sigma^-');
% hl=legend('supper-continuum white light reflectence');
% set(hl,'box','off')
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% ylabel('(R_{sample}-R_{Ag})/R_{Ag}','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28)

%% %%%%%%%%%%%%%%%%%%Բƫ��2��
% figure(2)
% Y=(B{1,1}'-B{1,2}')./(B{1,1}'+B{1,2}');
% pcolor(strip,lamda,Y);
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% daspect([1 2 2]);   % ����ͼ��ĸ߶Ⱥͳ��ȱ���
% shading interp; %ƽ��
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

%%��һ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3)
% NOR=B{1}./B{2};
% NOR=NOR';
% pcolor(strip,lamda,NOR);
% set(gca,'YDir','reverse')
% set(gca,'linewidth',2,'fontsize',30,'fontname','Times'); %��������
% daspect([6 12 12]);   % ����ͼ��ĸ߶Ⱥͳ��ȱ���
% shading interp;
% % hold on;
% colormap jet;
% axis([strip(1) strip(end) lamda(1) lamda(end)]);
% axis ij;
%  %colormap gray;
%  ylabel('Wavelength (nm)','FontSize',32);
%  xlabel('\theta (degree)','FontSize',32);


