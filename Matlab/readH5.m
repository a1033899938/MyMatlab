clc;clear;close all;
filepath = 'D:\BaiduSyncdisk\Junjie Xie Backup\Script\Python';
cd(filepath);
file= dir([filepath '\*.h5']);
images = h5read([file.name '2022-07-06_DF(1).h5'], '/images');

pcolor(lum.x,lum.y,lum.z);