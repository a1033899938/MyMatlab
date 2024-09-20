% 生成一个100*100的随机矩阵，求出矩阵元素的平均值与方差，并画出矩阵的统计分布直方图
matrix = rand(100);
matrix_mean = mean(matrix);
var = sum((matrix - matrix_mean).^2);
histogram(matrix,10);