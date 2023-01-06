function varargout = extertrig_settings(varargin)
% EXTERTRIG_SETTINGS M-file for extertrig_settings.fig
%      EXTERTRIG_SETTINGS, by itself, creates a new EXTERTRIG_SETTINGS or raises the existing
%      singleton*.
%
%      H = EXTERTRIG_SETTINGS returns the handle to a new EXTERTRIG_SETTINGS or the handle to
%      the existing singleton*.
%
%      EXTERTRIG_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTERTRIG_SETTINGS.M with the given input arguments.
%
%      EXTERTRIG_SETTINGS('Property','Value',...) creates a new EXTERTRIG_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to extertrig_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help extertrig_settings

% Copyright 2001-2003 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 10-Aug-2014 18:48:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @extertrig_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @extertrig_settings_OutputFcn, ...
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


% --- Executes just before extertrig_settings is made visible.
function extertrig_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to extertrig_settings (see VARARGIN)
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
define_command_codes;
% global LvlTrigLevelTwosComp;
% global LvlTrigCh;
global LvlTrigEdge;
% set(handles.triglevel, 'String', num2str(LvlTrigLevelTwosComp));
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
if LvlTrigEdge == RISING_EDGE
    edge_list{1} = 'Rising';
    edge_list{2} = 'Falling';
    set(handles.trigedge, 'String', edge_list);
else 
    edge_list{2} = 'Rising';
    edge_list{1} = 'Falling';
    set(handles.trigedge, 'String', edge_list);
end
%nofrecords = 100;
%triglevel = 35000;
%configure;
%selected_trigger = SW_TRIGGER_MODE;
% Choose default command line output for extertrig_settings
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes extertrig_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = extertrig_settings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% % --- Executes on button press in pushbutton2.
% function triglevel_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % Display mesh plot of the currently selected data
% global LvlTrigLevelTwosComp;
% samplenumber = get(hObject,'String');
% LvlTrigLevelTwosComp = str2double (samplenumber);
% guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function Enter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display contour plot of the currently selected data
%close(extertrig_settings);
drawnow;
global LvlTrigLevelTwosComp;
global LvlTrigCh;
global LvlTrigEdge;
%configure;
 guidata(hObject, handles);
 %extertrig_settings_OutputFcn(hObject, eventdata, handles);
% set(handles.textStatus, 'String', 'Setup completed')
delete(handles.figure1);

% % --- Executes on selection change in levchannel.
% function levchannel_Callback(hObject, eventdata, handles)
% % hObject    handle to levchannel (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% define_command_codes;
% global LvlTrigCh;
% val = get(hObject,'Value');
% str = get(hObject, 'String');
% switch str{val};
% case 'Channel A' % User selects peaks.
% %   handles.current_data = handles.peaks;
% %   set(handles.textStatus, 'String', 'Peaks button pushed')
% LvlTrigCh = CH_A;
% 
% case 'Channel B' % User selects membrane.
% %   handles.current_data = handles.membrane;
% %   set(handles.textStatus, 'String', 'Membrane button pushed')
% LvlTrigCh = CH_B;
% 
% case 'Channel C' % User selects sinc.
% %  handles.current_data = handles.sinc;
% %   set(handles.textStatus, 'String', 'Sinc button pushed')
% LvlTrigCh = CH_C;
% 
% case 'Channel D' % User selects sinc.
% %  handles.current_data = handles.sinc;
% %   set(handles.textStatus, 'String', 'Sinc button pushed')
% LvlTrigCh = CH_D;
% end
% guidata(hObject,handles)
% % Hints: contents = get(hObject,'String') returns levchannel contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from levchannel
% 
% 
% % --- Executes during object creation, after setting all properties.
% function levchannel_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to levchannel (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc
%     set(hObject,'BackgroundColor','white');
% else
%     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
% end
% 
% 
% % --- Executes during object creation, after setting all properties.
% function figure1_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% 


% --- Executes on selection change in trigedge.
function trigedge_Callback(hObject, eventdata, handles)
% hObject    handle to trigedge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
define_command_codes;
global LvlTrigEdge;
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
case 'Rising' % User selects peaks.
%   handles.current_data = handles.peaks;
%   set(handles.textStatus, 'String', 'Peaks button pushed')
LvlTrigEdge = RISING_EDGE;

case 'Falling' % User selects peaks.
%   handles.current_data = handles.peaks;
%   set(handles.textStatus, 'String', 'Peaks button pushed')
LvlTrigEdge = FALLING_EDGE;
end
% Hints: contents = cellstr(get(hObject,'String')) returns trigedge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trigedge


% --- Executes during object creation, after setting all properties.
function trigedge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trigedge (see GCBO)
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
switch eventdata.Key
    case 'return'
       Enter_Callback(hObject, eventdata, handles)
end
% handles    structure with handles and user data (see GUIDATA)
