function [n, vte,vtl] = velocityderive(gate, t, dtn)
%velocityderive is to intercpt the time data of delay scan

n = find(gate == max(gate));
m = find(dtn == max(dtn));
% vte = interp1(gate(1:n)/max(gate),t(1:n),dtn(1:m)/max(dtn));
% vtl = interp1(gate(n:end)/max(gate),t(n:end),dtn(m:end)/max(dtn));
vte = interp1(gate(1:n),t(1:n),dtn(1:m));
vtl = interp1(gate(n:end),t(n:end),dtn(m:end));