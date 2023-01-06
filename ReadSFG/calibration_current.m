%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern; 
clc;clear variables; close all;
pathname = 'N:\4all\mpsd_ad_exp\EDiff\New Gas Machine\Data\2018\2018_11_01\Data\Run C\';
for i=615:630
    %%Read the diffraction binary files; plot the diffraction patterns; Find
    %%the center
    filename = sprintf('C_01.11.2018_Frames=10_Gold_H18.48_V12.55_%dmA_TR_NonDiff_0fs_17_11.bin',i);
    file = fullfile(pathname,filename);
    dat(:,:,i-614) = ReadspeAndorIndividual(file);
%     [centersBright(i-614,:), radiiBright(i-614,:)] = imfindcircles(dat(:,:,i-614),[100, 5000],'ObjectPolarity', 'bright');
    figure;
    iptsetpref('ImshowAxesVisible','on');
    imshow(dat(:,:,i-614),[100 15000]);%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
%     hBright = viscircles(centersBright(i-614,:), radiiBright(i-614,:),'EdgeColor','b');
    xlabel('Unit in pixel', 'FontSize', 14);
    ylabel('Unit in pixel', 'FontSize', 14);
    title(sprintf('%d mV',i),'Fontsize',20);
    %%plot sice profile of diffraction patterns; 
    clear pks pkss
    x = 1:length(dat(580,:,i-614));
    figure;findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100);
    [pks(:,1),pks(:,2),pks(:,3),pks(:,4)] = findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100);
    pkss = sortrows(pks,'descend');
    rad(i-614,:) = abs(pkss(1,2)-pkss(2,2))+1;
    wid(i-614,:) = mean([pkss(1,3),pkss(2,3)]);
    eva(i-614,:) = rad(i-614,:)/wid(i-614,:);
end
xi = 615:630;
%plot the Diameter-to-thickness ratio
h1 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,eva,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diameter-to-thickness ratio', 'FontSize', 20);
set(h1, 'Position', [80,100,1000,620]);
set(h1, 'PaperpositionMode', 'auto');
%plot the diffraction ring diameter as a function of magentic lens current
h2 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,rad,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diffration ring diameter (Pixel)', 'FontSize', 20);
set(h2, 'Position', [80,100,1000,620]);
set(h2, 'PaperpositionMode', 'auto');
%plot the diffraction ring thickness as a function of magentic lens current
h3 = figure('PaperSize',[8.267716 15.692913]);
plot(xi,wid,'-o','linewidth',2,'markersize',6)
set(gca,'fontsize',20);
xlabel('Current (mA)', 'FontSize', 20);
ylabel('Diffraction ring thickness (Pixel)', 'FontSize', 20);
set(h3, 'Position', [80,100,1000,620]);
set(h3, 'PaperpositionMode', 'auto');