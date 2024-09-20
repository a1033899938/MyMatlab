function ais = direct_interpolation(x0s, fx0s)
    xs = x0s(:);
    fxs = fx0s(:);

    % figure;
    % hold on;
    % plot(xs, fxs, 'g', 'LineWidth', 4);
    
    n = length(xs);
    if n ~= length(fxs)
        fprintf("Error input!");
    end

    coefficient_matrix = zeros(n);
    for iRow = 1:1:n
        coefficient_matrix(iRow, :) = x0s(iRow) .^ (0:1:n-1);
    end
    
    ais = coefficient_matrix\fxs;

    % x = linspace(xs(1), xs(end), 100);
    % y = polyval(flip(ais), x);
    % 
    % plot(x, y, 'r', 'LineWidth',2);
    % legend('origin', 'interpolation');

end