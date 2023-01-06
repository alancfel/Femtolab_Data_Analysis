function pein = plumedensity(fwhm, nofion, focusdi)
%plumedensity is to calculate the plumedensity of LIAD. pein is the
%plumedensity with unit of cm-3;
%fwhm is full width half maximum of the plume with unit of mm; nofion is the ion yields after each laser shot; 
%focusdi is the foucus diameter of the spot size with unit of um; 

pein = nofion/(2*fwhm*0.1*pi*(0.5*focusdi*1e-4).^2);