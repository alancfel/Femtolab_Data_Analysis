# Femtolab_Data_Analysis 
&copy; 2015-2024 Zhipeng Huang

## App Documentation

The **Femtolab_Data_Analysis** app is developed by [Dr. Zhipeng Huang](https://zhipeng-huang.netlify.app/). It is a MATLAB based grapic user interface (GUI) for quickly analysing and visualizing the sum-frequency generation (SFG) spectroscopy data and time-of-flight (TOF) mass spectroscopy data.

The [**application documentation for the `main` branch**](https://github.com/alancfel/Femtolab_Data_Analysis) is automatically published on this project's *GitHub Page*. 


## Dependencies

The application is tested with both mac and windows version of MATLAB.

It needs to have MATLAB [curve fitting toolbox](https://www.mathworks.com/products/curvefitting.html) installed. 

## Set Up

Follow these steps to set up `Femtolab_Data_Analysis`:

1. Install [MATLAB](https://www.mathworks.com/products/matlab.html).

2. Clone or download the `main` branch to your local computer folder.

3. Add the `Femtolab_Data_Analysis/ReadSFG` folder and its subfolders to the MATLAB search path. Run `MATLAB` and type `pathtool` in the command window. There will be a window pop up for adding folders to the MATLAB search path.


## Run the application

1. Type `cmidaq_iteration` in the MATLAB command window. The `Femtolab_Data_Analysis` app will be poped up.

2. Select the `menu File -> Open SFG data` to choose the SFG data to be opened. It can open the .spe file(s) collected by the [lightfield softeware](https://www.teledynevisionsolutions.com/en-hk/categories/software/vision-application-software/) for controlling the Princeton Instrument cameras and spectrographs. It can also open the .csv, .h5, .txt types of files.

3. When collecting the SFG spectrum, the background spectrum (collected by blocking the infrared beam path) can be either collected seperately or subtracted directly during the data collection. Therefore, there is a sub-window poping up to provide the option `Would you like to substract the background and normalize the spectrum?` after clicking the `menu File -> Open SFG data`. If the background spectrum is collected seperately, you can choose `Subtract background only` to subtract the background. If the background has been subtracted during the data collection, you then choose `No`. 

4. The `Subtract and normalize` option is used for subtracting the background and normalize the spectrum with a referece sample specta (e.g. gold, quartz, etc.). The output result will be $I_{output}=\frac{I_{sam}-I_{sambkg}}{I_{ref}-I_{refbkg}}$, where $I_{sam},I_{sambkg},I_{ref},I_{refbkg}$ are the sample SFG signal, sample SFG bakground signal, referece SFG signal, referece SFG background signal.

5. Once the spectrum is loaded, change the `X label options` located in the bottom left panel to `SFG Wavelength`. Click the `Axis auto` button located in the right middle panel to display the spectrum in the axis auto mode. It can be switched to the `Maual axis mode` by clicking the `Axis auto` button and type the axis range in the texbook neaby the sides of the x and y axis.

6. The `X label options` provides several options to switch the x axis. The `SFG Wavelength` is to display the x axis in SFG wavelength mode. The `SFG Photon Energy` is to display the x axis in SFG Photon Energy mode. The `IR Wavelength` is to display the x axis in IR wavelength mode. The `IR Wavenumber` is to display the x axis in IR wavenumber mode. When swithing to the `IR Wavelength` or `IR wavenumber` mode, a subwindow will be poped up for typing the `Enter up conversion center wavelength (nm)`. For our case we use the narrowband 800 nm as the up-conversion beam. The accurate value is measured by a spectrometer. The conversion between the different x axis mode is given by $X_{SFG Photon Energy} (eV)= \frac{1240}{X_{SFG Wavelength}(nm)}$; $X_{IR Wavelength} (nm)= \frac{1240}{\frac{1240}{X_{SFG Wavelength}(nm)}-\frac{1240}{X_{SFG Wavelength}(nm)}}$;$X_{IR Wavenumber} (cm^{-1}) = \frac{10^7}{X_{IR Wavelength} (nm)}$.

7. By clicking the `Copy Plot`, the displayed the SFG specrtrum will be poped up and can be copied and saved to other format.

8. Select the `menu File -> Save rawdata workspace`, the displayed the SFG spectrum is saved to the MATLAB workspace for further analysis. 












 