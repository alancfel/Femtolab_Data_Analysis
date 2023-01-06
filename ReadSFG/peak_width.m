%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern; 
clear i rad wid eva x;
close all;
for i=615:630
    clear pks pkss
    x = 1:length(dat(580,:,i-614));
    figure;findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100,'Annotate','extents');
    [pks(:,1),pks(:,2),pks(:,3),pks(:,4)] = findpeaks(dat(580,:,i-614),x,'MinPeakDistance',100);
    pkss = sortrows(pks,'descend');
    rad(i-614,:) = abs(pkss(1,2)-pkss(2,2))+1;
    wid(i-614,:) = min([pkss(1,3),pkss(2,3)]);
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