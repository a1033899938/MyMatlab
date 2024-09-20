function pnx = lagrange_interpolation(x0s, fx0s, x)
    xs = x0s(:);
    fxs = fx0s(:);

    figure;
    hold on;
    plot(xs, fxs, 'g', 'LineWidth', 1);
    
    n = length(xs);
    Li = cell(1, n);
    rst_add = 0;
    for iNum = 1:1:n
        rst_times = 1;
        for jNum = 1:1:n
            if jNum ~= iNum
               rst_times = rst_times .* (x-xs(jNum))/(xs(iNum) - xs(jNum));
            end
        end
        Li{iNum} = rst_times;
        rst_add = rst_add + rst_times* fxs(iNum);
    end
    Pnx = rst_add;
    
    plot(x, Pnx, 'r', 'LineWidth',2);
    
    legend('origin', 'interpolation');
end