%%
clc
clear
%% 读取文件名
filepath='E:\3-------------------------Plot--------------------------';
filelist=dir([filepath '\*.spe']);
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
%% 分隔文件名
L=length(filename);
filename_split_1 = {1,L};
filename_splited = {1,L};
filename_splited = {1,L};
for iFiles = 1:1:L
    filename{1,iFiles} = replace(filename{1,iFiles},'.spe','');%先去掉后缀
    filename_split_1{1,iFiles} = split(filename{1,iFiles},'#');
    filename_splited{1,iFiles} = split(filename_split_1{1,iFiles}{2,1},'-');
    filename_splited{1,iFiles}{1,1} = strcat(filename_split_1{1,iFiles}{1,1},'#');
    filename_splited{1,iFiles} =  filename_splited{1,iFiles};%便于后续改进
end
%% 根据电压修改文件名
%修改部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_votage_1 = -4;
end_votage_1 = 4;
step_votage_1 = 0.2;

start_votage_2 = -4;
end_votage_2 = 4;
step_votage_2 = 0.2;
votage_mat_1 = start_votage_1:step_votage_1:end_votage_1;
votage_mat_2 = start_votage_2:step_votage_2:end_votage_2;
for iFiles = 1:1:L
    filename_splited{1,iFiles}{1,1} = 'WS2-20231024-1#';
    filename_splited{1,iFiles}{12,1} = '(1)';
    filename_splited{1,iFiles}{14,1} = num2str(votage_mat_1(iFiles),'%.1f');%以一位小数点将数值转换为字符
    filename_splited{1,iFiles}{15,1} = num2str(votage_mat_2(iFiles),'%.1f');
    filename_splited{1,iFiles}{14,1} = replace(filename_splited{1,iFiles}{14,1},'-','n');%将文件名中的"-"换为"n"
    filename_splited{1,iFiles}{15,1} = replace(filename_splited{1,iFiles}{15,1},'-','n');
    filename_splited{1,iFiles}{14,1} = strcat(filename_splited{1,iFiles}{14,1},'V');%在文件名后加"V"
    filename_splited{1,iFiles}{15,1} = strcat(filename_splited{1,iFiles}{15,1},'V.spe');%在文件名后加"V"，并补回文件后缀
    filename{1,iFiles} = strcat(filename{1,iFiles},'.spe');%补回文件后缀
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_splitname = length(filename_splited);
%生成mat便于查看修改情况
for iSplitname = 1:1:number_splitname
    if iSplitname == 1
        filename_splited_mat = filename_splited{1,1};
    else
        filename_splited_mat = [filename_splited_mat filename_splited{1,iSplitname}];
    end
end


%逐个组合文件名 
newfilename = {1,L};
for iFiles = 1:1:L
    newfilename{1,iFiles} = strjoin(filename_splited{1,iFiles},'-');
end
%% 复制文件到新文件夹
newfilepath='E:\Spectra\file_newname\';
for iFiles = 1:1:L
    copyfile([filepath '\' filename{1,iFiles}],[newfilepath newfilename{1,iFiles}])%复制文件
    % movefile([filepath filename{1,iFiles}],[newfilepath newfilename{1,iFiles}])%剪切文件
end