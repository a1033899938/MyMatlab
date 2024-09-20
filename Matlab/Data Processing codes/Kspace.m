clc;
clear;
clf;
filepath='D:\文件\matlab\hexcitons\2024-3-9 sample3\2024-3-15 cavity\4#';  %文件路径
Files=dir([filepath '\*.txt']);
L=length(Files);       %%文件个数
A={1,L};
B={1,L};
PL={1,L};
C={1,L};
strip=[];
lamda=[];
NA=0.75; %物镜数值孔径
for index=1:L
    cel{1,index}=readtable(Files(index).name);
        fname=Files(index).name;
A{1,index}=cel{1,index};
  M=size(A{1,index},1);  % 行数
N=size(A{1,index},2);  % 列数
C{1,index}=A{1,index}(1,:);    %取出每个文件的波长数据
for i=1:1:1024
    w(:,i)=C{1,index}(:,i+1);
end
B{1,index}=A{1,index}(2:M,:);  %取出每个文件的强度数据
for i=1:1:1024
    Int(:,i)=B{1,index}(:,i+1);
end
strip(:,1)=B{1,index}(:,1);%取出每个文件的strip数据         %图排列
E=1240./w;
    Int=Int./1000;
%         figure;
%     pcolor(E,strip,Int);
%     shading interp
    stripmax=248;
    stripmin=48;
%     E=E([stripmin:1:stripmax],:);
%     Int=Int';
    Int1=Int([stripmin:1:stripmax],:);
    theta=-53.13:(106.26./(stripmax-stripmin)):53.13;
nor{index}=Int1;
figure;
% E1=E(409:809,:);
% nor=nor';
% nor1=nor(409:809,:);
% nor=nor./max(nor);
pcolor(theta,E,Int1');
shading interp;
colorbar
colormap('gray')
    shading interp
title(fname,'Interpreter', 'none')
%     legend(Files(iFile).name(1:end-4),'Location','northoutside');
%     xlabel('\theta({\circ})')
     ylabel('E(eV)')
    xlabel('\theta(^o)')
%     set(gca,'YDir','Reverse')
    set(gca,'YDir','Normal')
    grid on
    box on
    colorbar
    caxis([0.6 1.0])
    colormap("hsv");
    set (gca,'FontSize',18)
    hold on
%     Contr{iFile}=Con{iFile}(:,[521:1:1070]);
%     Conex{iFile}=Con{iFile}(:,[1:1:568]);
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


