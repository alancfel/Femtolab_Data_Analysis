%% Detect and Measure Circular Objects in an Image
% This example shows how to use |imfindcircles| to automatically detect
% circles or circular objects in an image. It also shows the use of
% |viscircles| to visualize the detected circles.

% Copyright 2012 The MathWorks, Inc.
close all;
%% Step 1: Load Image
% This example uses an image of round plastic chips of various colors.
% [filename, pathname] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.tiff'}, 'Open Data');
% if filename ~=0
%     file = fullfile(pathname, filename);
%     dot = regexp(filename,'\.');
% end
% iptsetpref('ImshowAxesVisible','off');
% imshow(Probe);
% caxis([800 95000]);
% F = getframe(gca);
% rgb = F.cdata;
% rgb = Probe;
a = max(max(Diffraction_Image_Data));
BWcenter = imbinarize(Diffraction_Image_Data,a*0.01);
[centersBright, radiiBright] = imfindcircles(BWcenter,[30, 60],'ObjectPolarity', 'dark','Sensitivity',0.95);

yname = 'Intensity';
% 
h0 = figure;
iptsetpref('ImshowAxesVisible','on');
imshow(BWcenter);
hBright = viscircles(centersBright(1,:),radiiBright(1),'EdgeColor','r');
xlabel('Unit in Pixel', 'FontSize', 14);
ylabel('Unit in Pixel', 'FontSize', 14);
% cbar = colorbar;title(cbar, yname);
set(h0, 'PaperpositionMode', 'auto');
% cen0 = [centersBright(1,1),radiiBright(1,2)];
%% 
% Besides having plenty of circles to detect, there are a few interesting
% things going on in this image from a circle detection point-of-view:
% 
% # There are chips of different colors, which have different contrasts
% with respect to the background. On one end, the blue and red ones have
% strong contrast on this background. On the other end, some of the yellow
% chips do not contrast well with the background.
% # Notice how some chips are on top of each other and some others that are
% close together and almost touching each other. Overlapping object
% boundaries and object occlusion are usually challenging scenarios for
% object detection.

%% Step 2: Determine Radius Range for Searching Circles
% |imfindcircles| needs a radius range to search for the circles. A quick
% way to find the appropriate radius range is to use the interactive tool
% |imdistline| to get an approximate estimate of the radii of various
% objects.
% d = imdistline;
cenPreCrop.x = round(centersBright(1,1));%551;%466;
cenPreCrop.y = round(centersBright(1,2));%581;%446;
nx_crop = 820;
ny_crop = nx_crop;
borderX = cenPreCrop.x - (nx_crop/2) - 1;
borderY = cenPreCrop.y - (ny_crop/2) - 1;
imgCrop.x = borderX + (1:nx_crop);
imgCrop.y = borderY + (1:ny_crop);
nxCrop = length(imgCrop.x);
nyCrop = length(imgCrop.y);
Probe = medfilt2(Diffraction_Image_Data(imgCrop.y,imgCrop.x),[3,3]);
% figure();
% imagesc(IMG_crpd, [0, 0.5*max(max(IMG_crpd))]);
% pbaspect([1 1 1]);

%%
% cen0.x = (nx_crop/2) + 0.5;
% cen0.y = (ny_crop/2) + 0.5;
% RoundMask = fRoundMask(Diffraction_Image_Data, cen0, 500);
% CenterMask = ~fRoundMask(Diffraction_Image_Data, cen0, 50);
% BeamBlock2 = BeamBlock2 | RoundMask | CenterMask;
% MASK = 1-BeamBlock2;
% Probe = MASK.*Diffraction_Image_Data;
%% 
% |imdistline| creates a draggable tool that can be moved to fit across a
% chip and the numbers can be read to get an approximate estimate of its
% radius. Most chips have radius in the range of 21-23 pixels. Use a
% slightly larger radius range of 20-25 pixels just to be sure. Before that
% remove the |imdistline| tool.
% delete(d);

%% Step 3: Initial Attempt to Find Circles
% Call |imfindcircles| on this image with the search radius of [20 25]
% pixels. Before that, it is a good practice to ask whether the objects are
% brighter or darker than the background. To answer that question, look at
% the grayscale version of this image.

