clear all fft
clc
close all
Fs = 1000;  %取样频率
T = 1/Fs;   %取样时域周期
L =1500;    %取样点数
t = (0:L-1)*T;  %取样时刻阵列
i=1;

display_region = 200;


%原始信号
% Signal_origin = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
Signal_origin = 4*sin(2*pi*50*t);
subplot(5,6,i);i=i+1;
plot(Signal_origin(1:display_region));
title('origin');

%原始信号的fft
M=fftshift(fft(Signal_origin));
M_real=real(M);
M_imag=imag(M);
M_amp=abs(M);
M_ang=angle(M)*180/pi;

subplot(5,6,i);i=i+1;
plot(M);
title('origin-fft');

subplot(5,6,i);i=i+1;
plot(M_real);
title('origin-fft-real');

subplot(5,6,i);i=i+1;
plot(M_imag);
title('origin-fft-image');

subplot(5,6,i);i=i+1;
plot(M_amp);
title('origin-fft-amplitude');

subplot(5,6,i);i=i+1;
plot(M_ang);
title('origin-fft-angle');

%加噪声
ft = Signal_origin + 2*randn(size(t));
subplot(5,6,i);i=i+1;
plot(ft(1:display_region));
title('add white noise: ft');

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

%滤波器
F_filter = zeros(size(Fw));
% width = (826-676)/2+20;
% filter((L/2+1-width):(L/2+1+width)) = 1;
F_filter(Fw_amp>198) = 1;  

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

% Fw_real_filted = M_real.*filter;
% Fw_imag_filted = M_imag.*filter;
% Fw_amp_filted = M_amp.*filter;
% Fw_ang_filted = M_ang.*filter;

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

Fw_filted = complex(Fw_real_filted,Fw_imag_filted);
subplot(5,6,i);i=i+1;
plot(Fw_ang_filted);
title('Fw-filted');


ft_filted=ifft(ifftshift(Fw_filted));
subplot(5,6,i);i=i+1;
plot(ft_filted(1:display_region));
title('ft-filted');