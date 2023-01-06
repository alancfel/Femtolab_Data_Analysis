function varargout = xlabel_mode(varargin)
% XLABEL_MODE M-file for xlabel_mode.fig
%      XLABEL_MODE, by itself, creates a new XLABEL_MODE or raises the existing
%      singleton*.
%
%      H = XLABEL_MODE returns the handle to a new XLABEL_MODE or the handle to
%      the existing singleton*.
%
%      XLABEL_MODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XLABEL_MODE.M with the given input arguments.
%
%      XLABEL_MODE('Property','Value',...) creates a new XLABEL_MODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xlabel_mode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xlabel_mode

% Copyright 2001-2003 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 17-Mar-2016 18:04:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @xlabel_mode_OpeningFcn, ...
    'gui_OutputFcn',  @xlabel_mode_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before xlabel_mode is made visible.
function xlabel_mode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xlabel_mode (see VARARGIN)
% Create the data to plot
% handles.peaks=peaks(35);
% handles.membrane=membrane;
% [x,y] = meshgrid(-8:.5:8);
% r = sqrt(x.^2+y.^2) + eps;
% sinc = sin(r)./r;
% handles.sinc = sinc;
% handles.current_data = handles.peaks;
% surf(handles.current_data)
%global nofrecords;
% define_command_codes;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global time_calibrate2;
global mass_calibrate2;
set(handles.calibrate_mass, 'String', num2str(mass_calibrate));
set(handles.trigger_delay, 'String', num2str(delay_trigger));
set(handles.calibrate_time, 'String', num2str(time_calibrate));
set(handles.time2, 'String', num2str(time_calibrate2));
set(handles.mass2, 'String', num2str(mass_calibrate2));
% if LvlTrigCh == CH_A
%     string_list{1} = 'Channel A';
%     string_list{2} = 'Channel B';
%     string_list{3} = 'Channel C';
%     string_list{4} = 'Channel D';
%     set(handles.levchannel, 'String', string_list);
% else if LvlTrigCh == CH_B
%     string_list{1} = 'Channel B';
%     string_list{2} = 'Channel C';
%     string_list{3} = 'Channel D';
%     string_list{4} = 'Channel A';
%         set(handles.levchannel, 'String', string_list);
%     else if LvlTrigCh == CH_C
%     string_list{1} = 'Channel C';
%     string_list{2} = 'Channel D';
%     string_list{3} = 'Channel A';
%     string_list{4} = 'Channel B';
%         set(handles.levchannel, 'String', string_list);
%         else
%     string_list{1} = 'Channel D';
%     string_list{2} = 'Channel A';
%     string_list{3} = 'Channel B';
%     string_list{4} = 'Channel C';
%     set(handles.levchannel, 'String', string_list);
%         end
%     end
% end
% if LvlTrigEdge == RISING_EDGE
%     edge_list{1} = 'Rising';
%     edge_list{2} = 'Falling';
%     set(handles.trigedge, 'String', edge_list);
% else
%     edge_list{2} = 'Rising';
%     edge_list{1} = 'Falling';
%     set(handles.trigedge, 'String', edge_list);
% end
%nofrecords = 100;
%calibrate_mass = 35000;
%configure;
%selected_trigger = SW_TRIGGER_MODE;
% Choose default command line output for xlabel_mode
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xlabel_mode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xlabel_mode_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton2.
function calibrate_mass_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display mesh plot of the currently selected data
global mass_calibrate;
samplenumber = get(hObject,'String');
mass_calibrate = str2double (samplenumber);
%guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function Enter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data
%close(xlabel_mode);
drawnow;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
global enter_flag;
global time_calibrate2;
global mass_calibrate2;
delay_trigger = (time_calibrate - time_calibrate2*sqrt(mass_calibrate/mass_calibrate2))/(1 - sqrt(mass_calibrate/mass_calibrate2));
set(handles.trigger_delay, 'String', num2str(delay_trigger));
%configure;
enter_flag = 1;
%xlabel_mode_OutputFcn(hObject, eventdata, handles);
% set(handles.textStatus, 'String', 'Setup completed')
if isnan(delay_trigger) || isnan(mass_calibrate) || isnan(time_calibrate)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    %     set(handles.nofrecord,'String', '100')
    %     set(handles.nofrecord,'String', '100')
    %     nofrecords = 100;
else
    guidata(hObject, handles);
    delete(handles.figure1);
end



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




function trigger_delay_Callback(hObject, eventdata, handles)
% hObject    handle to trigger_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global delay_trigger;
% samplenumber = get(hObject,'String');
delay_trigger = str2double (samplenumber);
set(hObject,'String',num2str(samplenumber))
% Hints: get(hObject,'String') returns contents of trigger_delay as text
%        str2double(get(hObject,'String')) returns contents of trigger_delay as a double


% --- Executes during object creation, after setting all properties.
function trigger_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trigger_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function calibrate_time_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global time_calibrate;
samplenumber = get(hObject,'String');
time_calibrate = str2double (samplenumber);
% Hints: get(hObject,'String') returns contents of calibrate_time as text
%        str2double(get(hObject,'String')) returns contents of calibrate_time as a double


% --- Executes during object creation, after setting all properties.
function calibrate_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calibrate_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
switch eventdata.Key
    case 'return'
        Enter_Callback(hObject, eventdata, handles)
end
% handles    structure with handles and user data (see GUIDATA)



function mass2_Callback(hObject, eventdata, handles)
% hObject    handle to mass2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mass_calibrate2;
samplenumber = get(hObject,'String');
mass_calibrate2 = str2double (samplenumber);
% Hints: get(hObject,'String') returns contents of mass2 as text
%        str2double(get(hObject,'String')) returns contents of mass2 as a double


% --- Executes during object creation, after setting all properties.
function mass2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time2_Callback(hObject, eventdata, handles)
% hObject    handle to time2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global time_calibrate2;
samplenumber = get(hObject,'String');
time_calibrate2 = str2double (samplenumber);
% Hints: get(hObject,'String') returns contents of time2 as text
%        str2double(get(hObject,'String')) returns contents of time2 as a double


% --- Executes during object creation, after setting all properties.
function time2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
