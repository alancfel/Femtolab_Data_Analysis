function [eva,evag2,rad,radg2,wid,widg2] = second_peak(dat,video,fig)
%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern;
%Dat is the diffraction data
%Video is the option to export fitted figure to AVI (Video =1) or not.
if video == 1
    v = VideoWriter('second_ring.avi');
    v.FrameRate = 2;
    open(v);
end
figure;
for i=615:630
    clear pks pkss pksss
    x = 1:length(dat(580,:,i-614));
    %     [fitresult, gof] = Gauss8(x, dat(580,:,i-614));
    %     figure;findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100,'Annotate','extents');
    [pks(:,1),pks(:,2),pks(:,3),pks(:,4)] = findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100);
    pksss = sortrows(pks,'descend');
    pkss = sortrows(pksss(1:2,:),2);
    x1 = ((pkss(1,2)-round(3*pkss(1,3))):(pkss(1,2)+round(2*pkss(1,3))));
    [FitResults,FitError] = peakfit([x1;dat(580,x1,i-614)],612,0,2,0,0,0,0,1);
    if video == 1
        title(sprintf('Ring No.2 -- %d mA',i),'Fontsize',14);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    x2 = ((pkss(2,2)-round(2*pkss(2,3))):(pkss(2,2)+round(3*pkss(2,3))));
    [FitResults2,FitError2] = peakfit([x2;dat(580,x2,i-614)],612,0,2,0,0,0,0,1);
    if video == 1
        title(sprintf('Ring No.2 -- %d mA',i),'Fontsize',14);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    rad(i-614,:) = abs(pkss(1,2)-pkss(2,2));
    wid(i-614,:) = mean([pkss(1,3),pkss(2,3)]);
    fitresult = sortrows(FitResults,2);
    fitresult2 = sortrows(FitResults2,2);
    radg1(i-614,:) = abs(fitresult2(1,2)-fitresult(2,2));
    radg2(i-614,:) = abs(fitresult2(2,2)-fitresult(1,2));
    widg1(i-614,:) = mean([fitresult2(1,4),fitresult(2,4)]);
    widg2(i-614,:) = mean([fitresult2(2,4),fitresult(1,4)]);
    
end
close(gcf);
if video == 1
    close(v);
end
eva = rad./wid;
evag1 = radg1./widg1;
evag2 = radg2./widg2;
if fig == 1
    xi = 615:630;
    %plot the Diameter-to-thickness ratio
    h1 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,evag2,'-bo','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diameter-to-thickness ratio', 'FontSize', 20);
    set(h1, 'Position', [160,200,700,62*7]);
    set(h1, 'PaperpositionMode', 'auto');
    title('Ring No.2 analysis','Fontsize',20);
    %plot the diffraction ring diameter as a function of magentic lens current
    h2 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,radg2,'-bo','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffration ring diameter (Pixel)', 'FontSize', 20);
    set(h2, 'Position', [160,200,700,62*7]);
    set(h2, 'PaperpositionMode', 'auto');
    title('Ring No.2 analysis','Fontsize',20);
    %plot the diffraction ring thickness as a function of magentic lens current
    h3 = figure('PaperSize',[8.267716 15.692913]);
    plot(xi,widg2,'-bo','linewidth',2,'markersize',6)
    set(gca,'fontsize',20);
    xlabel('Current (mA)', 'FontSize', 20);
    ylabel('Diffraction ring thickness (Pixel)', 'FontSize', 20);
    set(h3, 'Position', [160,200,700,62*7]);
    set(h3, 'PaperpositionMode', 'auto');
    title('Ring No.2 analysis','Fontsize',20);
end
end