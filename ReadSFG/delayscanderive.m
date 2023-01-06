function [desortre_165_0_5,desortre_165_0_5_normalized] = delayscanderive(dist, t, dtn, dire, vt1_165,vt2_165)
%plumedensity is to derive the delay scan data back using the fitted slope
%velocity 
n = size(vt2_165);
m = size(vt1_165);
for i=1:length(vt2_165) 
    desort2=[ones(1,n(2))',(1000.*dire(length(dire)-n(2)+1:end)')]\(vt2_165(i,:)');
    desortre2_165_0_5(i)=desort2(1)+dist*desort2(2);
end
for i=1:length(vt1_165) 
    desort1=[ones(1,m(2))',(1000.*dire(length(dire)-m(2)+1:end)')]\vt1_165(i,:)';
    desortre1_165_0_5(i)=desort1(1)+dist*desort1(2);
end
desortre_165_0_5=[desortre1_165_0_5,(desortre2_165_0_5(2:end))];
% dt=[dtn, flip(dtn(1:end-1))];
% [fitresultshift_0_5mm, gofshift_0_5mm]=maxwelldelayfit(desortre_165_0_5,dtn/max(dtn));
[fitresultshift_0_5mm, gofshift_0_5mm]=fit_delay_all(desortre_165_0_5,dtn/max(dtn));
desortre_165_0_5_fit=fitresultshift_0_5mm(t);
desortre_165_0_5_normalized=desortre_165_0_5_fit/sum(desortre_165_0_5_fit);
% n = find(gate==max(gate));
% vte = interp1(gate(1:n)/max(gate),t(1:n),dtn);
% vtl = interp1(gate(n:end)/max(gate),t(n:end),dtn);
