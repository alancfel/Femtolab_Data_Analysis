function varargout = wfa(varargin)
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

% Last Modified by GUIDE v2.5 18-Sep-2015 17:32:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @wfa_OpeningFcn, ...
    'gui_OutputFcn',  @wfa_OutputFcn, ...
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
function wfa_OpeningFcn(hObject, eventdata, handles, varargin)
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
global selected_trigger;
global LvlTrigLevelTwosComp;
global LvlTrigCh;
global LvlTrigEdge;
global xlabelmod;
global ylabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global h;
global sliderVal;
global dimension;
global channel_show;
global step;
global machename;
global coincidence;
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
isChannelA = 1;
isChannelB = 1;
isChannelC = 1;
isChannelD = 1;
xlabelmod = 1;
ylabelmod = 1;
delay_trigger = 0;
mass_calibrate = 18;
time_calibrate = 5;
sliderVal = 1;
dimension = 1;
channel_show = 4;
coincidence = 0;
step = 1:nofrecords;
machename = 'None';
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
t = 0:1/(2000):(recordsize-1)/(2000);
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
function varargout = wfa_OutputFcn(hObject, eventdata, handles)
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
% global enter_flag;
string_list{1} = 'Channel A';
string_list{2} = 'Channel B';
string_list{3} = 'Channel C';
string_list{4} = 'Channel D';
% enter_flag = 0;
axes(handles.axes1);
switch dimension
    case 1
        [slider,recordsize] = size(handles.current_dataA);
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
        t=0:1/(2000):(recordsize-1)/(2000);
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
    case 2
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
        t=0:1/(2000):(recordsize-1)/(2000);
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
                        h(1) = pcolor(x,ylabel2,handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:));shading interp;
                    case 2
                        h(2) = pcolor(x,ylabel2,handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:));shading interp;
                    case 3
                        h(3) = pcolor(x,ylabel2,handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:));shading interp;
                    case 4
                        h(4) = pcolor(x,ylabel2,handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:));shading interp;
                end
            end
        else
            switch channel_show
                case 1
                    h(1) = pcolor(x,ylabel2,handles.current_dataA((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659);shading interp;
                case 2
                    h(2) = pcolor(x,ylabel2,handles.current_dataB((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659);shading interp;
                case 3
                    h(3) = pcolor(x,ylabel2,handles.current_dataC((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659);shading interp;
                case 4
                    h(4) = pcolor(x,ylabel2,handles.current_dataD((sliderVal-1)*nofrepes+1:sliderVal*nofrepes,:)/3.3659);shading interp;
            end
        end
        bar = colorbar;title(bar, yname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel('Software average')%,'FontSize',20)
    case 3
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
        if strcmp(machename,'DDG')
            ylabel2 = 50e3-step;
            yname = 'Delay time(\mus)';
        else if strcmp(machename,'vertical')
                ylabel2 = step;
                yname = 'ns laser vertical scanning (mm)';
            else
                ylabel2 = 1:nofrecords;
                yname = 'Measurement series';
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
        t=0:1/(2000):(recordsize-1)/(2000);
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
                zname = 'Intensity (arb. units)';
            case 2
                zname = 'Voltage (mV)';
        end
        set(handles.previous,'string',sprintf('%d',sliderVal));
        set(handles.textStatus, 'String', sprintf('\nStep number = %d',sliderVal));
        %handles.current_data2(sliderVal,:) = adq_data.DataD;
        % plot(x,handles.current_data1(sliderVal,:),'r', x,handles.current_data2(sliderVal,:),'b');
        % legend('channelB','channelD');
        if ylabelmod == 1;
            switch channel_show
                case 1
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataA((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(1) = pcolor(x,ylabel2,newdata);shading interp;
                case 2
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataB((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(2) = pcolor(x,ylabel2,newdata);shading interp;
                case 3
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataC((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(3) = pcolor(x,ylabel2,newdata);shading interp;
                case 4
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataD((index-1)*nofrepes+1:index*nofrepes,:),1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(4) = pcolor(x,ylabel2,newdata);shading interp;
            end
        else
            switch channel_show
                case 1
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataA((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(1) = pcolor(x,ylabel2,newdata);shading interp;
                case 2
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataB((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(2) = pcolor(x,ylabel2,newdata);shading interp;
                case 3
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataC((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(3) = pcolor(x,ylabel2,newdata);shading interp;
                case 4
                    data = [];
                    for index = 1:nofrecords
                        data = [data', mean(handles.current_dataD((index-1)*nofrepes+1:index*nofrepes,:)/3.3659,1)']';
                    end
                    if nofcycle ~= 1
                        indexre = reshape(1:nofrecords, length(step), nofcycle);
                        newdata = [];
                        for re = 1:length(step)
                            newdata = [newdata', mean(data(indexre(re,:),:),1)']';
                        end
                    else
                        newdata = data;
                    end
                    h(4) = pcolor(x,ylabel2,newdata);shading interp;
            end
        end
        bar = colorbar;title(bar, zname);
        legend off;
        hold off;
        xlabel(xname)%,'FontSize',20)
        ylabel(yname)%,'FontSize',20)
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
switch dimension
    case 1
        isChannelA = get(hObject,'Value');
        if isChannelA
            set(handles.textStatus, 'string', 'Channel A is selected')
            set(h(1),'visible','on')
        else
            set(handles.textStatus, 'string', 'Channel A is excluded')
            set(h(1),'visible','off')
        end
        refresh_legend;
    case 2
        channel_show = 1;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'string', 'Channel A is selected')
    case 3
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
switch dimension
    case 1
        isChannelB = get(hObject,'Value');
        if isChannelB
            set(handles.textStatus, 'string', 'Channel B is selected')
            set(h(2),'visible','on')
        else
            set(handles.textStatus, 'string', 'Channel B is excluded')
            set(h(2),'visible','off')
        end
        refresh_legend;
    case 2
        channel_show = 2;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'string', 'Channel B is selected')
    case 3
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
switch dimension
    case 1
        isChannelC = get(hObject,'Value');
        if isChannelC
            set(handles.textStatus, 'string', 'Channel C is selected')
            set(h(3),'visible','on')
        else
            set(handles.textStatus, 'string', 'Channel C is excluded')
            set(h(3),'visible','off')
        end
        refresh_legend;
    case 2
        channel_show = 3;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'string', 'Channel C is selected')
    case 3
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
switch dimension
    case 1
        isChannelD = get(hObject,'Value');
        if isChannelD
            set(handles.textStatus, 'string', 'Channel D is selected')
            set(h(4),'visible','on')
        else
            set(handles.textStatus, 'string', 'Channel D is excluded')
            set(h(4),'visible','off')
        end
        refresh_legend;
    case 2
        channel_show = 4;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'string', 'Channel D is selected')
    case 3
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


% --------------------------------------------------------------------
function help_multirecord_Callback(hObject, eventdata, handles)
% hObject    handle to help_multirecord (see GCBO)
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
global nofcycle;
global sliderVal;
global nofwaveforms;
global selected_trigger;
global nofrepes;
global machename;
global step;
[filename, pathname] = uigetfile({'*.hdf';'*.h5';'*.mat';'*.hdf5'}, 'Open Data');
if filename ~=0
    file = fullfile(pathname, filename);
    dot = regexp(filename,'\.');
    %     set(handles.figure1, 'Name', filename);
    clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
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
                    settings = h5read(file,strcat('/',info.Datasets.Name));
                    recordsize = settings.adq_recordLength; %info.Groups(1).Attributes(5).Value; %Samples per record
                    nofrecords = length(info.Groups.Groups.Groups(1).Groups)*settings.scan_niterations; %length(info.Groups); % measurement number = step number * cycle number
                    nofrepes = settings.adq_nRecords;% settings.scan_niterations; %settings.adq_nRecords; %info.Groups(1).Attributes(2).Value; % software average number settings.scan_niterations
                    nofcycle = settings.scan_niterations;
                    nofwaveforms = settings.adq_nAverages; %info.Groups(1).Attributes(3).Value; % hardware average number
                    selected_trigger = 'External'; %info.Groups(1).Attributes(4).Value; % find(strcmp(string_list,info.Groups(1).Attributes(6).Value));
                    machename = settings.scanChannel; %char(info.Groups(1).Attributes((strmatch('Settings',char(info.Groups(1).Attributes.Name)))).Value(1));
                    %                     stepvalue = [];
                    %                     for att = 1:nofrecords
                    if strcmp(machename,'Channel.A')
                        stepvalue = (settings.scan_from/1000):(settings.scan_stepSize/1000):(settings.scan_to/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))*1e6];
                        if length(stepvalue) == nofrecords/nofcycle
                            step = stepvalue;
                        else step = stepvalue(1:nofrecords/nofcycle);
                        end
                    else if strcmp(machename,'Channel.B')
                            stepvalue = (settings.scan_from/1000):(settings.scan_stepSize/1000):(settings.scan_to/1000);%-settings.scan_stepSize/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))/800];
                            if length(stepvalue) == nofrecords/nofcycle
                                step = stepvalue;
                            else
                                step = stepvalue(1:nofrecords/nofcycle);
                            end
                        else
                            step = 1:nofrecords/nofcycle;
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
                    channel = {'Channel A','Channel C'}; %,'current_dataC'}; %cellstr(cat(1,info.Groups(1).Datasets.Name));
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
                    attA = zeros(nofrecords*nofrepes);
                    set(handles.ChannelA, 'Value', isChannelA);
                    set(handles.ChannelB, 'Value', isChannelB);
                    set(handles.ChannelC, 'Value', isChannelC);
                    set(handles.ChannelD, 'Value', isChannelD);
                    record = 0;
                    for i = 1:nofrecords/nofcycle; %[1:1044,1047:1263,1265:nofrecords]
                        for k = 1:nofcycle
                            for j = 1:nofrepes
                                record = record+1;%i;%record+1;
                                if isChannelA == 1;
                                    if ismember(sprintf('trace_%d_%d',k-1,j-1),cellstr(char(info.Groups.Groups.Groups(2).Groups(i).Datasets.Name)))
                                        handles.current_dataA(record,:) = h5read(file,strcat(info.Groups.Groups.Groups(2,1).Groups(i).Name,'/', sprintf('trace_%d_%d',k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
%                                         handles.current_dataA(record,:) = dataA(1,:);
                                        attA(record) = h5readatt(file,strcat(info.Groups.Groups.Groups(2,1).Groups(i).Name,'/', sprintf('trace_%d_%d',k-1,j-1)),'timestamp');
                                    else
                                        if record ~= 1
                                            handles.current_dataA(record,:) = handles.current_dataA(record-1,:); %dataA(1,:);
                                            attA(record) =  attA(record-1);
                                            fprintf('Channel A trace_%d_%d is not exist in file',k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                        else
                                             attA(record) = 0;
                                             fprintf('Channel A Attribute trace_%d_%d is not exist in file',k-1,j-1);
                                        end
                                    end
                                end
                                if isChannelB == 1;
                                    dataB = h5read(file,strcat('/',num2str(i),'/Channel B'));
                                    handles.current_dataB(record,:) = dataB(j,:);
                                end
                                if isChannelC == 1;
                                    if ismember(sprintf('trace_%d_%d',k-1,j-1),cellstr(char(info.Groups.Groups.Groups(1).Groups(i).Datasets.Name)))
                                        handles.current_dataC(record,:) = h5read(file,strcat(info.Groups.Groups.Groups(1,1).Groups(i).Name,'/', sprintf('trace_%d_%d',k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
%                                         handles.current_dataC(record,:) = dataC(1,:);
                                    else
                                         if record ~= 1
                                            handles.current_dataC(record,:) = handles.current_dataC(record-1,:); %dataC(1,:);
                                            fprintf('Channel C trace_%d_%d is not exist in file',k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                        end
%                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                    end
                                end
                                if isChannelD == 1;
                                    dataD = h5read(file,strcat('/',num2str(i),'/Channel D'));
                                    handles.current_dataD(record,:) = dataD(j,:);
                                end
                            end
                        end
                    end
                    [~,ind] = sort(attA);
                    handles.current_dataA = handles.current_dataA(ind,:);
                    handles.current_dataC = handles.current_dataC(ind,:);
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
    % else
    %     uiwait(warndlg(sprintf('Error: No file selected')));
    set(handles.figure1, 'Name', filename);
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
[filename, pathname] = uiputfile('*.hdf5', 'Save Data as');
if filename ~=0;
    file = fullfile(pathname, filename);
    [loops,nofsamples] = size(handles.current_dataA);
    t=0:1/(2000):(nofsamples-1)/(2000);
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
        %   handles.current_data = handles.peaks;
        %   set(handles.textStatus, 'String', 'Peaks button pushed')
        xlabelmod = 1;
        %         switch xlabelmod
        %             case 1
        %                 x = t;
        %                 xname = 'Time (\mus)';
        %             case 2
        %                 x = n;
        %                 xname = 'Record Number';
        %             case 3
        %                 x = m;
        %                 xname = 'm/q (Da)';
        %         end
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
        %         ymin = get(handles.ymin,'String');
        %         ymax = get(handles.ymax,'String');
        %         ylim([str2double(ymin), str2double(ymax)]);
        %         xlabel(xname)%,'FontSize',20)
        %         ylabel('Intensity (arb.units)')%,'FontSize',20)
        %         grid on;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'X label changes to time')
    case 'Record Size' % User selects membrane.
        %   handles.current_data = handles.membrane;
        %   set(handles.textStatus, 'String', 'Membrane button pushed')
        % leveltrig_settings;
        xlabelmod = 2;
        %         switch xlabelmod
        %             case 1
        %                 x = t;
        %                 xname = 'Time (\mus)';
        %             case 2
        %                 x = n;
        %                 xname = 'Record Number';
        %             case 3
        %                 x = m;
        %                 xname = 'm/q (Da)';
        %         end
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
        %         ymin = get(handles.ymin,'String');
        %         ymax = get(handles.ymax,'String');
        %         ylim([str2double(ymin), str2double(ymax)]);
        %         xlabel(xname)%,'FontSize',20)
        %         ylabel('Intensity (arb.units)')%,'FontSize',20)
        %         grid on;
        show_Callback(handles.show, eventdata, handles)
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
        %         m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
        %         switch xlabelmod
        %             case 1
        %                 x = t;
        %                 xname = 'Time (\mus)';
        %             case 2
        %                 x = n;
        %                 xname = 'Record Number';
        %             case 3
        %                 x = m;
        %                 xname = 'm/q (Da)';
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
        %         xlabel(handles.axes1,xname)%,'FontSize',20)
        %         ylabel(handles.axes1,'Intensity (arb.units)')%,'FontSize',20)
        %         grid (handles.axes1, 'on');
        %         refresh_legend;
        show_Callback(handles.show, eventdata, handles)
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
global nofrepes;
global nofcycle;
global machename;
global dimension;
global step;
if strcmp(machename,'Channel.A')
    xlabel2 = 50e3-step;
    xname = 'Delay between fs laser and ns laser (\mus)';
else if strcmp(machename,'vertical')
        xlabel2 = step;
        xname = 'ns laser vertical scanning (mm)';
    else if strcmp(machename,'Channel.B')
            xlabel2 = step;
            xname = 'Delay between flshlamp and Q-switch (\mus)';
        else
            xlabel2 = 1:nofrecords;
            xname = 'Measurement series';
        end
    end
end
if dimension == 1
    dcm_obj = datacursormode(handles.figure1);
    set(dcm_obj,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
    set(handles.textStatus, 'String', 'Click line to display four data tips, then press Return.')
    % Wait while the user does this.
    pause
    c_info = getCursorInfo(dcm_obj);
    gate = sort([c_info(1).DataIndex,c_info(2).DataIndex,c_info(3).DataIndex,c_info(4).DataIndex]);
    set(handles.textStatus, 'String', sprintf('The gate range is from %d to %d',gate(1),gate(4)));
    % switch xlabelmod
    %     case 1
    %         t = 0:1/(2000):(double(recordsize)-1)/(2000);
    %         n = 1:recordsize;
    %         backgroundmin = n(t == gate(1));
    %         backgroundmax = n(t == gate(2));
    %         gatemin = n(t == gate(3));
    %         gatemax = n(t == gate(4));
    %     case 2
    backgroundmin = gate(1);
    backgroundmax = gate(2);
    gatemin = gate(3);
    gatemax = gate(4);
    %     case 3
    %         t = 0:1/(2000):(double(recordsize)-1)/(2000);
    %         m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
    %         n = 1:recordsize;
    %         backgroundmin = n(m == gate(1));
    %         backgroundmax = n(m == gate(2));
    %         gatemin = n(m == gate(3));
    %         gatemax = n(m == gate(4));
    % end
    gatedata = abs(mean(handles.current_dataA(:,backgroundmin:backgroundmax)')-mean(handles.current_dataA(:,gatemin:gatemax)'))*(gatemax-gatemin+1);
    gatemean = abs(mean(handles.current_dataA(:,backgroundmin:backgroundmax)')-mean(handles.current_dataA(:,gatemin:gatemax)'));
%     for j=1:nofrecords/nofcycle
%         msignalraw(j)=mean(gatedata(((nofrepes*nofcycle*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
%         stdsignalraw(j)=std(gatedata(((nofrepes*nofcycle*j)-(nofrepes*nofcycle)+1):(nofrepes*nofcycle*j)));
%     end
    for j=1:nofrecords
        msignalraw(j)=mean(gatedata((nofrepes*j-nofrepes+1):(nofrepes*j)));
        stdsignalraw(j)=std(gatedata((nofrepes*j-nofrepes+1):(nofrepes*j)));
    end
        if nofcycle ~= 1
            msignal = mean(reshape(msignalraw, nofrecords/nofcycle,[])',1);
            stdsignal = std(reshape(msignalraw, nofrecords/nofcycle,[])',1);
        else
            msignal = msignalraw;
            stdsignal = stdsignalraw;
        end
%     msignal = msignalraw;
%     stdsignal = stdsignalraw;
    h0 = figure('PaperSize',[8.267716 15.692913]);
    plot(gatedata/98.24);%,'-o','linewidth',2,'markersize',8);
    ylabel('Ion Numbers per laser shot','FontSize',14)%Intensiy (a.u.)','FontSize',14)
    xlabel('Desorption laser shots','FontSize',14)%Measurement series','FontSize',14)
    set(gca,'fontsize',20);
    set(h0, 'Position', [80,100,1000,620]);
    set(h0, 'PaperpositionMode', 'auto');
    h1 = figure('PaperSize',[8.267716 15.692913]);
    errorbar(xlabel2,msignal/98.24,stdsignal/98.24,'linewidth',2);
    ylabel('Ion Numbers per laser shot','FontSize',14)
    xlabel(xname,'FontSize',14)
    set(gca,'fontsize',20);
    set(h1, 'Position', [80,100,1000,620]);
    set(h1, 'PaperpositionMode', 'auto');
    h2 = figure('PaperSize',[8.267716 15.692913]);
    errorbar(xlabel2,msignal,stdsignal,'linewidth',2);
    ylabel('Intensiy (a.u.)','FontSize',14)
    xlabel(xname,'FontSize',14)
    set(gca,'fontsize',20);
    set(h2, 'Position', [80,100,1000,620]);
    set(h2, 'PaperpositionMode', 'auto');
    h3 = figure('PaperSize',[8.267716 15.692913]);
    [fk1,xk1,h1] = ksdensity(gatemean);
    [f1,xi1] = ecdf(gatemean);
    ecdfhist(f1,xi1,range(gatemean)/h1);
    hold on
    plot(xk1,fk1,'r','linewidth',2);
    set(h3, 'Position', [80,100,1000,620]);
    xlabel('Intensiy (a.u.)','FontSize',14)
    ylabel('Probability','FontSize',14)
    set(gca,'fontsize',20);
    if nofcycle ~= 1
        h4 = figure('PaperSize',[8.267716 15.692913]);
        errorbar(repmat(xlabel2,nofcycle,1)',reshape(msignalraw, nofrecords/nofcycle,[])/98.24,reshape(msignalraw, nofrecords/nofcycle,[])/98.24,'linewidth',2);
        ylabel('Ion Numbers per laser shot','FontSize',14)
        xlabel(xname,'FontSize',14)
        set(gca,'fontsize',20);
        set(h4, 'Position', [80,100,1000,620]);
        set(h4, 'PaperpositionMode', 'auto');
    end
    h5 = figure('PaperSize',[8.267716 15.692913]);
    plot(xlabel2,reshape(msignalraw, nofrecords/nofcycle,[])'/98.24,'-o','linewidth',2,'markersize',8);
    ylabel('Ion Numbers per laser shot','FontSize',14)
    xlabel(xname,'FontSize',14)
    set(gca,'fontsize',20);
    set(h5, 'Position', [80,100,1000,620]);
    set(h5, 'PaperpositionMode', 'auto');
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
axes(handles.axes1);
[slider,recordsize] = size(handles.current_dataA);
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
        set(hObject,'String',num2str(1));
        sliderVal    = 1;
    else if (sliderVal < 1)
            set(hObject,'String',num2str(slider))
            sliderVal    = slider;
        else if (isnan(sliderVal))
                set(hObject,'String',num2str(slider))
                sliderVal    = slider;
            end
        end
    end
    %     t=0:1/(2000):(recordsize-1)/(2000);
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
    case '1D'
        dimension = 1;
        %         coincidence = 0;
        show_Callback(handles.show, eventdata, handles)
        set(handles.textStatus, 'String', 'Dimension changes to 1D')
    case '2D'
        dimension = 2;
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
        set(handles.textStatus, 'String', sprintf('Dimension changes to 2D\n %s is selected', string_list{channel_show}))
    case '3D'
        dimension = 3;
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
    axis(handles.axes1,'tight');
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
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
new_axes = copyobj(handles.axes1, Fig2);
% set(new_axes,'Parent',Fig2);
% set(new_axes,'Position',[0 0 1 1]);
set(new_axes, 'Units', 'Normalized', 'Position', 'default');
set(Fig2, 'Position', [80,100,1000,620]);
grid(new_axes, 'off')
set(new_axes,'fontsize',20);
hay = get(new_axes,'Ylabel');
hax = get(new_axes,'Xlabel');
NewFontSize = 20;
set(hay,'Fontsize',NewFontSize);
set(hax,'Fontsize',NewFontSize);
set(Fig2, 'PaperpositionMode', 'auto');
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
if nofrecords*nofrepes <= 1
    errorMessage = sprintf('The nofrecords and nofrepes are 1');
    uiwait(warndlg(errorMessage));
else
    t=0:1/(2000):(recordsize-1)/(2000);
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
end
