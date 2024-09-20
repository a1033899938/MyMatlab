function [] = TmmFigureSetting()
shading interp
% colormap('gray');
colormap('jet');
% clim([-.1 100]);%颜色图范围
% ylim([0 inf]);
% set(gca,'YDir','Normal')%y轴方向为常用（从左到右递增）
% set(gca,'Fontname','Times New Roman','FontSize',15,'linewidth',1);
colorbar

grid on%启用网格
box off%启用边框  
set(gca,'Fontsize',15);
xlabel('Wavelength(nm)','FontSize',15)
ylabel('R','FontSize',15)
% xlabel('Angle(degree)','FontSize',15)
% ylabel('Wavelength(nm)','FontSize',15)
% title('Simulated suspended TMD reflectance spectrum','FontSize',15)
end

% xlabel('Angle(degree)','FontSize',15)
% ylabel('PL Intensity(counts)','FontSize',15)
