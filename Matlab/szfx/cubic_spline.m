function Pnx = cubic_spline(x0s, fx0s, x, boun_set)
    % fprintf("cubic_spline running.");
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

    
    A = boun_set(2);
    B = boun_set(3);
    if boun_set(1) == 1  % 第一类边界, S1'(x1) = A, Sn-1'(xn) = B
        coefficient_matrix(1, 1) = 2*h(1);
        coefficient_matrix(1, 2) = h(1);
        coefficient_matrix(n, n-1) = h(n-1);
        coefficient_matrix(n, n) = 2*h(n-1);

        constant_vector(1) = (fxs(2) - fxs(1))/h(1) - A;
        constant_vector(n) = B - (fxs(n) - fxs(n-1))/h(n-1);
    elseif boun_set(1) == 2  % 第二类边界, S1''(x1) = A, Sn-1''(xn) = B
        coefficient_matrix(1, 1) = 1;
        coefficient_matrix(n, n-1) = 1;
        coefficient_matrix(n, n) = 1;

        constant_vector(1) = A/6;
        constant_vector(n) = B/6;
    elseif boun_set(1) == 3  % 第三类边界, S1'(x1) = Sn-1'(xn), S1''(x1) = Sn-1''(xn)
        coefficient_matrix(1, 1) = 2*h(1);
        coefficient_matrix(1, 2) = h(1);
        coefficient_matrix(1, n-1) = h(n-1);
        coefficient_matrix(1, n) = 2*h(n-1);

        coefficient_matrix(n, 1) = 1; 
        coefficient_matrix(n, n-1) = -1;
        coefficient_matrix(n, n) = -1;

        constant_vector(1) = (fxs(2)-fxs(1))/h(1) - (fxs(n)-fxs(n-1))/h(n-1);
        constant_vector(n) = 0;
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
    hold on;
    plot(xs, fxs, 'o', 'color', 'g', 'LineWidth', 4, 'DisplayName', 'origin data');

    Si = cell(1, n);
    Pnx = [fxs(1)];
    for iNum = 1:1:n-1
        this_x = x(x > xs(iNum) & x < xs(iNum+1));
        Si{iNum} = a(iNum) + b(iNum)*(this_x-xs(iNum)) + c(iNum)*(this_x-xs(iNum)).^2 + d(iNum)*(this_x-xs(iNum)).^3;
        Pnx = [Pnx; Si{iNum}(:); fxs(iNum+1)];
        hold on;
        plot(this_x, Si{iNum}, '-', 'LineWidth', 1, 'DisplayName', num2str(iNum));
    end

    hLegend = legend('show');
    hLegend.NumColumns = 2;
    hLegend.Location = 'northeastoutside';

    title("cubic spline");

    xlim_values = xlim;
    ylim_values = ylim;
    if boun_set(1) == 1 || boun_set(1) == 2
        text_str = sprintf('n = %d\nA = %.2f\nB = %.2f', n, A, B);
    elseif boun_set(1) == 3
        text_str = sprintf('n = %d', n);
    else
        fprintf("Error boundary type!");
    end
    text(xlim_values(1), ylim_values(2), text_str, 'FontSize', 14, 'Color', 'r', ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'Top');

end