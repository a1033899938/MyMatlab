function [sum_of_matrix, num_of_matrix] = sumMatrix(matrix)
    size_matrix = size(matrix);
    dimension_matrix = length(size_matrix);
    sum_of_matrix = matrix;
    num_of_matrix = 1;
    for iDimension = 1:1:dimension_matrix
        sum_of_matrix = sum(sum_of_matrix);
        num_of_matrix = num_of_matrix*(size_matrix(iDimension));
    end
end