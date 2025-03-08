%% Calculate the fresnel factor from refractive index by Zhipeng Huang
%%
function [Lxx,Lyy,Lzz] = calculateLxyz(n2,n11,wsfg)
Lxx = 2*1*cos(asin(1*sin(wsfg*pi/180)./n2))./(1*cos(asin(1*sin(wsfg*pi/180)./n2))+n2*cos(wsfg*pi/180));
Lyy = 2*1*cos(wsfg*pi/180)./(1*cos(wsfg*pi/180)+n2.*cos(asin(1*sin(wsfg*pi/180)./n2)));
Lzz = (2*n2*cos(wsfg*pi/180)./(1*cos(asin(1*sin(wsfg*pi/180)./n2))+n2.*cos(wsfg*pi/180))).*(1./n11).^2;