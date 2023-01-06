IMG = gold;%2019-11-07 Run MagLenCurrent
% IMG = Diffraction_Image_Data;fastsplitting
%%
figure();
imagesc(IMG); axis equal; axis tight;

%%
[ny,nx] = size(IMG);

cen0.x = 391;%2019-11-07 Run MagLenCurrent 516;%fastsplitting 488;%571;%cx(34);%551;%466;
cen0.y = 393;%2019-11-07 Run MagLenCurrent 463;%fastsplitting 495;%550;%cy(34);%581;%446;
imgCrop.x = (1:nx);
imgCrop.y = (1:ny);
IMG_crpd = medfilt2(IMG(imgCrop.y,imgCrop.x),[3,3]);
figure();
imagesc(IMG_crpd, [0, 0.5*max(max(IMG_crpd))]);
axis equal; axis tight;

%%

BeamBlock2 = findBeamBlock(IMG_crpd, cen0,[9,9]);
RoundMask = fRoundMask(IMG_crpd, cen0, 450);
CenterMask = ~fRoundMask(IMG_crpd, cen0, 20);
BeamBlock2 = BeamBlock2 | RoundMask | CenterMask;
% BeamBlock2 =  RoundMask | CenterMask;
figure();
imagesc(BeamBlock2); axis equal; axis tight;