% gray_image = 255*Probe/(max(max(Probe)));
% gray_image = rgb2gray(rgb);
gray_image = Probe;
h1 = figure;
iptsetpref('ImshowAxesVisible','on');
imshow(gray_image,'XData',[0 size(gray_image,2)],'YData', [0 size(gray_image,1)])
xlabel('Unit in Pixel', 'FontSize', 14);
ylabel('Unit in Pixel', 'FontSize', 14);
caxis([800 95000]);
cbar = colorbar;title(cbar, yname);
set(h1, 'PaperpositionMode', 'auto');

% imhist(gray_image);
[pixelCount, grayLevels] = imhist(gray_image);
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
% ylabel('Number of pixels','FontSize',14)%Intensiy (a.u.)','FontSize',14)
% xlabel('Intensity','FontSize',14)%Measurement series','FontSize',14)
        
% level = graythresh(rgb);
% % BW = im2bw(rgb,level);
% % BW = imbinarize(gray_image,'adaptive','ForegroundPolarity','bright','Sensitivity',0.2);
BW = imbinarize(Probe/45360,'adaptive','ForegroundPolarity','bright','Sensitivity',0.3);
% h3 = figure;
% iptsetpref('ImshowAxesVisible','on');
% imshow(BW,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
% xlabel('Unit in (\mum)', 'FontSize', 14);
% ylabel('Unit in (\mum)', 'FontSize', 14);
% % imshow(BW);
% set(h3, 'PaperpositionMode', 'auto');
% threshold = level*255;
% 
% gray_image_eq = histeq(gray_image);  
% cover = size(find(gray_image > threshold));
% total = size(gray_image);
% ratiocover = cover(1)*cover(2)/(total(1)*total(2));
% 
% h4 = figure;
% iptsetpref('ImshowAxesVisible','on');
% imshow(gray_image,[threshold, 250],'XData',[0 size(gray_image,2)*0.93],'YData', [0 size(gray_image,1)*0.93])
% xlabel('Unit in (\mum)', 'FontSize', 14);
% ylabel('Unit in (\mum)', 'FontSize', 14);
% imshow
% % imshow(gray_image,[threshold, 100]);
% cbar = colorbar;title(cbar, yname);
% set(h4, 'PaperpositionMode', 'auto');
% 
% fprintf('The threshold of the gray image is %d \n', threshold);
% fprintf('The coverage of the molecules on the foil band is %d \n', ratiocover);

%%
% The background is quite bright and most of the chips are darker than the
% background. But, by default, |imfindcircles| finds circular objects that
% are brighter than the background. So, set the parameter 'ObjectPolarity'
% to 'dark' in |imfindcircles| to search for dark circles.

% [centers, radii] = imfindcircles(gray_image_eq,[10 255],'ObjectPolarity','dark');
% 
% %% 
% % Note that the outputs |centers| and |radii| are empty, which means that
% % no circles were found. This happens frequently because |imfindcircles| is
% % a circle _detector_, and similar to most detectors, |imfindcircles| has
% % an internal _detection threshold_ that determines its sensitivity. In
% % simple terms it means that the detector's confidence in a certain
% % (circle) detection has to be greater than a certain level before it is
% % considered a _valid_ detection. |imfindcircles| has a parameter
% % 'Sensitivity' which can be used to control this internal threshold, and
% % consequently, the sensitivity of the algorithm. A higher 'Sensitivity'
% % value sets the detection threshold lower and leads to detecting more
% % circles. This is similar to the sensitivity control on the motion
% % detectors used in home security systems.
% 
% %% Step 4: Increase Detection Sensitivity
% % Coming back to the chip image, it is possible that at the default
% % sensitivity level all the circles are lower than the internal threshold,
% % which is why no circles were detected. By default, 'Sensitivity', which
% % is a number between 0 and 1, is set to 0.85. Increase 'Sensitivity' to
% % 0.9.
% 
% [centers, radii] = imfindcircles(gray_image_eq,[10 255],'ObjectPolarity','dark', ...
%     'Sensitivity',0.9);
% 
% %% 
% % This time |imfindcircles| found some circles - eight to be precise.
% % |centers| contains the locations of circle centers and |radii| contains
% % the estimated radii of those circles.
%  
% %% Step 5: Draw the Circles on the Image
% % The function |viscircles| can be used to draw circles on the image.
% % Output variables |centers| and |radii| from |imfindcircles| can be passed
% % directly to |viscircles|.
% 
% imshow(gray_image_eq);
% 
% h = viscircles(centers,radii);
% 
% %% 
% % The circle centers seem correctly positioned and their corresponding
% % radii seem to match well to the actual chips. But still quite a few
% % chips were missed. Try increasing the 'Sensitivity' even more, to 0.92.
% 
% [centers, radii] = imfindcircles(gray_image_eq,[10 255],'ObjectPolarity','dark', ...
%     'Sensitivity',0.92);
% 
% length(centers)
% 
% %%
% % So increasing 'Sensitivity' gets us even more circles. Plot these circles
% % on the image again.
% 
% delete(h);  % Delete previously drawn circles
% h = viscircles(centers,radii);
% 
% %% Step 6: Use the Second Method (Two-stage) for Finding Circles
% % This result looks better. Now, under the hood, |imfindcircles| has two
% % different methods for finding circles. So far the default method, called
% % the _phase coding_ method, was used for detecting circles. There's
% % another method, popularly called the _two-stage_ method, that is
% % available in |imfindcircles|. Use the two-stage method and show the
% % results.
% 
% [centers, radii] = imfindcircles(gray_image_eq,[10 255], 'ObjectPolarity','dark', ...
%           'Sensitivity',0.92,'Method','twostage');
% 
% delete(h);
% 
% h = viscircles(centers,radii);
% 
% %%
% % The two-stage method is detecting more circles, at the Sensitivity of
% % 0.92. In general, these two method are complementary in that have they
% % have different strengths. Phase coding method is typically faster and
% % slightly more robust to noise than the two-stage method. But it may also
% % need higher 'Sensitivity' levels to get the same number of detections as
% % the two-stage method. For example, the phase coding method also finds the
% % same chips if the 'Sensitivity' level is raised higher, say to 0.95.
% 
% [centers, radii] = imfindcircles(gray_image_eq,[10 255], 'ObjectPolarity','dark', ...
%           'Sensitivity',0.95,'Method','twostage');
% 
% delete(h);
% 
% viscircles(centers,radii);
% 
% %%
% % Note that both the methods in |imfindcircles| find the centers and radii
% % of the partially visible (occluded) chips accurately.
%  
% %% Step 7: Why are Some Circles Still Getting Missed?
% % Looking at the last result, it is curious that |imfindcircles| does not
% % find the yellow chips in the image. The yellow chips do not have
% % strong contrast with the background. In fact they seem to have very
% % similar intensities as the background. Is it possible that the yellow
% % chips are not really 'darker' than the background as was assumed? To
% % confirm, show the grayscale version of this image again.
% 
% imshow(gray_image);
% 
% %% Step 8: Find 'Bright' Circles in the Image
% % Indeed! The yellow chips are almost the same intensity, maybe even
% % brighter, as compared to the background. Therefore, to detect the yellow
% % chips, change 'ObjectPolarity' to 'bright'.
% 
[centersBright, radiiBright] = imfindcircles(BW,[3, 10],'ObjectPolarity', 'bright');%,'Sensitivity',0.95);
% 
% %% Step 9: Draw 'Bright' Circles with Different Color
% % Draw the _bright_ circles in a different color, say blue, by changing the
% % 'EdgeColor' parameter in |viscircles|.
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

