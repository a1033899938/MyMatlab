clc;
clear;
clf;
filepath='E:\ZnO\PL 320EX_ TE_gradual size_1#_3.1_1.txt';  %�ļ�·��
filelist=dir([filepath '\*.txt']);
L=length(filelist);       %%�ļ�����
A={1,L};
B={1,L};
PL={1,L};
C={1,L};
strip=[];
lamda=[];
figure(1);
NA=0.75; %�ﾵ��ֵ�׾�
for index=1:L;
cell(1,index)=importdata(filelist(index).name); 
A{1,index}=cell(1,index).data;
M=size(A{1,index},1);  % ����
N=size(A{1,index},2);  % ����
C{1,index}=A{1,index}(2,:);    %ȡ��ÿ���ļ���cell���Ĳ�������
B{1,index}=A{1,index}(4:M,:);  %ȡ��ÿ���ļ���cell����ǿ������
PL=B{1,index};
D{1,index}= PL(68,:);
PL=PL'; %��ǿ
strip=1:1:(M-3);    %�Ƕȷ�Χ
strip=linspace(-asind(NA), asind(NA),(M-3));
%lamda=1:1:size((C{1,index})');   %ȡstrip��Χ
lamda=C{1,index};
lamda=lamda';
subplot(1,L,index);               %ͼ����
pcolor(strip,lamda,PL);
set(gca,'linewidth',1,'fontsize',24,'fontname','Times'); %��������
daspect([1 1.5 1.5]);   % ����ͼ��ĸ߶Ⱥͳ��ȱ���
shading interp; %ƽ��
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
% set(h,'FontSize',14,'FontName','Time New Roman');%����X������������С������
end

% plot(lamda',D{1,1},lamda',D{1,2},lamda',D{1,3},lamda',D{1,4},lamda',D{1,5});
% set(gca,'linewidth',1,'fontsize',24,'fontname','Times');
% daspect([1 50 50]); 
% ylabel('Intensity (arb.units)','FontSize',28);
% xlabel('Wavelength (nm)','FontSize',28);
% %��һ����
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


