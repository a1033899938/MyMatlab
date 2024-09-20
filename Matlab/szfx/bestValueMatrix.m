function [max_value, min_value] = bestValueMatrix(matrix)
    size_matrix = size(matrix);
    dimension_matrix = length(size_matrix);
    
    max_value = matrix;
    min_value = matrix;
    for iDimension = 1:1:dimension_matrix
            max_value = max(max_value);
            min_value = min(min_value);
        end
end