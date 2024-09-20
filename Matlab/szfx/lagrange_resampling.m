function lagrange_resampling(x0, fx0, interval)
    figure;
    hold on;
    plot(x0, fx0, 'g', 'LineWidth', 1);

    ais = direct_interpolation(x0, fx0);
    x = linspace(x0(1), x0(end), floor((x0(end)-x0(1))/interval));
    y = polyval(flip(ais), x);

    plot(x, y, 'r', 'LineWidth',2);
    legend('origin', 'interpolation');
end