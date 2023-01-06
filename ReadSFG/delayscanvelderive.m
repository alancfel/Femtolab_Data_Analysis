function [desortre_165_0_5_fit,desortre_165_0_5_normalized] = delayscanvelderive(dist,t, dtn,desorp_165_0, velocity_165)
%plumedensity is to derive the delay scan data use fitted velocity
%distribution data and desorption time data
% n = find(desorp_165_0 == max(desorp_165_0));
% m = find(velocity_165 == max(velocity_165));
% vte = interp1(gate(1:n)/max(gate),t(1:n),dtn(1:m)/max(dtn));
% vtl = interp1(gate(n:end)/max(gate),t(n:end),dtn(m:end)/max(dtn));
% for i=1:length(vt2_165) 
%     desort2=[ones(1,5)',dire(2:end)']\(vt2_165(i,:)');
% desortre2_165_0_5 = desorp_165_0(n:end)+dist*1000./velocity_165(1:m);
desortre_165_0_5 = desorp_165_0+dist*1000./velocity_165;
% end
% for i=1:length(vt1_165) 
%     desort1=[ones(1,6)',dire']\vt1_165(i,:)';
% desortre1_165_0_5 = desorp_165_0(1:n)+dist*1000./velocity_165(m:end);
% end
% desortre_165_0_5=[desortre1_165_0_5,(desortre2_165_0_5(2:end))];
% dt=[dtn, flip(dtn(1:end-1))];
[fitresultshift_0_5mm, gofshift_0_5mm]=fit_delay_all(desortre_165_0_5,dtn/max(dtn));
desortre_165_0_5_fit=fitresultshift_0_5mm(t);
desortre_165_0_5_normalized=desortre_165_0_5_fit/sum(desortre_165_0_5_fit);
% n = find(gate==max(gate));
% vte = interp1(gate(1:n)/max(gate),t(1:n),dtn);
% vtl = interp1(gate(n:end)/max(gate),t(n:end),dtn);