%---------------------------
%% Anatase TiO2 - Static
% location = 'N:\4all\mpsd_ad_exp\EDiff\New Gas Machine\Useful Files\Useful worksheets\GED_Analysis\cmidaqreader\Xinxin_GUI_Andor_Friedjof\Anatase_CrystalStructure';
% fname = '5000223 Reflexion List Alignment 0p4 strain0p6.txt';
% location = 'N:\4all\mpsd_ad_exp\EDiff\New Gas Machine\Useful Files\Useful worksheets\GED_Analysis\cmidaqreader\ged_diffindex';
% fname = 'COD_5000223_Horn1972 Reflexion List edited.txt';
% TiO2_table = readtable([location,'\',fname]);
% TiO2.radii = 2*pi./TiO2_table.d_hkl_;
% TiO2.intensities = TiO2_table.Intensity;

% 
% %% Gold diffraction
Au.radii =    [2.668,   3.081,  4.358,   5.110,  5.337, 6.163, 6.716,   6.890,  7.548,  8.005,  8.715,  9.115,  9.244,  9.744, 10.103, 10.220, 10.674, 11.002, 11.110, 11.529, 11.834]; % 2*pi/d (A-1)
intensXrayAu = [665.51, 343.054, 260.97, 323.284, 94.147, 44.6, 134.271, 123.171, 90.098, 73.215, 26.898, 91.012, 43.141, 35.218, 30.542, 29.173, 8.155, 21.594, 20.739, 35.495, 31.760];
intensElecAu = [1037.313, 530.128, 389.958, 471.601, 136.284, 62.708, 185.142, 168.825, 120.955, 97.144, 35.315];
Au.intensities = intensXrayAu; % I couldn't get as many points from the electron diffraction and the difference is mostly just scaling, so I used the x-ray data
% 
% %% Bismuth
% Bi.radii =   [1.596, 1.686, 1.921, 2.662, 2.771, 3.103, 3.191, 3.198, 3.372, 3.842, 4.052, 4.160, 4.226, 4.364, 4.546, 4.737, 4.799, 4.909, 4.999]; % 2*pi/d (A-1)
% intensXray = [];
% intensElec = [4.4,   1.4,   100,   41.6,  44.4,   7.6,   6.9,   5.4,   25.2,  15.3,   6.5,   3.3,  18.6,  23.9,   5.3,  16.5,   9.3,   3.6, 3.8];
% Bi.intensities = intensElec; 

% CalibrationSample = TiO2;
CalibrationSample = Au;

% Simulated diffraction parameters
experiment.wavel = 1e10*voltage2wavelength(1e5);
experiment.nx = nx;
experiment.ny = ny;
binning = 1;%2;
experiment.pixelSize = 20e-6;%binning*24e-6;%20e-6;%
experiment.pixelAspect = 1.0; % ratio of x:y
experiment.distanceDet = 0.48;%0.53; %0.48;% in meters
experiment.xCenBeam = cen0.x;
experiment.yCenBeam = cen0.y;
experiment.xCenLens = cen0.x-24; 
experiment.yCenLens = cen0.y-21; 
experiment.radialDist = [3.1890 -0.4580 1.5400];%[2.5 0 0];%[3,-0.1,1];% [1.8,0,0];
experiment.lensAstigmatism = 0.9820;%0.953;%1; % 1 = no distortion
experiment.thetaLensAstig = 2.9212;%0.0205;%0.15;%0.2;
experiment.intensityScale = 1.9368;%max(max(IMG_crpd))/max(CalibrationSample.intensities);
experiment.peakWidth =  3.4677;%5.5627;%6/binning; %8/binning; % =1*sigma in units of pixels
experiment.radialBackground = [2.4632e+03 -2.2866];%[8.7903e+03 -0.4726];%[1e4,-5]; %Exponentially degacing BG. Parameters are: [scaling, decay in s-units]
experiment.flatBackground = 2.1569e+03;% Parameter values for fitting function
p0 = expStruc2params(experiment);
nPar = length(p0);
pLB(1:nPar) = -inf;
pUB(1:nPar) = inf;

% Lower and upper bounds for the lens centre
cenErr = 100;
pLB([3,4]) = [experiment.xCenLens-cenErr, experiment.yCenLens-cenErr];
pUB([3,4]) = [experiment.xCenLens+cenErr, experiment.yCenLens+cenErr];
pLB(11) = 1;
pUB(11) = 8;
%%
% experiment = fittedExperimentParameters;

% View initial guess
MASK = 1-BeamBlock2;
IMGsim = MASK.*(calculatePowderDiffraction(experiment,CalibrationSample));
figure();
subplot(1,3,1); imagesc(MASK.*IMG_crpd); axis equal; axis tight; title('data');
subplot(1,3,2); imagesc(IMGsim); axis equal; axis tight; title('simulation guess params');
subplot(1,3,3); imagesc(MASK.*IMG_crpd-IMGsim); axis equal; axis tight; title('difference'); colormap('gray');
%%
% Define function for fitting
function2minimize = @(X) MASK.*(IMG_crpd-calculatePowderDiffraction(paramList2expStruc(X,experiment),CalibrationSample));

% Perform non-linear LS fit
options = optimset('Display','iter','MaxFunEvals',1000);
parFit = lsqnonlin(@(parFit)function2minimize(parFit), p0, pLB, pUB, options);
fittedExperimentParameters = paramList2expStruc(parFit,experiment);

%%
% View results
display(fittedExperimentParameters);
[IMG_sim_fit, SmatDet] = calculatePowderDiffraction(fittedExperimentParameters,CalibrationSample);
IMG_diff = MASK.*(IMG_crpd - IMG_sim_fit);
figure();
subplot(1,3,1); imagesc(MASK.*IMG_crpd); axis equal; axis tight; title('data');
subplot(1,3,2); imagesc(MASK.*IMG_sim_fit); axis equal; axis tight; title('simulation');
subplot(1,3,3); imagesc(IMG_diff); axis equal; axis tight; title('difference'); colormap('gray');

%%
%-------------------------------------------------------------
%           Process time-resolved data
%-------------------------------------------------------------
% dirScan = 'N:\4all\mpsd_ad_exp\EDiff\Cyclotron Lab\TiO2\2014-09-10_TiO2\TiO2_30mW_1kHz_120kV_LAS_920mA_y9.2_z35.4_scan2_from1.54ns_500fs_step';

% Process scan - Radial average
dsPixel = fittedExperimentParameters.radialDist(1)*2*pi*fittedExperimentParameters.pixelSize/(fittedExperimentParameters.distanceDet*fittedExperimentParameters.wavel);
sPeakWidth = fittedExperimentParameters.peakWidth*dsPixel;

% Choose integration size
% ds = sPeakWidth;
ds = dsPixel;

sMin = 1.1;
sMax = 10;
sVec = sMin:ds:sMax;
nROI = length(sVec);
ROIs_3d = zeros(ny,nx,nROI);

for indx = 1:nROI
    sminring = sVec(indx) - 0.5*ds;
    smaxring = sVec(indx) + 0.5*ds;
    ROIs_3d(:,:,indx) = MASK.*((SmatDet >= sminring) & (SmatDet <= smaxring));
end
figure(); imagesc(sum(ROIs_3d,3)); axis equal; axis tight;
assignin('base',sprintf('ImgCrop'),imgCrop);
assignin('base',sprintf('RoIs_3d'),ROIs_3d);
%%
% scan = process_data_TimeResolvedImages(t,Difference,imgCrop,ROIs_3d);
scan = process_data_TimeResolvedImages(1,probe(:,:,1),imgCrop,ROIs_3d);
%%

figure(); plot(sVec ,scan.dI_ROIs,'linewidth',2); 
xlabel(sprintf('Scattering vector (%s^{-1})', char(197))); ylabel('Intensity (arb. unit)');