clc;clear;close all;
x0s = -2:0.5:2;
fx0s = (1 + x0s.^2).^(-1);

h = [0.1, 0.2, 0.3, 0.4, 0.5];
boun_set = [1, 0, 0];
x = cell(1, length(h));
for iStep = 1:1:length(h)
    x{iStep} = -2:h(iStep):2;
    polynomial_interpolation(x0s, fx0s, x{iStep}, 2, boun_set);
end