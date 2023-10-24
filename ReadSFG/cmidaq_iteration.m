function varargout = cmidaq_iteration(varargin)
% WAVEFORM AVERAGING MATLAB code for multirecord.fig
%      MULTIRECORD, by itself, creates a new MULTIRECORD or raises the existing
%      singleton*.
%
%      H = MULTIRECORD returns the handle to a new MULTIRECORD or the handle to
%      the existing singleton*.
%
%      MULTIRECORD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIRECORD.M with the given input arguments.
%
%      MULTIRECORD('Property','Value',...) creates a new MULTIRECORD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multirecord_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      pause.  All inputs are passed to multirecord_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multirecord

% Last Modified by GUIDE v2.5 14-Jul-2023 18:27:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @cmidaq_iteration_OpeningFcn, ...
    'gui_OutputFcn',  @cmidaq_iteration_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before multirecord is made visible.
function cmidaq_iteration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multirecord (see VARARGIN)
% Choose default command line output for multirecord
clc;
% diary('example')
% diary on;
%COMMANDS YOU WANT TO BE SHOWN IN THE COMMAND WINDOW
%disp(array);
% pretty(function);
% mex_ADQ ;
% &THEN
% diary off;
% output=fileread('example');
%FINALLY
% jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% jCmdWin = jDesktop.getClient('Command Window');
% jTextArea = jCmdWin.getComponent(0).getViewport.getView;
% cwText = char(jTextArea.getText);
%FINALLY
% set(handles.textStatus,'string',cwText,'FontSize',20);
% set(handles.textStatus,'string',output,'FontSize',20);
% delete('example');%OPTIONAL
folder = fileparts(which('multirecord'));
baseFileName = 'CMI group logo.png';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);

% Check for existence. Warn user if not found.
if ~exist(fullFileName, 'file')
    % Didn't find it there. Check the search path for it.
    fullFileName = baseFileName; % No path this time.
    if ~exist(fullFileName, 'file')
        % Still didn't find it. Alert user.
        axes(handles.logo);
        axis off;
        errorMessage = sprintf('Error: %s does not exist.', fullFileName);
        uiwait(warndlg(errorMessage));
    end
else
    % Read it in from disk.
    axes(handles.logo);
    axis off;
    rgbImage = imread(fullFileName,'BackgroundColor',get(handles.logo,'Color'));
    
    % Display the original color image.
    %     axes(handles.logo);
    %     axis off;
    %     [data, map]=imread(fullFileName);
    %     logo=ind2rgb(data,map);
    %     image(logo);
    imshow(rgbImage, []);
    %title('Reza Logo Image', 'FontSize', 20);
end
define_command_codes;
global manual
global isDown;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global nofwaveforms;
global recordsize;
global nofrecords;
global nofpretrig;
global nofholdoff;
global nofrepes;
global nofcycle;
global selected_trigger;
global LvlTrigLevelTwosComp;
global LvlTrigCh;
global LvlTrigEdge;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global time_calibrate2;
global mass_calibrate2;
global h;
global sliderVal;
global dimension;
global channel_show;
global step; % It is a vector showing the scanning step
global machename;
global coincidence;
global bandwith;
global saveps;
global figurename;
global slider;
global xaxis;
global pgate;
global filenumber;
selected_trigger = 1;
LvlTrigLevelTwosComp = 2000; %-8192 - 8191
LvlTrigEdge = RISING_EDGE; %RISING_EDGE or FALLING_EDGE
LvlTrigCh = CH_A;
nofwaveforms = 1000;
nofrecords = 100;
recordsize = 20480;
nofpretrig = 0;
nofholdoff = 0;
nofrepes = 1;
nofcycle = 1;
isChannelA = 1;
isChannelB = 1;
isChannelC = 1;
isChannelD = 1;
xlabelmod = 1;
ylabelmod = 1;
delay_trigger = 0;
mass_calibrate = 18;
time_calibrate = 5;
mass_calibrate2 = 30;
time_calibrate2 = 6;
sliderVal = 1;
dimension = 1;
channel_show = 4;
coincidence = 0;
bandwith = 1000;
saveps = 0;
figurename = 'file';
xaxis = 0;
pgate = 0;
step = 1:nofrecords;
machename = 'None';
slider = nofrecords;
filenumber = 1;
handles.current_dataA = zeros(nofrecords,recordsize);
handles.current_dataB = zeros(nofrecords,recordsize);
handles.current_dataC = zeros(nofrecords,recordsize);
handles.current_dataD = zeros(nofrecords,recordsize);
set(handles.ChannelA, 'Value', isChannelA);
set(handles.ChannelB, 'Value', isChannelB);
set(handles.ChannelC, 'Value', isChannelC);
set(handles.ChannelD, 'Value', isChannelD);
% wfa_configure;
isDown = 0;
manual = 0;
axes(handles.axes1);
t=0:1/(bandwith):(recordsize-1)/(bandwith);
m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
n = 1:recordsize;
switch xlabelmod
    case 1
        x = t;
        xname = 'Time (\mus)';
    case 2
        x = n;
        xname = 'Record Number';
    case 3
        x = m;
        xname = 'm/q (Da)';
end
switch ylabelmod
    case 1
        yname = 'Intensity (arb. units)';
    case 2
        yname = 'Voltage (mV)';
end
axes(handles.axes1);
if isChannelA == 1;
    legA = 'on';
else
    legA = 'off';
end
if ylabelmod == 1;
    h(1) = plot(handles.axes1,x,handles.current_dataA(1,:),'r','DisplayName','ChannelA','visible',legA);
else
    h(1) = plot(handles.axes1,x,handles.current_dataA(1,:)/3.3659,'r','DisplayName','ChannelA','visible',legA);
end
%legend('-DynamicLegend');
hold all;
if isChannelB == 1;
    legB = 'on';
else
    legB = 'off';
end
if ylabelmod == 1;
    h(2) = plot(handles.axes1,x,handles.current_dataB(1,:),'g','DisplayName','ChannelB','visible',legB);
else
    h(2) = plot(handles.axes1,x,handles.current_dataB(1,:)/3.3659,'g','DisplayName','ChannelB','visible',legB);
end
if isChannelC == 1;
    legC = 'on';
else
    legC = 'off';
end
if ylabelmod ==1;
    h(3) = plot(handles.axes1,x,handles.current_dataC(1,:),'b','DisplayName','ChannelC','visible',legC);
else
    h(3) = plot(handles.axes1,x,handles.current_dataC(1,:)/3.3659,'b','DisplayName','ChannelC','visible',legC);
end
if isChannelD == 1;
    legD = 'on';
else
    legD = 'off';
end
if ylabelmod ==1;
    h(4) = plot(handles.axes1,x,handles.current_dataD(1,:),'m','DisplayName','ChannelD','visible',legD);
else
    h(4) = plot(handles.axes1,x,handles.current_dataD(1,:)/3.3659,'m','DisplayName','ChannelD','visible',legD);
end
%plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
%legend('channelB','channelD');
%     refresh_legend;
hold off;
ymin = get(handles.ymin,'String');
ymax = get(handles.ymax,'String');
ylim([str2double(ymin), str2double(ymax)]);
xmin = get(handles.xmin,'String');
xmax = get(handles.xmax,'String');
xlim([str2double(xmin), str2double(xmax)]);
xlabel(xname)%,'FontSize',20)
ylabel(yname)%,'FontSize',20)
grid on;
refresh_legend;
% ylim('manual');
handles.output = hObject;
% wfa_configure;
%wfa_measurement;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multirecord wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cmidaq_iteration_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%wfa_configure;
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Setup.
function Setup_Callback(hObject, eventdata, handles)
% hObject    handle to Setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display surf plot of the currently selected data.
% surf(handles.current_data);

%wfa_configure;
%set(handles.textStatus, 'String', 'Parameters are setting, Please wait...');
wfa_settings;
set(handles.textStatus, 'String', 'Please type the setting parameters, then click enter button')
guidata(hObject, handles);

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display mesh plot of the currently selected data.
set(handles.textStatus, 'String', 'Triggering')
global isDown;
% axes(handles.axes1);
wfa_measurement;
set(handles.textStatus, 'String', sprintf('\nStep number = %d\nRepetition number = %d\nCompleted',scan,repetition))
guidata(hObject, handles);


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data.
%contour(handles.current_data);
BoardID = 1;
% interface_ADQ('waveformaveragingdisarm',[],BoardID);
set(handles.textStatus, 'String', 'Multirecord was closed')
% close(multirecord);
delete(handles.figure1);



% --- Executes during object creation, after setting all properties.
function textStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recordsize;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global sliderVal;
global nofrepes;
global dimension;
global nofrecords;
global nofcycle;
global machename;
global step;
global channel_show;
global coincidence;
global bandwith;
global slider;
% global enter_flag;
string_list{1} = 'Channel A';
string_list{2} = 'Channel B';
string_list{3} = 'Channel C';
string_list{4} = 'Channel D';
% enter_flag = 0;
axes(handles.axes1);
switch dimension
    case 1
        [slider,recordsize] = size(handles.current_dataD);
        % slider = min([m, record]);
        if slider > 1;
            set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
            sliderVal    = round(get(hObject,'Value'));
            %show_CreateFcn(hObject, eventdata, handles);
            %sliderStatus = ['View azimuth: ' num2str(sliderVal)];
            %set(handles.textStatus, 'string', sliderStatus)
            %handles.current_data1(sliderVal,:) = adq_data.DataB;
            %global recordsize;
            if (sliderVal > slider)
                set(hObject,'Value',1)
                sliderVal    = 1;
            else if (sliderVal < 1)
                    set(hObject,'Value',slider)
                    sliderVal    = slider;
                end
            end
        end
        t = 0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';                
        end
        switch ylabelmod
            case 1
                yname = 'Intensity (arb. units)';
            case 2
                yname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d\nRepetition number = %d',(floor((sliderVal-1)/nofrepes)+1),rem((sliderVal-1),nofrepes)+1));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        if ylabelmod == 1;
            h(1) = plot(x,handles.current_dataA(sliderVal,:),'r','DisplayName','ChannelA','visible',legA);
        else
            h(1) = plot(x,handles.current_dataA(sliderVal,:)/3.3659,'r','DisplayName','ChannelA','visible',legA);
        end
        %    legend('-DynamicLegend');
        hold all;
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        if ylabelmod == 1
            h(2) = plot(x,handles.current_dataB(sliderVal,:),'g','DisplayName','ChannelB','visible',legB);
        else
            h(2) = plot(x,handles.current_dataB(sliderVal,:)/3.3659,'g','DisplayName','ChannelB','visible',legB);
        end
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        if ylabelmod == 1
            h(3) = plot(x,handles.current_dataC(sliderVal,:),'b','DisplayName','ChannelC','visible',legC);
        else
            h(3) = plot(x,handles.current_dataC(sliderVal,:)/3.3659,'b','DisplayName','ChannelC','visible',legC);
        end
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        if ylabelmod == 1
            h(4) = plot(x,handles.current_dataD(sliderVal,:),'m','DisplayName','ChannelD','visible',legD);
        else
            h(4) = plot(x,handles.current_dataD(sliderVal,:)/3.3659,'m','DisplayName','ChannelD','visible',legD);
        end
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        %refresh_legend;
        hold off;
        if coincidence == 0
            ymin = get(handles.ymin,'String');
            ymax = get(handles.ymax,'String');
            ylim([str2double(ymin), str2double(ymax)]);
        else
            axis tight;
        end
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
        grid on;
