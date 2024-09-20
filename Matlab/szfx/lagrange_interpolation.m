function Pnx = lagrange_interpolation(x0s, fx0s, x)
    fprintf("lagrange_interpolation running.");
    xs = x0s(:);
    fxs = fx0s(:);

    hold on;
    plot(xs, fxs, 'o', 'color', 'g', 'LineWidth', 4, 'DisplayName', 'origin data');
    
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
    
    hLegend = legend('show');
    hLegend.NumColumns = 2;
    hLegend.Location = 'northeastoutside';

    title("lagrange interpolation");
end