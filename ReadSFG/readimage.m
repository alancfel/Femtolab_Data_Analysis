function [dat] = readimage(pathinput)
% clc;clear variables; close all;
% if pathinput = 1, use the defined pathname
%otherwise, select the folder path
if pathinput == 1
    pathname = 'N:\4all\mpsd_ad_exp\EDiff\New Gas Machine\Data\2018\2018_11_01\Data\Run C\';
else
    pathname = uigetdir;
end
for i=615:630
    filename = sprintf('C_01.11.2018_Frames=10_Gold_H18.48_V12.55_%dmA_TR_NonDiff_0fs_17_11.bin',i);
    file = fullfile(pathname,filename);
    dat(:,:,i-614) = ReadspeAndorIndividual(file);
    fprintf('Read %d mA file\n',i);
end
end