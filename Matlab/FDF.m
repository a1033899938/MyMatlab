clc;clear;clf;close all;
filepath = 'C:\Users\a1033\Desktop\plot';
cd(filepath);
%%
NA = 0.75;
iPic = 1;
%% 获取文件列表
filelist=dir([filepath '\*.spe']);
filecell=struct2cell(filelist);
filename = sort_nat(filecell(1,:));
L=length(filename);
%% 读取数据
mapping = cell(1,L);
wavelength = cell(1,L);
intensity = cell(1,L);
energy = cell(1,L);
sp = cell(1,L);
figure(iPic);iPic=iPic+1;
for iFiles=1:1:L
        spnow = loadSPE(filename{1,iFiles});
        sp{1,iFiles} = spnow;
        mapping{1,iFiles} = spnow.int;
        wavelength{1,iFiles} = spnow.wavelength;
        energy{1,iFiles} = 1240./wavelength{1,iFiles};
        wavelength{1,iFiles} = sort(wavelength{1,iFiles});%为了防止光谱中的波长/能量是从大到小，导致wavelength_range获取的上下限idx大小是相反的
        strip = 1:1:spnow.ydim;
        centerstrip = spnow.ydim/2;
        Angle = tan(asin(NA))*((strip-centerstrip)/(centerstrip-1));
        Angle = 180/pi*atan(Angle);
        %作图
        subplot(2,2,1);
        pcolor(strip,wavelength{1,iFiles},mapping{1,iFiles}');
        colorbar;
        xlabel("Strip",'Fontname','Times New Roman','FontSize',15);
        ylabel("wavelength(nm)",'Fontname','Times New Roman','FontSize',15);
        shading interp;
end
%% 二维FFT
for iFiles=1:1:L
    mean_strip = floor(spnow.ydim/2);
    x_FFT = strip-mean_strip;
    y_FFT = 1:1:length(wavelength{1,iFiles});
    y_FFT = y_FFT-floor(length(wavelength{1,iFiles})/2);
    FD = fft2(mapping{1,iFiles}');
    FD = fftshift(FD);
    subplot(2,2,2);
    imshow(log(1+FD),[]);
    colorbar;
    shading interp;
end
%% 掩模
mMask = length(y_FFT);
nMask = length(x_FFT);
mask = ones(mMask,nMask);
mask2 = ones(mMask,nMask);

%巴特沃斯
% N = 1;
% wc = 100;
% for i = 1:1:nMask
%     for j = 1:1:mMask
%         rx = floor(nMask/2);
%         ry = floor(mMask/2);
%         w = sqrt((i-rx)^2+(j-ry)^2);
%         mask(j,i) = 1/sqrt(1+(w/wc)^(2*N));
%     end
% end
% subplot(2,2,3);
% pcolor(x_FFT,y_FFT,mask);
% colorbar;
% shading interp;

% 矩形
D = 5;
L = 10;
mask2(floor(mMask/2)-D:floor(mMask/2)+D,1:floor(nMask/2)-L) = 0;
mask2(floor(mMask/2)-D:floor(mMask/2)+D,floor(nMask/2)+L:end) = 0;
mask = mask.*mask2;
% subplot(2,2,3);
% pcolor(x_FFT,y_FFT,mask);
% colorbar;
% shading interp;

% 圆形
% r = min(mMask,nMask)/5;
% rx1 = floor(nMask/4);
% ry1 = floor(mMask/2);
% rx2 = floor(nMask*3/4);
% ry2 = floor(mMask/2);
% for i = 1:1:nMask
%     for j = 1:1:mMask
%         if (i-rx1)^2 + (j-ry1)^2 <= r^2 || (i-rx2)^2 + (j-ry2)^2 <= r^2
%             mask(j,i) = 0;    
%         end
%     end
% end
%% 掩模+频域信号
afterFDF = FD.*mask;
subplot(2,2,3);
imshow(log(1+afterFDF),[]);
colorbar;
shading interp;
%% IFFT
afterIFFT = real(ifft2(ifftshift(afterFDF),'symmetric'));
% figure(iPic);iPic=iPic+1;
subplot(2,2,4);
pcolor(strip,wavelength{1,iFiles},afterIFFT);
colorbar;
shading interp;