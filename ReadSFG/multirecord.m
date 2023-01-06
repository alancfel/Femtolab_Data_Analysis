function varargout = multirecord(varargin)
% MULTIRECORD MATLAB code for multirecord.fig
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

% Last Modified by GUIDE v2.5 11-Aug-2014 14:16:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @multirecord_OpeningFcn, ...
    'gui_OutputFcn',  @multirecord_OutputFcn, ...
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
function multirecord_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multirecord (see VARARGIN)
% Create the data to plot.
% i=35;
% handles.peaks=peaks(i);
% handles.membrane=membrane;
% [x,y] = meshgrid(-8:.5:8);
% r = sqrt(x.^2+y.^2) + eps;
% sinc = sin(r)./r;
% handles.sinc = sinc;
% Set the current data value.
%handles.current_data1 = zeros(100,35000);
%handles.current_data2 = zeros(100,35000);
%surf(handles.current_data)
% Choose default command line output for multirecord
clc;
%diary('example')
%diary on;
%COMMANDS YOU WANT TO BE SHOWN IN THE COMMAND WINDOW
%disp(array);
% pretty(function);
mex_ADQ ;
% &THEN
%diary off;
%output=fileread('example');
jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
jCmdWin = jDesktop.getClient('Command Window');
jTextArea = jCmdWin.getComponent(0).getViewport.getView;
cwText = char(jTextArea.getText);
%FINALLY
set(handles.textStatus,'string',cwText,'FontSize',20);
% delete('example');%OPTIONAL
folder = fileparts(mfilename('fullpath'));
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
global isDown;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global recordsize;
global nofrecords;
global selected_trigger;
global LvlTrigLevelTwosComp;
global LvlTrigCh;
global LvlTrigEdge;
global xlabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global h;
global sliderVal;
selected_trigger = 1;
nofrecords = 100;
recordsize = 35000;
LvlTrigLevelTwosComp = 2000; %-8192 - 8191
LvlTrigEdge = RISING_EDGE; %RISING_EDGE or FALLING_EDGE
LvlTrigCh = CH_A;
isChannelA = 1;
isChannelB = 1;
isChannelC = 1;
isChannelD = 1;
xlabelmod = 1;
delay_trigger = 0;
mass_calibrate = 18;
time_calibrate = 5;
sliderVal = 1;
handles.current_dataA = zeros(nofrecords,recordsize);
handles.current_dataB = zeros(nofrecords,recordsize);
handles.current_dataC = zeros(nofrecords,recordsize);
handles.current_dataD = zeros(nofrecords,recordsize);
set(handles.ChannelA, 'Value', isChannelA);
set(handles.ChannelB, 'Value', isChannelB);
set(handles.ChannelC, 'Value', isChannelC);
set(handles.ChannelD, 'Value', isChannelD);
set(handles.xlabelopt, 'Value', xlabelmod);
configure;
isDown = 0;
t = 0:1/(1000):(recordsize-1)/(1000);
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
axes(handles.axes1);
if isChannelA == 1;
    legA = 'on';
else
    legA = 'off';
end
h(1) = plot(handles.axes1,x,handles.current_dataA(1,:),'r','DisplayName','ChannelA','visible',legA);
%legend('-DynamicLegend');
hold all;
if isChannelB == 1;
    legB = 'on';
else
    legB = 'off';
end
h(2) = plot(handles.axes1,x,handles.current_dataB(1,:),'g','DisplayName','ChannelB','visible',legB);
if isChannelC == 1;
    legC = 'on';
else
    legC = 'off';
end
h(3) = plot(handles.axes1,x,handles.current_dataC(1,:),'b','DisplayName','ChannelC','visible',legC);
if isChannelD == 1;
    legD = 'on';
else
    legD = 'off';
