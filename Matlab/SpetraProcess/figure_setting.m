function [] = figure_setting()
%传递变量
filename_splited_mat = evalin('base', 'filename_splited_mat');
iFiles = evalin('base', 'iFiles');
sw = evalin('base', 'sw');
%%
fontSize_tick = evalin('base', 'fontSize_tick');
    shading interp
    
    if contains(lower(num2str(filename_splited_mat{2,iFiles})),'white')
        colormap('gray');
    elseif contains(lower(num2str(filename_splited_mat{2,iFiles})),'Laser')
        colormap('jet');
    else
        colormap('jet');
    end
    % clim([-.1 100]);%颜色图范围
    % ylim([0 inf]);
    set(gca,'FontSize',fontSize_tick);
    % set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
    % set(gca,'XTickLabel','Fontsize',15);
    % set(gca,'YTickLabel','Fontsize',15);
    grid on%启用网格
    box on%启用边框  
end