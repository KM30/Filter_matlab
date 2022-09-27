function [s,v,a,time1]=oneLevelFilter(time,data,gin)

%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%
% data��һά����(�Ƕ�)                   %%%
% time��һά����(ʱ��)                   %%%
% gin���˲�������(ѡȡ��һ�����ֹƵ��)  %%%
% s���˲��������(�Ƕ�)                  %%%
% v�����ݱ仯��(���ٶ�)                  %%%
% a�����ݱ仯���ٶ�(�Ǽ��ٶ�)            %%%
% time1�����²�ֵ���ʱ������            %%%
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