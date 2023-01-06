function [desortre_165_0_5,velocitydata] = velocitydistributederi(dire, vt1_165,vt2_165)
%plumedensity is to derive the velocity of LIAD plume. pein is the
%plumedensity with unit of cm-3;
%fwhm is full width half maximum of the plume with unit of mm; nofion is the ion yields after each laser shot; 
%focusdi is the foucus diameter of the spot size with unit of um; 
n = size(vt2_165);
m = size(vt1_165);
for i=1:length(vt2_165) 
    desort2=[ones(1,n(2))',vt2_165(i,:)']\(1000.*dire(length(dire)-n(2)+1:end)');
    desortre2_165_0_5(i)=desort2(1);
    velocity2(i) = desort2(2);
end
for i=1:length(vt1_165) 
    desort1=[ones(1,m(2))',vt1_165(i,:)']\(1000.*dire(length(dire)-m(2)+1:end)');
    desortre1_165_0_5(i)=desort1(1);
    velocity1(i) = desort1(2);
end
desortre_165_0_5=[desortre1_165_0_5,(desortre2_165_0_5(2:end))];
velocitydata = [velocity1,velocity2(2:end)];
% dt=[dtn, flip(dtn(1:end-1))];
% [fitresultshift_0_5mm, gofshift_0_5mm]=maxwelldelayfit(desortre_165_0_5,dtn/max(dtn));
% desortre_165_0_5_fit=fitresultshift_0_5mm(t);
% desortre_165_0_5_normalized=desortre_165_0_5_fit/sum(desortre_165_0_5_fit);
% n = find(gate==max(gate));
% vte = interp1(gate(1:n)/max(gate),t(1:n),dtn);
% vtl = interp1(gate(n:end)/max(gate),t(n:end),dtn);