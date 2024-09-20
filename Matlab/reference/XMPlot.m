clf
clc
clear all
close all

%%
filepath='C:\Users\a1033\Desktop\TEST-80';
filelist=dir([filepath '\*.dat']);
L = length(filelist);
filename = {1,L};
file = {1,L};
f = {1,L};
integrate_width = 60;
peak_position = [311.535800000000 324.735800000000 337.935800000000 351.135800000000  364.335800000000];

for i = 1:1:L
    filename{1,i} = filelist(i).name;
    file{1,i} = importdata(filename{1,i});
end

%% 查找参数列位置
% c e w x
idx.Ecmin = find(ismember(file{1,1}.textdata,'Ec_min,[eV]'));
idx.Evmax = find(ismember(file{1,1}.textdata,'Ev_max,[eV]'));
idx.ElectronFermiLevel = find(ismember(file{1,1}.textdata,'ElectronFermiLevel'));
idx.HoleFermiLevel = find(ismember(file{1,1}.textdata,'HoleFermiLevel'));
% ai
idx.pTot = find(ismember(file{1,1}.textdata,'pTot'));

% ae
idx.nTot = find(ismember(file{1,1}.textdata,'nTot'));

% aa ab log10
idx.ElectronCurrent = find(ismember(file{1,1}.textdata,'ElectronCurrent'));
idx.HoleCurrent = find(ismember(file{1,1}.textdata,'HoleCurrent'));

% au 模型不同，量子阱位置不同
idx.RadiativeRecombinationRate = find(ismember(file{1,1}.textdata,'RadiativeRecombinationRate'));

% aw
idx.NonRadiativeRecombinationRate = find(ismember(file{1,1}.textdata,'NonRadiativeRecombinationRate'));

% ax
idx.SRRecombinationRate = find(ismember(file{1,1}.textdata,'SRRecombinationRate'));

% ay
idx.AugerRecombinationRate = find(ismember(file{1,1}.textdata,'AugerRecombinationRate'));

%% 创建文件夹保存图片
for i = 1:1:L
    mkdir(sprintf(filename{1,i}(1:end-4)));
end

%% 作图
for i = 1:1:L
    j = 1;
    f{1,j} = figure(j);
    %Ecmin Evmax ElectronFermiLevel HoleFermiLevel
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.Ecmin));
    hold on;
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.Evmax));
    hold on;
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.ElectronFermiLevel));
    hold on;
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.HoleFermiLevel));
    hold off;
    saveas(f{1,j},[filepath '\' filename{1,i}(1:end-4) '\' 'band.png']);
    j = j+1;
    
    %pTot
    f{1,j} = figure(j);
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.pTot));
    saveas(f{1,j},[filepath '\' filename{1,i}(1:end-4) '\' 'pTot.png']);
    j = j+1;
    
    %nTot
    f{1,j} = figure(j);
    plot(file{1,i}.data(:,1),file{1,i}.data(:,idx.nTot));
    saveas(f{1,j},[filepath '\' filename{1,i}(1:end-4) '\' 'nTot.png']);
    j = j+1;
    
    %ElectronCurrent HoleCurrent
    f{1,j} = figure(j);
    plot(file{1,i}.data(:,1),log10(file{1,i}.data(:,idx.ElectronCurrent)));
    hold on;
    plot(file{1,i}.data(:,1),log10(file{1,i}.data(:,idx.HoleCurrent)));
    hold off;
    saveas(f{1,j},[filepath '\' filename{1,i}(1:end-4) '\' 'ElectronHoleCurrent.png']);
    j = j+1;
    
    % %RadiativeRecombinationRate
    % f{1,j} = figure(j);
    % plot(file{1,1}.data(:,1),file{1,1}.data(:,idx.RadiativeRecombinationRate));
    % y = zeros(size(file{1,1}.data(:,1)));
    % y(ismember(file{1,1}.data(:,1),peak_position)) = max(file{1,1}.data(:,idx.RadiativeRecombinationRate));
    % hold on;
    % plot(file{1,1}.data(:,1),y,'r');
    % % saveas(f{1,j},[filepath '\' filename{1,1}(1:end-4) '\' 'RadiativeRecombinationRate.png']);
    % j = j+1;
    % 
    % %NonRadiativeRecombinationRate
    % f{1,j} = figure(j);
    % plot(file{1,1}.data(:,1),file{1,1}.data(:,idx.NonRadiativeRecombinationRate));
    % hold on;
    % plot(file{1,1}.data(:,1),y,'r');
    % % saveas(f{1,j},[filepath '\' filename{1,1}(1:end-4) '\' 'NonRadiativeRecombinationRate.png']);
    % j = j+1;
    % 
    % %SRRecombinationRate
    % f{1,j} = figure(j);
    % plot(file{1,1}.data(:,1),file{1,1}.data(:,idx.SRRecombinationRate));
    % hold on;
    % plot(file{1,1}.data(:,1),y,'r');
    % % saveas(f{1,j},[filepath '\' filename{1,1}(1:end-4) '\' 'SRRecombinationRate.png']);
    % j = j+1;
    % 
    % %AugerRecombinationRate
    % f{1,j} = figure(j);
    % plot(file{1,1}.data(:,1),file{1,1}.data(:,idx.AugerRecombinationRate));
    % hold on;
    % plot(file{1,1}.data(:,1),y,'r');
    % % saveas(f{1,j},[filepath '\' filename{1,1}(1:end-4) '\' 'AugerRecombinationRate.png']);
    % j = j+1;
end

