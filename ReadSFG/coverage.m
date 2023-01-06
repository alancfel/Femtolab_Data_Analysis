function [coverratio, crystal] = coverage(grayimage, level)
if isa(grayimage,'logical')
    BW = grayimage;
    threshold = 1;
    cover = size(find(grayimage == threshold));
else
    BW = im2bw(grayimage,level);
    threshold = level*255;
    cover = size(find(grayimage > threshold));
end
total = size(grayimage);
coverratio = cover(1)*cover(2)/(total(1)*total(2));

h1 = figure;
iptsetpref('ImshowAxesVisible','on');
imshow(grayimage,'XData',[0 size(grayimage,2)*0.93],'YData', [0 size(grayimage,1)*0.93])
xlabel('Unit in \mum', 'FontSize', 14);
ylabel('Unit in \mum', 'FontSize', 14);
yname = 'Intensity';
cbar = colorbar;title(cbar, yname);
set(h1, 'PaperpositionMode', 'auto');

[pixelCount, grayLevels] = imhist(grayimage);
h2 = figure('PaperSize',[8.267716 15.692913]);
bar(grayLevels, pixelCount); % Plot it as a bar chart.
grid off;
% title('Histogram of original image', 'FontSize', fontSize);
set(gca,'fontsize',20);
xlabel('Gray Level', 'FontSize', 14);
ylabel('Pixel Count', 'FontSize', 14);
xlim([0 grayLevels(end)]); % Scale x axis manually.
set(h2, 'Position', [80,100,1000,620]);
set(h2, 'PaperpositionMode', 'auto');

[centersBright, radiiBright] = imfindcircles(BW,[3, 10],'ObjectPolarity', 'bright');

h5 = figure;
iptsetpref('ImshowAxesVisible','on');
imshow(BW)%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
% xlabel('Unit in (\mum)', 'FontSize', 14);
% ylabel('Unit in (\mum)', 'FontSize', 14);
% imshow(BW); 
% 
hBright = viscircles(centersBright, radiiBright,'EdgeColor','b');
xlabel('Unit in pixel', 'FontSize', 14);
ylabel('Unit in pixel', 'FontSize', 14);
set(h5, 'PaperpositionMode', 'auto');

h6 = figure('PaperSize',[8.267716 15.692913]);
hist(2*0.93*radiiBright,100);
set(gca,'fontsize',20);
xlabel('Crystal size (\mum)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h6, 'Position', [80,100,1000,620]);
set(h6, 'PaperpositionMode', 'auto');

% fprintf('For circle finding: \nThe crystal size is %d (\mum)\n', mode(2*0.93*radiiBright));
fprintf(strcat(sprintf('For circle finding: \nThe crystal size is %d \n', mode(2*0.93*radiiBright)), char(0181),'m','\n'));

statel = regionprops(BW,'Centroid','MajorAxisLength','MinorAxisLength');
centers = cat(1, statel.Centroid);
diameters = mean([cat(1,statel.MajorAxisLength) cat(1,statel.MinorAxisLength)],2);
radii = diameters/2;
h9 = figure('PaperSize',[8.267716 15.692913]);
iptsetpref('ImshowAxesVisible','on');
imshow(BW)%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
% xlabel('Unit in (\mum)', 'FontSize', 14);
% ylabel('Unit in (\mum)', 'FontSize', 14);
% imshow(BW); 
% 
hCircle = viscircles(centers, radii,'EdgeColor','r');
xlabel('Unit in pixel', 'FontSize', 14);
ylabel('Unit in pixel', 'FontSize', 14);
set(h9, 'PaperpositionMode', 'auto');

h10 = figure('PaperSize',[8.267716 15.692913]);
[nelements, ncenters]=hist(2*0.93*radii,100);
hist(2*0.93*radii,100);
set(gca,'fontsize',20);
xlabel('Crystal size (\mum)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h10, 'Position', [80,100,1000,620]);
set(h10, 'PaperpositionMode', 'auto');

crystal = ncenters(nelements == max(nelements));
end