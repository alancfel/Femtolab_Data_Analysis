function varargout = show2D(varargin)
% SHOW2D M-file for show2D.fig
%      SHOW2D, by itself, creates a new SHOW2D or raises the existing
%      singleton*.
%
%      H = SHOW2D returns the handle to a new SHOW2D or the handle to
%      the existing singleton*.
%
%      SHOW2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW2D.M with the given input arguments.
%
%      SHOW2D('Property','Value',...) creates a new SHOW2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show2D

% Copyright 2001-2003 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 13-Oct-2014 20:41:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @show2D_OpeningFcn, ...
    'gui_OutputFcn',  @show2D_OutputFcn, ...
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


% --- Executes just before show2D is made visible.
function show2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show2D (see VARARGIN)
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
global channel_show;
if channel_show == 1
    string_list{1} = 'Channel A';
    string_list{2} = 'Channel B';
    string_list{3} = 'Channel C';
    string_list{4} = 'Channel D';
    set(handles.select_channel, 'String', string_list);
else if channel_show == 2
    string_list{1} = 'Channel B';
    string_list{2} = 'Channel C';
    string_list{3} = 'Channel D';
    string_list{4} = 'Channel A';
        set(handles.select_channel, 'String', string_list);
    else if channel_show == 3
    string_list{1} = 'Channel C';
    string_list{2} = 'Channel D';
    string_list{3} = 'Channel A';
    string_list{4} = 'Channel B';
        set(handles.select_channel, 'String', string_list);
        else
    string_list{1} = 'Channel D';
    string_list{2} = 'Channel A';
    string_list{3} = 'Channel B';
    string_list{4} = 'Channel C';
    set(handles.select_channel, 'String', string_list);
        end
    end
end
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
% Choose default command line output for show2D
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = show2D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton3.
function Enter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data
%close(show2D);
drawnow;
global enter_flag;
global channel_show;
%configure;
enter_flag = 1;
%show2D_OutputFcn(hObject, eventdata, handles);
% set(handles.textStatus, 'String', 'Setup completed')
if isnan(channel_show)||channel_show > 4
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




function select_channel_Callback(hObject, eventdata, handles)
% hObject    handle to select_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global channel_show;
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
    case 'Channel A'
        channel_show = 1;
    case 'Channel B'
        channel_show = 2;
    case 'Channel C'
        channel_show = 3;
    case 'Channel D'
        channel_show =4;
end
% Hints: get(hObject,'String') returns contents of select_channel as text
%        str2double(get(hObject,'String')) returns contents of select_channel as a double


% --- Executes during object creation, after setting all properties.
function select_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_channel (see GCBO)
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