end
h(4) = plot(handles.axes1,x,handles.current_dataD(1,:),'m','DisplayName','ChannelD','visible',legD);
%plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
%legend('channelB','channelD');
%     refresh_legend;
hold off;
ymin = get(handles.ymin,'String');
ymax = get(handles.ymax,'String');
ylim([str2double(ymin), str2double(ymax)]);
xlabel(xname)%,'FontSize',20)
ylabel('Intensity (arb.units)')%,'FontSize',20)
grid on;
refresh_legend;
% folder = fileparts(mfilename('fullpath'));
% logoname = 'CMI group logo.png';
% Read in a reza's color logo image.
% Prepare the full file name.
% ylim('manual');
handles.output = hObject;
% configure;
%measurement;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multirecord wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multirecord_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%configure;
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Setup.
function Setup_Callback(hObject, eventdata, handles)
% hObject    handle to Setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display surf plot of the currently selected data.
% surf(handles.current_data);

%configure;
%set(handles.textStatus, 'String', 'Parameters are setting, Please wait...');
multirecord_settings;
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
%axes(handles.axes1);
measurement;
set(handles.textStatus, 'String', strcat('Loop numbers: ', num2str(record),sprintf('\nCompleted')))
guidata(hObject, handles);


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data.
%contour(handles.current_data);
eventdataboardid=1;
interface_ADQ('multirecordclose', [], eventdataboardid);
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
% global record;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global sliderVal;
axes(handles.axes1);
[slider,recordsize] = size(handles.current_dataA);
% slider = min([m, record]);
if slider > 1;
    set(hObject,'Min',1,'Max',slider, 'SliderStep',[1/(slider-1) 10/(slider-1)]);
    sliderVal    = round(get(hObject,'Value'));
    %show_CreateFcn(hObject, eventdata, handles);
    %sliderStatus = ['View azimuth: ' num2str(sliderVal)];
    %set(handles.textStatus, 'string', sliderStatus)
    %handles.current_data1(sliderVal,:) = adq_data.DataB;
    %global nofrecords;
    %global recordsize;
    if (sliderVal > slider)
        set(hObject,'Value',1)
        sliderVal    = 1;
    else if (sliderVal < 1)
            set(hObject,'Value',slider)
            sliderVal    = slider;
        end
    end
    
    t = 0:1/(1000):(recordsize-1)/(1000);
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
    set(handles.textStatus, 'String', strcat('Loop numbers: ', num2str(sliderVal)));
    %handles.current_data2(sliderVal,:) = adq_data.DataD;
    % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
    % legend('channelB','channelD');
    if isChannelA == 1;
        legA = 'on';
    else
        legA = 'off';
    end
    h(1) = plot(x,handles.current_dataA(sliderVal,:),'r','DisplayName','ChannelA','visible',legA);
    %    legend('-DynamicLegend');
    hold all;
    if isChannelB == 1;
        legB = 'on';
    else
        legB = 'off';
    end
    h(2) = plot(x,handles.current_dataB(sliderVal,:),'g','DisplayName','ChannelB','visible',legB);
    if isChannelC == 1;
        legC = 'on';
    else
        legC = 'off';
    end
    h(3) = plot(x,handles.current_dataC(sliderVal,:),'b','DisplayName','ChannelC','visible',legC);
    if isChannelD == 1;
        legD = 'on';
    else
        legD = 'off';
    end
    h(4) = plot(x,handles.current_dataA(sliderVal,:),'m','DisplayName','ChannelD','visible',legD);
    %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
    %legend('channelB','channelD');
    hold off;
    ymin = get(handles.ymin,'String');
    ymax = get(handles.ymax,'String');
    ylim([str2double(ymin), str2double(ymax)]);
    xlabel(xname)%,'FontSize',20)
    ylabel('Intensity (arb.units)')%,'FontSize',20)
    grid on;
    refresh_legend;
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
    set(handles.textStatus, 'string', sprintf('Pause. \n Please click "Continue" button or type "c" to continue'))
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
isChannelA = get(hObject,'Value');
if isChannelA
    set(handles.textStatus, 'string', 'Channel A is selected')
    set(h(1),'visible','on')
else
    set(handles.textStatus, 'string', 'Channel A is excluded')
    set(h(1),'visible','off')
end
refresh_legend;
% Hint: get(hObject,'Value') returns toggle state of ChannelA


% --- Executes on button press in ChannelB.
function ChannelB_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelB
global h
isChannelB = get(hObject,'Value');
if isChannelB
    set(handles.textStatus, 'string', 'Channel B is selected')
    set(h(2),'visible','on')
