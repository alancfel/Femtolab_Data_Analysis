function varargout = multirecord_settings(varargin)
% MULTIRECORD_SETTINGS M-file for multirecord_settings.fig
%      MULTIRECORD_SETTINGS, by itself, creates a new MULTIRECORD_SETTINGS or raises the existing
%      singleton*.
%
%      H = MULTIRECORD_SETTINGS returns the handle to a new MULTIRECORD_SETTINGS or the handle to
%      the existing singleton*.
%
%      MULTIRECORD_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIRECORD_SETTINGS.M with the given input arguments.
%
%      MULTIRECORD_SETTINGS('Property','Value',...) creates a new MULTIRECORD_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multirecord_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multirecord_settings

% Copyright 2001-2003 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 10-Aug-2014 19:28:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @multirecord_settings_OpeningFcn, ...
    'gui_OutputFcn',  @multirecord_settings_OutputFcn, ...
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


% --- Executes just before multirecord_settings is made visible.
function multirecord_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multirecord_settings (see VARARGIN)
% Create the data to plot
% handles.peaks=peaks(35);
% handles.membrane=membrane;
% [x,y] = meshgrid(-8:.5:8);
% r = sqrt(x.^2+y.^2) + eps;
% sinc = sin(r)./r;
% handles.sinc = sinc;
% handles.current_data = handles.peaks;
% surf(handles.current_data)
global nofrecords;
global recordsize;
global selected_trigger;
set(handles.nofrecord, 'String', num2str(nofrecords));
set(handles.Recordsize, 'String', num2str(recordsize));
if selected_trigger == 1
    string_list{1} = 'Software';
    string_list{2} = 'Level';
    string_list{3} = 'External';
    set(handles.Triggersetting, 'String', string_list);
else if selected_trigger == 2
        string_list{1} = 'External';
        string_list{2} = 'Software';
        string_list{3} = 'Level';
        set(handles.Triggersetting, 'String', string_list);
    else
        string_list{1} = 'Level';
        string_list{2} = 'External';
        string_list{3} = 'Software';
        set(handles.Triggersetting, 'String', string_list);
    end
end
%nofrecords = 100;
%recordsize = 35000;
%configure;
%selected_trigger = SW_TRIGGER_MODE;
% Choose default command line output for multirecord_settings
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multirecord_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multirecord_settings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function nofrecord_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display surf plot of the currently selected data
global nofrecords;
loopnumber = get(hObject,'String');
nofrecords = str2double (loopnumber);
guidata(hObject, handles);
% surf(handles.current_data);

% --- Executes on button press in pushbutton2.
function Recordsize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display mesh plot of the currently selected data
global recordsize;
samplenumber = get(hObject,'String');
recordsize = str2double (samplenumber);
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function Enter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data
%close(multirecord_settings);
drawnow;
define_command_codes;
global recordsize;
global nofrecords;
global selected_trigger;
global LvlTrigLevelTwosComp;
global LvlTrigCh;
global LvlTrigEdge;
if isnan(nofrecords) || isnan(recordsize)
    errorMessage = sprintf('Error: Invalid input');
    uiwait(warndlg(errorMessage));
    %     set(handles.nofrecord,'String', '100')
    %     set(handles.nofrecord,'String', '100')
    %     nofrecords = 100;
else
    configure;
    guidata(hObject, handles);
    %multirecord_settings_OutputFcn(hObject, eventdata, handles);
    % set(handles.textStatus, 'String', 'Setup completed')
    delete(handles.figure1);
end

% --- Executes on selection change in Triggersetting.
function Triggersetting_Callback(hObject, eventdata, handles)
% hObject    handle to Triggersetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selected_trigger;
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
    case 'Software' % User selects peaks.
        %   handles.current_data = handles.peaks;
        %   set(handles.textStatus, 'String', 'Peaks button pushed')
        selected_trigger = 1;
        
    case 'Level' % User selects membrane.
        %   handles.current_data = handles.membrane;
        %   set(handles.textStatus, 'String', 'Membrane button pushed')
        selected_trigger = 3;
        leveltrig_settings;
        
    case 'External' % User selects sinc.
        %  handles.current_data = handles.sinc;
        %   set(handles.textStatus, 'String', 'Sinc button pushed')
        selected_trigger = 2;
        extertrig_settings;
end
guidata(hObject,handles)
% Hints: contents = get(hObject,'String') returns Triggersetting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Triggersetting


% --- Executes during object creation, after setting all properties.
function Triggersetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Triggersetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
switch eventdata.Key
    case 'return'
        %        nofrecord_Callback(hObject, eventdata, handles)
        %        drawnow;
        Enter_Callback(hObject, eventdata, handles)
end
% handles    structure with handles and user data (see GUIDATA)