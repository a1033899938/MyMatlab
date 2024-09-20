% function cubic_spline(x0s, fx0s, x, boun_set)
clear;
close all;
clc;
x0s = 1:1:10;
fx0s = rand(1,10);
x = 1:0.2:10;
boun_set = [2, 1, 1];

    xs = x0s(:);
    fxs = fx0s(:);

    n = length(xs);
    h = xs(2:n)-xs(1:n-1);  % h(i) = x(i+1)-x(i), i = 1, ..., n-1

    coefficient_matrix = zeros(n);
    constant_vector = zeros(n, 1);
    for i = 2:1:n-1
        coefficient_matrix(i, i-1) = h(i-1);
        coefficient_matrix(i, i) = 2*(h(i-1) + h(i));
        coefficient_matrix(i, i+1) = h(i);

        constant_vector(i) = (fxs(i+1) - fxs(i))/h(i) - (fxs(i) - fxs(i-1))/h(i-1);
    end


    if boun_set(1) == 1  % 自然边界, m1 = mn = 0
        coefficient_matrix(1, 1) = 1;
        coefficient_matrix(n, n) = 1;

        constant_vector(1) = 0;
        constant_vector(n) = 0;
    elseif boun_set(1) == 2  % 固定边界, S1'(x1) = A, Sn-1'(xn) = B
        coefficient_matrix(1, 1) = 2*h(1);
        coefficient_matrix(1, 2) = h(1);
        coefficient_matrix(n, n-1) = h(n-1);
        coefficient_matrix(n, n) = 2*h(n-1);

        constant_vector(1) = (fxs(2) - fxs(1))/h(1) - boun_set(2);
        constant_vector(n) = boun_set(3) - (fxs(n) - fxs(n-1))/h(n-1);
    elseif boun_set(1) == 3  % 非扭结边界，S1'''(x1) = S2'''(x2), Sn-2'''(xn-1) = Sn-1'''(xn)
    else
        fprintf("Error boundary type!")
    end

    constant_vector = constant_vector*6;

    % solve function
    m = coefficient_matrix\constant_vector;

    a = fxs(1:n-1);
    b = (fxs(2:n)-fxs(1:n-1))./h(1:n-1) - h(1:n-1).*m(1:n-1)/2 - h(1:n-1).*(m(2:n)-m(1:n-1))/6;
    c = m(1:n-1)/2;
    d = (m(2:n)-m(1:n-1))./(h(1:n-1)*6);

    % plot
    figure;
    hold on;
    plot(xs, fxs, 'o', 'color', 'g', 'LineWidth', 4, 'DisplayName', 'origin data');

    Si = cell(1, n);
    for iNum = 1:1:n-1
        this_x = x(x >= xs(iNum) & x <= xs(iNum+1));
        Si{iNum} = a(iNum) + b(iNum)*(this_x-xs(iNum)) + c(iNum)*(this_x-xs(iNum)).^2 + d(iNum)*(this_x-xs(iNum)).^3;
        hold on;
        plot(this_x, Si{iNum}, '-', 'LineWidth', 1, 'DisplayName', num2str(iNum));
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
