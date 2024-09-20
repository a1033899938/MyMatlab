function M = getTransferMatrix(lambda0, theta0, n_in, d, pol)
%function：计算波在介质i中传输的子转移矩阵M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%子转移矩阵具有的参数：
%beta_i：介质i中的波矢在传播方向上的分量
%d：波传播的距离
%p_i或q_i：用于简化式子的参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以上参数需要的基础参数
%beta_i：n_i（介质i的折射率）, k0（真空波矢）, theta_i（波在介质i中的偏转角）
%p_i或q_i：n_i, theta_i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入的参数
% lambda0：真空波长(nm)
% theta0：真空入射角(degree)
% n_i：介质i的折射率
% d：波传播的距离(nm)
% pol：波的极化方式('TE'/'TM')
%***计算theta中对n应取实部（不考虑衰减），beta、p、q中对n不能点除（需考虑衰减）,与beta、p、q和n相关的都不能点除
%% 定义变量
%
n0 = 1;
theta_i = asind(n0*sind(theta0)/real(n_in));%n_i*sind(theta_i) = n0*sind(theta0)
k0 = 2*pi/lambda0;%真空波矢
%
p_i = cosd(theta_i)*n_in;%介质中的p
q_i = cosd(theta_i)/n_in;%介质中的q
beta_i = n_in*k0*cosd(theta_i);%介质中的beta(波矢传播方向上的分量)
%% 计算矩阵元
if pol == 'TE'
    m11 = cos(beta_i*d);%注意此处不加d
    m12 = 1j/p_i*sin(beta_i*d);
    m21 = 1j*p_i*sin(beta_i*d);
    m22 = m11;
    M = [m11,m12;m21,m22];
elseif pol == 'TM'
    m11 = cos(beta_i*d);%注意此处不加d
    m12 = -1j/q_i*sin(beta_i*d);
    m21 = -1j*q_i*sin(beta_i*d);
    m22 = m11;
    M = [m11,m12;m21,m22];
else
    sprintf('wrong put polarization!');
end
return
end