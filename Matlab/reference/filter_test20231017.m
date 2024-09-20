clc;
clear;
close all;
%% 原始信号
Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T; 
ft_i = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
figure;
i=1;
subplot(3,4,i);i = i+1;
plot(ft_i(1:100));
title('原始信号');

ft = ft_i + 2*randn(size(t));
subplot(3,4,i);i = i+1;
plot(ft(1:100));
title('加噪声');

%% 傅里叶变换
Fw = fftshift(fft(ft));
subplot(3,4,i);i = i+1;
plot(Fw);
title('傅里叶变换');

Fw_a = abs(Fw);
subplot(3,4,i);i = i+1;
plot(Fw_a);
title('幅频特性');

Fw_p = angle(Fw);
subplot(3,4,i);i = i+1;
plot(Fw_p);
title('相频特性');

%% 滤波器设计
%
%高斯低通滤波
width = 50;
filter_center = floor(length(Fw)/2)+1;
idx = 1:1:length(Fw);
D = idx-filter_center;
filter = exp(-D.^2/(2*width^2));
subplot(3,4,i);i = i+1;
plot(filter);
title('滤波器');

%% 滤波
Fww = Fw.*filter;
subplot(3,4,i);i = i+1;
plot(Fww);
title('滤波后频域');

Fw_aa = abs(Fww);
subplot(3,4,i);i = i+1;
plot(Fw_aa);
title('滤波后频域');

Fw_pp = angle(Fww);
subplot(3,4,i);i = i+1;
plot(Fw_pp);
title('滤波后幅频特性');
%% 反傅里叶变换
ftt = abs(ifft(ifftshift(Fww)));
subplot(3,4,i);i = i+1;
plot(ftt);
title('反傅里叶变换');