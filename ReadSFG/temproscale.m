function scaleA = temproscale(t,rawdata,t_fit,fitdata)
%plumedensity is to derive the delay scan data back using the fitted slope
%velocity 
% [n, vte,vtl] = velocityderive(t_fit, fitdata, t);
comdata = interp1(t_fit, fitdata, t);
coe = 0.5:0.001:1.5;
n = 0;
for i = 0.5:0.001:1.5
    n = n+1;
    a(n,:) = rawdata*i-comdata;
end
afit = sum((a.^2),2);
scaleA = coe(afit==min(afit));
h = figure('PaperSize',[8.267716 15.692913]);
hold on;
plot(t_fit,fitdata,'bo','markersize',8);
plot(t,rawdata,'ro','markersize',8);
plot(t,rawdata*scaleA,'ko','markersize',8);
xlabel('Delay between ionization laser and desorption laser ( \mus)','FontSize',20)
ylabel('Normalized parent ion yields (arb.units)','Fontsize',20);
set(gca,'fontsize',20);
set(h, 'Position', [80,100,1000,620]);
set(h, 'PaperpositionMode', 'auto');
end