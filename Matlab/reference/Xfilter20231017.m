close all;
%% 原始信号
ft = Intensity;
figure;
i=1;
subplot(3,4,i);i = i+1;
plot(ft);
title('原始信号');
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
width = 20;
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
title('滤波后幅频特性');

Fw_pp = angle(Fww);
subplot(3,4,i);i = i+1;
plot(Fw_pp);
title('滤波后相频特性');
%% 反傅里叶变换
ftt = abs(ifft(ifftshift(Fww)));
subplot(3,4,i);i = i+1;
plot(ftt);
title('反傅里叶变换');