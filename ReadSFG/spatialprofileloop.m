function [namex] = spatialprofileloop(t_fit,dtn,data)
%laserin is to calculate the peak intensity of the fs laser. pein is the
%peak intensity of laser with unit of W/cm2;
%fwhm is full width half maximum of the pulse duration with unit of fs; powe is the power of the laser with unit of mW; 
%focusdi is the foucus diameter of the spot size with unit of um; 

% pein = powe*1e12/(fwhm*pi*(0.5*focusdi*1e-4).^2);
a = size(data);
for i = 1:(length(t_fit)-1)/10
    for j = 1:a(1)
        datasum = sum(data(:,(i*10-9):(10*i)),2);
        namex(:,j,i) = dtn*datasum(j)/max(dtn);
%     [namex((i-loopa)/loopst+1,:), namey((i-loopa)/loopst+1,:)] = delayscanderive(i,t_fit,dtn,dire,vt1_165,vt2_165);
    end
end