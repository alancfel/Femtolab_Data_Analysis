function [eva,evag1,rad,radg1,wid,widg1] = fourth_peak(dat,video,fig)
%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern;
% clear i rad wid eva x Fitresults Fitresults2 radg1 widg1;
% close all;
if video == 1
    v = VideoWriter('fourth_ring.avi');
    v.FrameRate = 2;
    open(v);
end
figure;
for i=615:630
    clear pks pkss
    x = 1:length(dat(580,:,i-614));
    %     figure;findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100,'Annotate','extents');
    [pks(:,1),pks(:,2),pks(:,3),pks(:,4)] = findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100);
    x1=((pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),2)-round(1.5*pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),3))):(pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),2)+round(1.5*pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),3))));
    [FitResults,FitError] = peakfit([x1;dat(580,x1,i-614)],612,0,1,0,0,0,0,3);
    if video == 1
        title(sprintf('Ring No.4 -- %d mA',i),'Fontsize',14);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    x2=((pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),2)-round(1.5*pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),3))):(pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),2)+round(1.5*pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),3))));
    [FitResults2,FitError2] = peakfit([x2;dat(580,x2,i-614)],612,0,1,0,0,0,0,3);
    if video == 1
        title(sprintf('Ring No.4 -- %d mA',i),'Fontsize',14);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    clf;
    radg1(i-614,:) = abs(FitResults2(2)-FitResults(2));
    widg1(i-614,:) = mean([FitResults2(4),FitResults(4)]);
    rad(i-614,:) = abs(pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),2)-pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),2));
    wid(i-614,:) = mean([pks(((abs(pks(:,2)-413))==min(abs(pks(:,2)-413))),3),pks(((abs(pks(:,2)-835))==min(abs(pks(:,2)-835))),3)]);
end
close(gcf);
if video == 1
    close(v);
end
eva = rad./wid;
evag1 = radg1./widg1;
if fig == 1
    xi = 615:630;
    %plot the Diameter-to-thickness ratio
    h1 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,eva,'-bo','linewidth',2,'markersize',6)
    hold on;
    plot(xi,evag1,'-ro','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diameter-to-thickness ratio', 'FontSize', 20);
    set(h1, 'Position', [160,200,700,62*7]);
    set(h1, 'PaperpositionMode', 'auto');
    lh1=legend('Findpeaks result','Gaussian fit','location','Best');
    set(lh1,'fontsize',20);
    set(lh1,'box','off');
    title('Ring No.4 analysis','Fontsize',20);
    %plot the diffraction ring diameter as a function of magentic lens current
    h2 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,rad,'-bo','linewidth',2,'markersize',6)
    hold on;
    plot(xi,radg1,'-ro','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffration ring diameter (Pixel)', 'FontSize', 20);
    set(h2, 'Position', [160,200,700,62*7]);
    set(h2, 'PaperpositionMode', 'auto');
    lh2=legend('Findpeaks result','Gaussian fit','location','Best');
    set(lh2,'fontsize',20);
    set(lh2,'box','off');
    title('Ring No.4 analysis','Fontsize',20);
    %plot the diffraction ring thickness as a function of magentic lens current
    h3 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,wid,'-bo','linewidth',2,'markersize',6)
    hold on;
    plot(xi,widg1,'-ro','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffraction ring thickness (Pixel)', 'FontSize', 20);
    set(h3, 'Position', [160,200,700,62*7]);
    set(h3, 'PaperpositionMode', 'auto');
    lh3=legend('Findpeaks result','Gaussian fit','location','Best');
    set(lh3,'fontsize',20);
    set(lh3,'box','off');
    title('Ring No.4 analysis','Fontsize',20);
end
end