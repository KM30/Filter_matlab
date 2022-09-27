
%************ 1 从Excel中读取采样数据(时间和角度) ************%

[A]=xlsread('右手肩关节.xlsx','B7:C1806');

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

%*********************** 3 观察频谱图 ************************%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 观察频谱图是为了选择低通滤波函数的gin参数 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 1/0.017;
N = 1800;
n = 0:N-1;
t = n/fs;
f = n*fs/N;
x=fft(angle,N);                  %可将参数angle，替换为v或aa
m=abs(x);

figure('name','右手肩关节')
subplot(2,1,1);
plot(t,angle);                  %可将参数angle，替换为v或aa
title('时域图');
xlabel('时间');
ylabel('角度');

%figure('name','原始角度频谱图')
subplot(2,1,2);
plot(f,m);
title('频域图');
xlabel('频率');
ylabel('幅值');

%************************ End File ************************%