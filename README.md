# Femtolab_Data_Analysis

## App Documentation

The **Femtolab_Data_Analysis** app is developed by [Dr. Zhipeng Huang](https://zhipeng-huang.netlify.app/). It is a MATLAB based grapic user interface (GUI) for quickly analysing and visualizing the sum-frequency generation (SFG) spectroscopy data and time-of-flight (TOF) mass spectroscopy data.

The [**application documentation for the `main` branch**](https://github.com/alancfel/Femtolab_Data_Analysis) is automatically published on this project's *GitHub Page*. 


## Dependencies

The application is tested with both mac and windows version of MATLAB.

It needs to have MATLAB [curve fitting toolbox](https://www.mathworks.com/products/curvefitting.html) to be installed. 

## Set Up

Follow these steps to set up `Femtolab_Data_Analysis`:

1. Install [MATLAB](https://www.mathworks.com/products/matlab.html).

2. Clone or download the `main` branch to your local computer folder.

3. Add the `Femtolab_Data_Analysis/ReadSFG` folder and its subfolders to the MATLAB search path. Run `MATLAB` and type `pathtool` in the command window. There will be a window pop up for adding folders to the MATLAB search path.


## Run the application

1. Type `cmidaq_iteration` in the MATLAB command window. The `Femtolab_Data_Analysis` app will be poped up.

2. Select the `menu File -> Open SFG data` to choose the SFG data to be opened. It can open the .spe file collected by the [lightfield softeware](https://www.teledynevisionsolutions.com/en-hk/categories/software/vision-application-software/) for controlling the Princeton Instrument cameras and spectrographs. It can also open the .csv, .h5, .txt types of files.

3. When collecting the SFG spectrum, the background spectrum can be either collected seperately or subtracted directly during the data collection. Therefore, there is a sub-window poping up to provide the option `Would you like to substract the background and normalize the spectrum?` after clicking the `menu File -> Open SFG data`. If the background spectrum is collected seperately, you can choose `Subtract background only` to subtract the background. If the background has been subtracted during the data collection, you can choose `No`. 








 