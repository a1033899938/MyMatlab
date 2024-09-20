function Pnx = piecewise_linear(x0s, fx0s, x)
    % fprintf("piecewise_linear running.");
    xs = x0s(:);
    fxs = fx0s(:);
    
    hold on;
    plot(xs, fxs, 'o', 'color', 'g', 'LineWidth', 4, 'DisplayName', 'origin data');

    n = length(x0s);
    Si = cell(1, n);
    Pnx = [fxs(1)];
    for iNum = 1:1:n-1      
        this_x = x(x > xs(iNum) & x < xs(iNum+1));
        Si{iNum} = ((this_x-xs(iNum+1))/(xs(iNum)-xs(iNum+1)))*fxs(iNum) + ((this_x-xs(iNum))/(xs(iNum+1)-xs(iNum)))*fxs(iNum+1);
        Pnx = [Pnx; Si{iNum}(:); fxs(iNum+1)];
        hold on;
        plot(this_x, Si{iNum}, '.-', 'LineWidth', 1, 'DisplayName', num2str(iNum));
    end
    hLegend = legend('show');
    hLegend.NumColumns = 2;
    hLegend.Location = 'northeastoutside';
    title("piecewise linear");
end
