clear;
close all;
clc;
x0s = 1:1:10;
fx0s = rand(1, 10);
x = 1:0.2:10;
boun_set = [2, 1, 1];  % 自然边界条件

xs = x0s(:);
fxs = fx0s(:);

n = length(xs);
h = xs(2:end) - xs(1:end-1);  % h(i) = x(i+1) - x(i)

% 系数矩阵和常数向量初始化
coefficient_matrix = zeros(n);
constant_vector = zeros(n, 1);

% 填充系数矩阵和常数向量
for i = 2:1:n-1
    coefficient_matrix(i, i-1) = h(i-1);
    coefficient_matrix(i, i) = 2*(h(i-1) + h(i));
    coefficient_matrix(i, i+1) = h(i);

    constant_vector(i) = ((fxs(i+1) - fxs(i)) / h(i)) - ((fxs(i) - fxs(i-1)) / h(i-1));
end

% 边界条件设置
if boun_set(1) == 1  % 自然边界, m1 = mn = 0
    coefficient_matrix(1, 1) = 1;
    coefficient_matrix(n, n) = 1;

    constant_vector(1) = 0;
    constant_vector(n) = 0;
elseif boun_set(1) == 2  % 固定边界, S1'(x1) = A, Sn'(xn) = B
    coefficient_matrix(1, 1) = 2*h(1);
    coefficient_matrix(1, 2) = h(1);
    coefficient_matrix(n, n-1) = h(n-1);
    coefficient_matrix(n, n) = 2*h(n-1);

    constant_vector(1) = (fxs(2) - fxs(1)) / h(1) - boun_set(2);
    constant_vector(n) = boun_set(3) - (fxs(n) - fxs(n-1)) / h(n-1);
else
    fprintf("Error boundary type!\n");
end

% 乘以 6
constant_vector = constant_vector * 6;

% 求解 m
m = coefficient_matrix \ constant_vector;

% 计算三次样条的系数 a, b, c, d
a = fxs(1:n-1);
b = (fxs(2:n) - fxs(1:n-1)) ./ h - h .* m(1:n-1) / 2 - h .* (m(2:n) - m(1:n-1)) / 6;
c = m(1:n-1) / 2;
d = (m(2:n) - m(1:n-1)) ./ (6 * h);

% 绘制插值曲线
figure;
hold on;
plot(xs, fxs, 'o', 'color', 'g', 'LineWidth', 4, 'DisplayName', 'origin data');

for i = 1:n-1
    % 选定当前区间
    this_x = x(x >= xs(i) & x <= xs(i+1));
    % 计算当前区间的插值
    this_y = a(i) + b(i)*(this_x - xs(i)) + c(i)*(this_x - xs(i)).^2 + d(i)*(this_x - xs(i)).^3;
    plot(this_x, this_y, '-b', 'LineWidth', 1, 'DisplayName', ['Interval ', num2str(i)]);
end

xx = x;
% yy_struct = csape(xs, fxs, 'variational');
yy_struct = csape(xs, fxs, 'clamped', [boun_set(2), boun_set(3)]);
yy = ppval(yy_struct, xx);

% 绘图
hold on;
plot(xx, yy, '.', 'Color', 'r', 'DisplayName', 'matlab 插值曲线');
legend;
% end
