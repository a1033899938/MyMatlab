% function []=plotSPE(filepath)
clc;
clear;
clf;
close all;
filepath='E:\Spectra\-------------------------Plot-------------------------';     %文件路径
filelist=dir([filepath '\*.spe']);      %获取文件中所有文件信息
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
Position_Title_Start = width('White-100Slit-kspace-5s-5times');
L=length(filename);     %文件个数


A={1,L};B={1,L};Intensity={1,L};C={1,L};    %创建空cell数组，A放每个文件的数据，
file = {1,L};
fName = {1,L};

Intensity = {1,L};
Wavelength = {1,L};


for i=1:1:L         %穷举每个文件
    spnow = loadSPE(filename{1,i});
    Intensity{1,i} = sum(spnow.int,1);
    Wavelength{1,i} = spnow.wavelength;
%     if i<=8
%         Position_Title_End = width('(300-800)-Minusbackground 2023 七月 15 19_43_25 1.spe');
%     else
%         Position_Title_End = width('(300-800)-100umPinhole-Minusbackground 2023 七月 15 19_43_25 1.spe');
%     end
%     fName{1,i}=filename{1,i}(Position_Title_Start+2:end-Position_Title_End);      %当前文件的文件名(去除后缀)
%     fName{1,i}=num2str(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---minus background
% sw_minus_background = 1;        %sw_minus_background = 1：打开减背景
% Background_members_index = [1];        %输入背景们的序号，组成矩阵
% Background_members = [];
% signal_members = [];
% size_backgrounds = size(Background_members_index);
% signal_names = [];
% 
% for i=1:1:L
%     if ismember(i,Background_members_index)
%         Background_members = cat(1,Background_members,Intensity{1,i});
%     elseif ~ismember(i,Background_members_index)
%         signal_members = cat(1,signal_members,Intensity{1,i});
%         signal_names = cat(1,signal_names,filename{1,i});
%     else
%         print('error:minus background!!!');
%     end
% end
% 
% 
% Background = sum(Background_members,1)/size(Background_members,1);
% 
% size_signals = size(signal_members,1);
% Intensity_minus_background = [];
% 
% 
% qq = 0;                             %qq=0：纵坐标为反射率
%                                     %qq=1：纵坐标反射率上下翻转
% if sw_minus_background ~=0
%     L = size_signals;
%     for i=1:1:size_signals
%         if qq==0
%             Intensity_minus_background(i,:) = (signal_members(i,:))./Background; 
%         elseif qq==1
%             Intensity_minus_background(i,:) = -(signal_members(i,:))./Background; 
%         else
%             print('error:qq!!!');
%         end
%     end
% end
% 
% 
% 
% if size(Background_members,1)~=size_backgrounds
%     print('error:minus background!!!');
% end
% 
% 

%signal_names = {'SiO_2/Si','WS_2(air)','WS_2(SiO_2/Si)'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---plot
j = 1;      %j=1：打印未处理graph    %k=0：横坐标为波长
k = 0;      %j=2：打印减背景graph    %k=1：横坐标为能量
q = 0;      %j=3：打印未处理image    %q=0：纵坐标为强度
            %j=4：打印减背景image    %q=1：纵坐标为归一化强度
                                    %q=2：纵坐标为差分反射率


switch j
    case 1
        for i=1:1:L
            if k==0
                plot(Wavelength{1,i},Intensity{1,i},'LineWidth',2);
                xlabel('Wavelength(nm)','Fontname','Times New Roman','FontSize',15);
            elseif k==1
                Wavelength{1,i}=1240./Wavelength{1,i};
                plot(Wavelength{1,i},Intensity{1,i},'LineWidth',2);
                xlabel('Energy(eV)','Fontname','Times New Roman','FontSize',15);
            else
                print('error:xlable!!!');
            end
            if q==0
                ylabel('Intensity(counts)','Fontname','Times New Roman','FontSize',15);
            elseif q==1
                ylabel('Nomalized Intensity','Fontname','Times New Roman','FontSize',15);
            elseif q==2
                ylabel('\DeltaR/R','Fontname','Times New Roman','FontSize',15);
            else
                print('error:ylable!!!');
            end
            shading interp;
%             set(gca,'xlim',[454 800]);
            grid on;
            box off;
            hold on;
        end
        legend(char(signal_names(:)));
    case 2
        for i=1:1:L
            if k==0
                plot(Wavelength{1,i},Intensity_minus_background(i,:),'LineWidth',2);
                xlabel('Wavelength(nm)','Fontname','Times New Roman','FontSize',15);
            elseif k==1
                Wavelength{1,i}=1240./Wavelength{1,i};                
                plot(Wavelength{1,i},Intensity_minus_background(i,:),'LineWidth',2);
                xlabel('Energy(eV)','Fontname','Times New Roman','FontSize',15);
            else
                print('error:xlable!!!');
            end
            if q==0
                ylabel('Intensity(counts)','Fontname','Times New Roman','FontSize',15);
            elseif q==1
                ylabel('Nomalized Intensity','Fontname','Times New Roman','FontSize',15);
            elseif q==2
                ylabel('\DeltaR/R','Fontname','Times New Roman','FontSize',15);
            else
                print('error:ylable!!!');
            end
            shading interp;
%             set(gca,'xlim',[454 800]);
            grid on;
            box off;
            hold on;
        end
        legend(char(signal_names(:)));
    case 3
        for i=1:1:L         %穷举每个文件
            f = figure;
            spnow = loadSPE(filename{1,i});
%             strip=linspace(1,256,length(spnow.wavelength)-1);
%             strip=strip';
            Y = 1:spnow.ydim;
            X = spnow.wavelength; 
            pcolor(X,Y,spnow.int);
            ylabel('strip');
            xlabel('Wavelength(nm)');
            view(2);
            shading interp;
            colorbar;
            cb = colorbar;
            cb.Title.String='Intensity';
            titles={'BL WS_2(hole)','hole','SiO_2/Si','BL WS_2(SiO_2/Si)'};
            title(titles{1,i});
            %saveas(100, [Files(iFile).name(1:end-4) '.fig']);
            % saveas(f, [titles{1,i} '.png']);
        end
    case 4
    otherwise
        print('error!!!!!!!!!')
end


% return

%fileparts
%title(sprintf("%d次多项式最小二乘拟合", i
    % % 计算显示区域的范围
    % x_range = round(xaxis_mean) - half_size : round(xaxis_mean) + half_size;
    % y_range = round(yaxis_mean) - half_size : round(yaxis_mean) + half_size;