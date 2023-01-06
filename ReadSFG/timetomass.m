function m = timetomass(t, time_calibrate, mass_calibrate, time_calibrate2, mass_calibrate2)

delay_trigger = (time_calibrate - time_calibrate2*sqrt(mass_calibrate/mass_calibrate2))/(1 - sqrt(mass_calibrate/mass_calibrate2));
m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;