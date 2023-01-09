%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       read HDF5 files       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [c_num,delay_num,spectra_singlecycle,...
    spectra_meancycles,spectra_singlecycle_sum,WL] ...
    = read_HDF5_IR_wavelength_delay_scan(filename,inte_region)

% extract all raw data, 5 dimensions
% 1st dim: rotation or topas(generally 1)
% 2nd dim: cycles;
% 3rd dim: topas or rotation (generally 1)
% 4th dim: frames;
% 5th dim: spectra

rawdata_all = double(h5read(filename,'/Data/Camera/Image ROI1'));

c_num = size(rawdata_all,2);
delay_num = size(rawdata_all,4);

%%%%%%%% mean spectra of all cycles %%%%%%%%
spectra_meancycles_all = ...
    squeeze(mean(squeeze(rawdata_all(:,:,1,:,:)),1));
spectra_meancycles = squeeze(mean(spectra_meancycles_all,1));

%%%%%%%% spectra of all single cycles %%%%%%%%

spectra_singlecycle = squeeze(rawdata_all(1,:,1,:,:));
spectra_singlecycle_sum = sum(spectra_singlecycle(:,:,inte_region),3);

WL = (h5read(filename,'/Data/Spectrograph/Module Data/ROIs Wavelengths'));

end