%         refresh_legend;
    case 2
        slider = nofrecords;
        [~,recordsize] = size(handles.current_dataA);
        if slider > 1;
            set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
            sliderVal    = round(get(hObject,'Value'));
            %show_CreateFcn(hObject, eventdata, handles);
            %sliderStatus = ['View azimuth: ' num2str(sliderVal)];
            %set(handles.textStatus, 'string', sliderStatus)
            %handles.current_data1(sliderVal,:) = adq_data.DataB;
            %global recordsize;
            if (sliderVal > slider)
                set(hObject,'Value',1)
                sliderVal    = 1;
            else if (sliderVal < 1)
                    set(hObject,'Value',slider)
                    sliderVal    = slider;
                end
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';             
        end
        switch ylabelmod
            case 1
                yname = 'Intensity (arb. units)';
            case 2
                yname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        if ylabelmod == 1;
            h(1) = plot(x,mean(handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1),'r','DisplayName','ChannelA','visible',legA);
        else
            h(1) = plot(x,mean(handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1)/3.3659,'r','DisplayName','ChannelA','visible',legA);
        end
        %    legend('-DynamicLegend');
        hold all;
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        if ylabelmod == 1
            h(2) = plot(x,mean(handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1),'g','DisplayName','ChannelB','visible',legB);
        else
            h(2) = plot(x,mean(handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1)/3.3659,'g','DisplayName','ChannelB','visible',legB);
        end
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        if ylabelmod == 1
            h(3) = plot(x,mean(handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1),'b','DisplayName','ChannelC','visible',legC);
        else
            h(3) = plot(x,mean(handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1)/3.3659,'b','DisplayName','ChannelC','visible',legC);
        end
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        if ylabelmod == 1
            h(4) = plot(x,mean(handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1),'m','DisplayName','ChannelD','visible',legD);
        else
            h(4) = plot(x,mean(handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:),1)/3.3659,'m','DisplayName','ChannelD','visible',legD);
        end
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        %refresh_legend;
        hold off;
        if coincidence == 0
            ymin = get(handles.ymin,'String');
            ymax = get(handles.ymax,'String');
            ylim([str2double(ymin), str2double(ymax)]);
        else
            axis tight;
        end
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
        grid on;
        refresh_legend;
    case 3 % 1D scan show
        slider = length(step);
        [~,recordsize] = size(handles.current_dataA);
        if slider > 1;
            set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
            sliderVal    = round(get(hObject,'Value'));
            %show_CreateFcn(hObject, eventdata, handles);
            %sliderStatus = ['View azimuth: ' num2str(sliderVal)];
            %set(handles.textStatus, 'string', sliderStatus)
            %handles.current_data1(sliderVal,:) = adq_data.DataB;
            %global recordsize;
            if (sliderVal > slider)
                set(hObject,'Value',1)
                sliderVal    = 1;
            else if (sliderVal < 1)
                    set(hObject,'Value',slider)
                    sliderVal    = slider;
                end
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';            
        end
        switch ylabelmod
            case 1
                yname = 'Intensity (arb. units)';
            case 2
                yname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        if ylabelmod == 1;
            h(1) = plot(x,mean(handles.current_dataA(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1),'r','DisplayName','ChannelA','visible',legA);% Averge the nofrepes and nocycle to get the 1D data
        else
            h(1) = plot(x,mean(handles.current_dataA(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1)/3.3659,'r','DisplayName','ChannelA','visible',legA);
        end
        %    legend('-DynamicLegend');
        hold all;
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        if ylabelmod == 1
            h(2) = plot(x,mean(handles.current_dataB(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1),'g','DisplayName','ChannelB','visible',legB);
        else
            h(2) = plot(x,mean(handles.current_dataB(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1)/3.3659,'g','DisplayName','ChannelB','visible',legB);
        end
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        if ylabelmod == 1
            h(3) = plot(x,mean(handles.current_dataC(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1),'b','DisplayName','ChannelC','visible',legC);
        else
            h(3) = plot(x,mean(handles.current_dataC(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1)/3.3659,'b','DisplayName','ChannelC','visible',legC);
        end
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        if ylabelmod == 1
            h(4) = plot(x,mean(handles.current_dataD(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1),'m','DisplayName','ChannelD','visible',legD);
        else
            h(4) = plot(x,mean(handles.current_dataD(((sliderVal-1)*(nofrepes*nofcycle)+1):(sliderVal*(nofrepes*nofcycle)),:),1)/3.3659,'m','DisplayName','ChannelD','visible',legD);
        end
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        %refresh_legend;
        hold off;
        if coincidence == 0
            ymin = get(handles.ymin,'String');
            ymax = get(handles.ymax,'String');
            ylim([str2double(ymin), str2double(ymax)]);
        else
            axis tight;
        end
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
        grid on;
        refresh_legend;
    case 4
        %         show2D;
        %         while (enter_flag == 0)
        %             set(handles.textStatus, 'String', 'Please selected channel to show, then click enter button')
        %             pause(0.1)
        %         end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 1;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 0;
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 1;
                isChannelC = 0;
                isChannelD = 0;
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 1;
                isChannelD = 0;
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 1;
        end
        slider = nofrecords;
        [~,recordsize] = size(handles.current_dataA);
        ylabel2 = 1:nofrepes;
        if slider > 1;
            set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
            sliderVal    = round(get(hObject,'Value'));
            if (sliderVal > slider)
                set(hObject,'Value',1)
                sliderVal    = 1;
            else if (sliderVal < 1)
                    set(hObject,'Value',slider)
                    sliderVal    = slider;
                end
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';        
        end
        switch ylabelmod
            case 1
                yname = 'Intensity (arb. units)';
            case 2
                yname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        if ylabelmod == 1;
            if nofrepes == 1;
                ylabel2 = 1:2;
                switch channel_show
                    case 1
                        h(1) = pcolor(x,ylabel2,[handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)',handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)']');shading interp;
                    case 2
                        h(2) = pcolor(x,ylabel2,[handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)',handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)']');shading interp;
                    case 3
                        h(3) = pcolor(x,ylabel2,[handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)',handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)']');shading interp;
                    case 4
                        h(4) = pcolor(x,ylabel2,[handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)',handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)']');shading interp;
                end
            else
                switch channel_show
                    case 1
                        h(1) = pcolor(x,ylabel2,double(handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)));shading interp;
                    case 2
                        h(2) = pcolor(x,ylabel2,double(handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)));shading interp;
                    case 3
                        h(3) = pcolor(x,ylabel2,double(handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)));shading interp;
                    case 4
                        h(4) = pcolor(x,ylabel2,double(handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)));shading interp;
                end
            end
        else
            switch channel_show
                case 1
                    h(1) = pcolor(x,ylabel2,double(handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659));shading interp;
                case 2
                    h(2) = pcolor(x,ylabel2,double(handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659));shading interp;
                case 3
                    h(3) = pcolor(x,ylabel2,double(handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659));shading interp;
                case 4
                    h(4) = pcolor(x,ylabel2,double(handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659));shading interp;
            end
        end
        bar = colorbar;ylabel(bar,yname);%title(bar, yname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel('Software average')%,'FontSize',20)
    case 5
        %         show2D;
        %         while (enter_flag == 0)
        %             set(handles.textStatus, 'String', 'Please selected channel to show, then click enter button')
        %             pause(0.1)
        %         end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 1;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 0;
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 1;
                isChannelC = 0;
                isChannelD = 0;
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 1;
                isChannelD = 0;
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 1;
        end
        slider = nofcycle;
        [~,recordsize] = size(handles.current_dataA);
        if strcmp(machename,'Channel.A')
            ylabel2 = 50e3-step;
            yname = 'Delay between fs laser and ns laser (\mus)';
        else if strcmp(machename,'vertical')
                ylabel2 = step;
                yname = 'ns laser vertical scanning (mm)';
            else if strcmp(machename,'Channel.B')
                    ylabel2 = step;
                    yname = 'Delay between flshlamp and Q-switch (\mus)';
                else
                    ylabel2 = 1:ceil(nofrecords/nofcycle) ;
                    yname = 'Measurement series';
                end
            end
        end
        %         ylabel2 = 1:nofrepes;
        if slider > 1;
            set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
            sliderVal    = round(get(hObject,'Value'));
            if (sliderVal > slider)
                set(hObject,'Value',1)
                sliderVal    = 1;
            else if (sliderVal < 1)
                    set(hObject,'Value',slider)
                    sliderVal    = slider;
                end
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';             
        end
        switch ylabelmod
            case 1
                zname = 'Intensity (arb. units)';
            case 2
                zname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nIteration number = %d',sliderVal));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        switch channel_show
            case 1
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataA((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                 if nofcycle ~= 1
                indexre = reshape(1:nofrecords, nofcycle, length(step));
                %                     newdata = [];
                %                     for re = 1:length(step)
                %                         newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                     end
                %                 else
                %                     newdata = data;
                %                 end
                h(1) = pcolor(x,ylabel2,double(data(indexre(sliderVal,:),:)));shading interp;
            case 2
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataB((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                 if nofcycle ~= 1
                indexre = reshape(1:nofrecords, nofcycle, length(step));
                %                     newdata = [];
                %                     for re = 1:length(step)
                %                         newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                     end
                %                 else
                %                     newdata = data;
                %                 end
                h(2) = pcolor(x,ylabel2,double(data(indexre(sliderVal,:),:)));shading interp;
            case 3
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataC((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                 if nofcycle ~= 1
                indexre = reshape(1:nofrecords, nofcycle, length(step));
                %                     newdata = [];
                %                     for re = 1:length(step)
                %                         newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                     end
                %                 else
                %                     newdata = data;
                %                 end
                h(3) = pcolor(x,ylabel2,double(data(indexre(sliderVal,:),:)));shading interp;
            case 4
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataD((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                indexre = reshape(1:nofrecords, nofcycle,length(step));
                h(4) = pcolor(x,ylabel2,double(data(indexre(sliderVal,:),:)));shading interp;
        end
        bar = colorbar;ylabel(bar,zname);%title(bar, zname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
    case 6
        %         show2D;
        %         while (enter_flag == 0)
        %             set(handles.textStatus, 'String', 'Please select the channel to show, then click enter button')
        %             pause(0.1)
        %         end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 1;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 0;
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 1;
                isChannelC = 0;
                isChannelD = 0;
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 1;
                isChannelD = 0;
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 1;
        end
        slider = 1;
        sliderVal = 1;
        [~,recordsize] = size(handles.current_dataA);
        set(hObject,'Min',1,'Max',slider+1, 'SliderStep',[1 1]);
        sliderVal    = round(get(hObject,'Value'));
        %         if strcmp(machename,'DDG')
        %             ylabel2 = 50e3-step;
        %             yname = 'Delay time(\mus)';
        %         else if strcmp(machename,'vertical')
        %                 ylabel2 = step;
        %                 yname = 'ns laser vertical scanning (mm)';
        %             else
        %                 ylabel2 = 1:nofrecords;
        %                 yname = 'Measurement series';
        %             end
        %         end
        ylabel2 = 1:nofcycle;
        if (sliderVal > slider)
            set(hObject,'Value',1)
            sliderVal    = 1;
        else if (sliderVal < 1)
                set(hObject,'Value',slider)
                sliderVal    = slider;
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';               
        end
        switch ylabelmod
            case 1
                zname = 'Intensity (arb. units)';
            case 2
                zname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        %         if ylabelmod == 1;
        switch channel_show
            case 1
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataA((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                if nofcycle ~= 1
                    indexre = reshape(1:nofrecords, nofcycle, length(step));
                    newdata = [];
                    for re = 1:nofcycle
                        newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                    end
                else
                    ylabel2 = 1:2;
                    newdata = [data', data']';
                end
                h(1) = pcolor(x,ylabel2,double(newdata));shading interp;
            case 2
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataB((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                if nofcycle ~= 1
                    indexre = reshape(1:nofrecords, nofcycle, length(step));
                    newdata = [];
                    for re = 1:nofcycle
                        newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                    end
                else
                    ylabel2 = 1:2;
                    newdata = [data', data']';
                end
                h(2) = pcolor(x,ylabel2,double(newdata));shading interp;
            case 3
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataC((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                if nofcycle ~= 1
                    indexre = reshape(1:nofrecords, nofcycle, length(step));
                    newdata = [];
                    for re = 1:nofcycle
                        newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                    end
                else
                    ylabel2 = 1:2;
                    newdata = [data', data']';
                end
                h(3) = pcolor(x,ylabel2,double(newdata));shading interp;
            case 4
                data = [];
                for index = 1:nofrecords
                    data = [data', mean(handles.current_dataD((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                if nofcycle ~= 1
                    indexre = reshape(1:nofrecords, nofcycle, length(step));
                    newdata = [];
                    for re = 1:nofcycle
                        newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                    end
                else
                    ylabel2 = 1:2;
                    newdata = [data', data']';
                end
                h(4) = pcolor(x,ylabel2,double(newdata));shading interp;
        end
        bar = colorbar;ylabel(bar,zname);%title(bar, zname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel('Iteration number')%,'FontSize',20)
    case 7
        %         show2D;
        %         while (enter_flag == 0)
        %             set(handles.textStatus, 'String', 'Please select the channel to show, then click enter button')
        %             pause(0.1)
        %         end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 1;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 0;
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 1;
                isChannelC = 0;
                isChannelD = 0;
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 1;
                isChannelD = 0;
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
                isChannelA = 0;
                isChannelB = 0;
                isChannelC = 0;
                isChannelD = 1;
        end
        slider = 1;
        sliderVal = 1;
        [~,recordsize] = size(handles.current_dataA);
        set(hObject,'Min',1,'Max',slider+1, 'SliderStep',[1 1]);
        sliderVal    = round(get(hObject,'Value'));
        %         if strcmp(machename,'DDG')
        %             ylabel2 = 50e3-step;
        %             yname = 'Delay time(\mus)';
        %         else if strcmp(machename,'vertical')
        %                 ylabel2 = step;
        %                 yname = 'ns laser vertical scanning (mm)';
        %             else
        %                 ylabel2 = 1:nofrecords;
        %                 yname = 'Measurement series';
        %             end
        %         end
        if strcmp(machename,'Channel.A')
            ylabel2 = 50e3-step;
            yname = 'Delay between fs laser and ns laser (\mus)';
        else if strcmp(machename,'vertical')
                ylabel2 = step;
                yname = 'ns laser vertical scanning (mm)';
            else if strcmp(machename,'Channel.B')
                    ylabel2 = step;
                    yname = 'Delay between flshlamp and Q-switch (\mus)';
                else
                    ylabel2 = 1:ceil(nofrecords/nofcycle) ;
                    yname = 'Measurement series';
                end
            end
        end
        if (sliderVal > slider)
            set(hObject,'Value',1)
            sliderVal    = 1;
        else if (sliderVal < 1)
                set(hObject,'Value',slider)
                sliderVal    = slider;
            end
        end
        t=0:1/(bandwith):(recordsize-1)/(bandwith);
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        n = 1:recordsize;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                x = m;
                xname = 'm/q (Da)';
            case 4
                x = handles.x;
                xname = 'SFG Wavelength (nm)';
            case 5
                x = 1240./handles.x;
                xname = 'SFG Photon Energy (eV)';  
            case 6
                x = 1240./(1240./handles.x-1240./mass_calibrate);
                xname = 'IR Wavelength (nm)';  
            case 7
                x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
                xname = 'Wavenumber (cm^{-1})';               
        end
        switch ylabelmod
            case 1
                zname = 'Intensity (arb. units)';
            case 2
                zname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        %         if ylabelmod == 1;
        switch channel_show
            case 1
                data = [];
                for index = 1:length(step)
                    data = [data', mean(handles.current_dataA(((index-1)*(nofrepes*nofcycle)+1):(index*(nofrepes*nofcycle)),:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                     if nofcycle ~= 1
                %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
                %                         newdata = [];
                %                         for re = 1:length(step)
                %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                         end
                %                     else
                %                         newdata = data;
                %                     end
                h(1) = pcolor(x,ylabel2,double(data));shading interp;
            case 2
                data = [];
                for index = 1:length(step)
                    data = [data', mean(handles.current_dataB((index-1)*(nofrepes*nofcycle)+1:index*(nofrepes*nofcycle),:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                     if nofcycle ~= 1
                %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
                %                         newdata = [];
                %                         for re = 1:length(step)
                %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                         end
                %                     else
                %                         newdata = data;
                %                     end
                h(2) = pcolor(x,ylabel2,double(data));shading interp;
            case 3
                data = [];
                for index = 1:length(step)
                    data = [data', mean(handles.current_dataC((index-1)*(nofrepes*nofcycle)+1:index*(nofrepes*nofcycle),:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                     if nofcycle ~= 1
                %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
                %                         newdata = [];
                %                         for re = 1:length(step)
                %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                         end
                %                     else
                %                         newdata = data;
                %                     end
                h(3) = pcolor(x,ylabel2,double(data));shading interp;
            case 4
                data = [];
                for index = 1:length(step)
                    data = [data', mean(handles.current_dataD((index-1)*(nofrepes*nofcycle)+1:index*(nofrepes*nofcycle),:),1)']';
                end
                if ylabelmod ~= 1;
                    data = data/3.3659;
                end
                %                     if nofcycle ~= 1
                %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
                %                         newdata = [];
                %                         for re = 1:length(step)
                %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                %                         end
                %                     else
                %                         newdata = data;
                %                     end
                h(4) = pcolor(x,ylabel2,double(data));shading interp;
        end
        %         else
        %             switch channel_show
        %                 case 1
        %                     data = [];
        %                     for index = 1:nofrecords
        %                         data = [data', mean(handles.current_dataA((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
        %                     end
        %                     if nofcycle ~= 1
        %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
        %                         newdata = [];
        %                         for re = 1:length(step)
        %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
        %                         end
        %                     else
        %                         newdata = data;
        %                     end
        %                     h(1) = pcolor(x,ylabel2,double(newdata));shading interp;
        %                 case 2
        %                     data = [];
        %                     for index = 1:nofrecords
        %                         data = [data', mean(handles.current_dataB((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
        %                     end
        %                     if nofcycle ~= 1
        %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
        %                         newdata = [];
        %                         for re = 1:length(step)
        %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
        %                         end
        %                     else
        %                         newdata = data;
        %                     end
        %                     h(2) = pcolor(x,ylabel2,newdata);shading interp;
        %                 case 3
        %                     data = [];
        %                     for index = 1:nofrecords
        %                         data = [data', mean(handles.current_dataC((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
        %                     end
        %                     if nofcycle ~= 1
        %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
        %                         newdata = [];
        %                         for re = 1:length(step)
        %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
        %                         end
        %                     else
        %                         newdata = data;
        %                     end
        %                     h(3) = pcolor(x,ylabel2,double(newdata));shading interp;
        %                 case 4
        %                     data = [];
        %                     for index = 1:nofrecords
        %                         data = [data', mean(handles.current_dataD((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
        %                     end
        %                     if nofcycle ~= 1
        %                         indexre = reshape(1:nofrecords, length(step), nofcycle);
        %                         newdata = [];
        %                         for re = 1:length(step)
        %                             newdata = [newdata', mean(data(indexre(re,:),:),1)']';
        %                         end
        %                     else
        %                         newdata = data;
        %                     end
        %                     h(4) = pcolor(x,ylabel2,newdata);shading interp;
        %             end
        %         end
        bar = colorbar;ylabel(bar,zname);%title(bar, zname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
end
if coincidence == 0
    xmin = get(handles.xmin,'String');
    xmax = get(handles.xmax,'String');
    xlim([str2double(xmin), str2double(xmax)]);
    cmin = get(handles.cmin,'String');
    cmax = get(handles.cmax,'String');
    caxis([str2double(cmin), str2double(cmax)]);
else
    axis tight;
end
guidata(hObject, handles);
%view(sliderVal, 30)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function show_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
% global nofrecords;
%global recordsize;
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[1 1 1]);
end
set(hObject,'Min',1,'Max',101, 'SliderStep',[0.01, 0.1]);
set(hObject,'Value',1)
%guidata(hObject, handles);


% --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
% hObject    handle to Pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;
ispushed = get(hObject,'Value');
if ispushed
    set(handles.textStatus, 'string', sprintf('Pause \n Please click "Continue" button or type "c" to continue'))
    set(hObject, 'string', 'Continue')
    uiwait;
else
    set(handles.textStatus, 'string', 'Continue')
    set(hObject, 'string', 'Pause')
end
guidata(hObject,handles)


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isDown;
isDown = get(hObject,'Value');
if isDown
    set(handles.textStatus, 'string', 'Break')
    set(handles.Stop, 'Value', 0);
else
    set(handles.textStatus, 'string', 'Continue')
end
guidata(hObject,handles)



function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmin = get(hObject,'String');
xmax = get(handles.xmax,'String');
newXLim = [str2double(xmin), str2double(xmax)];
if any(isnan(newXLim)) || str2double(xmin)>= str2double(xmax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.xmin,'String', '0')
else
    set(handles.axes1,  'XLim', newXLim);
end
% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double


% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmax = get(hObject,'String');
xmin = get(handles.xmin,'String');
newXLim = [str2double(xmin), str2double(xmax)];
if any(isnan(newXLim)) || str2double(xmin)>= str2double(xmax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.xmax,'String', '30')
else
    set(handles.axes1,  'XLim', newXLim);
end
% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double


% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ymax = get(hObject,'String');
ymin = get(handles.ymin,'String');
newYLim = [str2double(ymin), str2double(ymax)];
if any(isnan(newYLim)) || str2double(ymin)>= str2double(ymax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.ymax,'String', '30')
else
    set(handles.axes1,  'YLim', newYLim);
end
% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ymin = get(hObject,'String');
ymax = get(handles.ymax,'String');
newYLim = [str2double(ymin), str2double(ymax)];
if any(isnan(newYLim)) || str2double(ymin)>= str2double(ymax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.ymin,'String', '-50')
else
    set(handles.axes1,  'YLim', newYLim);
end
% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double


% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChannelA.
function ChannelA_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelA
global h
global dimension
global channel_show;
if dimension < 4
    isChannelA = get(hObject,'Value');
    if isChannelA
        set(handles.textStatus, 'string', 'Channel A is selected')
        set(h(1),'visible','on')
    else
        set(handles.textStatus, 'string', 'Channel A is excluded')
        set(h(1),'visible','off')
    end
    refresh_legend;
    
else
    channel_show = 1;
    show_Callback(handles.show, eventdata, handles)
    set(handles.textStatus, 'string', 'Channel A is selected')
end
% Hint: get(hObject,'Value') returns toggle state of ChannelA


% --- Executes on button press in ChannelB.
function ChannelB_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelB
global h
global dimension
global channel_show;
if dimension < 4
    isChannelB = get(hObject,'Value');
    if isChannelB
        set(handles.textStatus, 'string', 'Channel B is selected')
        set(h(2),'visible','on')
    else
        set(handles.textStatus, 'string', 'Channel B is excluded')
        set(h(2),'visible','off')
    end
    refresh_legend;
else
    channel_show = 2;
    show_Callback(handles.show, eventdata, handles)
    set(handles.textStatus, 'string', 'Channel B is selected')
end

% Hint: get(hObject,'Value') returns toggle state of ChannelB


% --- Executes on button press in ChannelC.
function ChannelC_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelC
global h
global dimension
global channel_show;
if dimension < 4
    isChannelC = get(hObject,'Value');
    if isChannelC
        set(handles.textStatus, 'string', 'Channel C is selected')
        set(h(3),'visible','on')
    else
        set(handles.textStatus, 'string', 'Channel C is excluded')
        set(h(3),'visible','off')
    end
    refresh_legend;
else
    channel_show = 3;
    show_Callback(handles.show, eventdata, handles)
    set(handles.textStatus, 'string', 'Channel C is selected')
end

% Hint: get(hObject,'Value') returns toggle state of ChannelC


% --- Executes on button press in ChannelD.
function ChannelD_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelD
global h
global dimension
global channel_show;
if dimension < 4
    isChannelD = get(hObject,'Value');
    if isChannelD
        set(handles.textStatus, 'string', 'Channel D is selected')
        set(h(4),'visible','on')
    else
        set(handles.textStatus, 'string', 'Channel D is excluded')
        set(h(4),'visible','off')
    end
    refresh_legend;
else
    channel_show = 4;
    show_Callback(handles.show, eventdata, handles)
    set(handles.textStatus, 'string', 'Channel D is selected')
end

% Hint: get(hObject,'Value') returns toggle state of ChannelD


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_joker_Callback(hObject, eventdata, handles)
% hObject    handle to help_joker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Copyright (c) [Dr. Zhipeng Huang]','Please contact Dr. Zhipeng Huang for help.','Email: zhipeng.huang@ag-campen.org'});

% --------------------------------------------------------------------
function help_multirecord_Callback(hObject, eventdata, handles)
% hObject    handle to help_multirecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Copyright (c) [Dr. Zhipeng Huang]','Please contact Dr. Zhipeng Huang for help.','Email: zhipeng.huang@ag-campen.org'});

% --------------------------------------------------------------------
function menu_file_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global recordsize;
global nofrecords;
global nofcycle;
global sliderVal;
global nofwaveforms;
global selected_trigger;
global nofrepes;
global machename;
global step;
global ind;
global figurename;
global filenumber;
global settings;
[filenameall, pathname] = uigetfile({'*.bin';'*.h5';'*.mat';'*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if ~isempty(filenameall)
    clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        filenumber = length(filenameall);
        channel = {'Channel A','Channel B','Channel C','Channel D'};
        fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
        handles = rmfield(handles,fields);
        if ismember('Channel A',channel)
            isChannelA = 1;
        else
            isChannelA = 0;
        end
        if ismember('Channel B',channel)
            isChannelB = 1;
        else
            isChannelB = 0;
        end
        if ismember('Channel C',channel)
            isChannelC = 1;
        else
            isChannelC = 0;
        end
        if ismember('Channel D',channel)
            isChannelD = 1;
        else
            isChannelD = 0;
        end
        set(handles.ChannelA, 'Value', isChannelA);
        set(handles.ChannelB, 'Value', isChannelB);
        set(handles.ChannelC, 'Value', isChannelC);
        set(handles.ChannelD, 'Value', isChannelD);
        handles.current_dataA = [];
        handles.current_dataB = [];
        handles.current_dataC = [];
        handles.current_dataD = [];
        attA = [];
        for i = 1:filenumber;%length(filenameall)
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);
            [dataA, dataB, dataC, dataD, attdata] = getdata(filename, file, dot,i);
            handles.current_dataA = [handles.current_dataA',dataA']';
            handles.current_dataB = [handles.current_dataB',dataB']';
            handles.current_dataC = [handles.current_dataC',dataC']';
            handles.current_dataD = [handles.current_dataD',dataD']';
            attA = [attA,attdata];
        end
        [~,ind] = sort(attA);
        nofcycle = length(filenameall);% iteration number
        nofrecords = nofrecords*nofcycle; %length(info.Groups); % measurement number = step number * cycle number
        sliderVal = 1;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles);
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        filenumber = 1;
        %     set(handles.figure1, 'Name', filename);
%         clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
        if strcmp(filename(dot+1:end), 'mat')
            channeldata = load(file);
            names = fieldnames(channeldata);
            [nofrecords, recordsize] = size(channeldata.(char(names(1,:))));
            nofrepes = 1;
            nofwaveforms = 1;
            nofcycle = 1;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 1;
            isChannelC = 0;
            isChannelD = 1;
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            handles.current_dataA = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = channeldata.(char(names(2,:)));
            handles.current_dataD = channeldata.(char(names(1,:)));
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles)
        else if strcmp(filename(dot+1:end), 'hdf5') || strcmp(filename(dot+1:end), 'h5') || strcmp(filename(dot+1:end), 'hdf')
                info = h5info(file);
                if isfield(info.Groups,'Attributes') && isempty(info.Groups(1).Attributes)
                    %                 if isfield(info.Groups(1).Attributes,'Value')
                    samplerate = 2e+09; %info.Groups(1).Attributes(6).Value;
                    if samplerate == 2e+09
                        string_list{1} = 'Software';
                        string_list{2} = 'External';
                        string_list{3} = 'Level';
                        string_list{4} = 'Internal';
                        if isempty(info.Datasets) %ismember ('Name',fieldnames(info.Datasets))
                        else
                            settings = h5read(file,strcat('/',info.Datasets.Name));
                            recordsize = double(settings.adq_recordLength); %info.Groups(1).Attributes(5).Value; %Samples per record
                            nofrecords = length(info.Groups.Groups.Groups(1).Groups)*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
                            nofrepes = double(settings.adq_nRecords);% settings.scan_niterations; %settings.adq_nRecords; %info.Groups(1).Attributes(2).Value; % software average number settings.scan_niterations
                            nofcycle = double(settings.scan_niterations);% iteration number
                            nofwaveforms = double(settings.adq_nAverages); %info.Groups(1).Attributes(3).Value; % hardware average number
                            selected_trigger = 'External'; %info.Groups(1).Attributes(4).Value; % find(strcmp(string_list,info.Groups(1).Attributes(6).Value));
                            machename = settings.scanChannel; %char(info.Groups(1).Attributes((strmatch('Settings',char(info.Groups(1).Attributes.Name)))).Value(1));
                            %                     stepvalue = [];
                            %                     for att = 1:nofrecords
                            if ((length(cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name))) == ceil(nofrecords/nofcycle)) && ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',0)),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name))))
                                fprintf('The hdf5 structure is well organised\n')
                                nofrecords = length(info.Groups.Groups.Groups(1).Groups)*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
                            else
                                fprintf('The hdf5 structure is not well organised\n')
                                nofrecords = length(info.Groups.Groups.Groups(1).Groups);%*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
                                if ceil(nofrecords/nofcycle) ~= floor(nofrecords/nofcycle)
                                    nofrecords = ceil(nofrecords/nofcycle)*nofcycle;
                                end
                            end
                        end
                        if strcmp(machename,'Channel.A')
                            stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))*1e6];
                            if length(stepvalue) == ceil(nofrecords/nofcycle)
                                step = stepvalue;
                            else if length(stepvalue) > ceil(nofrecords/nofcycle)
                                    step = stepvalue(1:ceil(nofrecords/nofcycle) );
                                else
                                    step = [stepvalue (double(settings.scan_to)/1000)];
                                end
                            end
                        else if strcmp(machename,'Channel.B')
                                stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %-settings.scan_stepSize/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))/800];
                                if length(stepvalue) == ceil(nofrecords/nofcycle)
                                    step = stepvalue;
                                else if length(stepvalue) > ceil(nofrecords/nofcycle)
                                        step = stepvalue(1:ceil(nofrecords/nofcycle) );
                                    else
                                        step = [stepvalue (double(settings.scan_to)/1000)];
                                    end
                                end
                            else
                                step = 1:ceil(nofrecords/nofcycle) ;
                            end
                        end
                        %                     end
                        
                        %                     if stepvalue(1) < stepvalue(length(stepvalue))
                        %                         stepraw = sort(stepvalue);
                        %                     else
                        %                         stepraw = sort(stepvalue,'descend');
                        %                     end
                        %                     step = stepvalue; %unique(stepraw);%, 'stable');
                        %                     nofcycle = length(stepraw)/length(step);
                        channel = {'Channel A','Channel B','Channel C','Channel D'}; %,'current_dataC'}; %cellstr(cat(1,info.Groups(1).Datasets.Name));
                        fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
                        handles = rmfield(handles,fields);
                        if ismember('Channel A',channel)
                            isChannelA = 1;
                        else
                            isChannelA = 0;
                            handles.current_dataA = zeros(nofrecords*nofrepes,recordsize);
                        end
                        if ismember('Channel B',channel)
                            isChannelB = 1;
                        else
                            isChannelB = 0;
                            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
                        end
                        if ismember('Channel C',channel)
                            isChannelC = 1;
                        else
                            isChannelC = 0;
                            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
                        end
                        if ismember('Channel D',channel)
                            isChannelD = 1;
                        else
                            isChannelD = 0;
                            handles.current_dataD = zeros(nofrecords*nofrepes,recordsize);
                        end
                        attA = zeros(1,nofrecords*nofrepes);
                        set(handles.ChannelA, 'Value', isChannelA);
                        set(handles.ChannelB, 'Value', isChannelB);
                        set(handles.ChannelC, 'Value', isChannelC);
                        set(handles.ChannelD, 'Value', isChannelD);
                        record = 0;
                        if ((length(cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name))) == ceil(nofrecords/nofcycle)) && ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',0)),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name))))
                            for i = 1:nofrecords/nofcycle; %[1:1044,1047:1263,1265:nofrecords]
                                infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                                infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                                infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                                infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                                for k = 1:nofcycle
                                    for j = 1:nofrepes
                                        record = record+1;%i;%record+1;
                                        if isChannelA == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoA.Datasets.Name)))
                                                dataA = h5read(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
%                                                 handles.current_dataA(record,:) = single(dataA(1,:)/nofwaveforms);
                                                handles.current_dataA(record,:) = single(dataA(1,:)*4096/0.8);
                                                attA(record) = h5readatt(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)),'timestamp');
                                            else
                                                if record ~= 1
                                                    handles.current_dataA(record,:) = handles.current_dataA(record-1,:); %dataA(1,:);
                                                    attA(record) = attA(record-1);
                                                    fprintf('Channel A scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    attA(record) = 0;
                                                    handles.current_dataA(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel A scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                                end
                                            end
                                        end
                                        if isChannelB == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoB.Datasets.Name)))
                                                dataB = h5read(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
%                                                 handles.current_dataB(record,:) = single(dataB(1,:)/nofwaveforms);
                                                handles.current_dataB(record,:) = single(dataB(1,:)*4096/0.8);

                                            else
                                                if record ~= 1
                                                    handles.current_dataB(record,:) = handles.current_dataB(record-1,:); %dataA(1,:);
                                                    fprintf('Channel B scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataB(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel B scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                                end
                                            end
                                            %                                     dataB = h5read(file,strcat('/',num2str(i),'/Channel B'));
                                            %                                     handles.current_dataB(record,:) = single(dataB(j,:));
                                        end
                                        if isChannelC == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoC.Datasets.Name)))
                                                dataC = h5read(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
%                                                 handles.current_dataC(record,:) = single(dataC(1,:)/nofwaveforms);
                                                handles.current_dataC(record,:) = single(dataC(1,:)*4096/0.8);
                                            else
                                                if record ~= 1
                                                    handles.current_dataC(record,:) = handles.current_dataC(record-1,:); %dataC(1,:);
                                                    fprintf('Channel C scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataC(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel C scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                                end
                                                %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                            end
                                        end
                                        if isChannelD == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoD.Datasets.Name)))
                                                dataD = h5read(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
%                                                 handles.current_dataD(record,:) = single(dataD(1,:)/nofwaveforms);
                                                handles.current_dataD(record,:) = single(dataD(1,:)*4096/0.8);
                                            else
                                                if record ~= 1
                                                    handles.current_dataD(record,:) = handles.current_dataD(record-1,:); %dataC(1,:);
                                                    fprintf('Channel D scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataD(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel D scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                                end
                                                %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            for m = 1:ceil(nofrecords/nofcycle) ; %[1:1044,1047:1263,1265:nofrecords]
                                %                         infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                                %                         infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                                %                         infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                                %                         infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                                for k = 1:nofcycle
                                    if ismember(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d',m+(k-1)*(ceil(nofrecords/nofcycle) +1))),cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name)))
                                        infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1))));
                                    else
                                        fprintf(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1)), 'is not exist in file\n'));
                                    end
                                    if ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',m+(k-1)*(ceil(nofrecords/nofcycle) +1))),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name)))
                                        infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1))));
                                    else
                                        fprintf(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1)), 'is not exist in file\n'));
                                    end
                                    if ismember(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d',m+(k-1)*(ceil(nofrecords/nofcycle) +1))),cellstr(char(info.Groups.Groups.Groups(3,1).Groups.Name)))
                                        infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1))));
                                    else
                                        fprintf(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1)), 'is not exist in file\n'));
                                    end
                                    if ismember(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d',m+(k-1)*(ceil(nofrecords/nofcycle) +1))),cellstr(char(info.Groups.Groups.Groups(4,1).Groups.Name)))
                                        infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1))));
                                    else
                                        fprintf(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',m+(k-1)*(ceil(nofrecords/nofcycle) +1)), 'is not exist in file\n'));
                                    end
                                    for j = 1:nofrepes
                                        record = record+1;%i;%record+1;
                                        if isChannelA == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoA.Datasets.Name)))
                                                dataA = h5read(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                                handles.current_dataA(record,:) = single(dataA(1,:)*4096/0.8);
                                                attA(record) = h5readatt(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1)),'timestamp');
                                            else
                                                if record ~= 1
                                                    handles.current_dataA(record,:) = handles.current_dataA(record-1,:); %dataA(1,:);
                                                    attA(record) = attA(record-1);
                                                    fprintf('Channel A scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    attA(record) = 0;
                                                    handles.current_dataA(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel A scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);
                                                end
                                            end
                                        end
                                        if isChannelB == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoB.Datasets.Name)))
                                                dataB = h5read(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                                handles.current_dataB(record,:) = single(dataB(1,:)*4096/0.8);
                                            else
                                                if record ~= 1
                                                    handles.current_dataB(record,:) = handles.current_dataB(record-1,:); %dataA(1,:);
                                                    fprintf('Channel B scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataB(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel B scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);
                                                end
                                            end
                                            %                                     dataB = h5read(file,strcat('/',num2str(i),'/Channel B'));
                                            %                                     handles.current_dataB(record,:) = single(dataB(j,:));
                                        end
                                        if isChannelC == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoC.Datasets.Name)))
                                                dataC = h5read(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                                handles.current_dataC(record,:) = single(dataC(1,:)*4096/0.8);
                                            else
                                                if record ~= 1
                                                    handles.current_dataC(record,:) = handles.current_dataC(record-1,:); %dataC(1,:);
                                                    fprintf('Channel C scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataC(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel C scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);
                                                end
                                                %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                            end
                                        end
                                        if isChannelD == 1;
                                            if ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoD.Datasets.Name)))
                                                dataD = h5read(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                                handles.current_dataD(record,:) = single(dataD(1,:)*4096/0.8);
                                            else
                                                if record ~= 1
                                                    handles.current_dataD(record,:) = handles.current_dataD(record-1,:); %dataC(1,:);
                                                    fprintf('Channel D scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                                else
                                                    handles.current_dataD(record,:) = zeros(1,recordsize);
                                                    fprintf('Channel D scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m+(k-1)*(ceil(nofrecords/nofcycle) +1),k-1,j-1);
                                                end
                                                %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        [~,ind] = sort(attA);
                        %                     handles.current_dataA = handles.current_dataA(ind,:);
                        %                     handles.current_dataC = handles.current_dataC(ind,:);
                        sliderVal = 1;
                        set(handles.show, 'Value', sliderVal);
                        show_Callback(handles.show, eventdata, handles);
                    else
                        uiwait(warndlg(sprintf('Error: Not the multirecord data \n It might be the waveform average data')));
                    end
                else
                    uiwait(warndlg(sprintf('Error: Not the right type data \n It might be the other hdf5 data')));
                    %                 end
                    %             else
                    %                 uiwait(warndlg(sprintf('Error: Not the right type data \n The data were not generated by this software')));
                end
            else
                uiwait(warndlg(sprintf('Error: Not the standard hdf5 data')));
            end
        end
    end
    % else
    %     uiwait(warndlg(sprintf('Error: No file selected')));
    % handles.current_dataB = handles.current_dataD;
    set(handles.figure1, 'Name', filename);
    figurename = filename(1:(dotall(1)-1));
end

% --------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nofwaveforms;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global selected_trigger;
global nofrecords;
global nofrepes;
global bandwith;
[filename, pathname] = uiputfile('*.hdf5', 'Save Data as');
if filename ~=0;
    file = fullfile(pathname, filename);
    [loops,nofsamples] = size(handles.current_dataA);
    t=0:1/(bandwith):(nofsamples-1)/(bandwith);
    string_list{1} = 'Software';
    string_list{2} = 'External';
    string_list{3} = 'Level';
    string_list{4} = 'Internal';
    %     tic
    if exist(file, 'file')
        delete(file)
    end
    if exist(file, 'file')
        uiwait(warndlg(sprintf('File is opened by another program \nPlease close the program and try again')));
    else
        record = 0;
        for i = 1:nofrecords
            %         fileID = H5F.create(file,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
            %         dataspaceID = H5S.create_simple(2, [2, nofsamples], []);
            %         datatypeID = H5T.copy('H5T_NATIVE_DOUBLE');
            %         datasetID = H5D.create(fileID,strcat('/',num2str(i),'/Channel_B'),datatypeID,dataspaceID,'H5P_DEFAULT');
            for j = 1:nofrepes
                record = record+1;
                if isChannelA == 1;
                    h5create(file,strcat('/',num2str(i),'/',num2str(j),'/Channel_A'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                    %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                    current_dataA = [t', handles.current_dataA(record,:)']';
                    h5write(file, strcat('/',num2str(i),'/',num2str(j),'/Channel_A'), current_dataA);
                end
                if isChannelB == 1;
                    h5create(file,strcat('/',num2str(i),'/',num2str(j),'/Channel_B'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                    %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                    current_dataB = [t', handles.current_dataB(record,:)']';
                    %         H5D.write(datasetID,'H5ML_DEFAULT','H5S_ALL','H5S_ALL', ...
                    %             'H5P_DEFAULT', current_dataB);
                    %         H5D.close(datasetID);
                    %         H5S.close(dataspaceID);
                    %         H5T.close(datatypeID);
                    %         H5F.close(fileID);
                    h5write(file, strcat('/',num2str(i),'/',num2str(j),'/Channel_B'), current_dataB);
                end
                if isChannelC == 1;
                    h5create(file,strcat('/',num2str(i),'/',num2str(j),'/Channel_C'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                    %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                    current_dataC = [t', handles.current_dataC(record,:)']';
                    h5write(file, strcat('/',num2str(i),'/',num2str(j),'/Channel_C'), current_dataC);
                end
                if isChannelD == 1;
                    h5create(file,strcat('/',num2str(i),'/',num2str(j),'/Channel_D'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                    current_dataD = [t', handles.current_dataD(record,:)']';
                    h5write(file, strcat('/',num2str(i),'/',num2str(j),'/Channel_D'), current_dataD);
                end
            end
            if isChannelA || isChannelB || isChannelC || isChannelD
                h5writeatt(file, strcat('/',num2str(i)), 'Sample Rate (Hz)',2e9);
                h5writeatt(file, strcat('/',num2str(i)), 'Step number',nofrecords);
                h5writeatt(file, strcat('/',num2str(i)), 'Repetition number',nofrepes);
                h5writeatt(file, strcat('/',num2str(i)), 'Hardware Average Number',nofwaveforms);
                h5writeatt(file, strcat('/',num2str(i)), 'Record Size',nofsamples);
                h5writeatt(file, strcat('/',num2str(i)), 'Selected_trigger',string_list{selected_trigger});
            else
                uiwait(warndlg('No data selected'));
            end
        end
    end
    %     toc
end
% h5writeatt(file, '/Channel_B', 'sample rate',2e9);

% --------------------------------------------------------------------
function menu_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to menu_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function measure_multirecord_Callback(hObject, eventdata, handles)
% hObject    handle to measure_multirecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete(handles.figure1);
Close_Callback(hObject, eventdata, handles)
multirecord;

% --------------------------------------------------------------------
function help_wfa_Callback(hObject, eventdata, handles)
% hObject    handle to help_wfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Copyright (c) [Dr. Zhipeng Huang]','Please contact Dr. Zhipeng Huang for help.','Email: zhipeng.huang@ag-campen.org'})


% --- Executes on selection change in xlabelopt.
function xlabelopt_Callback(hObject, eventdata, handles)
% hObject    handle to xlabelopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global record;
global recordsize;
global xlabelmod;
global sliderVal;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global enter_flag;
enter_flag = 0;
%global sliderVal;
val = get(hObject,'Value');
str = get(hObject, 'String');
%axes(handles.axes1);
% t = 0:1/(2000):(double(recordsize)-1)/(2000);
% % m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
% n = 1:recordsize;
% channelA = get(h(1),'Ydata');
% channelB = get(h(2),'Ydata');
% channelC = get(h(3),'Ydata');
% channelD = get(h(4),'Ydata');
switch str{val};
    case 'Time' % User selects peaks.
        xlabelmod = 1;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to time')
    case 'Record Size' % User selects membrane.
        xlabelmod = 2;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to record number')
    case 'Mass' % User selects sinc.
        xlabelmod = 3;
        xlabel_mode;
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please type the calibrated mass parameters, then click enter button')
            pause(0.1)
        end
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to mass')
   case 'SFG Wavelength' % User selects sinc.
        xlabelmod = 4;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to SFG wavelength')   
    case 'SFG Photon Energy'
        xlabelmod = 5;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to SFG photon energy') 
    case 'IR Wavelength'
        xlabelmod = 6;
        mass_calibrate = str2double(inputdlg('Enter up conversion center wavelength (nm):',...
             'Sample', 1));
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to IR wavelength')    
    case 'IR Wavenumber'
        xlabelmod = 7;
        mass_calibrate = str2double(inputdlg('Enter up conversion center wavelength (nm):',...
             'Sample', 1));          
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to IR wavenumber') 
end
% Hints: contents = cellstr(get(hObject,'String')) returns xlabelopt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xlabelopt


% --- Executes during object creation, after setting all properties.
function xlabelopt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlabelopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
global sliderVal
switch eventdata.Key
    case 'f5'
        %        nofrecord_Callback(hObject, eventdata, handles)
        %        drawnow;
        Start_Callback(hObject, eventdata, handles)
    case 's'
        Setup_Callback(hObject, eventdata, handles)
    case 'p'
        set(handles.Pause, 'Value', 1);
        Pause_Callback(handles.Pause, eventdata, handles)
    case 'c'
        set(handles.Pause, 'Value', 0);
        Pause_Callback(handles.Pause, eventdata, handles)
    case 'b'
        set(handles.Stop, 'Value', 1);
        Stop_Callback(handles.Stop, eventdata, handles)
    case 'r'
        set(handles.Stop, 'Value', 0);
        Stop_Callback(handles.Stop, eventdata, handles)
    case 'escape'
        Close_Callback(hObject, eventdata, handles)
    case 'leftarrow'
        sliderVal = sliderVal-1;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles)
    case 'rightarrow'
        sliderVal = sliderVal+1;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles)
    case 'downarrow'
        sliderVal = sliderVal+10;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles)
    case 'uparrow'
        sliderVal = sliderVal-10;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles)
    case 't'
        set(handles.xlabelopt, 'Value', 1);
        xlabelopt_Callback(handles.xlabelopt, eventdata, handles)
    case 'n'
        set(handles.xlabelopt, 'Value', 2);
        xlabelopt_Callback(handles.xlabelopt, eventdata, handles)
    case 'm'
        set(handles.xlabelopt, 'Value', 3);
        xlabelopt_Callback(handles.xlabelopt, eventdata, handles)
    case 'i'
        set(handles.ylabelopt, 'Value', 1);
        ylabelopt_Callback(handles.ylabelopt, eventdata, handles)
    case 'v'
        set(handles.ylabelopt, 'Value', 2);
        ylabelopt_Callback(handles.ylabelopt, eventdata, handles)
end
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 or any of its controls.

% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gate.
function gate_Callback(hObject, eventdata, handles)
% hObject    handle to gate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global nofrecords;
% global recordsize;
% global xlabelmod;
% global delay_trigger;
% global mass_calibrate;
% global time_calibrate;
% global enter_flag;
global channel_show;
global nofrepes;
global nofcycle;
global nofwaveforms;
global machename;
global dimension;
global step;
global ind;
global saveps;
global figurename;
global las;
global xaxis;
global pgate;
global filenumber;
% show2D;
%         while (enter_flag == 0)
%             set(handles.textStatus, 'String', 'Please select channel to gate, then click enter button')
%             pause(0.1)
%         end
if strcmp(machename,'Channel.A')
    xlabel2 = 50e3-step;
    xname = 'Delay between fs laser and ns laser (\mus)';
    xname2 = 'Delay between fs laser and ns laser (\mus)';
else if strcmp(machename,'vertical')
        xlabel2 = step;
        xname = 'ns laser vertical scanning (mm)';
    else if strcmp(machename,'Channel.B')
            xlabel2 = step;
            xname = 'Delay between flshlamp and Q-switch (\mus)';
            xname2 = 'Desorption laser power (mJ)';
        else
            xlabel2 = 1:ceil(nofrecords/nofcycle) ;
            xname = 'Measurement series';
%             xname2 = 'Ionisation laser power (mW)';
            xname2 = 'Delay time (ps)';%Lens stage position (mm)';
        end
    end
end
if dimension < 4
    dcm_obj = datacursormode(handles.figure1);
    set(dcm_obj,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
    set(handles.textStatus, 'String', 'Click line to select four data tips: background is primary than gatedata, then press Return.')
    % Wait while the user does this.
    pause
    c_info = getCursorInfo(dcm_obj);
    if length(c_info) ~= 4
        errorMessage = sprintf('Please select four cursors then click plot again');
        uiwait(warndlg(errorMessage));
    else
        gate = sort([c_info(1).DataIndex,c_info(2).DataIndex,c_info(3).DataIndex,c_info(4).DataIndex]);
        set(handles.textStatus, 'String', sprintf('The gate range is from %d to %d',gate(1),gate(4)));
        pos = flipud(get(handles.axes1,'Children'));
        channel_show = find(pos == c_info(1).Target);
        % switch xlabelmod
        %     case 1
        %         t = 0:1/(2000):(double(recordsize)-1)/(2000);
        %         n = 1:recordsize;
        %         backgroundmin = n(t == gate(1));
        %         backgroundmax = n(t == gate(2));
        %         gatemin = n(t == gate(3));
        %         gatemax = n(t == gate(4));
        %     case 2
%         promptmessage = {'Is the backrgound data earlier than the gate data or not?'};
%         dlg_title = 'Input';
%         num_lines = 1;
%         defaultans = {'18'};
%         gate = inputdlg(promptmessage,dlg_title,num_lines,defaultans);
%         mgate = str2double(gate);
        answer = questdlg('Is the backrgound data earlier than the gate data?',...
            'Gatedata Menu',...
            'Yes', 'No','Don''t know','Don''t know');
        switch answer
            case 'Yes'
                disp([answer ' Yes.'])
                backgroundmin = gate(1);
                backgroundmax = gate(2);
                promptrange = {'Enter length of gate:'};
                dlg_title_gate = 'Input';
                num_range = 1;
                defaultansrange = {'18'};
                gaterange = inputdlg(promptrange,dlg_title_gate,num_range,defaultansrange);
                gateran = str2double(gaterange);
                if pgate == 1
                   switch channel_show
                        case 1
                            current_data = mean(handles.current_dataA);
                        case 2
                            current_data = mean(handles.current_dataB);
                        case 3
                            current_data = mean(handles.current_dataC);
                        case 4
                            current_data = mean(handles.current_dataD);
                    end
                    gatemin = find(current_data(gate(3):gate(4)) == min(current_data(gate(3):gate(4))))+gate(3)-1-floor(gateran/2);% find the minium data point of the gate and set range with external length
                    gatemax = find(current_data(gate(3):gate(4)) == min(current_data(gate(3):gate(4))))+gate(3)-1+floor(gateran/2);% find the minium data point of the gate and set range with external length
                else
                    gatemin = gate(3);
                    gatemax = gate(4);
                end
            case 'No'
                disp([answer ' No.'])
                backgroundmin = gate(3);
                backgroundmax = gate(4);
                promptrange = {'Enter length of gate:'};
                dlg_title_gate = 'Input';
                num_range = 1;
                defaultansrange = {'18'};
                gaterange = inputdlg(promptrange,dlg_title_gate,num_range,defaultansrange);
                gateran = str2double(gaterange);
                if pgate == 1
                   switch channel_show
                        case 1
                            current_data = mean(handles.current_dataA);
                        case 2
                            current_data = mean(handles.current_dataB);
                        case 3
                            current_data = mean(handles.current_dataC);
                        case 4
                            current_data = mean(handles.current_dataD);
                    end
                    gatemin = find(current_data(gate(1):gate(2)) == min(current_data(gate(1):gate(2))))+gate(1)-1-floor(gateran/2);
                    gatemax = find(current_data(gate(1):gate(2)) == min(current_data(gate(1):gate(2))))+gate(1)-1+floor(gateran/2);
                else
                    gatemin = gate(1);
                    gatemax = gate(2);
                end
            case 'Don''t know'
                disp('Please check the selected data again. Now the results assume the backrgound data is earlier than the gate data')
                backgroundmin = gate(1);
                backgroundmax = gate(2);
                promptrange = {'Enter length of gate:'};
                dlg_title_gate = 'Input';
                num_range = 1;
                defaultansrange = {'18'};
                gaterange = inputdlg(promptrange,dlg_title_gate,num_range,defaultansrange);
                gateran = str2double(gaterange);
                if pgate == 1
                   switch channel_show
                        case 1
                            current_data = mean(handles.current_dataA);
                        case 2
                            current_data = mean(handles.current_dataB);
                        case 3
                            current_data = mean(handles.current_dataC);
                        case 4
                            current_data = mean(handles.current_dataD);
                    end
                    gatemin = find(current_data(gate(3):gate(4)) == min(current_data(gate(3):gate(4))))+gate(3)-1-floor(gateran/2);
                    gatemax = find(current_data(gate(3):gate(4)) == min(current_data(gate(3):gate(4))))+gate(3)-1+floor(gateran/2);
                else
                    gatemin = gate(3);
                    gatemax = gate(4);
                end
        end
%         backgroundmin = gate(1);
%         backgroundmax = gate(2);
%         gatemin = gate(3);
%         gatemax = gate(4);
        %     case 3
        %         t = 0:1/(2000):(double(recordsize)-1)/(2000);
        %         m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        %         n = 1:recordsize;
        %         backgroundmin = n(m == gate(1));
        %         backgroundmax = n(m == gate(2));
        %         gatemin = n(m == gate(3));
        %         gatemax = n(m == gate(4));
        % end
        switch channel_show
            case 1
                gatedataraw = (mean(handles.current_dataA(:,backgroundmin:backgroundmax)')-mean(handles.current_dataA(:,gatemin:gatemax)'))*(gatemax-gatemin+1);
            case 2
                gatedataraw = (mean(handles.current_dataB(:,backgroundmin:backgroundmax)')-mean(handles.current_dataB(:,gatemin:gatemax)'))*(gatemax-gatemin+1);
            case 3
                gatedataraw = (mean(handles.current_dataC(:,backgroundmin:backgroundmax)')-mean(handles.current_dataC(:,gatemin:gatemax)'))*(gatemax-gatemin+1);
            case 4
                gatedataraw = (mean(handles.current_dataD(:,backgroundmin:backgroundmax)')-mean(handles.current_dataD(:,gatemin:gatemax)'))*(gatemax-gatemin+1);
        end
        %     gatemean = abs(mean(handles.current_dataA(:,backgroundmin:backgroundmax)')-mean(handles.current_dataA(:,gatemin:gatemax)'));
        %     for j=1:ceil(nofrecords/nofcycle)
        %         csignalraw(j)=mean(gatedataraw(((nofrepes*nofcycle*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
        %         stdcsignalraw(j)=std(gatedataraw(((nofrepes*nofcycle*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
        %     end
        if filenumber > 1
            adqsignalraw = mean(reshape(gatedataraw,(nofrepes*1),[]),1);%-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
            stdadqsignalraw = std(reshape(gatedataraw,(nofrepes*1),[]),1,1);%*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
            if nofcycle ~= 1
                csignalraw = mean(reshape(adqsignalraw, ceil(nofrecords/nofcycle) ,[])',1);
                stdcsignalraw = std(reshape(adqsignalraw, ceil(nofrecords/nofcycle) ,[])',1,1);
%                 csignalraw = mean(reshape(adqsignalraw(1:(nofrecords-nofrecords/nofcycle)), ceil(nofrecords/nofcycle) ,nofcycle-1)',1); %Give rid of the last iteration
%                 stdcsignalraw = std(reshape(adqsignalraw(1:(nofrecords-nofrecords/nofcycle)), ceil(nofrecords/nofcycle) ,nofcycle-1)',1,1);
%                 csignalraw = mean(reshape(adqsignalraw((nofrecords+1-3*nofrecords/nofcycle):end), ceil(nofrecords/nofcycle) ,nofcycle-1)',1);
%                 stdcsignalraw = std(reshape(adqsignalraw((nofrecords+1-3*nofrecords/nofcycle):end), ceil(nofrecords/nofcycle) ,nofcycle-1)',1,1);
            else
                csignalraw = adqsignalraw;
                stdcsignalraw = stdadqsignalraw;
            end
        else
            csignalraw = mean(reshape(gatedataraw,(nofrepes*nofcycle),[]),1);%-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
            stdcsignalraw = std(reshape(gatedataraw,(nofrepes*nofcycle),[]),1,1);%*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
        end
        gatedata = gatedataraw;%gatedataraw(ind);
        fprintf('The size of ind is\n');
        size (ind)
        fprintf('The size of gatedata after sorting is\n');
        size (gatedata)
        fprintf('The size of gatedata before sorting is\n');
        size (gatedataraw)
        fprintf('nofrecords*nofrepes is\n');
        a=(nofrecords*nofrepes)
        fprintf('The filenumber is %d\n', filenumber);
        if size(ind)~= size(gatedataraw)
            fprintf('The data sort is wrong\n'); 
            errorMessage = sprintf('The data sort is wrong');
            uiwait(warndlg(errorMessage));
        end
        %     for j=1:nofrecords
        %         msignalraw(j,:)=mean(gatedata((nofrepes*j-nofrepes+1):(nofrepes*j)),1);
        %         stdsignalraw(j,:)=std(gatedata((nofrepes*j-nofrepes+1):(nofrepes*j)),1);
        %     end
        msignalraw = mean(reshape(gatedata,nofrepes,[]),1);
        stdsignalraw = std(reshape(gatedata,nofrepes,[]),1,1);
        if nofcycle ~= 1
            msignal = mean(reshape(msignalraw, ceil(nofrecords/nofcycle) ,[])',1);
            stdsignal = std(reshape(msignalraw, ceil(nofrecords/nofcycle) ,[])',1,1);
        else
            msignal = msignalraw;
            stdsignal = stdsignalraw;
        end
        %     msignal = msignalraw;
        %     stdsignal = stdsignalraw;
        laser_shot = (1:length(gatedata))*double(nofwaveforms);
        laser_shot_softave = (1:(length(gatedata)/nofrepes))*double(nofwaveforms*nofrepes);
        %% ask the gate signal mass for input
        prompt = {'Enter mass of gate:'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {'18'};
        gatemass = inputdlg(prompt,dlg_title,num_lines,defaultans);
        mgate = str2double(gatemass);
        %% assign the signal gate and background gate range to worksapce
        assignin('base',sprintf('m_gate%d_signalfrom', mgate),gatemin);
        assignin('base',sprintf('m_gate%d_signalto', mgate),gatemax);
        assignin('base',sprintf('m_gate%d_backgroundfrom', mgate),backgroundmin);
        assignin('base',sprintf('m_gate%d_backgroundto', mgate),backgroundmax);
        assignin('base',sprintf('m_gate%d_msignal', mgate),msignal);
        assignin('base',sprintf('m_gate%d_rawSFG', mgate),gatedataraw);
        %%
        h0 = figure('PaperSize',[8.267716 15.692913]);
        plot(laser_shot, gatedata/61.04);%,'-o','linewidth',2,'markersize',8);
        ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
        xlabel('Desorption laser shots','FontSize',14)%Measurement series','FontSize',14)
        set(gca,'fontsize',20);
        set(h0, 'Position', [80,100,1000,620]);
        set(h0, 'PaperpositionMode', 'auto');
%         if saveps == 1
%             saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'.fig'));
%             export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'.pdf'),'-transparent');
%             saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'.png'));
%         end
        h9 = figure('PaperSize',[8.267716 15.692913]);
        plot(xlabel2,reshape(gatedataraw/61.04,nofrepes*nofcycle,[]),'.','markersize',8);%,'-o','linewidth',2,'markersize',8);
        ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
        xlabel(xname,'FontSize',14)%Measurement series','FontSize',14)
        set(gca,'fontsize',20);
        set(h9, 'Position', [80,100,1000,620]);
        set(h9, 'PaperpositionMode', 'auto');
        h8 = figure('PaperSize',[8.267716 15.692913]);
        plot(laser_shot_softave,msignalraw/61.04,'-o','linewidth',2,'markersize',8);
        ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
        xlabel('Desorption laser shots','FontSize',14)%Measurement series','FontSize',14)
        set(gca,'fontsize',20);
        set(h8, 'Position', [80,100,1000,620]);
        set(h8, 'PaperpositionMode', 'auto');
%         if saveps == 1
%             saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_ave','.fig'));
%             export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_ave','.pdf'),'-transparent');
%             saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_ave','.png'));
%         end
        h3 = figure('PaperSize',[8.267716 15.692913]);
        [fk1,xk1,h1] = ksdensity(gatedataraw);
        [f1,xi1] = ecdf(gatedataraw);
        ecdfhist(f1,xi1,range(gatedataraw)/h1);
        hold on
        plot(xk1,fk1,'r','linewidth',2);
        set(h3, 'Position', [80,100,1000,620]);
        xlabel('Intensiy (a.u.)','FontSize',14)
        ylabel('Probability','FontSize',14)
        set(gca,'fontsize',20);
        if nofwaveforms == 1
            h6 = figure('PaperSize',[8.267716 15.692913]);
            plot(gatedataraw/61.04);%,'-o','linewidth',2,'markersize',8);
            assignin('base',sprintf('gate%d_all', mgate),gatedataraw);
            ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
            xlabel('Desorption laser shots','FontSize',14)%Measurement series','FontSize',14)
            set(gca,'fontsize',20);
            set(h6, 'Position', [80,100,1000,620]);
            set(h6, 'PaperpositionMode', 'auto');
            shot=reshape(laser_shot,nofcycle,[]);
            gatemean50 = mean(reshape(gatedata, nofcycle,[]),1)/61.04;
            h9 = figure('PaperSize',[8.267716 15.692913]);
            bar(shot(nofcycle,:),gatemean50);
            axis tight;
            ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
            xlabel('Desorption laser shots','FontSize',14)
            set(gca,'fontsize',20);
            set(h9, 'Position', [80,100,1000,620]);
            set(h9, 'PaperpositionMode', 'auto');
            unifstd = zeros(1,floor(double(nofrecords*nofrepes)/2));%Uniformity of the samples by checking the standard deviation
            for un = 1:floor(double(nofrecords*nofrepes)/2)
                uni = floor(double(nofrecords*nofrepes)/un);
                unifstd(un) = std(mean(reshape(gatedata(1:un*uni), un, []),1)/61.04,1);
                %             unifave(u) = mean(mean(reshape(gatedata(1:u*uni), u, []),1)/61.04);
            end
            unif = 1:floor(nofrecords*nofrepes/2);
            h10 = figure('PaperSize',[8.267716 15.692913]);
            plot(unif,unifstd,'linewidth',2);%,'-o','linewidth',2,'markersize',8);
            xlabel('Average shots','FontSize',14)
            ylabel('Standard deviation (arb. units)','FontSize',14)
            set(gca,'fontsize',20);
            set(h10, 'Position', [80,100,1000,620]);
            set(h10, 'PaperpositionMode', 'auto');
        else
            h6 = figure('PaperSize',[8.267716 15.692913]);
            plot(linspace(xlabel2(1),xlabel2(length(xlabel2)),length(gatedataraw)),gatedataraw/61.04);%,'-o','linewidth',2,'markersize',8);
            ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);%Intensiy (a.u.)','FontSize',14)
            xlabel(xname,'FontSize',14)%Measurement series','FontSize',14)
            set(gca,'fontsize',20);
            set(h6, 'Position', [80,100,1000,620]);
            set(h6, 'PaperpositionMode', 'auto');
            if saveps == 1
                saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_all','.fig'));
                export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_all','.pdf'),'-transparent');
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_all','.png'));
%                 eval(sprintf('%s_gate%d_all = gatedataraw/61.04; ', figurename, mgate));
                assignin('base',sprintf('m%s_gate%d_all', figurename, mgate),gatedataraw/61.04);
            end
            h1 = figure('PaperSize',[8.267716 15.692913]);
            if xaxis == 1 && length(las) == length(xlabel2)
%                 errorbar(las,msignal/61.04,stdsignal/(61.04*nofcycle),'-o','linewidth',2,'markersize',8);
                errorbar(las,msignal/61.04,stdsignal/(sqrt(nofcycle)*61.04),'-o','linewidth',2,'markersize',8);
                xlabel(xname2,'FontSize',14)
            else
%                 errorbar(xlabel2,msignal/61.04,stdsignal/(61.04*nofcycle),'-o','linewidth',2,'markersize',8);
                errorbar(xlabel2,msignal/61.04,stdsignal/(sqrt(nofcycle)*61.04),'-o','linewidth',2,'markersize',8);
                xlabel(xname,'FontSize',14)
            end
            ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);
            set(gca,'fontsize',20);
            set(h1, 'Position', [80,100,1000,620]);
            set(h1, 'PaperpositionMode', 'auto');
%             if saveps == 1
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.fig'));
%                 export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.pdf'),'-transparent');
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.png'));
%             end
            h7 = figure('PaperSize',[8.267716 15.692913]);
            if xaxis == 1 && length(las) == length(xlabel2)
                errorbar(las,csignalraw/61.04,stdcsignalraw/(sqrt(nofcycle)*61.04),'-o','linewidth',2,'markersize',8);
                xlabel(xname2,'FontSize',14)
            else
                errorbar(xlabel2,csignalraw/61.04,stdcsignalraw/(sqrt(nofcycle)*61.04),'-o','linewidth',2,'markersize',8);
                xlabel(xname,'FontSize',14)
            end
            ylabel(sprintf('Ion yields at %d Da (arb.units)',mgate),'FontSize',14);
            set(gca,'fontsize',20);
            set(h7, 'Position', [80,100,1000,620]);
            set(h7, 'PaperpositionMode', 'auto');
            if saveps == 1
                saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.fig'));
                export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.pdf'),'-transparent');
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan','.png'));
%                 eval(sprintf('%s_gate%d_ave = csignalraw/61.04; ', figurename, mgate));
                assignin('base',sprintf('m%s_gate%d_ave', figurename, mgate),csignalraw/61.04);
%                 eval(sprintf('%s_gate%d_err = stdcsignalraw/61.04; ', figurename, mgate));
                assignin('base',sprintf('m%s_gate%d_err', figurename, mgate),stdcsignalraw/61.04);
            end
            h2 = figure('PaperSize',[8.267716 15.692913]);
            if xaxis == 1 && length(las) == length(xlabel2)
                errorbar(las,msignal,stdsignal/sqrt(nofcycle),'-o','linewidth',2,'markersize',8);
                xlabel(xname2,'FontSize',14)
            else
                errorbar(xlabel2,msignal,stdsignal/sqrt(nofcycle),'-o','linewidth',2,'markersize',8);
                xlabel(xname,'FontSize',14)
            end
            ylabel('Intensiy (a.u.)','FontSize',14)            
            set(gca,'fontsize',20);
            set(h2, 'Position', [80,100,1000,620]);
            set(h2, 'PaperpositionMode', 'auto');
            h5 = figure('PaperSize',[8.267716 15.692913]);
            if xaxis == 1 && length(las) == length(xlabel2)
                plot(las,reshape(msignalraw, ceil(nofrecords/nofcycle) ,[])'/61.04,'-o','linewidth',2,'markersize',8);
                xlabel(xname2,'FontSize',14)
            else
                plot(xlabel2,reshape(msignalraw, ceil(nofrecords/nofcycle) ,[])'/61.04,'-o','linewidth',2,'markersize',8);
                xlabel(xname,'FontSize',14)
            end
            ylabel('Ion Numbers per laser shot','FontSize',14)
            xlabel(xname,'FontSize',14)
            set(gca,'fontsize',20);
            set(h5, 'Position', [80,100,1000,620]);
            set(h5, 'PaperpositionMode', 'auto');
%             if saveps == 1
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%dDa',mgate),'_scan_all','.fig'));
%                 export_fig(gcf,strcat(figurename,'_',sprintf('gate_%d',mgate),'_scan_all','.pdf'),'-transparent');
%                 saveas(gcf,strcat(figurename,'_',sprintf('gate_%dDa',mgate),'_scan_all','.png'));
%             end
        end
        if nofcycle ~= 1
            h4 = figure('PaperSize',[8.267716 15.692913]);
            errorbar(repmat(xlabel2,nofcycle,1)',reshape(msignalraw, ceil(nofrecords/nofcycle) ,[])/61.04,reshape(stdsignalraw, ceil(nofrecords/nofcycle) ,[])/61.04,'-o','linewidth',2,'markersize',8);
            ylabel('Ion Numbers per laser shot','FontSize',14)
            xlabel(xname,'FontSize',14)
            set(gca,'fontsize',20);
            set(h4, 'Position', [80,100,1000,620]);
            set(h4, 'PaperpositionMode', 'auto');
        end
    end
else
    errorMessage = sprintf('Please change the dimension to 1D then click plot');
    uiwait(warndlg(errorMessage));
    dimension = 1;
    set(handles.Dimension,'Value',1);
    %                 string_list{1} = '1D';
    %     string_list{2} = '2D';
    %     string_list{3} = '3D';
    %     set(handles.Dimension, 'String', string_list);
    Dimension_Callback(handles.Dimension, eventdata, handles)
end
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)



function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global sliderVal;
global nofrepes;
global slider;
axes(handles.axes1);
%[slider,recordsize] = size(handles.current_dataA);
previous = get(hObject,'String');
% slider = min([m, record]);
if slider > 1;
    %     set(hObject,'Min',1,'Max',slider);
    sliderVal = str2double(previous);
    %     sliderVal    = round(get(hObject,'Value'));
    %show_CreateFcn(hObject, eventdata, handles);
    %sliderStatus = ['View azimuth: ' num2str(sliderVal)];
    %set(handles.textStatus, 'string', sliderStatus)
    %handles.current_data1(sliderVal,:) = adq_data.DataB;
    %global nofrecords;
    %global recordsize;
    if (sliderVal > slider)
        uiwait(warndlg('Valve is out of range','!! Warning !!'));
        %pause;
        set(hObject,'String',num2str(1));
        sliderVal    = 1;
    else if (sliderVal < 1)
            uiwait(warndlg('Valve should be positive','!! Warning !!'));
            % pause;
            set(hObject,'String',num2str(slider))
            sliderVal    = slider;
        else if (isnan(sliderVal))
                uiwait(warndlg('Valve should be number','!! Warning !!'));
                % pause;
                set(hObject,'String',num2str(slider))
                sliderVal    = slider;
            end
        end
    end
    %     t=0:1/(bandwith):(recordsize-1)/(bandwith);
    %     m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
    %     n = 1:recordsize;
    %     switch xlabelmod
    %         case 1
    %             x = t;
    %             xname = 'Time (\mus)';
    %         case 2
    %             x = n;
    %             xname = 'Record Number';
    %         case 3
    %             x = m;
    %             xname = 'm/q (Da)';
    %     end
    %     switch ylabelmod
    %         case 1
    %             yname = 'Intensity (arb. units)';
    %         case 2
    %             yname = 'Voltage (mV)';
    %     end
    set(handles.previous,'string',sprintf('%d',sliderVal));
    set(handles.show,'value',sliderVal);
    set(handles.textStatus, 'String', sprintf('\nStep number = %d\nRepetition number = %d',(floor((sliderVal-1)/nofrepes)+1),rem((sliderVal-1),nofrepes)+1));
    %handles.current_data2(sliderVal,:) = adq_data.DataD;
    % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
    % legend('channelB','channelD');
    %     if isChannelA == 1;
    %         legA = 'on';
    %     else
    %         legA = 'off';
    %     end
    %     h(1) = plot(x,handles.current_dataA(sliderVal,:),'r','DisplayName','ChannelA','visible',legA);
    %     %    legend('-DynamicLegend');
    %     hold all;
    %     if isChannelB == 1;
    %         legB = 'on';
    %     else
    %         legB = 'off';
    %     end
    %     h(2) = plot(x,handles.current_dataB(sliderVal,:),'g','DisplayName','ChannelB','visible',legB);
    %     if isChannelC == 1;
    %         legC = 'on';
    %     else
    %         legC = 'off';
    %     end
    %     h(3) = plot(x,handles.current_dataC(sliderVal,:),'b','DisplayName','ChannelC','visible',legC);
    %     if isChannelD == 1;
    %         legD = 'on';
    %     else
    %         legD = 'off';
    %     end
    %     h(4) = plot(x,handles.current_dataD(sliderVal,:),'m','DisplayName','ChannelD','visible',legD);
    %     %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
    %     %legend('channelB','channelD');
    %     %refresh_legend;
    %     hold off;
    %     ymin = get(handles.ymin,'String');
    %     ymax = get(handles.ymax,'String');
    %     ylim([str2double(ymin), str2double(ymax)]);
    %     xmin = get(handles.xmin,'String');
    %     xmax = get(handles.xmax,'String');
    %     ylim([str2double(xmin), str2double(xmax)]);
    %     xlabel(xname)%,'FontSize',20)
    %     ylabel(yname)%,'FontSize',20)
    %     grid on;
    %     refresh_legend;
    show_Callback(handles.show, eventdata, handles)
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of previous as text
%        str2double(get(hObject,'String')) returns contents of previous as a double


% --- Executes during object creation, after setting all properties.
function previous_CreateFcn(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ylabelopt.
function ylabelopt_Callback(hObject, eventdata, handles)
% hObject    handle to ylabelopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recordsize;
global xlabelmod;
global ylabelmod;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
% global enter_flag;
% enter_flag = 0;
%global sliderVal;
val = get(hObject,'Value');
str = get(hObject, 'String');
%axes(handles.axes1);
% t = 0:1/(2000):(double(recordsize)-1)/(2000);
% m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
% n = 1:recordsize;
% channelA = get(h(1),'Ydata');
% channelB = get(h(2),'Ydata');
% channelC = get(h(3),'Ydata');
% channelD = get(h(4),'Ydata');
% switch xlabelmod
%     case 1
%         x = t;
%         xname = 'Time (\mus)';
%     case 2
%         x = n;
%         xname = 'Record Number';
%     case 3
%         x = m;
%         xname = 'm/q (Da)';
% end
switch str{val};
    case 'Intensity' % User selects peaks.
        %   handles.current_data = handles.peaks;
        %   set(handles.textStatus, 'String', 'Peaks button pushed')
        ylabelmod = 1;
        %         yname = 'Intensity (arb. units)';
        %         if isChannelA == 1;
        %             legA = 'on';
        %         else
        %             legA = 'off';
        %         end
        %         h(1) = plot(handles.axes1,x,channelA,'r','DisplayName','ChannelA','visible',legA);
        %         %    legend('-DynamicLegend');
        %         hold all;
        %         if isChannelB == 1;
        %             legB = 'on';
        %         else
        %             legB = 'off';
        %         end
        %         h(2) = plot(handles.axes1,x,channelB,'g','DisplayName','ChannelB','visible',legB);
        %         if isChannelC == 1;
        %             legC = 'on';
        %         else
        %             legC = 'off';
        %         end
        %         h(3) = plot(handles.axes1,x,channelC,'b','DisplayName','ChannelC','visible',legC);
        %         if isChannelD == 1;
        %             legD = 'on';
        %         else
        %             legD = 'off';
        %         end
        %         h(4) = plot(handles.axes1,x,channelD,'m','DisplayName','ChannelD','visible',legD);
        %         %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %         %legend('channelB','channelD');
        %         refresh_legend;
        %         hold off;
        %         xlabel(xname)%,'FontSize',20)
        %         ylabel(yname)%,'FontSize',20)
        %         grid on;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Y label changes to intensity')
    case 'Voltage' % User selects membrane.
        %   handles.current_data = handles.membrane;
        %   set(handles.textStatus, 'String', 'Membrane button pushed')
        % leveltrig_settings;
        ylabelmod = 2;
        %         yname = 'Voltage (mV)';
        %         if isChannelA == 1;
        %             legA = 'on';
        %         else
        %             legA = 'off';
        %         end
        %         h(1) = plot(handles.axes1,x,channelA/3.3659,'r','DisplayName','ChannelA','visible',legA);
        %         %    legend('-DynamicLegend');
        %         hold all;
        %         if isChannelB == 1;
        %             legB = 'on';
        %         else
        %             legB = 'off';
        %         end
        %         h(2) = plot(handles.axes1,x,channelB/3.3659,'g','DisplayName','ChannelB','visible',legB);
        %         if isChannelC == 1;
        %             legC = 'on';
        %         else
        %             legC = 'off';
        %         end
        %         h(3) = plot(handles.axes1,x,channelC/3.3659,'b','DisplayName','ChannelC','visible',legC);
        %         if isChannelD == 1;
        %             legD = 'on';
        %         else
        %             legD = 'off';
        %         end
        %         h(4) = plot(handles.axes1,x,channelD/3.3659,'m','DisplayName','ChannelD','visible',legD);
        %         %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %         %legend('channelB','channelD');
        %         refresh_legend;
        %         hold off;
        %         xlabel(xname)%,'FontSize',20)
        %         ylabel(yname)%,'FontSize',20)
        %         grid on;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Y label changes to voltage')
        %     case 'Mass' % User selects sinc.
        %         %  handles.current_data = handles.sinc;
        %         %   set(handles.textStatus, 'String', 'Sinc button pushed')
        %         xlabelmod = 3;
        %         xlabel_mode;
        %         %     pause(1)
        %         while (enter_flag == 0)
        %             set(handles.textStatus, 'String', 'Please type the calibrated mass parameters, then click enter button')
        %             pause(0.1)
        %         end
        %         m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        %         switch xlabelmod
        %             case 1
        %                 x = t;
        %                 yname = 'Time (\mus)';
        %             case 2
        %                 x = n;
        %                 yname = 'Record Number';
        %             case 3
        %                 x = m;
        %                 yname = 'm/q (Da)';
        %         end
        %         if isChannelA == 1;
        %             legA = 'on';
        %         else
        %             legA = 'off';
        %         end
        %         h(1) = plot(handles.axes1,x,channelA,'r','DisplayName','ChannelA','visible',legA);
        %         %    legend('-DynamicLegend');
        %         hold (handles.axes1, 'all');
        %         if isChannelB == 1;
        %             legB = 'on';
        %         else
        %             legB = 'off';
        %         end
        %         h(2) = plot(handles.axes1,x,channelB,'g','DisplayName','ChannelB','visible',legB);
        %         if isChannelC == 1;
        %             legC = 'on';
        %         else
        %             legC = 'off';
        %         end
        %         h(3) = plot(handles.axes1,x,channelC,'b','DisplayName','ChannelC','visible',legC);
        %         if isChannelD == 1;
        %             legD = 'on';
        %         else
        %             legD = 'off';
        %         end
        %         h(4) = plot(handles.axes1,x,channelD,'m','DisplayName','ChannelD','visible',legD);
        %         %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %         %legend('channelB','channelD');
        %
        %         hold (handles.axes1, 'off');
        %         ymin = get(handles.ymin,'String');
        %         ymax = get(handles.ymax,'String');
        %         ylim(handles.axes1,[str2double(ymin), str2double(ymax)]);
        %         xlabel(handles.axes1,yname)%,'FontSize',20)
        %         ylabel(handles.axes1,'Intensity (arb.units)')%,'FontSize',20)
        %         grid (handles.axes1, 'on');
        %         refresh_legend;
        %         set(handles.textStatus, 'String', 'X label changes to mass')
        %         %         xlabel_mode;
        
end
% ymin = get(handles.ymin,'String');
% ymax = get(handles.ymax,'String');
% ylim([str2double(ymin), str2double(ymax)]);
% xmin = get(handles.xmin,'String');
% xmax = get(handles.xmax,'String');
% xlim([str2double(xmin), str2double(xmax)]);
% Hints: contents = cellstr(get(hObject,'String')) returns ylabelopt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ylabelopt


% --- Executes during object creation, after setting all properties.
function ylabelopt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylabelopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Dimension.
function Dimension_Callback(hObject, eventdata, handles)
% hObject    handle to Dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dimension;
global enter_flag;
global channel_show;
global coincidence;
enter_flag = 0;
string_list{1} = 'Channel A';
string_list{2} = 'Channel B';
string_list{3} = 'Channel C';
string_list{4} = 'Channel D';
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
    case '1D show'
        dimension = 1;
        %         coincidence = 0;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Dimension changes to 1D')
    case '1D software average show'
        dimension = 2;
        %         coincidence = 0;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Dimension changes to 1D with software averaging')
    case '1D scan show'
        dimension = 3;
        %         coincidence = 0;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Dimension changes to 1D with scan averaging')
    case 'Software average 2D show'
        dimension = 4;
        show2D;
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please selected channel to show, then click enter button')
            pause(0.1)
        end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
        end
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', sprintf('Dimension changes to 2D-1\n %s is selected', string_list{channel_show}))
    case 'Iteration scan show'
        dimension = 5;
        show2D;
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please selected channel to show, then click enter button')
            pause(0.1)
        end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
        end
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', sprintf('Dimension changes to 2D-2\n %s is selected', string_list{channel_show}))
    case 'Iteration show'
        dimension = 6;
        show2D;
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please selected channel to show, then click enter button')
            pause(0.1)
        end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
        end
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', sprintf('Dimension changes to 2D-3\n %s is selected', string_list{channel_show}))
    case '3D show'
        dimension = 7;
        show2D;
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please select the channel to show, then click enter button')
            pause(0.1)
        end
        %         set(handles.textStatus, 'String', strcat(sprintf(string_list{channel_show}),' is selected'))
        switch channel_show
            case 1
                set(handles.ChannelA, 'Value', 1);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 2
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 1);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 0);
            case 3
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 1);
                set(handles.ChannelD, 'Value', 0);
            case 4
                set(handles.ChannelA, 'Value', 0);
                set(handles.ChannelB, 'Value', 0);
                set(handles.ChannelC, 'Value', 0);
                set(handles.ChannelD, 'Value', 1);
        end
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', sprintf('Dimension changes to 3D\n %s is selected', string_list{channel_show}))
end
% Hints: contents = cellstr(get(hObject,'String')) returns Dimension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dimension


% --- Executes during object creation, after setting all properties.
function Dimension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axisauto.
function axisauto_Callback(hObject, eventdata, handles)
% hObject    handle to axisauto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global coincidence;
ispushed = get(handles.axisauto,'Value');
if ispushed
    coincidence = 1;
    set(handles.textStatus, 'string', sprintf('Axis auto is on'))
    %     set(handles.axisauto, 'string', 'Axis manual')
    axis(handles.axes1,'auto');
else
    coincidence = 0;
    set(handles.textStatus, 'string', 'Axis manual is on')
    %     set(handles.axisauto, 'string', 'Axis Auto')
end
%     show_Callback(handles.show, eventdata, handles)
%     set(handles.textStatus, 'String', 'Axis auto is on')
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in copyplot.
function copyplot_Callback(hObject, eventdata, handles)
% hObject    handle to copyplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename, pathname] = uiputfile('*.hdf5', 'Save Figure as');
global dimension;
global machename;
global step;
global nofrecords;
global nofcycle;
global saveps; % save figure or not
global figurename; %Hdf5 file name
global slider;
global las;%extetrnal X label
global xaxis;%Enable external X label or not (Yscan)
global pgate;
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
set(Fig2, 'Position', [80,100,1000,620]);
set(Fig2, 'color', 'w');
if dimension == 3 && saveps == 1
    filename = strcat(figurename,'_scan','.gif');
    if strcmp(machename,'Channel.A')
        xlabel2 = 50e3-step;
        xname = 'Delay between fs laser and ns laser at %g \\mus';
        xname2 = 'Delay between fs laser and ns laser at %g \\mus';
    else if strcmp(machename,'vertical')
            xlabel2 = step;
            xname = 'ns laser vertical scanning (mm)';
        else if strcmp(machename,'Channel.B')
                xlabel2 = step;
                xname = 'Delay between flshlamp and Q-switch at %g \\mus';
                xname2 = 'Desorption laser energy at %2.2f mJ';
            else
                xlabel2 = 1:ceil(nofrecords/nofcycle) ;
                xname = 'Measurement series';
                xname2 = 'Ionisation laser power at %g mW';
            end
        end
    end
    for n = 1:1:slider
        delete(findall(findall(Fig2,'Type','axe')));%,'Type','text'))
        set(handles.previous,'string',sprintf('%d',n));
        previous_Callback(handles.previous, eventdata, handles)
        new_axes = copyobj(handles.axes1, Fig2);
        set(new_axes, 'Units', 'Normalized', 'Position', [0.15, 0.15, 0.75, 0.75]);
        grid(new_axes, 'off')
        set(new_axes,'fontsize',20);
        hay = get(new_axes,'Ylabel');
        hax = get(new_axes,'Xlabel');
        NewFontSize = 20;
        set(hay,'Fontsize',NewFontSize);
        set(hax,'Fontsize',NewFontSize);
        set(Fig2, 'PaperpositionMode', 'auto');
        hgca = findobj(Fig2,'Type','line','visible','on');
        set(hgca,'Color','b');
        ylim(new_axes,'auto');
        if xaxis == 1 && length(las) == length(xlabel2)
            %             title(new_axes,strcat(sprintf('Desorption laser energy at %2.2f',las(n)),{' '},'mJ'));
            title(new_axes,sprintf(xname2,las(n)));
        else
            %             title(new_axes,strcat(xname,{' '},sprintf('at %d',xlabel2(n))));
            title(new_axes,sprintf(xname,xlabel2(n)));
        end
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [A,map] = rgb2ind(im,256);
        if n == 1;
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1);
        end
    end
else
    new_axes = copyobj(handles.axes1, Fig2);
    % set(new_axes,'Parent',Fig2);
    % set(new_axes,'Position',[0 0 1 1]);
    set(new_axes, 'Units', 'Normalized', 'Position', [0.15, 0.15, 0.75, 0.75]);
    set(Fig2, 'Position', [80,100,1000,620]);
    grid(new_axes, 'off')
    set(new_axes,'fontsize',20);
    hay = get(new_axes,'Ylabel');
    hax = get(new_axes,'Xlabel');
    NewFontSize = 20;
    set(hay,'Fontsize',NewFontSize);
    set(hax,'Fontsize',NewFontSize);
    set(Fig2, 'PaperpositionMode', 'auto');
end
% axis(new_axes,'tight');
% hgsave(Fig2, 'myFigure.fig');


% --- Executes on button press in average.
function average_Callback(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nofrecords;
global nofrepes;
global recordsize;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global coincidence;
global bandwith;
if nofrecords*nofrepes <= 1
    errorMessage = sprintf('The nofrecords and nofrepes are 1');
    uiwait(warndlg(errorMessage));
else
    t=0:1/(bandwith):(recordsize-1)/(bandwith);
    m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
    n = 1:recordsize;
    switch xlabelmod
        case 1
            x = t;
            xname = 'Time (\mus)';
        case 2
            x = n;
            xname = 'Record Number';
        case 3
            x = m;
            xname = 'm/q (Da)';
        case 4
            x = handles.x;
            xname = 'SFG Wavelength (nm)';
        case 5
            x = 1240./handles.x;
            xname = 'SFG Photon Energy (eV)';  
        case 6
            x = 1240./(1240./handles.x-1240./mass_calibrate);
            xname = 'IR Wavelength (nm)';  
        case 7
            x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
            xname = 'Wavenumber (cm^{-1})'; 
    end
    switch ylabelmod
        case 1
            yname = 'Intensity (arb. units)';
        case 2
            yname = 'Voltage (mV)';
    end
    if isChannelA == 1;
        legA = 'on';
    else
        legA = 'off';
    end
    if ylabelmod == 1;
        h(1) = plot(x,mean(handles.current_dataA),'r','DisplayName','ChannelA','visible',legA);
    else
        h(1) = plot(x,mean(handles.current_dataA)/3.3659,'r','DisplayName','ChannelA','visible',legA);
    end
    %    legend('-DynamicLegend');
    hold all;
    if isChannelB == 1;
        legB = 'on';
    else
        legB = 'off';
    end
    if ylabelmod == 1
        h(2) = plot(x,mean(handles.current_dataB),'g','DisplayName','ChannelB','visible',legB);
    else
        h(2) = plot(x,mean(handles.current_dataB)/3.3659,'g','DisplayName','ChannelB','visible',legB);
    end
    if isChannelC == 1;
        legC = 'on';
    else
        legC = 'off';
    end
    if ylabelmod == 1
        h(3) = plot(x,mean(handles.current_dataC),'b','DisplayName','ChannelC','visible',legC);
    else
        h(3) = plot(x,mean(handles.current_dataC)/3.3659,'b','DisplayName','ChannelC','visible',legC);
    end
    if isChannelD == 1;
        legD = 'on';
    else
        legD = 'off';
    end
    if ylabelmod == 1
        h(4) = plot(x,mean(handles.current_dataD),'m','DisplayName','ChannelD','visible',legD);
    else
        h(4) = plot(x,mean(handles.current_dataD)/3.3659,'m','DisplayName','ChannelD','visible',legD);
    end
    %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
    %legend('channelB','channelD');
    %refresh_legend;
    hold off;
    if coincidence == 0
        ymin = get(handles.ymin,'String');
        ymax = get(handles.ymax,'String');
        ylim([str2double(ymin), str2double(ymax)]);
        xmin = get(handles.xmin,'String');
        xmax = get(handles.xmax,'String');
        xlim([str2double(xmin), str2double(xmax)]);
    else
        axis tight;
    end
    xlabel(xname)%,'FontSize',20)
    ylabel(yname)%,'FontSize',20)
    grid on;
    refresh_legend;
    set(handles.textStatus, 'string', sprintf('Averaged all of traces'))
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logo


