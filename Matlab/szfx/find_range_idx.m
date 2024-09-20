function [idx_min, idx_max] = find_range_idx(x, x_min, x_max)
    [~, idx_min] = min(abs(x - x_min));
    val_min = x(idx_min);
    [~, idx_max] = min(abs(x - x_max));
    val_max = x(idx_max);
    fprintf("val_min = %d", val_min);
    fprintf("val_max = %d", val_max);
end