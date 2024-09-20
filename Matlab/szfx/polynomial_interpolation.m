function Pnx = polynomial_interpolation(x0s,fx0s,x,method,boun_set)
    if method == 1
        Pnx = lagrange_interpolation(x0s, fx0s, x);
    elseif method == 2
        Pnx = piecewise_linear(x0s, fx0s, x);
    elseif method == 3
        Pnx = cubic_spline(x0s, fx0s, x, boun_set);
    else
        fprintf("Error this method is not exist!");
    end
end
