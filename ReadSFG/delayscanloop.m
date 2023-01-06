function [namex, namey] = delayscanloop(loopa,loopst,loople, t_fit,dtn,vt1_165,vt2_165)
%laserin is to calculate the peak intensity of the fs laser. pein is the
%peak intensity of laser with unit of W/cm2;
%fwhm is full width half maximum of the pulse duration with unit of fs; powe is the power of the laser with unit of mW; 
%focusdi is the foucus diameter of the spot size with unit of um; 

% pein = powe*1e12/(fwhm*pi*(0.5*focusdi*1e-4).^2);
for i = loopa:loopst:loople
    %[namex((i-loopa)/loopst+1,:), namey((i-loopa)/loopst+1,:)] = delayscanderive(i,t_fit,dtn,dire,vt1_165,vt2_165);
    [namex((i-loopa)/loopst+1,:), namey((i-loopa)/loopst+1,:)] = delayscanvelderive(i,t_fit,dtn,vt1_165,vt2_165);
end