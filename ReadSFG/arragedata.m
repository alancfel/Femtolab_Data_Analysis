function [csignalraw, stdcsignalraw] = arragedata(gatedataraw, mgate)
% The function was used to arrange and plot measuremnt data from flip
% scanning. Gatedataraw is the arranged all scan data; mgate is the gate of
% ion mass.
global nofrecords;
global nofrepes;
global nofcycle;
global machename;
global step;
global saveps;
global figurename;
global las;
global xaxis;
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
% gatedataraw = [data(1:(length(data)/nofcycle)) flip(data((length(data)/nofcycle)+1:length(data)))];
adqsignalraw = mean(reshape(gatedataraw,(nofrepes*1),[]),1);%-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
stdadqsignalraw = std(reshape(gatedataraw,(nofrepes*1),[]),1,1);%*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
if nofcycle ~= 1
    csignalraw = mean(reshape(adqsignalraw, ceil(nofrecords/nofcycle) ,[])',1);
    stdcsignalraw = std(reshape(adqsignalraw, ceil(nofrecords/nofcycle) ,[])',1,1);
else
    csignalraw = adqsignalraw;
    stdcsignalraw = stdadqsignalraw;
end
h7 = figure('PaperSize',[8.267716 15.692913]);
if xaxis == 1 && length(las) == length(xlabel2)
    errorbar(las,csignalraw,stdcsignalraw,'-o','linewidth',2,'markersize',8);
    xlabel(xname2,'FontSize',14)
else
    errorbar(xlabel2,csignalraw,stdcsignalraw,'-o','linewidth',2,'markersize',8);
    xlabel(xname,'FontSize',14)
end
ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);
set(gca,'fontsize',20);
set(h7, 'Position', [80,100,1000,620]);
set(h7, 'PaperpositionMode', 'auto');
if saveps == 1
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.fig'));
    export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.pdf'),'-transparent');
    saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.png'));
    %                 eval(sprintf('%s_gate%d_ave = csignalraw/61.04; ', figurename, mgate));
    assignin('base',sprintf('%s_gate%d_ave', figurename, mgate),csignalraw);
    %                 eval(sprintf('%s_gate%d_err = stdcsignalraw/61.04; ', figurename, mgate));
    assignin('base',sprintf('%s_gate%d_err', figurename, mgate),stdcsignalraw);
end
end