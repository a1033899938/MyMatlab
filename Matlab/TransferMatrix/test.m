clc;clear all;close all;
x = [260, 280, 300, 320, 350, 400, 450, 500];
y = [6.16762688614541e-12, 5.48740586769687e-12, 4.79532447272557e-12, 4.14815097697779e-12, 3.29324532705844e-12, 2.06929430549527e-12, 1.43668363281190e-12, 1.15770053137296e-12];
X = log(x);
Y = log(y);
figure
plot(X,Y,'o');
hold on;
fittingEqn = fittype('b*x + log(a)', ...
        'coefficients', {'b', 'a'});
        initialGuess = [-2.56, 6.1782e-12];
% fittingModel = fit(wavelength{1,iFiles}, intensity{1,iFiles}', fittingEqn, 'StartPoint', initialGuess);% 进行曲线拟合
fittingModel = fit(X', Y', fittingEqn,'StartPoint', initialGuess);
disp(fittingModel);
fittingCoefficients = coeffvalues(fittingModel);
b = fittingCoefficients(1);
a = fittingCoefficients(2);
fitx = linspace(260,500,100);
fity = a*fitx.^b;
plot(fittingModel);

hold off;
figure
plot(x,y,'o');
hold on;
plot(fitx,fity);
legend('origin','fitting')

