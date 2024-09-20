% function [wavelengthArray,r_E,R_E,t_E,T_E] = TMM(model)%function测试用
clear;
clc;
% clf;
% close all;
%% 选择输入的模型
model = 1;
%% 预设变量值
wavelengthArray =300:0.3:975;%nm
    nWavelengthArray = length(wavelengthArray);
angleArray = 0;%:0.5:45;
    nAngleArray = length(angleArray);
pol = 'TE';
wavelength_dbr = 650;%目标DBR波长

%% 已知的介电常数
nr_Sapphire=1.7; 
nr_GaAs = 3.68;
nr_AlAs = 3.02;
nr_Al15GaAs = 3.58;%Al(0.15)GaAs
nr_Si = 3.48;
nr_SiO2 = 1.46;
nr_SiN = 2.2;
nr_Ta2O5 = 2.25;
nr_PMMA = 1.75;
%% 设计多层结构
n_Air = 1;
%层材料折射率
medium_in = 'Air';
medium_out = 'Air';

%仅用于DBR
scaling = 1;%DBR形变系数
medium_high = 'Ta2O5';
medium_low = 'SiO2';
medium_cavity = 'SiO2';
eval(sprintf('nr_high = nr_%s',medium_high));
eval(sprintf('nr_low = nr_%s',medium_low));
eval(sprintf('nr_cavity = nr_%s',medium_cavity));
d_high = wavelength_dbr/4/nr_high*scaling;%厚度*折射率=光程
d_low = wavelength_dbr/4/nr_low*scaling;
d_cavity = wavelength_dbr/4/nr_cavity;
nDbr_top = 8;
nDbr_bot = 8;

%% 将设计的结构转换为"Layer的类向量"：Layers
z = 0;%初始化当前Layer的底面位置
nLayer = 0;%初始化当前Layer的标号
layers = setLayer.empty(5,0);%预分配layers的大小
%% 设置模型参数
switch model
    case {1}
        %% DBR
        % 上银镜
        %添加一层
        % nLayer = nLayer + 1;
        % layers(nLayer) = setLayer('material','Ag','thickness',50,'z_min',z);
        % z = layers(nLayer).z_max;


        % 上DBR: 高-低-...低-高
        for iGroups = 1:1:nDbr_top
            %添加一层
            nLayer = nLayer + 1;
            layers(nLayer) = setLayer('material',medium_high,'thickness',d_high,'z_min',z);
            z = layers(nLayer).z_max;    
            %新加一层
            nLayer = nLayer + 1;
            layers(nLayer)=setLayer('material',medium_low,'thickness',d_low,'z_min',z);
            z = layers(nLayer).z_max;  
        end
            %新加一层
            nLayer = nLayer + 1;
            layers(nLayer)=setLayer('material',medium_high,'thickness',d_high,'z_min',z);
            z = layers(nLayer).z_max;  


        % 腔
        %新加一层
        nLayer = nLayer + 1;
        layers(nLayer)=setLayer('material',medium_cavity,'thickness',d_cavity,'z_min',z);
        z = layers(nLayer).z_max; 
        % % % 新加一层
        % % nLayer = nLayer + 1;
        % % layers(nLayer)=setLayer('material','WS2ML','thickness',0.7,'z_min',z);
        % % % z = layers(nLayer).z_max;


        % 下DBR: 高-低-...低-高
        for iGroups = 1:1:nDbr_bot
            %新加一层
            nLayer = nLayer + 1;
            layers(nLayer)=setLayer('material',medium_low,'thickness',d_low,'z_min',z);
            z = layers(nLayer).z_max;   
            %添加一层
            nLayer = nLayer + 1;
            layers(nLayer) = setLayer('material',medium_high,'thickness',d_high,'z_min',z);
            z = layers(nLayer).z_max; 
        end
        
        % 衬底
        % 添加一层
        % nLayer = nLayer + 1;
        % layers(nLayer) = setLayer('material','Si','thickness',500*1e3,'z_min',z);
        % z = layers(nLayer).z_max;
    case {2}
        %% TMD on 3um hole: WS2ML-hole-SiO2-Si
        % 添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','WS2ML','thickness',0.3,'z_min',z);
        z = layers(nLayer).z_max;
        %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','Air','thickness',3000,'z_min',z);
        z = layers(nLayer).z_max; 
        %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','Si','thickness',500*1e3,'z_min',z);
        z = layers(nLayer).z_max;
    case {3}
        %% TMD on SiO2/Si
        % 添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','WS2ML','thickness',0.3,'z_min',z);
        z = layers(nLayer).z_max;
        % %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','SiO2','thickness',280,'z_min',z);
        z = layers(nLayer).z_max;
        % %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','Si','thickness',500*1e3,'z_min',z);
        z = layers(nLayer).z_max;
    case {4}
        %% SiO2/Si
        % %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','SiO2','thickness',280,'z_min',z);
        z = layers(nLayer).z_max;
        % %添加一层
        nLayer = nLayer + 1;
        layers(nLayer) = setLayer('material','Si','thickness',500*1e3,'z_min',z);
        z = layers(nLayer).z_max;
