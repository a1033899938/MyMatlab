function [mean_of_matrix, var_of_matrix] = mean_and_varMatrix(matrix)
    [sum_of_matrix, num_of_matrix] = sumMatrix(matrix);
    mean_of_matrix = sum_of_matrix/num_of_matrix;
    fprintf('mean is %d \n', mean_of_matrix);
    
    rst = (matrix - mean_of_matrix).^2;
    
    size_matrix = size(matrix);
    dimension_matrix = length(size_matrix);
    var_matrix = rst;
    for iDimension = 1:1:dimension_matrix
        var_matrix = sum(var_matrix);
    end
    
    var_of_matrix = var_matrix;
    fprintf('var is %d \n', var_of_matrix);
end