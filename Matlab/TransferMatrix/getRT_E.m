function [r_E,t_E] = getRT_E(M_total, n_in, n_out, theta_in, pol)
%function：波在多层结构中传播时，将"波在多层介质间的传播"等效为介质分界面上的入反透射，计算等效反射r_E和透射系数t_E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%等效反射/透射系数具有的参数
%M_total：波在多层结构中传播的总转移矩阵
%p_in/q_in：介质in中用于简化式子的系数
%p_out/q_out：：介质out中用于简化式子的系数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以上参数需要的基础参数
%M_total：波在多层结构中传播的总转移矩阵
%n_in：介质in的折射率
%n_out：介质out的折射率
%theta_in：波在介质in中的偏转角
%theta_out：波在介质out中的偏转角
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入的参数
%M_total：波在多层结构中传播的总转移矩阵
%n_in：介质in的复折射率(包含了衰减系数),虚部存在于e^(-j*beta*(z-zi))中时，相当于对幅度乘上一个系数，在含时形式时，幅度衰减或增加
%n_out：介质out的复折射率
%theta_in：波在介质in中的偏转角(degree)
%pol：波的极化方式('TE'/'TM')
%***计算theta中对n应取实部（不考虑衰减），beta、p、q中对n不能点除（需考虑衰减）,与beta、p、q和n相关的都不能点除
%% 定义变量
theta_out = asind(n_in*sind(theta_in)/real(n_out));%n_in*sind(theta_in) = n_out*sind(theta_out)
%
p_in = cosd(theta_in)*n_in;
p_out = cosd(theta_out)*n_out;
q_in = cosd(theta_in)/n_in;
q_out = cosd(theta_out)/n_out;
%% 计算等效反射/透射系数
if pol == 'TE'
    r_E = (-p_out*M_total(1,1) + p_in*p_out*M_total(1,2) - M_total(2,1) + p_in*M_total(2,2))/(p_out*M_total(1,1) + p_in*p_out*M_total(1,2) + M_total(2,1) + p_in*M_total(2,2));
    t_E = M_total(1,1)*(1+r_E) + p_in*M_total(1,2)*(-1+r_E);
elseif pol == 'TM'
    r_H = (q_out*M_total(1,1) + q_in*q_out*M_total(1,2) - M_total(2,1) - q_in*M_total(2,2))/(-q_out*M_total(1,1) + q_in*q_out*M_total(1,2) + M_total(2,1) - q_in*M_total(2,2));
    t_H = M_total(1,1)*(1+r_H) - q_in*M_total(1,2)*(-1+r_H);
    r_E = -r_H;
    t_E = (q_out/q_in)*t_H;
else
    sprintf('pol error');
end
return
end