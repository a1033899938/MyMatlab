function conway_game_of_life()
    n = 100;  % 网格尺寸
    grid = randi([0 1], n, n);  % 初始化随机网格
    
    h = imagesc(grid); 
    colormap(gray);
    axis square;  % 保持axis比例
    
    % 设置更新周期
    while true
        % 更新网格状态
        grid = update_grid(grid);
        % 更新可视化图像
        set(h, 'CData', grid);
        drawnow;
    end
end

function new_grid = update_grid(grid)
    % 获取网格尺寸
    [n, m] = size(grid);
    new_grid = zeros(n, m);  % 创建一个空的网格用于存储更新状态
    
    % 遍历网格中的每个单元
    for i = 1:n
        for j = 1:m
            % 计算该单元周围的活细胞数量
            neighbors = sum(sum(grid(max(1,i-1):min(n,i+1), max(1,j-1):min(m,j+1)))) - grid(i,j);
            
            % 按照生命游戏规则更新细胞状态
            if grid(i,j) == 1
                if neighbors == 2 || neighbors == 3
                    new_grid(i,j) = 1;
                else
                    new_grid(i,j) = 0;
                end
            else
                if neighbors == 3
                    new_grid(i,j) = 1;
                end
            end
        end
    end
end
