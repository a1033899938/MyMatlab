function [kvecs ] = theta_k_1D(E, theta )
%Convert A as a function of lambda/theta to E/k
%Assumes lam is in nm, theta in degrees
hc = 1.239842000000000e+03;

lam = hc./E;
kvecs = zeros(1,length(lam));
for iter = 1:length(lam)
    %Calculate k in [um^-1]
    k = 1000*(2*pi/lam(iter)).*sin(theta(iter)*pi/180);
    kvecs(1,iter) = k;
end
% figure;
% h = pcolor(kvecs,E,A);
% set(h, 'EdgeColor', 'none');
% h = gca;
% set(gca,'Fontsize',16,'FontWeight','Bold')
% xlabel('k [\mu m^{-1}]','FontSize',16,'FontWeight','Bold')
% ylabel('Energy [eV]','FontSize',16,'FontWeight','Bold');

end

