function ftt = Xfilter(ft,width)
%% 傅里叶变换
Fw = fftshift(fft(ft));

%% 滤波器设计
%高斯低通滤波
filter_center = floor(length(Fw)/2)+1;
idx = 1:1:length(Fw);
D = idx-filter_center;
filter = exp(-D.^2/(2*width^2));

%% 滤波
Fww = Fw.*filter;

%% 反傅里叶变换
ftt = abs(ifft(ifftshift(Fww)));
return
end