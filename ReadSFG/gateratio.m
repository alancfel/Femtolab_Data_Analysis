function [msignal, stdsignal] = gateratio(gate1,gate2,mass1,mass2) 
%function [msignal, stdsignal] = gateratio(gate1,gate2,mass1,mass2); gate1
%and gate2 are the gate data of two different gate; mass1 and mass2 are the
%gate mass;The function will return the mean value of the ratio (msignal)
%and the standard deviation (stdsignal).
global nofrecords;
global nofcycle;
global machename;
global step;
ratio = gate1./gate2;
for j = 1:nofrecords/nofcycle
    msignal(j)=mean(ratio((nofcycle*j-nofcycle+1):(nofcycle*j)));
    stdsignal(j)=std(ratio((nofcycle*j-nofcycle+1):(nofcycle*j)));
end
if strcmp(machename,'DDG')
    xlabel2 = 50e3-step;
    xname = 'Delay time(\mus)';
else if strcmp(machename,'vertical')
        xlabel2 = step;
        xname = 'ns laser vertical scanning (mm)';
    else
        xlabel2 = 1:nofrecords;
        xname = 'Measurement series';
    end
end
h1 = figure('PaperSize',[8.267716 15.692913]);
errorbar(xlabel2,msignal,stdsignal,'linewidth',2);
ylabel(sprintf('Ration of ion yields at %d Da to ion yields at %d', mass1, mass2),'FontSize',14)
xlabel(xname,'FontSize',14)
set(gca,'fontsize',20);
set(h1, 'Position', [80,100,1000,620]);
set(h1, 'PaperpositionMode', 'auto');
axis tight
end