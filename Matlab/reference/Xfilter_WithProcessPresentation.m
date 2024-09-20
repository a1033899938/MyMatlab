% function file_filted = Xfilter(file,D0)
file = Intensity;
D0 = 100;

L =length(file);%取样点数
i=1;

ft = file;
subplot(5,6,i);i=i+1;
plot(ft);
title('ft');

%fft
Fw=fftshift(fft(ft));
subplot(5,6,i);i=i+1;
plot(Fw);
title('Fw');

%filter：仍是用带虚部的Fw来做滤波和逆变换。只动实部，不动虚部
Fw_real=real(Fw);
Fw_imag=imag(Fw);
Fw_amp=abs(Fw);
Fw_ang=angle(Fw);

subplot(5,6,i);i=i+1;
plot(Fw_real);
title('Fw-real');

subplot(5,6,i);i=i+1;
plot(Fw_imag);
title('Fw-imag');

subplot(5,6,i);i=i+1;
plot(Fw_amp);
title('Fw-amplitude');

subplot(5,6,i);i=i+1;
plot(Fw_ang);
title('Fw-angle');
%%
%滤波器
%******************如果滤波器不是严格的偶对称，作FT则会引入时空间的虚部！！！
%基础参数
F_filter = zeros(L);
filter_floor = floor((L+1)/2-D0);
filter_center_floor = floor((L+1)/2);
filter_center_ceil = ceil((L+1)/2);
filter_center = (L+1)/2;
filter_ceil = ceil((L+1)/2+D0);
% 理想低通滤波
% F_filter(filter_floor:filter_ceil) = 1;
%高斯低通滤波
idx = 1:1:L;
D = idx-filter_center;
F_filter = exp((-D.^2)/(2*D0^2));
%%
i=i+2;
subplot(5,6,i);i=i+1;
plot(F_filter);
title('F-filter');

subplot(5,6,i);i=i+1;
plot(F_filter);
title('F-filter');

i=i+2;

%滤波操作
Fw_real_filted = Fw_real.*F_filter;
Fw_imag_filted = Fw_imag.*F_filter;
Fw_amp_filted = Fw_amp.*F_filter;
Fw_ang_filted = Fw_ang.*F_filter;
% Fw_ang_filted = Fw_ang*1;

i=i+2;
subplot(5,6,i);i=i+1;
plot(Fw_real_filted);
title('Fw-real-filted');

subplot(5,6,i);i=i+1;
plot(Fw_imag_filted);
title('Fw-imag-filted');

subplot(5,6,i);i=i+1;
plot(Fw_amp_filted);
title('Fw-amplitude-filted');

subplot(5,6,i);i=i+1;
plot(Fw_ang_filted);
title('Fw-angle-filted');

% Fw_filted = complex(Fw_real,Fw_imag);%测试
Fw_filted = complex(Fw_real_filted,Fw_imag_filted);
subplot(5,6,i);i=i+1;
plot(Fw_filted);
title('Fw-filted');

% Fw_filted=fftshift(fft(ft));%测试
ft_filted=ifft(ifftshift(Fw_filted));
subplot(5,6,i);
plot(ft_filted);
title('ft-filted');
file_filted = ft_filted;

%若滤波器不是偶对称的，则要去除时空间的虚部
% ft_filted_abs=abs(ft_filted);
% subplot(5,6,i);
% plot(ft_filted_abs);
% title('ft-filted-abs');

% return
% end