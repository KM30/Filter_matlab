function [s,v,a,time1]=oneLevelFilter(time,data,gin)

%%%%%%%%%%%%%%%% 参数介绍 %%%%%%%%%%%%%%%%%%
% data：一维数据(角度)                   %%%
% time：一维序列(时间)                   %%%
% gin：滤波器参数(选取归一化或截止频率)  %%%
% s：滤波后的数据(角度)                  %%%
% v：数据变化率(角速度)                  %%%
% a：数据变化加速度(角加速度)            %%%
% time1：重新插值后的时间序列            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent y0
if isempty(y0)
    y0 = data(1);
end
time1 = time(1):(time(end)-time(1))/(length(time)-1):time(end);
data = interp1(time,data,time1);
s=[];
for ii = 1:length(data)
    snow = gin*(data(ii)-y0)+y0;
    s = [s;snow];
    y0 = snow;
end
clear y0;
v = diff(s)/(time1(2)-time(1));
v = [0;v];
a = diff(v)/(time1(2)-time(1));
a = [0;a];

%************************* End File ***************************%