clc
clear
data = xlsread('C:\Users\HASEE\Desktop\练习数据.xlsx') ;%数据读取
prep_data=data(2:2,1:end);
m1=diff(prep_data(1:1,1:end));
subplot(2,2,1)
hold on
plot(data(1:1,:),prep_data,'g-')
axis([935 1650 ,0,60])
plot(data(1:1,1:(end-1)),(m1+1.0)*40,'r--','Linewidth',1.5)
title("原光谱图及其一阶导数")
 
m2=diff(prep_data(1:1,1:end),2);
subplot(2,2,2)
hold on
plot(data(1:1,:),prep_data,'g-')
axis([935 1650 ,0,60])
plot(data(1:1,1:(end-2)),(m2+1.0)*40,'b--','Linewidth',1.5)
title("原光谱图及其二阶导数")
 
m3=diff(prep_data(1:1,1:end),3);
subplot(2,2,3)
hold on
plot(data(1:1,:),prep_data,'g-')
axis([935 1650 ,0,60])
plot(data(1:1,1:(end-3)),(m3+1.0)*40,'k--','Linewidth',1.5)
title("原光谱图及其三阶导数")
 
m4=diff(prep_data(1:1,1:end),4);
subplot(2,2,4)
hold on
plot(data(1:1,:),prep_data,'g-')
axis([935 1650 ,0,60])
plot(data(1:1,1:(end-4)),(m4+1.0)*40,'y--','Linewidth',1.5)
title("原光谱图及其四阶导数")
 