clear clc;
close all;

%************ 1 从Excel中读取采样数据(时间和角度) ************%

[A]=xlsread('右手腕关节.xlsx','B7:C1806');

%************** 2 提取时间&角度&角速度&角加速度 **************%

time=A(:,1);                                         %时间
angle=A(:,2);                                        %角度

m=1800;
for i=1:m-1
    delta(i,:)=A(i+1,:)-A(i,:);    
end 
dt=delta(:,1);                                     %时间差
ds=delta(:,2);                                     %角度差
v=ds./dt;                                          %角速度

for i=1:m-2
    dv(i,:)=v(i+1,:)-v(i,:);    
end
aa=dv./dt(1:m-2);                                %角加速度


%************** 3 滤波前角度&角速度&角加速度 ****************%

figure('name','初始数据')
subplot(3,1,1);
plot(time(1:m-2),angle(1:m-2),'k');          %角度画黑色
title('原始采样数据');
xlabel('时间');
ylabel('角度');

subplot(3,1,2);
plot(time(1:m-2),v(1:m-2),'r');              %角速度画红色
%title('角速度');
xlabel('时间');
ylabel('角速度');

subplot(3,1,3);
plot(time(1:m-2),aa(1:m-2),'b');           %角加速度画蓝色
%title('角加速度');
xlabel('时间');
ylabel('角加速度');


%************* 4 分别滤波角度&角速度&角加速度 **************%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% oneLevelFilter(time,data,gin)是一阶滤波器 %%%
%%% data：一维数据(角度&角速度&角加速度)      %%%
%%% time：一维序列(时间)                      %%%
%%% gin：滤波器参数(参考频谱图选取)           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             该参数 仅供参考               %%%
%%%            建议gin：0.08 左右             %%%
%%%   右手肩关节 参数gin：0.06，0.02，0.01    %%%
%%%   右手肘关节 参数gin：0.03，0.03，0.03    %%%
%%%   右手腕关节 参数gin：0.06，0.02，0.01    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%******************** 4.1 角度一阶低通滤波 ********************%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  对 角度 滤波，然后求得 角速度&角加速度   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[s,v,a,time1]=oneLevelFilter(time(1:m-2),angle(1:m-2),0.023);

figure('name','角度一阶低通滤波')
subplot(3,1,1);
plot(time1,s,'k');
title('角度一阶低通滤波');
xlabel('时间');
ylabel('角度');

subplot(3,1,2);
plot(time1,v,'r');
%title('角速度');
xlabel('时间');
ylabel('角速度');

subplot(3,1,3);
plot(time1,a,'b');
%title('角加速度');
xlabel('时间');
ylabel('角加速度');

%******************* 4.2 角速度一阶低通滤波 ******************%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     对 角速度 滤波，然后求得 角加速度     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[s,v,~,time1]=oneLevelFilter(time(1:m-2),v(1:m-2),0.01);

figure('name','角速度一阶低通滤波')
subplot(2,1,1);
plot(time1,s,'r');
title('角速度一阶低通滤波');
xlabel('时间');
ylabel('角速度');

subplot(2,1,2);
plot(time1,v,'b');
%title('角加速度');
xlabel('时间');
ylabel('角加速度');

%****************** 4.3 角加速度一阶低通滤波 ******************%

[s,v,a,time1]=oneLevelFilter(time(1:m-2),aa(1:m-2),0.008);

figure('name','角加速度一阶低通滤波')
plot(time1,s,'r');
title('角加速度一阶低通滤波');
xlabel('时间');
ylabel('角加速度');

%************************ End File ************************%