else
    set(handles.textStatus, 'string', 'Channel B is excluded')
    set(h(2),'visible','off')
end
refresh_legend;

% Hint: get(hObject,'Value') returns toggle state of ChannelB


% --- Executes on button press in ChannelC.
function ChannelC_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelC
global h
isChannelC = get(hObject,'Value');
if isChannelC
    set(handles.textStatus, 'string', 'Channel C is selected')
    set(h(3),'visible','on')
else
    set(handles.textStatus, 'string', 'Channel C is excluded')
    set(h(3),'visible','off')
end
refresh_legend;

% Hint: get(hObject,'Value') returns toggle state of ChannelC


% --- Executes on button press in ChannelD.
function ChannelD_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isChannelD
global h
isChannelD = get(hObject,'Value');
if isChannelD
    set(handles.textStatus, 'string', 'Channel D is selected')
    set(h(4),'visible','on')
else
    set(handles.textStatus, 'string', 'Channel D is excluded')
    set(h(4),'visible','off')
end
refresh_legend;

% Hint: get(hObject,'Value') returns toggle state of ChannelD


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function wfa_mode_Callback(hObject, eventdata, handles)
% hObject    handle to wfa_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete(handles.figure1);
Close_Callback(hObject, eventdata, handles)
wfa;


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
global sliderVal;
global selected_trigger;
[filename, pathname] = uigetfile({'*.hdf5';'*.h5'}, 'Open Data');
if filename ~=0;
    dot = regexp(filename,'\.');
    if strcmp(filename(dot+1:end), 'hdf5') || strcmp(filename(dot+1:end), 'h5')
        file = fullfile(pathname, filename);
        info = h5info(file);
        if isfield(info.Groups,'Attributes') && length(info.Groups(1).Attributes)==4
            if isfield(info.Groups(1).Attributes,'Value')
                samplerate = info.Groups(1).Attributes(1).Value;
                if samplerate == 1e+09
                    string_list{1} = 'Software';
                    string_list{2} = 'External';
                    string_list{3} = 'Level';
                    string_list{4} = 'Internal';
                    recordsize = info.Groups(1).Attributes(3).Value;
                    nofrecords = info.Groups(1).Attributes(2).Value;
                    selected_trigger = find(strcmp(string_list,info.Groups(1).Attributes(4).Value));
                    channel = cellstr(cat(1,info.Groups(1).Datasets.Name));
                    fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
                    handles = rmfield(handles,fields);
                    if ismember('Channel_A',channel)
                        isChannelA = 1;
                    else
                        isChannelA = 0;
                        handles.current_dataA = zeros(nofrecords,recordsize);
                    end
                    if ismember('Channel_B',channel)
                        isChannelB = 1;
                    else
                        isChannelB = 0;
                        handles.current_dataB = zeros(nofrecords,recordsize);
                    end
                    if ismember('Channel_C',channel)
                        isChannelC = 1;
                    else
                        isChannelC = 0;
                        handles.current_dataC = zeros(nofrecords,recordsize);
                    end
                    if ismember('Channel_D',channel)
                        isChannelD = 1;
                    else
                        isChannelD = 0;
                        handles.current_dataD = zeros(nofrecords,recordsize);
                    end
                    set(handles.ChannelA, 'Value', isChannelA);
                    set(handles.ChannelB, 'Value', isChannelB);
                    set(handles.ChannelC, 'Value', isChannelC);
                    set(handles.ChannelD, 'Value', isChannelD);
                    for i = 1:nofrecords
                        if isChannelA == 1;
                            dataA = h5read(file,strcat('/',num2str(i),'/Channel_A'));
                            handles.current_dataA(i,:) = dataA(2,:);
                        end
                        if isChannelB == 1;
                            dataB = h5read(file,strcat('/',num2str(i),'/Channel_B'));
                            handles.current_dataB(i,:) = dataB(2,:);
                        end
                        if isChannelC == 1;
                            dataC = h5read(file,strcat('/',num2str(i),'/Channel_C'));
                            handles.current_dataC(i,:) = dataC(2,:);
                        end
                        if isChannelD == 1;
                            dataD = h5read(file,strcat('/',num2str(i),'/Channel_D'));
                            handles.current_dataD(i,:) = dataD(2,:);
                        end
                    end
                    sliderVal = 1;
                    set(handles.show, 'Value', sliderVal);
                    show_Callback(handles.show, eventdata, handles)
                else
                    uiwait(warndlg(sprintf('Error: Not the multirecord data \n It might be the waveform average data')));
                end
            else
                uiwait(warndlg(sprintf('Error: Not the right type data \n It might be the other hdf5 data')));
            end
        else
            uiwait(warndlg(sprintf('Error: Not the right type data \n The data were not generated by this software')));
        end
    else
        uiwait(warndlg(sprintf('Error: Not the standard hdf5 data')));
    end
    % else
    %     uiwait(warndlg(sprintf('Error: No file selected')));
