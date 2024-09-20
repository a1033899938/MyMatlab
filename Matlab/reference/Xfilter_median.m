function ft_filted = Xfilter_median(ft,D0)
% D0窗口大小
%D0 = 10;
% file = Intensity;

L =length(ft);%取样点数
% i=1;
% subplot(2,1,i);i=i+1;
% plot(ft);
% title('the signal before smoothened');

remainder = rem(L,D0); 
quotient = (L-remainder)/D0;

ft_filted = zeros(size(ft));
for j = 0:quotient-1
    idx_start = j*D0+1;
    med = median(ft(idx_start:idx_start+D0-1));
    ft_filted(idx_start:idx_start+D0-1) = med;
end
ft_filted(end-remainder+1:end) = median(ft(end-remainder+1:end));

% subplot(2,1,i);
plot(ft_filted);
% title('the signal after smoothened!!');

return
end