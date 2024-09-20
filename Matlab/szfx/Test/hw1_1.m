n = 10;
x0s = 1:1:n;
fx0s = rand(1, n);
x = 1:0.2:n;
boun_set = [1, 0, 0];
for method = 1:1:3
    polynomial_interpolation(x0s, fx0s, x, method, boun_set)
end
