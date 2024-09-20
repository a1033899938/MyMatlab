clear all;
close all;
clc;
%各品阶概率
probability=[0.01*1.2, 0.01*1.45, 0.01*5.36, 0.01*4.02, 0.01*19.93, 0.01*37.2, 0.01*30.65];
    %状元%对堂%三红%四进%二举%一秀%罚黑

%中奖概率
probability_GetPrize = sum(probability(1:end-1));
fprintf('the probability of getting prize : %d\n',probability_GetPrize);

%有奖品阶概率
P = probability(1:end-1);
P = P/probability_GetPrize;

%各品阶奖品数量
prize_number = P/P(1);

%修正一二阶奖品
prize_number(2) = 3;
prize_number(3:4) = 4;
% prize_number(6) = 50;
prize_number = floor(prize_number);
P(2) = 2.5*P(2);
P(3:4)=fliplr(P(3:4));

%若分两组
% prize_number = 2*prize_number;

fprintf('the prize number are : \n');
disp(prize_number);
fprintf('the total prize number is %d \n',sum(prize_number));
turns_number = sum(prize_number)/probability_GetPrize;
fprintf('the turns number is %d \n',floor(turns_number));

%计算奖品价格
%设奖品价格为price(x)
%
% if i<j, x(i)>x(j)
% x(i)*P(i)>x(j)*P(j)
% sum(x(i)*prize_num(i))==820;

%情形1
% j=1;
% a = [-1 3*1 0 0 0 0;
%     0 -1 1.5*1 0 0 0;
%     0 0 -1 1.2*1 0 0;
%     0 0 0 -1 3*1 0
%     0 0 0 0 -1 5*1];
% b1 = [0;0;0;0;0];
% 
% aeq = [prize_number(1), prize_number(2), prize_number(3), prize_number(4), prize_number(5), prize_number(6)];
% beq = 820;
% f = [-1 0 0 0 0 1];
% [x,y] = linprog(f,a,b,aeq,beq,zeros (6,1));

%情形2
j=1;
a = [-1 1.5*1 0 0 0
    0 -1 1.2*1 0 0 
    0 0 -1 2.5*1 0
    0 0 0 -1 1
    0 0 0 0 1];
b = [0;0;0;0;1];

aeq = [prize_number(2), prize_number(3), prize_number(4), prize_number(5), prize_number(6)];
beq = 720;
f = [-1 0 0 0 1];
[x,y] = linprog(-f,a,b,aeq,beq,zeros (5,1));



%zeros (3,1)就是下界，表示所有的决策量都大于零吧
prize_number = [1 3 3 4 ];

%打印结果
if j ==1
    price_total = sum(x'.*floor(prize_number(2:end)));
else
    price_total = 100+sum(x'.*floor(prize_number(2:end)));
end
fprintf('the price are : \n');
disp(x);
fprintf('the totle price is : %d \n',price_total);