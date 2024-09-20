function [zs,Es] = getField_E(des_wavelength, exist_wavelength, theta_in, n_in, layers, rs, pol)
%function：计算波在介质i中传播时，在所有兴趣点（zs）处的电场强度们（Es）
%*过程中把E_in的正向分量（入射分量）看作成了1，若要得到实际上的电场强度，只要将Es乘上实际的入射分量即可
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算zi处场强Ei所需要的的参数：
%E_in：初始位置的电场强度
%eta0H_in：初始位置的eta0H
%Mi：初始位置到zi处的子转移矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以上参数需要的基础参数：
%E_in：
%beta_i：介质i中的波矢在传播方向上的分量
%d：波传播的距离
%p_i或q_i：用于简化式子的参数


%des_wavelength：目标波长
%exist_wavelength：已有目录中的波长矩阵
%theta_in：入射角
%n_in：入射介质对电场的折射率
%layers：多层结构的类矩阵
%rs：反射系数
%入射波的极化方式

%%%
待改：
到底是单介质中传播波还是多层介质中传播？
%% 参数初始化
zs = [];
Es = [];
%% 获取波长目录中与目标波长最相近的波长
[~,idx] = min(abs(exist_wavelength - des_wavelength));%最相近波长的位置
wavlength = exist_wavelength(idx);%最相近波长
disp(['You are looking into ' num2str(wavlength) 'nm']);
%% 计算每个标记点处的场
%获取初始位置的[E;F]矩阵
if pol == 'TE'
    p_in = n_in.*cosd(theta_in);%初始位置的p
    E_in = 1 + rs(idx);%初始位置的E
    F_in = p_in*(-1 + rs(idx));%初始位置的F（即eta0*H）
    EF_in = [E_in;F_in];%初始位置的[E;F]矩阵
    %历遍所有层
    for i = 1:1:length(layers)
        zs = [zs layers(i).probePoints];%加入此层中的所有标记点z到zs中
        %历遍所有标记点(layers.resolution = length(layers.probePoints))
        for j = 1:1:layers(i).resolution
            M = getTransferMatrix(wavlength,theta_in,layers(i).index,layers(i).thickness,pol);%初始位置到此标记点处场的转移矩阵
            EF_now = M * EF_in;
            Es = [Es EF_now(1,1)];%加入此标记点处的E到Es中
        end
    end
elseif pol == 'TM'
    r = -rs(idx);%材料库中的r是对电场的反射率，此处的r应是对磁场的反射率
    q_in = cosd(theta_in)./n_in;
    F_in = 1 + r;
    E_in = -q_in(-1 + r);  
    FE_in = [F_in;E_in];
    %历遍所有层
    for i = 1:1:length(layers)
        zs = [zs layers(i).probePoints];%加入此层中的所有标记点z到zs中
        %历遍所有标记点(layers.resolution = length(layers.probePoints))
        for j = 1:1:layers(i).resolution
            M = getTransferMatrix(wavlength,theta_in,layers(i).index,layers(i).thickness,pol);%初始位置到此标记点处场的转移矩阵
            FE_now = M * FE_in;
            Es = [Es FE_now(2,1)];%加入此标记点处的E到Es中
        end
    end
else
    printf('input pol error!!');
end
return
end