end

% --------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global nofwaveforms;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global selected_trigger;
[filename, pathname] = uiputfile('*.hdf5', 'Save Data as');
if filename ~=0;
    file = fullfile(pathname, filename);
    [loops,nofsamples] = size(handles.current_dataA);
    t=0:1/(1000):(nofsamples-1)/(1000);
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
        for i = 1:loops
            %         fileID = H5F.create(file,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
            %         dataspaceID = H5S.create_simple(2, [2, nofsamples], []);
            %         datatypeID = H5T.copy('H5T_NATIVE_DOUBLE');
            %         datasetID = H5D.create(fileID,strcat('/',num2str(i),'/Channel_B'),datatypeID,dataspaceID,'H5P_DEFAULT');
            if isChannelA == 1;
                h5create(file,strcat('/',num2str(i),'/Channel_A'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                current_dataA = [t', handles.current_dataA(i,:)']';
                h5write(file, strcat('/',num2str(i),'/Channel_A'), current_dataA);
            end
            if isChannelB == 1;
                h5create(file,strcat('/',num2str(i),'/Channel_B'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                current_dataB = [t', handles.current_dataB(i,:)']';
                %         H5D.write(datasetID,'H5ML_DEFAULT','H5S_ALL','H5S_ALL', ...
                %             'H5P_DEFAULT', current_dataB);
                %         H5D.close(datasetID);
                %         H5S.close(dataspaceID);
                %         H5T.close(datatypeID);
                %         H5F.close(fileID);
                h5write(file, strcat('/',num2str(i),'/Channel_B'), current_dataB);
            end
            if isChannelC == 1;
                h5create(file,strcat('/',num2str(i),'/Channel_C'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                %     h5create('my_example_file.h5', '/data/6', size(c'),'ChunkSize',[2 2],'Deflate', 1);
                current_dataC = [t', handles.current_dataC(i,:)']';
                h5write(file, strcat('/',num2str(i),'/Channel_C'), current_dataC);
            end
            if isChannelD == 1;
                h5create(file,strcat('/',num2str(i),'/Channel_D'),[2, nofsamples],'ChunkSize',[2, nofsamples],'Deflate', 1);
                current_dataD = [t', handles.current_dataD(i,:)']';
                h5write(file, strcat('/',num2str(i),'/Channel_D'), current_dataD);
            end
            if isChannelA || isChannelB || isChannelC || isChannelD
                h5writeatt(file, strcat('/',num2str(i)), 'Sample Rate (Hz)',1e9);
                h5writeatt(file, strcat('/',num2str(i)), 'Number of loops',loops);
                %             h5writeatt(file, strcat('/',num2str(i)), 'Hardware Average Number',nofwaveforms);
                h5writeatt(file, strcat('/',num2str(i)), 'Record Size',nofsamples);
                h5writeatt(file, strcat('/',num2str(i)), 'Selected_trigger',string_list{selected_trigger});
            else
                uiwait(warndlg('No data selected'));
            end
        end
    end
    %     toc
end

% --------------------------------------------------------------------
function help_joker_Callback(hObject, eventdata, handles)
% hObject    handle to help_joker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_multirecord_Callback(hObject, eventdata, handles)
% hObject    handle to help_multirecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_wfa_Callback(hObject, eventdata, handles)
% hObject    handle to help_wfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in xlabelopt.
function xlabelopt_Callback(hObject, eventdata, handles)
% hObject    handle to xlabelopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global record;
global recordsize;
global xlabelmod;
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
t = 0:1/(1000):(recordsize-1)/(1000);
% m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
n = 1:recordsize;
channelA = get(h(1),'Ydata');
channelB = get(h(2),'Ydata');
channelC = get(h(3),'Ydata');
channelD = get(h(4),'Ydata');
switch str{val};
    case 'Time' % User selects peaks.
        %   handles.current_data = handles.peaks;
        %   set(handles.textStatus, 'String', 'Peaks button pushed')
        xlabelmod = 1;
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
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        h(1) = plot(handles.axes1,x,channelA,'r','DisplayName','ChannelA','visible',legA);
        %    legend('-DynamicLegend');
        hold all;
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        h(2) = plot(handles.axes1,x,channelB,'g','DisplayName','ChannelB','visible',legB);
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        h(3) = plot(handles.axes1,x,channelC,'b','DisplayName','ChannelC','visible',legC);
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        h(4) = plot(handles.axes1,x,channelD,'m','DisplayName','ChannelD','visible',legD);
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        refresh_legend;
        hold off;
        ymin = get(handles.ymin,'String');
        ymax = get(handles.ymax,'String');
        ylim([str2double(ymin), str2double(ymax)]);
        xlabel(xname)%,'FontSize',20)
        ylabel('Intensity (arb.units)')%,'FontSize',20)
        grid on;
        set(handles.textStatus, 'String', 'X label changes to time')
    case 'Record Size' % User selects membrane.
        %   handles.current_data = handles.membrane;
        %   set(handles.textStatus, 'String', 'Membrane button pushed')
        % leveltrig_settings;
        xlabelmod = 2;
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
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        h(1) = plot(handles.axes1,x,channelA,'r','DisplayName','ChannelA','visible',legA);
        %    legend('-DynamicLegend');
        hold all;
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        h(2) = plot(handles.axes1,x,channelB,'g','DisplayName','ChannelB','visible',legB);
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        h(3) = plot(handles.axes1,x,channelC,'b','DisplayName','ChannelC','visible',legC);
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        h(4) = plot(handles.axes1,x,channelD,'m','DisplayName','ChannelD','visible',legD);
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        refresh_legend;
        hold off;
        ymin = get(handles.ymin,'String');
        ymax = get(handles.ymax,'String');
        ylim([str2double(ymin), str2double(ymax)]);
        xlabel(xname)%,'FontSize',20)
        ylabel('Intensity (arb.units)')%,'FontSize',20)
        grid on;
        set(handles.textStatus, 'String', 'X label changes to record number')
    case 'Mass' % User selects sinc.
        %  handles.current_data = handles.sinc;
        %   set(handles.textStatus, 'String', 'Sinc button pushed')
        xlabelmod = 3;
        xlabel_mode;
        %     pause(1)
        while (enter_flag == 0)
            set(handles.textStatus, 'String', 'Please type the calibrated mass parameters, then click enter button')
            pause(0.1)
        end
        m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
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
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        h(1) = plot(handles.axes1,x,channelA,'r','DisplayName','ChannelA','visible',legA);
        %    legend('-DynamicLegend');
        hold (handles.axes1, 'all');
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        h(2) = plot(handles.axes1,x,channelB,'g','DisplayName','ChannelB','visible',legB);
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        h(3) = plot(handles.axes1,x,channelC,'b','DisplayName','ChannelC','visible',legC);
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        h(4) = plot(handles.axes1,x,channelD,'m','DisplayName','ChannelD','visible',legD);
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        
        hold (handles.axes1, 'off');
        ymin = get(handles.ymin,'String');
        ymax = get(handles.ymax,'String');
        ylim(handles.axes1,[str2double(ymin), str2double(ymax)]);
        xlabel(handles.axes1,xname)%,'FontSize',20)
        ylabel(handles.axes1,'Intensity (arb.units)')%,'FontSize',20)
        grid (handles.axes1, 'on');
        refresh_legend;
        set(handles.textStatus, 'String', 'X label changes to mass')
        %         xlabel_mode;
        
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


% --- Executes on key press with focus on figure1 or any of its controls.
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
end
% handles    structure with handles and user data (see GUIDATA)
