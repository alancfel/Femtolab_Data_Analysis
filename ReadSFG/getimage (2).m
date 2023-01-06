%Read the diffraction binary files; plot the diffraction pattern; Find the
%center; plot sice profile of diffraction pattern; 
% function [current_dataA, current_dataB, current_dataC, current_dataD, attA] = getimage(filename, file, dot, iter)
% [filenameall, pathname] = uigetfile({'*.bin';'*.h5';'*.mat';'*.hdf5'}, 'Open Data','MultiSelect','on');
% if ~isempty(filenameall)
%         filename = filenameall;
%         file = fullfile(pathname, filename);
%         dotall = regexp(filename,'\.');
%         dot = max(dotall);
%         dat = ReadspeAndorIndividual(file);
% %         channeldata = load(file);
% end
clc;clear variables; close all;
pathname = 'N:\4all\mpsd_ad_exp\EDiff\New Gas Machine\Data\2018\2018_11_01\Data\Run C\';
for i=615:630
    filename = sprintf('C_01.11.2018_Frames=10_Gold_H18.48_V12.55_%dmA_TR_NonDiff_0fs_17_11.bin',i);
    file = fullfile(pathname,filename);
    dat(:,:,i-614) = ReadspeAndorIndividual(file);
    [centersBright(i-614,:), radiiBright(i-614,:)] = imfindcircles(dat(:,:,i-614),[100, 5000],'ObjectPolarity', 'bright');
    figure(i-614);
    iptsetpref('ImshowAxesVisible','on');
    imshow(dat(:,:,i-614),[100 15000]);%,'XData',[0 size(BW,2)*0.93],'YData', [0 size(BW,1)*0.93])
    hBright = viscircles(centersBright(i-614,:), radiiBright(i-614,:),'EdgeColor','b');
    xlabel('Unit in pixel', 'FontSize', 14);
    ylabel('Unit in pixel', 'FontSize', 14);
    title(sprintf('%d mA',i),'Fontsize',20);
% x = 1:length(dat(:,round(centersBright(i-614,1)),i-614));
%     [fitresultleft, gofleft] = Gauss8(x(1:length(x)/2), dat(1:length(x)/2,round(centersBright(i-614,1)),i-614));
%     [fitresultright, gofright] = Gauss8(x((length(x)/2+1):end), dat(((length(x)/2+1):end),round(centersBright(i-614,1)),i-614));
    x = 1:length(dat(580,:,i-614));
%     [fitresult, gof] = Gauss8(x, dat(580,:,i-614));
    figure;findpeaks(dat(580,:,i-614),x, 'MinPeakDistance',100);
    [pks(1,:),locs(1,:),w,p] = findpeaks(dat(580,:,i-614),x, 'MinPeakDistance',100);
%     [fitresultleft, gofleft] = Gauss8(x(1:length(x)/2), dat(580,1:length(x)/2,i-614));
%     [fitresultright, gofright] = Gauss8(x((length(x)/2+1):end), dat(580,((length(x)/2+1):end),i-614));
%     bl(i-164,1) = fitresultleft.b1;
%     bl(i-164,2) = fitresultleft.b2;
%     bl(i-164,3) = fitresultleft.b3;
%     bl(i-164,4) = fitresultleft.b4;
%     bl(i-164,5) = fitresultleft.b5;
%     bl(i-164,6) = fitresultleft.b6;
%     bl(i-164,7) = fitresultleft.b7;
%     bl(i-164,8) = fitresultleft.b8;
%     cl(i-164,1) = fitresultleft.c1;
%     cl(i-164,2) = fitresultleft.c2;
%     cl(i-164,3) = fitresultleft.c3;
%     cl(i-164,4) = fitresultleft.c4;
%     cl(i-164,5) = fitresultleft.c5;
%     cl(i-164,6) = fitresultleft.c6;
%     cl(i-164,7) = fitresultleft.c7;
%     cl(i-164,8) = fitresultleft.c8;
%     br(i-164,1) = fitresultright.b1;
%     br(i-164,2) = fitresultright.b2;
%     br(i-164,3) = fitresultright.b3;
%     br(i-164,4) = fitresultright.b4;
%     br(i-164,5) = fitresultright.b5;
%     br(i-164,6) = fitresultright.b6;
%     br(i-164,7) = fitresultright.b7;
%     br(i-164,8) = fitresultright.b8;
%     cr(i-164,1) = fitresultright.c1;
%     cr(i-164,2) = fitresultright.c2;
%     cr(i-164,3) = fitresultright.c3;
%     cr(i-164,4) = fitresultright.c4;
%     cr(i-164,5) = fitresultright.c5;
%     cr(i-164,6) = fitresultright.c6;
%     cr(i-164,7) = fitresultright.c7;
%     cr(i-164,8) = fitresultright.c8;
end