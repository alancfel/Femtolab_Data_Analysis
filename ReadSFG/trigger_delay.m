function delayT = trigger_delay(m1,m2,t1,t2)
%trigger_delay(m1,m2,t1,t2)
%  Calculate the trigger delay time
%
%  Data for 'trigger_delay' :
%      m1 m2 Input : two known mass
%      t1 t2 Input: the known arriving time of these two known mass
%  Output:
%      delayT: The delay time of trigger
%
%  See also cmidaq, wfa, multirecord.

%  Programed by Zhipeng @18.03.2016


%% Fit: 'untitled fit 1'.

delayT = (t1 - t2*sqrt(m1/m2))./(1 - sqrt(m1/m2));


