function [msignal, stdsignal] = cdqgateratio(gate1,gate2,mass1,mass2) 
%function [msignal, stdsignal] = gateratio(gate1,gate2,mass1,mass2); gate1
%and gate2 are the gate data of two different gate; mass1 and mass2 are the
%gate mass;The function will return the mean value of the ratio (msignal)
%and the standard deviation (stdsignal).
global nofrecords;
global nofrepes;
global machename;
global step;
global nofcycle;
global saveps;
global las;
global xaxis;
global figurename;

adqsignalraw1 = mean(reshape(gate1,(nofrepes*1),[]),1);%-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
adqsignalraw2 = mean(reshape(gate2,(nofrepes*1),[]),1);%-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
ratio = adqsignalraw1./adqsignalraw2;

if nofcycle ~= 1
    gateall=reshape(ratio,ceil(nofrecords/nofcycle),nofcycle);
    msignal=mean(gateall',1);
    stdsignal = std(gateall',1, 1);
else
    gateall =reshape(ratio,nofrepes,ceil(nofrecords/nofcycle));
    msignal=mean(gateall,1);
    stdsignal = std(gateall, 1, 1);
% for j = 1:nofrecords
%     msignal(j)=mean(ratio((nofrepes*j-nofrepes+1):(nofrepes*j)));
%     stdsignal(j)=std(ratio((nofrepes*j-nofrepes+1):(nofrepes*j)));
% end
% msignal=mean(gateall',1);
% stdsignal = std(gateall',1);
% if strcmp(machename,'DDG')
%     xlabel2 = 50e3-step;
%     xname = 'Delay time(\mus)';
% else if strcmp(machename,'vertical')
%         xlabel2 = step;
%         xname = 'ns laser vertical scanning (mm)';
%     else
%         xlabel2 = 1:nofrecords;
%         xname = 'Measurement series';
%     end
end
if strcmp(machename,'Channel.A')
    xlabel2 = 50e3-step;
    xname = 'Delay between fs laser and ns laser (\mus)';
    xname2 = 'Delay between fs laser and ns laser (\mus)';
else if strcmp(machename,'vertical')
        xlabel2 = step;
        xname = 'ns laser vertical scanning (mm)';
    else if strcmp(machename,'Channel.B')
            xlabel2 = step;
            xname = 'Delay between flshlamp and Q-switch (\mus)';
            xname2 = 'Desorption laser power (mJ)';
        else
            xlabel2 = 1:ceil(nofrecords/nofcycle) ;
            xname = 'Measurement series';
%             xname2 = 'Ionisation laser power (mW)';
            xname2 ='Lens stage position (mm)';
        end
    end
end
h1 = figure('PaperSize',[8.267716 15.692913]);
% errorbar(xlabel2,msignal,stdsignal,'linewidth',2);
if xaxis == 1 && length(las) == length(xlabel2)
    errorbar(las,msignal,stdsignal/2,'-o','linewidth',2,'markersize',8);
    xlabel(xname2,'FontSize',14)
else
    errorbar(xlabel2,msignal,stdsignal/2,'-o','linewidth',2,'markersize',8);
    xlabel(xname,'FontSize',14)
end
% xlabel(xname,'FontSize',14)
ylabel(sprintf('Ratio between ion yields at %d Da and ion yields at %d', mass1, mass2),'FontSize',14)
set(gca,'fontsize',20);
set(h1, 'Position', [80,100,1000,620]);
set(h1, 'PaperpositionMode', 'auto');
% axis tight
if saveps == 1
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_all','.fig'));
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_all','.png'));
    export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_all','.pdf'),'-transparent');
end
% Another figure without errorbar
h2 = figure('PaperSize',[8.267716 15.692913]);
% errorbar(xlabel2,msignal,stdsignal,'linewidth',2);
if xaxis == 1 && length(las) == length(xlabel2)
    plot(las,msignal,'-o','linewidth',2,'markersize',8);
    xlabel(xname2,'FontSize',14)
else
    plot(xlabel2,msignal,'-o','linewidth',2,'markersize',8);
    xlabel(xname,'FontSize',14)
end
% xlabel(xname,'FontSize',14)
ylabel(sprintf('Ratio between ion yields at %d Da and ion yields at %d', mass1, mass2),'FontSize',14)
set(gca,'fontsize',20);
set(h2, 'Position', [80,100,1000,620]);
set(h2, 'PaperpositionMode', 'auto');
% axis auto
if saveps == 1
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_ave','.fig'));
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_ave','.png'));
    export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d_gate_%d_ratio',mass1,mass2),'_ave','.pdf'),'-transparent');
end
end