% % 匿名函数，通过ndgrid返回多个值
% c = 10;
% mygrid = @(x,y) ndgrid((-x:x/c:x),(-y:y/c:y));
% [x,y] = mygrid(pi,2*pi);
clear;clc
% x = 10:-1:1;
x = rand(5,5,5);
[max_value, min_value] = find_best_value(x);
[mean_value, var_value] = find_mean_and_var(x);

fprintf("Matlab: \n" + ...
    "  max_value = %d \n" + ...
    "  min_value = %d \n" + ...
    "  mean_value = %d \n" + ...
    "  var_value = %d \n", max_value, min_value, mean_value, var_value);