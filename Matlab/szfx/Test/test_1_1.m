%% 计算1^2到1000^2的和
clear;
clc;
a = 1:1000;
rst = sum(a.^2);
fprintf('result = %d', rst);