% --- Executes during object creation, after setting all properties.
function average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on Dimension and none of its controls.
function Dimension_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Dimension (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function cmax_Callback(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cmax = get(hObject,'String');
cmin = get(handles.cmin,'String');
newCLim = [str2double(cmin), str2double(cmax)];
if any(isnan(newCLim)) || str2double(cmin)>= str2double(cmax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.cmax,'String', '0')
else
    set(handles.axes1,  'CLim', newCLim);
end
% Hints: get(hObject,'String') returns contents of cmax as text
%        str2double(get(hObject,'String')) returns contents of cmax as a double


% --- Executes during object creation, after setting all properties.
function cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cmin_Callback(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cmin = get(hObject,'String');
cmax = get(handles.cmax,'String');
newCLim = [str2double(cmin), str2double(cmax)];
if any(isnan(newCLim)) || str2double(cmin)>= str2double(cmax)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    set(handles.cmin,'String', '-50')
else
    set(handles.axes1,  'CLim', newCLim);
end
% Hints: get(hObject,'String') returns contents of cmin as text
%        str2double(get(hObject,'String')) returns contents of cmin as a double


% --- Executes during object creation, after setting all properties.
function cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samplerate_Callback(hObject, eventdata, handles)
% hObject    handle to samplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bandwith;
samplerate = get(hObject,'String');
bandwith = str2double(samplerate);
show_Callback(handles.show, eventdata, handles)
set(handles.textStatus, 'string', sprintf('Sample rate changes to %d MHz',bandwith));

% Hints: get(hObject,'String') returns contents of samplerate as text
%        str2double(get(hObject,'String')) returns contents of samplerate as a double


% --- Executes during object creation, after setting all properties.
function samplerate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in psave.
function psave_Callback(hObject, eventdata, handles)
% hObject    handle to psave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global saveps
saveps = get(hObject,'Value');
if saveps == 1
    set(handles.textStatus, 'string', sprintf('Save gate plotted data'));
else
    set(handles.textStatus, 'string', sprintf('Donot save gate plotted data'));
end
% Hint: get(hObject,'Value') returns toggle state of psave


% --- Executes during object deletion, before destroying properties.
function psave_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to psave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yscan.
function yscan_Callback(hObject, eventdata, handles)
% hObject    handle to yscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xaxis
xaxis = get(hObject,'Value');
if xaxis == 1
    set(handles.textStatus, 'string', sprintf('Plot with external value'));
else
    set(handles.textStatus, 'string', sprintf('Plot with internal value'));
end
% Hint: get(hObject,'Value') returns toggle state of yscan


% --- Executes on button press in pgate.
function pgate_Callback(hObject, eventdata, handles)
% hObject    handle to pgate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pgate
pgate = get(hObject,'Value');
if pgate == 1
    set(handles.textStatus, 'string', sprintf('Gate with external input'));
else
    set(handles.textStatus, 'string', sprintf('Gate with cursor value'));
end
% Hint: get(hObject,'Value') returns toggle state of pgate


% --------------------------------------------------------------------
function menu_open_spe_individual_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open_spe_individual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global recordsize;
global nofrecords;
global nofcycle;
global sliderVal;
global nofwaveforms;
global selected_trigger;
global nofrepes;
global machename;
global step;
global ind;
global figurename;
global filenumber;
global settings;
answer = questdlg('Would you like to substract the background and normalize the spectrum?', ...
    'Substraction Menu', ...
    'Subtract and normalize','Subtract background only','No','No');
% Handle response
switch answer
    case 'Subtract and normalize'
        sub = 2;
        uiwait(msgbox('Please select the data background file','Select'));
        [filenameall, pathname] = uigetfile({'*.spe;*.h5;*.jdx;*.txt;*.csv;*.tif;*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'spe')
            datbkg = loadSPE(file);
            handles.backg = mean(squeeze(datbkg.int),2)';
        elseif strcmp(filename(dot+1:end), 'csv')
            datbkg = readmatrix(file);
            handles.backg = mean(squeeze(datbkg(:,2)),2)';%data in a row
        elseif strcmp(filename(dot+1:end), 'h5')
            bkgdata_all = double(h5read(file,'/Data/Camera/Image ROI1'));
            if length(size(squeeze(bkgdata_all))) == 2
                handles.backg = mean(squeeze(bkgdata_all));
            else
                [~, ~, bkgsize] = size(squeeze(bkgdata_all));
                handles.backg = mean(reshape(squeeze(bkgdata_all),[],bkgsize));
            end            
        else
            uiwait(warndlg(sprintf('Error: Not the background spe file')));
        end
        uiwait(msgbox('Please select the reference file','Select'));
        [filenameall, pathname] = uigetfile({'*.spe;*.h5;*.jdx;*.txt;*.csv;*.tif;*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'spe')
            datnor = loadSPE(file);
            if length(size(datnor.int)) == 2
                handles.datnor = datnor.int;
            else
                handles.datnor = (mean(squeeze(datnor.int),2))';
            end    
        elseif strcmp(filename(dot+1:end), 'csv')
            datnor = readmatrix(file);
            if length(size(datnor)) == 2
                handles.datnor = datnor(:,2)';
            else
                handles.datnor = (mean(squeeze(datnor(:,2:end)),2))';
            end      
        elseif strcmp(filename(dot+1:end), 'h5')
            bkgdata_all = double(h5read(file,'/Data/Camera/Image ROI1'));
            if length(size(squeeze(bkgdata_all))) == 2
                handles.datnor = mean(squeeze(bkgdata_all));
            else
                [~, ~, bkgsize] = size(squeeze(bkgdata_all));
                handles.datnor = mean(reshape(squeeze(bkgdata_all),[],bkgsize));
            end                
        else
            uiwait(warndlg(sprintf('Error: Not the spe file')));
        end
        uiwait(msgbox('Please select the reference file background','Select'));
        [filenameall, pathname] = uigetfile({'*.spe;*.h5;*.jdx;*.txt;*.csv;*.tif;*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'spe')
            norbkg = loadSPE(file);
            if length(size(norbkg.int)) == 2
                handles.nor = handles.datnor - norbkg.int;
            else
                handles.nor = handles.datnor - (mean(squeeze(norbkg.int),2))';%data in row
            end   
        elseif strcmp(filename(dot+1:end), 'csv')
            norbkg = readmatrix(file);
            if length(size(norbkg)) == 2
                handles.nor = handles.datnor - norbkg(:,2)';%data in row
            else
                handles.nor = handles.datnor - (mean(squeeze(norbkg(:,2:end)),2))';
            end   
        elseif strcmp(filename(dot+1:end), 'h5')
            bkgdata_all = double(h5read(file,'/Data/Camera/Image ROI1'));
            if length(size(squeeze(bkgdata_all))) == 2
                backg = mean(squeeze(bkgdata_all));
                handles.nor = handles.datnor-backg;
            else
                [~, ~, bkgsize] = size(squeeze(bkgdata_all));
                backg = mean(reshape(squeeze(bkgdata_all),[],bkgsize));
                handles.nor = handles.datnor-backg;
            end                
        else
            uiwait(warndlg(sprintf('Error: Not the background spe file')));
        end
    case 'Subtract background only'
        sub = 1;
        uiwait(msgbox('Please select the background file','Select'));
        [filenameall, pathname] = uigetfile({'*.spe;*.h5;*.jdx;*.txt;*.csv;*.tif;*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'spe')
            datbkg = loadSPE(file);
            handles.backg = (mean(squeeze(datbkg.int),2))';
        elseif strcmp(filename(dot+1:end), 'csv')
            datbkg = readmatrix(file);
            handles.backg = (mean(squeeze(datbkg(:,2:end)),2))';    
        elseif strcmp(filename(dot+1:end), 'h5')
            bkgdata_all = double(h5read(file,'/Data/Camera/Image ROI1'));
            if length(size(squeeze(bkgdata_all))) == 2
                handles.backg = mean(squeeze(bkgdata_all));
            else
                [~, ~, bkgsize] = size(squeeze(bkgdata_all));
                handles.backg = mean(reshape(squeeze(bkgdata_all),[],bkgsize));
            end                
        else
            uiwait(warndlg(sprintf('Error: Not the background bin file')));
        end
    case 'No'
        sub = 0;
        disp('Donot substract the background.')
end
uiwait(msgbox('Please select the data file','Select'));
[filenameall, pathname] = uigetfile({'*.spe;*.h5;*.jdx;*.txt;*.csv;*.tif;*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if ~isnumeric(filenameall)
    clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        filenumber = length(filenameall);
        channel = {'Channel A','Channel B','Channel C','Channel D'};
        fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
        handles = rmfield(handles,fields);
        if ismember('Channel A',channel)
            isChannelA = 1;
        else
            isChannelA = 0;
        end
        if ismember('Channel B',channel)
            isChannelB = 1;
        else
            isChannelB = 0;
        end
        if ismember('Channel C',channel)
            isChannelC = 1;
        else
            isChannelC = 0;
        end
        if ismember('Channel D',channel)
            isChannelD = 1;
        else
            isChannelD = 0;
        end
        set(handles.ChannelA, 'Value', isChannelA);
        set(handles.ChannelB, 'Value', isChannelB);
        set(handles.ChannelC, 'Value', isChannelC);
        set(handles.ChannelD, 'Value', isChannelD);
        handles.current_dataA = [];
        handles.current_dataB = [];
        handles.current_dataC = [];
        handles.current_dataD = [];
        attA = [];
        for i = 1:filenumber %length(filenameall)
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);
            [dataA, dataB, dataC, dataD, attdata] = getdata(filename, file, dot,i);
            handles.current_dataA = [handles.current_dataA',dataA']';
            handles.current_dataB = [handles.current_dataB',dataB']';
            handles.current_dataC = [handles.current_dataC',dataC']';
            handles.current_dataD = [handles.current_dataD',dataD']';
            %             attA = [attA,attdata];
        end        
        handles.x = dataA;
        %         [~,ind] = sort(attA);
        nofrepes = 1;
        nofcycle = length(filenameall);% iteration number
        nofrecords = nofrecords*nofcycle; %length(info.Groups); % measurement number = step number * cycle number
        %         ind = 1:nofrecords;
        step = 1:nofrecords;
        sliderVal = 1;
        for i = 1:nofcycle %length(filenameall)
            attdata = i:nofcycle:nofrecords*nofrepes*nofcycle;
            attA = [attA,attdata];
            %                     handles.current_dataD = [handles.current_dataD',(squeeze(spectra_singlecycle(i,:,:)))']';
        end
        [~,ind] = sort(attA);
        % handles.current_dataA = zeros(nofrecords*nofrepes,recordsize);
        handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
        handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
        if sub == 2            
            [fitresult, ~] = splinesmooth((handles.x)', handles.nor);
            handles.snor = (fitresult(handles.x))';
            handles.current_dataD = (reshape(handles.current_dataD,[],recordsize)-repmat(handles.backg,nofrecords,1))./repmat(handles.snor,nofrecords,1);
        elseif sub == 1
            handles.current_dataD = reshape(handles.current_dataD,[],recordsize)-repmat((handles.backg),nofrecords,1);
        else
            handles.current_dataD = reshape(handles.current_dataD,[],recordsize);
        end          
        handles.current_dataA = handles.current_dataD;
        set(handles.show, 'Value', sliderVal);
        show_Callback(handles.show, eventdata, handles);       
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        filenumber = 1;
        %     set(handles.figure1, 'Name', filename);
        %         clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
        if strcmp(filename(dot+1:end), 'mat')
            channeldata = load(file);
            names = fieldnames(channeldata);
            [nofrecords, recordsize] = size(channeldata.(char(names(1,:))));
            nofrepes = 1;
            nofwaveforms = 1;
            nofcycle = 1;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 1;
            isChannelC = 0;
            isChannelD = 1;
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            handles.current_dataA = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = channeldata.(char(names(2,:)));
            handles.current_dataD = channeldata.(char(names(1,:)));
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);
            handles.current_dataA = handles.current_dataD;
        elseif strcmp(filename(dot+1:end), 'spe')
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            dat = loadSPE(file);
            handles.x = dat.wavelength(dat.roix+1:dat.xdim+dat.roix);
            [~, nofframe] = size((squeeze(dat.int))');
            if nofframe == 1
                [nofrecords, recordsize] = size((squeeze(dat.int)));
                if sub == 2
                    [fitresult, ~] = splinesmooth((handles.x)', handles.nor);
                    handles.snor = (fitresult(handles.x))';
                    handles.current_dataD = ((squeeze(dat.int))-handles.backg)./handles.snor;
                elseif sub == 1
                    handles.current_dataD = (squeeze(dat.int))-handles.backg;
                else
                    handles.current_dataD = (squeeze(dat.int));
                end
            else
                [nofrecords, recordsize] = size((squeeze(dat.int))');
                if sub == 2
                    [fitresult, ~] = splinesmooth((handles.x)', handles.nor);
                    handles.snor = (fitresult(handles.x))';
                    handles.current_dataD = ((squeeze(dat.int))'-repmat(handles.backg,nofrecords,1))./repmat(handles.snor,nofrecords,1);
                elseif sub == 1
                    handles.current_dataD = (squeeze(dat.int))'-repmat((handles.backg),nofrecords,1);
                else
                    handles.current_dataD = (squeeze(dat.int))';
                end               
            end
            nofrepes = 1;
            nofwaveforms = dat.accumulations;
            nofcycle = 1;
            step = 1:nofrecords;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 0;
            isChannelC = 0;
            isChannelD = 1;
            handles.current_dataA = handles.current_dataD;
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
            ind = 1:nofrecords;
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);
       elseif strcmp(filename(dot+1:end), 'csv')
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            dat = readmatrix(file);
            handles.x = dat(:,1)'; %Please make sure that the data will be in a row not in column
            [~, nofframe] = size((squeeze(dat(:,2))));
            if nofframe == 1
                [nofrecords, recordsize] = size(squeeze(dat(:,2)'));
                if sub == 2
                    [fitresult, ~] = splinesmooth(datnor(:,1)', handles.nor);
                    handles.snor = (fitresult(handles.x))';
                    handles.current_dataD = (squeeze(dat(:,2))'-handles.backg)./handles.snor;
                elseif sub == 1
                    handles.current_dataD = (squeeze(dat(:,2)))'-handles.backg;
                else
                    handles.current_dataD = (squeeze(dat(:,2)))';
                end
            else
                [nofrecords, recordsize] = size((squeeze(dat(:,2:end)))');
                if sub == 2
                    [fitresult, ~] = splinesmooth(datnor(:,1)', handles.nor);
                    handles.snor = (fitresult(handles.x))';
                    handles.current_dataD = ((squeeze(dat(:,2:end)))'-repmat(handles.backg,nofrecords,1))./repmat(handles.snor,nofrecords,1);
                elseif sub == 1
                    handles.current_dataD = (squeeze(dat(:,2:end)))'-repmat((handles.backg),nofrecords,1);
                else
                    handles.current_dataD = (squeeze(dat(:,2:end)))';
                end               
            end
            nofrepes = 1;
            nofwaveforms = length(dat);
            nofcycle = 1;
            step = 1:nofrecords;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 0;
            isChannelC = 0;
            isChannelD = 1;
            handles.current_dataA = handles.current_dataD;
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
            ind = 1:nofrecords;
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);            
        elseif strcmp(filename(dot+1:end), 'jdx')
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            Jcampstruct = jcampread(file);
            dat = Jcampstruct.Blocks(1); 
            [~, nofframe] = size((squeeze(dat.YData))');
            if nofframe == 1
                [nofrecords, recordsize] = size((squeeze(dat.YData)));
                if sub == 2
                    uiwait(warndlg(sprintf('Error: .jdx does not need to normalize')));
                elseif sub == 1
                    uiwait(warndlg(sprintf('Error: .jdx does not need to subtract background')));
                else
                    handles.current_dataD = (squeeze(dat.YData));
                end
            else
                [nofrecords, recordsize] = size((squeeze(dat.YData))');
                if sub == 2
                    uiwait(warndlg(sprintf('Error: .jdx does not need to normalize')));
                elseif sub == 1
                    uiwait(warndlg(sprintf('Error: .jdx does not need to subtract background')));
                else
                    handles.current_dataD = (squeeze(dat.YData))';
                end               
            end
            nofrepes = 1;
            nofwaveforms = 1;
            nofcycle = 1;
            step = 1:nofrecords;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 0;
            isChannelC = 0;
            isChannelD = 1;
            handles.current_dataA = handles.current_dataD;
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
            handles.x = 1024./(1024./800+1024./(1e7./dat.XData));
            ind = 1:nofrecords;
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);    
        elseif strcmp(filename(dot+1:end), 'txt')
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            handles = rmfield(handles,fields);
            QMSsignal = readtable(file,'FileType','text');
            QMSYdata = QMSsignal{15:end,"Var2"};
            [nofrecords, recordsize] = size(QMSYdata');
            if sub == 2
                uiwait(warndlg(sprintf('Error: .jdx does not need to normalize')));
            elseif sub == 1
                uiwait(warndlg(sprintf('Error: .jdx does not need to subtract background')));
            else
                handles.current_dataD = (QMSYdata');
            end
            nofrepes = 1;
            nofwaveforms = 1;
            nofcycle = 1;
            step = 1:nofrecords;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 0;
            isChannelC = 0;
            isChannelD = 1;
            handles.current_dataA = handles.current_dataD;
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
            handles.x = QMSsignal{15:end,"Var1"};
            ind = 1:nofrecords;
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);             
        elseif strcmp(filename(dot+1:end), 'h5') || strcmp(filename(dot+1:end), 'hdf5') || strcmp(filename(dot+1:end), 'hdf')
            %                 info = h5info(file);
            nofrepes = 1;
            selected_trigger = 2;
            machename = 'None';
            isChannelA = 0;
            isChannelB = 0;
            isChannelC = 0;
            isChannelD = 1;
            handles.current_dataA = [];
            handles.current_dataB = [];
            handles.current_dataC = [];
            handles.current_dataD = [];
            attA = [];
            rawdata_all = double(h5read(file,'/Data/Camera/Image ROI1'));
            accum = squeeze(double(h5read(file,'/Data/Camera/Device Settings/Readout Control/Accumulations')));
            nofwaveforms = accum(1);
            spectra_singlecycle = squeeze(rawdata_all);
            if length(size(spectra_singlecycle)) == 2
                nofcycle = 1;
                [records, recordsize] = size(spectra_singlecycle);
            else
                [nofcycle, records, recordsize] = size(spectra_singlecycle);
            end
            nofrecords = records*nofcycle;
            step = 1:records;
            for i = 1:nofcycle %length(filenameall)
                attdata = i:nofcycle:records*nofrepes*nofcycle;
                attA = [attA,attdata];
                %                     handles.current_dataD = [handles.current_dataD',(squeeze(spectra_singlecycle(i,:,:)))']';
            end
            [~,ind] = sort(attA);
%             handles.current_dataD = reshape(spectra_singlecycle,[],recordsize);
            handles.current_dataA = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataC = zeros(nofrecords*nofrepes,recordsize);
            handles.current_dataB = zeros(nofrecords*nofrepes,recordsize);
            WL_raw = h5read(file,'/Data/Spectrograph/Module Data/ROIs Wavelengths');
            WL_wavelength = WL_raw.Wavelengths;
            WL_data = WL_wavelength(1,1,1,1);
            handles.x = (WL_data{1,1})';
            if sub == 2
                [fitresult, ~] = splinesmooth((handles.x)', handles.nor);
                handles.snor = (fitresult(handles.x))';
                handles.current_dataD = (reshape(spectra_singlecycle,[],recordsize)-repmat(handles.backg,nofrecords,1))./repmat(handles.snor,nofrecords,1);
            elseif sub == 1
                handles.current_dataD = reshape(spectra_singlecycle,[],recordsize)-repmat((handles.backg),nofrecords,1);
            else
                handles.current_dataD = reshape(spectra_singlecycle,[],recordsize);
            end              
            sliderVal = 1;
            set(handles.show, 'Value', sliderVal);
            show_Callback(handles.show, eventdata, handles);
            handles.current_dataA = handles.current_dataD;
        else
            uiwait(warndlg(sprintf('Error: Not the standard data')));
        end
    end
    set(handles.figure1, 'Name', filename);
    figurename = filename(1:(dotall(1)-1));
else
    uiwait(warndlg(sprintf('Error: No file selected')));
end

% --------------------------------------------------------------------
function savework_Callback(hObject, eventdata, handles)
% hObject    handle to savework (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base',sprintf('SFG_YData'),handles.current_dataD);
assignin('base',sprintf('SFG_XData'),handles.x);
set(handles.textStatus, 'String', sprintf('ChannelD data was copied to the workspace'));


% --------------------------------------------------------------------
function menu_plot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_show_all_Callback(hObject, eventdata, handles)
% hObject    handle to menu_show_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nofrecords;
global nofrepes;
global recordsize;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global coincidence;
global bandwith;
t=0:1/(bandwith):(recordsize-1)/(bandwith);
m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
n = 1:recordsize;
switch xlabelmod
    case 1
        x = t;
        xname = 'Time (\mus)';
    case 2
        x = n;
        xname = 'Record Number';
    case 3
        x = m;
        xname = 'm/q (Da)';
    case 4
        x = handles.x;
        xname = 'SFG Wavelength (nm)';
    case 5
        x = 1240./handles.x;
        xname = 'SFG Photon Energy (eV)';
    case 6
        x = 1240./(1240./handles.x-1240./mass_calibrate);
        xname = 'IR Wavelength (nm)';
    case 7
        x = 1e7./(1240./(1240./handles.x-1240./mass_calibrate));
        xname = 'Wavenumber (cm^{-1})';
end
switch ylabelmod
    case 1
        yname = 'Intensity (arb. units)';
    case 2
        yname = 'Voltage (mV)';
end
if isChannelA == 1;
    legA = 'on';
    if ylabelmod == 1;
        plot(x,squeeze(handles.current_dataA),'r','DisplayName','ChannelA','visible',legA);
    else
        plot(x,squeeze(handles.current_dataA)/3.3659,'r','DisplayName','ChannelA','visible',legA);
    end
else
    legA = 'off';
end
%    legend('-DynamicLegend');
hold all;
if isChannelB == 1;
    legB = 'on';
    if ylabelmod == 1
        plot(x,squeeze(handles.current_dataB),'g','DisplayName','ChannelB','visible',legB);
    else
        plot(x,squeeze(handles.current_dataB)/3.3659,'g','DisplayName','ChannelB','visible',legB);
    end
else
    legB = 'off';
end
if isChannelC == 1;
    legC = 'on';
    if ylabelmod == 1
        plot(x,squeeze(handles.current_dataC),'b','DisplayName','ChannelC','visible',legC);
    else
        plot(x,squeeze(handles.current_dataC)/3.3659,'b','DisplayName','ChannelC','visible',legC);
    end
else
    legC = 'off';
end
if isChannelD == 1;
    legD = 'on';
    if ylabelmod == 1
        plot(x,squeeze(handles.current_dataD),'m','DisplayName','ChannelD','visible',legD);
    else
        plot(x,squeeze(handles.current_dataD)/3.3659,'m','DisplayName','ChannelD','visible',legD);
    end
else
    legD = 'off';
end
%plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
%legend('channelB','channelD');
%refresh_legend;
hold off;
if coincidence == 0
    ymin = get(handles.ymin,'String');
    ymax = get(handles.ymax,'String');
    ylim([str2double(ymin), str2double(ymax)]);
    xmin = get(handles.xmin,'String');
    xmax = get(handles.xmax,'String');
    xlim([str2double(xmin), str2double(xmax)]);
else
    axis tight;
end
xlabel(xname)%,'FontSize',20)
ylabel(yname)%,'FontSize',20)
grid on;
% refresh_legend;
set(handles.textStatus, 'string', sprintf('Plot all of traces'))


% --------------------------------------------------------------------
function menu_filtero_Callback(hObject, eventdata, handles)
% hObject    handle to menu_filtero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
promptrange = {'Enter the filter thresholdfactor:'};
dlg_title_gate = 'Filter';
num_range = 1;
defaultansrange = {'8'};
gaterange = inputdlg(promptrange,dlg_title_gate,num_range,defaultansrange);
tfilter = str2double(gaterange);
handles.current_dataD = (filloutliers(handles.current_dataD',"spline","movmean",15,"ThresholdFactor",tfilter))';%(filloutliers(handles.current_dataD',"nearest","mean"))';%filloutliers(handles.current_dataD,"linear");%
show_Callback(handles.show, eventdata, handles);
set(handles.textStatus, 'string', sprintf('Outliers are removed'));


% --------------------------------------------------------------------
function Undofilter_Callback(hObject, eventdata, handles)
% hObject    handle to Undofilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.current_dataD = handles.current_dataA;
show_Callback(handles.show, eventdata, handles);
set(handles.textStatus, 'string', sprintf('Undo the outlier removal'));