h7 = figure('PaperSize',[8.267716 15.692913]);
[fk1,xk1,h1] = ksdensity(2*0.93*radiiBright);
[f1,xi1] = ecdf(2*0.93*radiiBright);
ecdfhist(f1,xi1,range(2*0.93*radiiBright)/h1);
hold on
plot(xk1,fk1,'r','linewidth',2);
set(h7, 'Position', [80,100,1000,620]);
xlabel('Crystal size (\mum)','FontSize',14)
ylabel('Number of Crystals','FontSize',14)
set(gca,'fontsize',20);

% fprintf('For circle finding: \nThe crystal size is %d (\mum)\n', mode(2*0.93*radiiBright));
fprintf(strcat(sprintf('For circle finding: \nThe crystal size is %d \n', xk1(fk1==max(fk1))), char(0181),'m','\n'));

h8 = figure('PaperSize',[8.267716 15.692913]);
hist(radiiBright,100);
set(gca,'fontsize',20);
xlabel('Crystal radius size (Pixel)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h8, 'Position', [80,100,1000,620]);
set(h8, 'PaperpositionMode', 'auto');
        
% 
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
hist(2*0.93*radii,100);
set(gca,'fontsize',20);
xlabel('Crystal size (\mum)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h10, 'Position', [80,100,1000,620]);
set(h10, 'PaperpositionMode', 'auto');

fprintf(strcat(sprintf('For ellipse finding: \nThe crystal size is %d \n', mode(2*0.93*radii)), char(0181),'m','\n'));
% %%
statre = regionprops(BW,'boundingbox');
leng = cat(1, statre.BoundingBox);
h11 = figure('PaperSize',[8.267716 15.692913]);
iptsetpref('ImshowAxesVisible','on');
imshow(BW)%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
xlabel('Unit in pixel', 'FontSize', 14);
ylabel('Unit in pixel', 'FontSize', 14);
hold on;
for i = 1:numel(statre)
    rectangle('Position', statre(i).BoundingBox, 'EdgeColor', 'r', 'LineStyle', '-');
end
set(h11, 'PaperpositionMode', 'auto');

% centeradi = [centers leng];
% centeradii = sortrows(centeradi,3,'descend');

for i = 1:length(radii)
    cenPreCrop.x = round(centers(i,1));%551;%466;
    cenPreCrop.y = round(centers(i,2));%581;%446;
    nx_crop = leng(i,3);
    ny_crop = leng(i,4);
    borderX = cenPreCrop.x - round(nx_crop/2);
    borderY = cenPreCrop.y - round(ny_crop/2);
    imgCrop.x = borderX + (1:nx_crop);
    imgCrop.y = borderY + (1:ny_crop);
    centerinten(i,:) = sum(sum(Probe(imgCrop.y,imgCrop.x)));
end

h12 = figure('PaperSize',[8.267716 15.692913]);
hist(0.93*mean([leng(:,3) leng(:,4)],2),100);
set(gca,'fontsize',20);
xlabel('Crystal size (\mum)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h12, 'Position', [80,100,1000,620]);
set(h12, 'PaperpositionMode', 'auto');

fprintf(strcat(sprintf('For rectangle finding: \nThe average crystal size is %d \n', mode(0.93*mean([leng(:,3) leng(:,4)],2))), char(0181),'m','\n'));

lengs = sortrows(leng,3,'descend');
h11 = figure('PaperSize',[8.267716 15.692913]);
iptsetpref('ImshowAxesVisible','on');
imshow(Probe)%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
xlabel('Unit in pixel', 'FontSize', 14);
ylabel('Unit in pixel', 'FontSize', 14);
caxis([800 75000]);
hold on;
for i = 1:100
    rectangle('Position', lengs(i,:), 'EdgeColor', 'r', 'LineStyle', '-');
end
set(h11, 'PaperpositionMode', 'auto');


h13 = figure('PaperSize',[8.267716 15.692913]);
hist([0.93*leng(:,3)',0.93*leng(:,4)'],100);
set(gca,'fontsize',20);
xlabel('Crystal size (\mum)', 'FontSize', 14);
ylabel('Number of Crystals', 'FontSize', 14);
set(h13, 'Position', [80,100,1000,620]);
set(h13, 'PaperpositionMode', 'auto');

fprintf(strcat(sprintf('For rectangle finding: \nThe two sides crystal size is %d \n', mode([0.93*leng(:,3)',0.93*leng(:,4)'])), char(0181),'m','\n'));

% Construct a questdlg with three options
choice = questdlg('Is the image taken before laser desorption or after laser desorption?', ...
	'Select One', ...
	'Before laser desorption','After laser desorption','Don''t know','Don''t know');
% Handle response
switch choice
    case 'Before laser desorption'
        disp('The image is taken before laser desorption')
    case 'After laser desorption'
        fprintf('The image is taken after laser desorption.\n The following analysis will give the width of scanning area: \n')
%         [H, theta, rho] = hough(BW);
%         peak = houghpeaks(H);
%         barAngle = theta(peak(2));
%         rotI1 = imrotate(gray_image,barAngle-90,'crop');

        h14 = figure;
        iptsetpref('ImshowAxesVisible','on');
        imshow(BW)
        xlabel('Unit in pixel', 'FontSize', 14);
        ylabel('Unit in pixel', 'FontSize', 14);
        d = imdistline(gca,[1 length(sum(BW,1))-300], [min(find(sum(BW(:,1:300),2)==0)) min(find(sum(BW(:,end-300:end),2)==0))]);
        api = iptgetapi(d);
        angle = -api.getAngleFromHorizontal;
        set(h14, 'PaperpositionMode', 'auto');
        rotI1 = imrotate(gray_image,angle,'crop');
        
        h15 = figure('PaperSize',[8.267716 15.692913]);
        iptsetpref('ImshowAxesVisible','on');
        imshow(rotI1,'XData',[0 size(rotI1,2)*0.93],'YData', [0 size(rotI1,1)*0.93])
        xlabel('Unit in \mum', 'FontSize', 14);
        ylabel('Unit in \mum', 'FontSize', 14);
        cbar = colorbar;title(cbar, yname);
        set(h15, 'PaperpositionMode', 'auto');
%         d = imdistline;
        
        h16 = figure('PaperSize',[8.267716 15.692913]);
        plot(0.93*[1:length(sum(rotI1,2))],sum(rotI1,2),'-','linewidth',2);
        set(gca,'fontsize',20);
        xlabel('Unit in \mum', 'FontSize', 14);
        ylabel('Sum of the horizontal pixel', 'FontSize', 14);
        set(h16, 'Position', [80,100,1000,620]);
        set(h16, 'PaperpositionMode', 'auto');
    case 'Don''t know'
        disp('Done')
end
% % Three of the missing yellow chips were found. One yellow chip is still
% % missing.  These yellow ones are hard to find because of they don't
% % _stand out_ as well as others on this background.
% 
% %% Step 10: Lower the Value of 'EdgeThreshold' 
% % There is another parameter in |imfindcircles| which may be useful here,
% % namely 'EdgeThreshold'. To find circles, |imfindcircles| uses only the
% % edge pixels in the image. These edge pixels are essentially pixels with
% % high gradient value. The 'EdgeThreshold' parameter controls how _high_
% % the gradient value at a pixel has to be before it is considered an edge
% % pixel and included in computation. A high value (closer to 1) for this
% % parameter will allow only the strong edges (higher gradient values) to be
% % included, whereas a low value (closer to 0) is more permissive and
% % includes even the weaker edges (lower gradient values) in computation. In
% % case of the missing yellow chip, since the contrast is low, some of the
% % boundary pixels (on the circumference of the chip) are expected to have
% % low gradient values. Therefore, lower the 'EdgeThreshold' parameter to
% % ensure that the most of the edge pixels for the yellow chip are included
% % in computation.
% 
% [centersBright, radiiBright, metricBright] = imfindcircles(gray_image_eq,[10 255], ...
%     'ObjectPolarity','bright','Sensitivity',0.92,'EdgeThreshold',0.1);
% 
% delete(hBright);
% 
% hBright = viscircles(centersBright, radiiBright,'EdgeColor','b');
% 
% %% Step 11: Draw 'Dark' and 'Bright' Circles Together
% % Now |imfindcircles| finds all of the yellow ones, and a green one too.
% % Draw these chips in blue, together with the other chips that were found
% % earlier (with 'ObjectPolarity' set to 'dark'), in red.
% 
% h = viscircles(centers,radii);
% 
% %%
% % All the circles are detected. A final word - it should be noted that
% % changing the parameters to be more aggressive in detection may find more
% % circles, but it also increases the likelihood of detecting false circles.
% % There is a trade-off between the number of true circles that can be found
% % (detection rate) and the number of false circles that are found with them
% % (false alarm rate).
% % 
% % Happy circle hunting!
% 
% % displayEndOfDemoMessage(mfilename)