end
%%
d_tot = z;%多层结构总厚度
%% 预设反射/透射系数/率

r_E=zeros(nAngleArray,nWavelengthArray);
t_E=zeros(nAngleArray,nWavelengthArray);
R_E=zeros(nAngleArray,nWavelengthArray);
T_E=zeros(nAngleArray,nWavelengthArray);
A_E=zeros(nAngleArray,nWavelengthArray);

%计算每个波长的反射/透射率
for iWavelengths = 1:1:nWavelengthArray
    %计算某波长的每个入射角情况下的反射/透射率
    wavelength_0 = wavelengthArray(iWavelengths);
    for iAngles = 1:1:nAngleArray
        angle_0 = angleArray(iAngles);%注意，此处的angle是真空入射角(结构为：空气-上DBR-cavity-下DBR-衬底)

        %%%%%%%%修改区%%%%%%%%
        [n_in_r, n_in_i, ~] = getIndex(medium_in, wavelength_0);
        n_in = n_in_r + 1j*n_in_i;
        [n_out_r, n_out_i, ~] = getIndex(medium_out,wavelength_0);
        n_out = n_out_r + 1j*n_out_i;
        %%%%%%%%修改区%%%%%%%%
        theta_in = asind(n_Air*sind(angle_0)/real(n_in));
        theta_out = asind(n_Air*sind(angle_0)/real(n_out));
        p_in = n_in*cosd(theta_in);
        q_in = cosd(theta_in)/n_in;
        p_out = n_out*cosd(theta_out);
        q_out = cosd(theta_out)/n_out;
        
        % 对每个情况（真空入射角、真空波长）计算经过整个结构的M_total
        M_total = eye(2);%初始化M
        % 记录折射率随波长变化的层
        layerIndexVariableNo = zeros(1,nLayer);
        % 优先用预设的折射率，再者是库中的折射率
        for iLayers = 1:1:nLayer
            switch layers(iLayers).material
                case 'Air'
                    layers(iLayers).index = 1;
                case 'PMMA'
                    layers(iLayers).index = nr_PMMA;
                case 'SiN'
                    layers(iLayers).index = nr_SiN;
                case 'Ta2O5'
                    layers(iLayers).index = nr_Ta2O5;
                case 'Al15GaAs'
                    layers(iLayers).index = nr_Al15GaAs;
                case 'AlAs'
                    layers(iLayers).index = nr_AlAs;
                case 'GaAs'
                    layers(iLayers).index = nr_GaAs;
                case 'SiO2'
                    layers(iLayers).index = nr_SiO2;
                otherwise
                    layerIndexVariableNo(iLayers) = 1;
                    [nr_now, ni_now, errorTag] = getIndex(layers(iLayers).material,wavelength_0);
                    layers(iLayers).index = nr_now + 1j*ni_now;
                    if errorTag
                        disp(['Did not find the index of ' layers(iLayers).material]);
                        disp(['index_now is: ' num2str(layers(iLayers).index)]);
                    else
                    end
            end
            M_current_Layer = getTransferMatrix(wavelength_0, angle_0, layers(iLayers).index, layers(iLayers).thickness, pol);  
            M_total = M_current_Layer*M_total;
        end
        [r_E(iAngles,iWavelengths),t_E(iAngles,iWavelengths)] = getRT_E(M_total, n_in, n_out, theta_in, pol);
        R_E(iAngles, iWavelengths) = abs(r_E(iAngles, iWavelengths))^2;
        if pol == 'TE'
            T_E(iAngles, iWavelengths) = p_out/p_in*abs(t_E(iAngles, iWavelengths))^2;
        elseif pol == 'TM'
            T_E(iAngles, iWavelengths) = p_out/p_in*abs(cosd(theta_in)/cosd(theta_out)*abs(t_E(iAngles, iWavelengths))^2);
        else
            sprintf('pol error');
        end
        A_E(iAngles, iWavelengths) = 1-R_E(iAngles, iWavelengths)-T_E(iAngles, iWavelengths);
    end
end

%% 作图
figure;
% hold on
if length(angleArray) ~= 1
    pcolor(angleArray,wavelengthArray,R_E');
    set(gca,'YDir','reverse')%y轴方向为常用（从左到右递增）
    yline(angleArray(1),'--y');
    yline(angleArray(end),'--y');

else
    plot(wavelengthArray, R_E);
end
TmmFigureSetting;
% end%function测试用
