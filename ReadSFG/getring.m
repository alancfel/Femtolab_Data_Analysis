function [evag,rad,wid] = getring(ringnumber,pathinput,video,fig,dat)
%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern; 
if length(dat) == 1204
else
    dat = readimage(pathinput);
end
for i = 1:length(ringnumber)
    elm = ringnumber(i);
    switch elm
        case 1
            [~,evag1(i,:),~,radg1(i,:),~,widg1(i,:)] = first_peak(dat,video,fig);
        case 2
            [~,evag1(i,:),~,radg1(i,:),~,widg1(i,:)] = second_peak(dat,video,fig);
        case 3
            [~,evag1(i,:),~,radg1(i,:),~,widg1(i,:)] = third_peak(dat,video,fig);
        case 4
            [~,evag1(i,:),~,radg1(i,:),~,widg1(i,:)] = fourth_peak(dat,video,fig);
        case 5
            [~,evag1(i,:),~,radg1(i,:),~,widg1(i,:)] = fifth_peak(dat,video,fig);
    end
end
if length(ringnumber) == 1
    evag = evag1;
    rad = radg1;
    wid = widg1;
else
    evag = mean(evag1,1);
    rad = mean(radg1,1);
    wid = mean(widg1,1);
    xi = 615:630;
    %plot the Diameter-to-thickness ratio
    h1 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,evag1,'-o','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diameter-to-thickness ratio', 'FontSize', 20);
    set(h1, 'Position', [160,200,700,62*7]);
    set(h1, 'PaperpositionMode', 'auto');
    legend ('show');
    title('Multiple ring analysis','Fontsize',20);
    %plot the diffraction ring diameter as a function of magentic lens current
    h2 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,radg1,'-o','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffration ring diameter (Pixel)', 'FontSize', 20);
    set(h2, 'Position', [160,200,700,62*7]);
    set(h2, 'PaperpositionMode', 'auto');
    legend ('show');
    title('Multiple ring analysis','Fontsize',20);
    %plot the diffraction ring thickness as a function of magentic lens current
    h3 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,widg1,'-o','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffraction ring thickness (Pixel)', 'FontSize', 20);
    set(h3, 'Position', [160,200,700,62*7]);
    set(h3, 'PaperpositionMode', 'auto');
    legend ('show');
    title('Multiple ring analysis','Fontsize',20);
end
%plot the Diameter-to-thickness ratio
xi = 615:630;
h1 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,evag,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diameter-to-thickness ratio', 'FontSize', 20);
set(h1, 'Position', [160,200,700,62*7]);
set(h1, 'PaperpositionMode', 'auto');
title('Ring average analysis','Fontsize',20);
%plot the diffraction ring diameter as a function of magentic lens current
h2 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,rad,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diffration ring diameter (Pixel)', 'FontSize', 20);
set(h2, 'Position', [160,200,700,62*7]);
set(h2, 'PaperpositionMode', 'auto');
title('Ring average analysis','Fontsize',20);
%plot the diffraction ring thickness as a function of magentic lens current
h3 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,wid,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diffraction ring thickness (Pixel)', 'FontSize', 20);
set(h3, 'Position', [160,200,700,62*7]);
set(h3, 'PaperpositionMode', 'auto');
title('Ring average analysis','Fontsize',20);
end