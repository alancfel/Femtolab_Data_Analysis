function varargout = PDVI(varargin)
% PDVI MATLAB code for PDVI.fig
%      PDVI, by itself, creates a new PDVI or raises the existing
%      singleton*.
%
%      H = PDVI returns the handle to a new PDVI or the handle to
%      the existing singleton*.
%
%      PDVI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PDVI.M with the given input arguments.
%
%      PDVI('Property','Value',...) creates a new PDVI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PDVI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PDVI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools plot.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PDVI

% Last Modified by GUIDE v2.5 23-Sep-2025 15:46:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PDVI_OpeningFcn, ...
                   'gui_OutputFcn',  @PDVI_OutputFcn, ...
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


% --- Executes just before PDVI is made visible.
function PDVI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PDVI (see VARARGIN)

% Choose default command line output for PDVI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PDVI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Plot logo
axes(handles.ECS)
iptsetpref('ImshowAxesVisible','off');
imshow('MPSD.png','Border','tight')


% --- Outputs from this function are returned to the command line.
function varargout = PDVI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function RingNumSlide_Callback(hObject, eventdata, handles)
% hObject    handle to RingNumSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Value = round(get(hObject,'Value'));
StringData = 1:Value;
% Val = num2str(StringData);
Val = num2cell(StringData');
set(handles.RingNumText,'String',num2str(Value))
set(handles.CurrentRingPop,'Value',1)
CurrentRingPix = get(handles.PixTable,'UserData');
set(handles.CurrentRingPop,'String',Val)
set(handles.PixTable,'Data',CurrentRingPix(1).Ring)

% Set up LatticeSpacing table
LineSpacData = SetUpLatticeSpacingable(Value);
set(handles.LatticeSpacing,'Data',LineSpacData)

% Adjust user control
% Controls on
set(handles.EditRings,'Enable','on')
set(handles.CurrentRingPop,'Enable','on')
set(handles.SelectPixels,'Enable','on')
set(handles.findcircle,'Enable','on')
set(handles.sensitivity,'Enable','on')
set(handles.radius,'Enable','on')
% Controls off
set(handles.RingNumSlide,'Enable','off')
set(handles.RingNumText,'Enable','off')


% --- Executes during object creation, after setting all properties.
function RingNumSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RingNumSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min',1,'Max',50)


function RingNumText_Callback(hObject, eventdata, handles)
% hObject    handle to RingNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RingNumText as text
%        str2double(get(hObject,'String')) returns contents of RingNumText as a double

Value = str2double(get(hObject,'String'));
set(handles.RingNumSlide,'Value',Value)
StringData = 1:Value;
Val = num2cell(StringData');
set(handles.CurrentRingPop,'Value',1)
CurrentRingPix = get(handles.PixTable,'UserData');
set(handles.CurrentRingPop,'String',Val)
set(handles.PixTable,'Data',CurrentRingPix(1).Ring)

% Set up LatticeSpacing table
LineSpacData = SetUpLatticeSpacingUITable(Value);
set(handles.LatticeSpacing,'Data',LineSpacData)

% Adjust user control
% Controls on
set(handles.EditRings,'Enable','on')
set(handles.CurrentRingPop,'Enable','on')
set(handles.SelectPixels,'Enable','on')
set(handles.findcircle,'Enable','on')
set(handles.sensitivity,'Enable','on')
set(handles.radius,'Enable','on')
% Controls off
set(handles.RingNumSlide,'Enable','off')
set(handles.RingNumText,'Enable','off')

% --- Executes during object creation, after setting all properties.
function RingNumText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RingNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenImageBut.
function OpenImageBut_Callback(hObject, eventdata, handles)
% hObject    handle to OpenImageBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider
global sliderVal
clear handles.dat
% global dat
[filenameall, pathname] = uigetfile({'*.bmp;*.spe;*.bin;*.png;*.tiff;*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if iscell(filenameall) || ischar(filenameall)
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        slider = length(filenameall);
%         delete handles.dat;
        for i = 1:slider
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);            
            if strcmp(filename(dot+1:end), 'spe')
                handles.dat(:,:,i) = ReadsspeIndividual(file);  
                handles.t(i) = str2double(regexp(filename, '\d*(?=fs)', 'match'));
                fprintf('Reading file: %s\n',filename);
            elseif strcmp(filename(dot+1:end), 'bmp')
                handles.dat(:,:,i) = double(imread(file));  
                handles.t(i) = str2double(filename(dot-5:dot-1));
                fprintf('Reading file: %s\n',filename);    
            elseif strcmp(filename(dot+1:end), 'tiff')
                handles.dat(:,:,i) = double(imread(file)); 
                num = (regexp(filename, 'delay(\d+)_', 'tokens'));
                handles.t(i) = str2double(num{1}{1});
                fprintf('Reading file: %s\n',filename);     
                else
                uiwait(warndlg(sprintf('Error: Not the camera .bmp file')));
            end
        end
        fprintf('Done. %d files were loaded\n',slider);
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        slider = 1;
        if strcmp(filename(dot+1:end), 'spe')
            handles.dat = ReadsspeIndividual(file);
            handles.t = str2double(regexp(filename, '\d*(?=fs)', 'match'));
            fprintf('Reading file: %s\n',filename);
        elseif strcmp(filename(dot+1:end), 'bmp')
            handles.dat = double(imread(file));
            handles.t = str2double(filename(dot-5:dot-1));
            fprintf('Reading file: %s\n',filename);
        elseif strcmp(filename(dot+1:end), 'tiff')
            handles.dat(:,:,i) = double(imread(file));
            num = (regexp(filename, 'delay(\d+)_', 'tokens'));
            handles.t(i) = str2double(num{1}{1});
            fprintf('Reading file: %s\n',filename);
        else
            uiwait(warndlg(sprintf('Error: Not the diffraction spe file')));
        end
    end
    set(handles.textStatus, 'String', sprintf('Opened %d files',slider))
    sliderVal = 1;
    set(handles.slide, 'Value', sliderVal);
    show_Callback(handles.slide, eventdata, handles);
    
    % Save file path for export data function
    set(handles.OpenImageBut,'UserData',file)
    
    % Adjust user control
    % Controls on
    set(handles.RingNumSlide,'Enable','on')
    set(handles.RingNumText,'Enable','on')
    set(handles.slide,'Enable','on')
    set(handles.previous,'Enable','on')
    set(handles.Vertical,'Enable','on')
    set(handles.horizontal,'Enable','on')
    set(handles.checkvertical,'Enable','on')
    set(handles.checkhorizontal,'Enable','on')
    set(handles.Calculate,'Enable','on')
    set(handles.colormin,'Enable','on')
    set(handles.colormax,'Enable','on')
    set(handles.Profile,'Enable','on')
else
    uiwait(warndlg(sprintf('Error: No file was selected')));
end
guidata(hObject, handles);




function   [xc,yc,R,a] = circfit(x,y)
%
%   [xc yx R] = circfit(x,y)
%
%   fits a circle  in x,y plane in a more accurate
%   (less prone to ill condition )
%  procedure than circfit2 but using more memory
%  x,y are column vector where (x(i),y(i)) is a measured point
%
%  result is center point (yc,xc) and radius R
%  an optional output is the vector of coeficient a
% describing the circle's equation
%
%   x^2+y^2+a(1)*x+a(2)*y+a(3)=0
%
%  By:  Izhak bucher 25/oct /1991, 
    x=x(:); y=y(:);
   a=[x y ones(size(x))]\[-(x.^2+y.^2)];
   xc = -.5*a(1);
   yc = -.5*a(2);
   R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));


% --- Executes on selection change in CurrentRingPop.
function CurrentRingPop_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentRingPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CurrentRingPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CurrentRingPop

CurrentRingPix = get(handles.PixTable,'UserData');
CurrentRing = get(hObject,'Value');
UserData = get(handles.CurrentRingPop,'UserData');
PlottedPix = UserData.PlottedPix;
axes(handles.Image)
if length(PlottedPix) > 1
    if PlottedPix(1)~0;
        for k = 1:length(PlottedPix)
            try delete(PlottedPix(k)) %set(PlottedPix,'Visible','off')
            catch continue
            end
        end
    end
else if PlottedPix(1) > 0
        delete(PlottedPix) %set(PlottedPix,'Visible','off') 
    end
end
if CurrentRing > length(CurrentRingPix)
    CurrentRingPix(CurrentRing).Ring = zeros(1,2);
end
set(handles.PixTable,'Data',CurrentRingPix(CurrentRing).Ring)
CurrentPix = CurrentRingPix(CurrentRing).Ring;
axes(handles.Image)
hold on
% if CurrentRing > length(UserData.PlottedPix)
    PlottedPix(CurrentRing) = plot(handles.Image,CurrentPix(:,1),CurrentPix(:,2),...
        'ro',...
        'MarkerSize',3);
% else if PlottedPix(CurrentRing) > 0
%         PlottedPix(CurrentRing) = plot(handles.Image,CurrentPix(:,1),CurrentPix(:,2))
%     end
% end
UserData.PlottedPix = PlottedPix;
set(hObject,'UserData',UserData)

% --- Executes during object creation, after setting all properties.
function CurrentRingPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentRingPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
UserData.PlottedPix = zeros(1);
set(hObject,'UserData',UserData)

% --- Executes on button press in ExportDataBut.
function ExportDataBut_Callback(hObject, eventdata, handles)
% hObject    handle to ExportDataBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set up DiffX structure for output
% im=get(handles.Image);
% for Kids = 1:length(im.Children)
%     Child = im.Children(Kids);
%     if strcmp(get(Child,'Type'),'image')
%         DiffPat=get(im.Children(Kids),'CData');
%     end
% end
% DiffX.Image = DiffPat;
DiffX.PixSizeText = get(handles.PixSizeText,'Value');
DiffX.PixTable = get(handles.PixTable,'UserData');
DiffX.RingTable = get(handles.RingTable,'Data');
DiffX.LatticeSpacing = get(handles.LatticeSpacing,'Data');
DiffX.RingNumVal = get(handles.RingNumSlide,'Value');
DiffX.RingNumText = get(handles.RingNumText,'String');
DiffX.CurrentRingPop = get(handles.CurrentRingPop,'String');

[pathstr, name, ext] = fileparts(get(handles.OpenImageBut,'UserData'));

save([pathstr,filesep,name,'.DiffX'],'DiffX')
% DiffX.handles.hPatCent = hPatCent;
% DiffX.handles.hRingCents = hRingCents;
% DiffX.handles.RingRad = RingRad;
% DiffX.handles.Caked = Caked;


% delete(handles.Image)
% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,~,scan] = size(handles.dat);
ring = inputdlg({'Enter space-separated ring numbers (1~5):','Enter the respective guass fit number (1~2):','Enter the two peak positions of each ring number'},'Input', [1 50;1 50;1 50]);
%Ask for whether need to save the fitted peak to AVI
current = inputdlg({'Enter the current start value:','Enter the current end value:'},'Input', [1 50;1 50]);
if ~isempty(current)
    if (scan == abs(str2num(current{1})-str2num(current{2}))+1)
        answer = questdlg('Would you like to save the fitted peaks to a movie?', ...
            'Save Menu', ...
            'Yes','No','No');
        % Handle response
        switch answer
            case 'Yes'
                avi = 1;
                disp('Save fitted peaks.')
            case 'No'
                avi = 0;
                disp('Donot save fitted peaks.')
        end
        %Ask for whether need to display the each ring result
        disring = questdlg('Would you like to plot every ring fitting images?', ...
            'Save Menu', ...
            'Yes','No','No');
        % Handle response
        switch disring
            case 'Yes'
                ringdis = 1;
                disp('Show every ring fitted images.')
            case 'No'
                ringdis = 0;
                disp('Donot show every ring fitted images.')
        end
        horizontal = get(handles.checkhorizontal,'Value');
        if horizontal == 1
            profile = get(handles.horizontal,'String');
        else
            profile = get(handles.Vertical,'String');
        end
        peakdata = get(handles.PixTable,'Data');
        profi = str2num(profile);
        [~,radg1,widg1] = plotring(str2num(ring{1}),str2num(ring{2}),str2num(ring{3}),peakdata,horizontal,profi,str2num(current{1}),str2num(current{2}),avi,ringdis,handles.dat);
        assignin('base',sprintf('diameter_ring'),radg1);
        assignin('base',sprintf('width_ring'),widg1);
    else
        warndlg('The input parameter is wrong','Warning');
    end
else
    warndlg('The input parameter is empty','Warning');
end

% --- Executes on button press in CalcPatCentBut.
function CalcPatCentBut_Callback(hObject, eventdata, handles)
% hObject    handle to CalcPatCentBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sliderVal;
Ring = get(handles.RingTable,'Data');
DiffPat = handles.dat(:,:,sliderVal);
% im=get(handles.Image);
markertrue = get(handles.maketrue,'Value');
% for Kids = 1:length(im.Children)
%     Child = im.Children(Kids);
%     if strcmp(get(Child,'Type'),'image')
%         DiffPat=get(im.Children(Kids),'CData');
%     end
% end
if markertrue == 1
    DiffPat = DiffPat.*(handles.Mask);
    set(handles.textStatus, 'String', sprintf('Radial average of the image with mask was shown'));
%     DiffPat2=DiffPat(:,:,1)*(handles.Mask);
% else
%     DiffPat2=DiffPat(:,:,1);
end
DiffPat2=DiffPat(:,:,1);
set(handles.textStatus, 'String', sprintf('Radial average of the image without mask was shown'));
% DiffPat2=DiffPat2(:);

% DiffPat2(:,2) = X(:);
% DiffPat2(:,3) = Y(:);
% DiffPat2=double(DiffPat2);
% DiffPat2(:,4)=sqrt((DiffPat2(:,2)-Ring(1)).^2+(DiffPat2(:,3)-Ring(2)).^2);
% DiffPat2=int16(DiffPat2);

% Calculate average pattern centre and update RingTable
% [Centre(1,1),Centre(1,2)]=find(minRadius);
Centre(1,1) = mean(Ring(:,1));
Centre(1,2) = mean(Ring(:,2));
Ring(:,4) = sqrt((Ring(:,1) - Centre(1)).^2 + (Ring(:,2) - Centre(2)).^2);
Centre(3) = mean(Ring(:,4));
set(handles.RingTable,'Data',Ring);

% Setup azimuthal integration of diffraction image
[X,Y] = meshgrid(1:size(DiffPat,2),1:size(DiffPat),1);
Radius = sqrt((X-Centre(1)).^2+(Y-Centre(2)).^2);
% for RingCount = 1:size(Ring,1)
%     Radius(:,:,RingCount) = sqrt((X-Ring(RingCount,1)).^2+(Y-Ring(RingCount,2)).^2);
% end
% meanRadius = mean(Radius,3);
% minRadius = imregionalmin(meanRadius);
A = accumarray(int16(Radius(:)+1), DiffPat2(:));
A(:,2) = 1:length(A);
A(:,3) = 2:length(A)+1;
A(:,4) = pi*(A(:,3).^2-A(:,2).^2);
A(:,5) = A(:,1)./A(:,4);
PiNormInt = A(:,5);
cla(handles.Cake) % Added 2016-1-6 13:01 to prevent multiple graph overlay 
% with repeated use ofCreate Pattern Centre button
Caked = plot(handles.Cake,PiNormInt);
box on
xlabel(handles.Cake,'Radius (pixels)')
ylabel(handles.Cake,'Average ring intensity')
axes(handles.Cake)
axis tight
hold on
RingRadOnly = Ring(:,3)+1;
RingRadOnly(RingRadOnly==0) = [];
RingRad = stem(handles.Cake,RingRadOnly,PiNormInt(int16(RingRadOnly)),'.');
set(RingRad,'Marker','o',...
    'LineStyle',':',...
    'LineWidth',1,...
    'MarkerSize',3,...
    'MarkerFaceColor','red',...
    'MarkerEdgeColor','red',...
    'Color','red')

% Plot pattern centre
axes(handles.Image)
hold on
hPatCent = plot(handles.Image,Centre(1,1),Centre(1,2),...
    'wo',...
    'MarkerSize',5);
hRingCents = plot(handles.Image,Ring(:,1),Ring(:,2),...
    'ro',...
    'MarkerSize',3);   
hBright = viscircles([Ring(:,1),Ring(:,2)],RingRadOnly,'EdgeColor','b');
% Output to LatticeSpacing
LatSpacData = get(handles.LatticeSpacing,'Data');
% LatSpacData(1:length(Ring),1) =  num2cell(1./(get(handles.PixSizeText,'Value')*Ring(:,3)));
% 2016-1-6, 12:29 line below replaces line above. Fixes error when number of
% rings is less than 4.
LatSpacData(1:size(Ring,1),1) =  num2cell(1./(get(handles.PixSizeText,'Value')*Ring(:,3)));
LatSpacData(:,5) = num2cell(abs(cell2mat(LatSpacData(:,1))-cell2mat(LatSpacData(:,2))));
% LatSpacData(1:length(Ring),6) =  num2cell(get(handles.PixSizeText,'Value')*Ring(:,3));
% 2016-1-6, 12:32 line below replaces line above. Fixes error when number of
% rings is less than 4.
LatSpacData(1:size(Ring,1),6) =  num2cell(get(handles.PixSizeText,'Value')*Ring(:,3));
set(handles.LatticeSpacing,'Data',LatSpacData)


% Adjust user control
% Controls on
set(handles.LatticeSpacing,'Enable','on')
set(handles.ExportDataBut,'Enable','on')
set(handles.radialplotshow,'Enable','on')
set(handles.textStatus, 'String', sprintf('Show the radial plot'));
guidata(hObject, handles);

% set(handles.Cake,'hittest','on')
% set(handles.Cake,'ButtonDownFcn',Cake_ButtonDownFcn)
% set(Caked,'hittest','on','ButtonDownFcn',Cake_ButtonDownFcn)
% set(RingRad,'hittest','on','ButtonDownFcn',Cake_ButtonDownFcn)
% --- Executes on mouse press over axes background.
function Image_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set(gca,'ButtonDownFcn','selectmoveresize')

% [x, y] = ginput
% [x, y] = getpts(hObject)

disp('you clicked on Image')


% --------------------------------------------------------------------
function ImagePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ImagePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Ring = get(handles.RingTable,'Data');
CurrentRingPix = get(handles.PixTable,'UserData');
CurrentRing = get(handles.CurrentRingPop,'Value');

[x, y] = getpts(handles.Image);
CurrentRingPix(CurrentRing).Ring = [x y];

[xc,yc,R,a] = circfit(x,y);
Ring(CurrentRing,1:3) = [xc yc R];
set(handles.RingTable,'Data',Ring)

set(handles.RingTable,'Data',Ring)
set(handles.PixTable,'UserData',CurrentRingPix)
set(handles.PixTable,'Data',CurrentRingPix(CurrentRing).Ring)

axes(handles.Image)
hBright = viscircles([xc,yc],R,'EdgeColor','r');
% Adjust user control
% Controls on
set(handles.CalcPatCentBut,'Enable','on')

% Controls off
% axes(handles.Image);

% --------------------------------------------------------------------
function MagPanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to MagPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('you clicked on Mag Panel')


% --- Executes on button press in SelectPixels.
function SelectPixels_Callback(hObject, eventdata, handles)
% hObject    handle to SelectPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [x, y] = getpts(handles.Image)
ImagePanel_ButtonDownFcn(hObject, eventdata, handles)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SelectPixels.
function SelectPixels_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SelectPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Image


% --- Executes on button press in EditRings.
function EditRings_Callback(hObject, eventdata, handles)
% hObject    handle to EditRings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Adjust user control
% Controls on
set(handles.RingNumSlide,'Enable','on')
set(handles.RingNumText,'Enable','on')
% Controls off
set(handles.SelectPixels,'Enable','off')
set(handles.findcircle,'Enable','off')
set(handles.sensitivity,'Enable','off')
set(handles.radius,'Enable','off')


% --- Executes during object creation, after setting all properties.
function PixTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'X Coord','Y Coord'})
Data = zeros(1,2);
set(hObject,'Data',Data);
UserData = struct('Ring',Data);
set(hObject,'UserData',UserData);


% --- Executes during object creation, after setting all properties.
function RingTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RingTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'X Centre','Y Centre','Radius','Cent. Dev.'})
Ring = zeros(1,4);
set(hObject,'Data',Ring)


% --- Executes on mouse press over axes background.
function Cake_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Cake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extCakehandle= figure;


% --- Executes during object creation, after setting all properties.
function LatticeSpacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatticeSpacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'Ring Dia. (Å)',...
    'd Spacing (Å)',...
    'Index',...
    'Phase',...
    'Exp.-Ref. Dev. (A)',...
    'Ring Dia. (1/Å)'})


% --- Executes during object creation, after setting all properties.
function ECS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ECS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ECS

function    LineSpacData = SetUpLatticeSpacingUITable(Value)
% Populates the LineSpacData variable for the LatticeSpacing table
LineSpacData = cell(Value,4);
TextPreFil = '-';
TextPreFil(2:Value,1)=TextPreFil;
TextPreFil = cellstr(TextPreFil);
NumPreFil = num2cell(zeros(Value,1));

LineSpacData(:,1) = NumPreFil;
LineSpacData(:,2) = NumPreFil;
LineSpacData(:,3) = TextPreFil;
LineSpacData(:,4) = TextPreFil;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Copyright.
function Copyright_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Copyright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%# read text file lines as cell array of strings

% Stolen from http://stackoverflow.com/questions/7910287/what-is-the-best-way-to-display-a-large-text-file-in-matlab-guide
fid = fopen( fullfile(pwd,'ReadDMFile copyright.txt') );
str = textscan(fid, '%s', 'Delimiter','\n'); str = str{1};
fclose(fid);

% Display ReadDMF Copyright notice
hFig = figure('Menubar','none', 'Toolbar','none', 'Name','ReadDMFile.m','NumberTitle','off');
hPan = uipanel(hFig, 'Title','Copyright Notice', ...
    'Units','normalized', 'Position',[0.05 0.05 0.9 0.9]);
hEdit = uicontrol(hPan, 'Style','edit', 'FontSize',9, ...
    'Min',0, 'Max',2, 'HorizontalAlignment','left', ...
    'Units','normalized', 'Position',[0 0 1 1], ...
    'String',str);

% %# enable horizontal scrolling
% jEdit = findjobj(hEdit);
% jEditbox = jEdit.getViewport().getComponent(0);
% jEditbox.setWrapping(false);                %# turn off word-wrapping
% jEditbox.setEditable(false);                %# non-editable
% set(jEdit,'HorizontalScrollBarPolicy',30);  %# HORIZONTAL_SCROLLBAR_AS_NEEDED
% 
% %# maintain horizontal scrollbar policy which reverts back on component resize 
% hjEdit = handle(jEdit,'CallbackProperties');
% set(hjEdit, 'ComponentResizedCallback',...
%     'set(gcbo,''HorizontalScrollBarPolicy'',30)')

% Display circfit copyright notice
fid = fopen( fullfile(pwd,'circfit copyright.txt') );
str = textscan(fid, '%s', 'Delimiter','\n'); str = str{1};
fclose(fid);

hFig = figure('Menubar','none', 'Toolbar','none', 'Name','circfit.m','NumberTitle','off');
hPan = uipanel(hFig, 'Title','Copyright Notice', ...
    'Units','normalized', 'Position',[0.05 0.05 0.9 0.9]);
hEdit = uicontrol(hPan, 'Style','edit', 'FontSize',9, ...
    'Min',0, 'Max',2, 'HorizontalAlignment','left', ...
    'Units','normalized', 'Position',[0 0 1 1], ...
    'String',str);

% Display PDVI copyright notice
fid = fopen( fullfile(pwd,'DiffractIndex copyright.txt') );
str = textscan(fid, '%s', 'Delimiter','\n'); str = str{1};
fclose(fid);

hFig = figure('Menubar','none', 'Toolbar','none', 'Name','DiffractIndex.m','NumberTitle','off');
hPan = uipanel(hFig, 'Title','Copyright Notice', ...
    'Units','normalized', 'Position',[0.05 0.05 0.9 0.9]);
hEdit = uicontrol(hPan, 'Style','edit', 'FontSize',9, ...
    'Min',0, 'Max',2, 'HorizontalAlignment','left', ...
    'Units','normalized', 'Position',[0 0 1 1], ...
    'String',str);


function PixSizeText_Callback(hObject, eventdata, handles)
% hObject    handle to PixSizeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PixSizeText as text
%        str2double(get(hObject,'String')) returns contents of PixSizeText as a double
PixSize = str2double(get(hObject,'String'));
set(hObject,'Value',PixSize)


% --- Executes when entered data in editable cell(s) in LatticeSpacing.
function LatticeSpacing_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to LatticeSpacing (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

LatSpacData = get(handles.LatticeSpacing,'Data');
% NewData = eventdata.NewData);
% Indices = get(eventdata.Indices);
LatSpacData{eventdata.Indices(:,1),eventdata.Indices(:,2)} = eventdata.NewData;
LatSpacData(:,5) = num2cell(abs(cell2mat(LatSpacData(:,1))-cell2mat(LatSpacData(:,2))));
set(handles.LatticeSpacing,'Data',LatSpacData)


% --- Executes on key press with focus on ExportDataBut and none of its controls.
function ExportDataBut_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ExportDataBut (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DiffXOnly.
function DiffXOnly_Callback(hObject, eventdata, handles)
% hObject    handle to DiffXOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DiffXOnly


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Progname.
function Progname_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Progname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Progname clicked')



function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sliderVal
global slider
previous = get(hObject,'String');
sliderVal = round(str2double(previous));
if (sliderVal > slider)
    uiwait(warndlg('Value is out of range','!! Warning !!'));
    set(hObject,'String',num2str(1));
    sliderVal    = 1;
else if (sliderVal < 1)
        uiwait(warndlg('Value should be positive','!! Warning !!'));
        set(hObject,'String',num2str(slider))
        sliderVal    = slider;
    else if (isnan(sliderVal))
            uiwait(warndlg('Valve should be number','!! Warning !!'));
            set(hObject,'String',num2str(slider))
            sliderVal    = slider;
        end
    end
end
set(handles.previous,'string',sprintf('%d',sliderVal));
set(handles.slide,'value',sliderVal);
slide_Callback(handles.slide, eventdata, handles);
set(handles.textStatus, 'String', sprintf('Showing file: %d',sliderVal));
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


% --- Executes on slider movement.
function slide_Callback(hObject, eventdata, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot image in "Image Axes"
global slider
global sliderVal
% global dat
% [~,~,slider] = size(handles.dat);
if slider > 1
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
else
     set(hObject,'Min',1,'Max',slider+1, 'SliderStep',[1 1]);
end
set(handles.previous,'string',sprintf('%d',sliderVal));
show_Callback(handles.slide, eventdata, handles);
vertical = get(handles.checkvertical,'Value');
if vertical == 1
    horizontal_Callback(handles.horizontal, eventdata, handles);
    Vertical_Callback(handles.Vertical, eventdata, handles);
else
    Vertical_Callback(handles.Vertical, eventdata, handles);    
    horizontal_Callback(handles.horizontal, eventdata, handles);  
end
set(handles.textStatus, 'String', sprintf('Showing file: %d',sliderVal));
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot image in "Image Axes"
global sliderVal
% global dat
axes(handles.Image);
cla(handles.Image);
%    imhandle = imagesc(DiffPattern); 
iptsetpref('ImshowAxesVisible','on');
min = get(handles.colormin,'string');
cmin = str2double(min);
max = get(handles.colormax,'string');
cmax = str2double(max);
imhandle = imagesc(handles.dat(:,:,sliderVal),[cmin cmax]); 
% hpanel = imoverviewpanel(handles.ImagePanel,imhandle);
% axis image
% hpanel = imscrollpanel(handles.ImagePanel,imhandle);
% % set(hpanel,'Position',[0 0 0.9 0.9])
% % set(hpanel,'ButtonDownFcn',@clickImagem2H);
% hMagBox = immagbox(handles.ImagePanel,imhandle);
% set(hMagBox,'Units','normalized');
% pos = get(hMagBox,'Position');
% % set(hMagBox,'Position',[0 1 pos(3) pos(4)]);
% hpanel = imoverviewpanel(handles.MagPanel,imhandle);



function horizontal_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=get(handles.Image);
for Kids = 1:length(im.Children)
    Child = im.Children(Kids);
    if strcmp(get(Child,'Type'),'image')
        DiffPat=double(get(im.Children(Kids),'CData'));
    end
end
previous = get(hObject,'String');
hori = round(str2double(previous));
set(handles.horizontal,'string',sprintf('%d',hori));
show_Callback(handles.slide, eventdata, handles);
axes(handles.Image);
hold on;
plot(1:length(DiffPat(hori,:)),hori*ones(1,length(DiffPat(hori,:))),'k','linewidth',1.5)
cla(handles.Mag) % prevent multiple graph overlay 
% with repeated use ofCreate Pattern Centre button
axes(handles.Mag)
findpeaks(DiffPat(hori,:),'MinPeakDistance',20,'MinPeakWidth',5,'MinPeakProminence',300,'Annotate','extents');
box on
grid off
legend off
xlabel(handles.Mag,'Radius (pixels)')
ylabel(handles.Mag,'Intensity')
[pks(:,2),pks(:,1),pks(:,3),pks(:,4)] = findpeaks(DiffPat(hori,:),'MinPeakDistance',20,'MinPeakWidth',5,'MinPeakProminence',300,'SortStr','descend');
text(pks(:,1)+.02,pks(:,2),num2str((1:numel(pks(:,2)))'));
pkss = sortrows(pks,2,'descend');
set(handles.PixTable,'Data',pkss)
set(handles.textStatus, 'String', sprintf('Horizaontal profile plot with y = %d',hori));

% Hints: get(hObject,'String') returns contents of horizontal as text
%        str2double(get(hObject,'String')) returns contents of horizontal as a double


% --- Executes during object creation, after setting all properties.
function horizontal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Vertical_Callback(hObject, eventdata, handles)
% hObject    handle to Vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
radialplot = get(handles.radialplotshow,'Value');
if radialplot == 1
    CalcPatCentBut_Callback(hObject, eventdata, handles);
else
im=get(handles.Image);
for Kids = 1:length(im.Children)
    Child = im.Children(Kids);
    if strcmp(get(Child,'Type'),'image')
        DiffPat=double(get(im.Children(Kids),'CData'));
    end
end
previous = get(hObject,'String');
verti = round(str2double(previous));
set(handles.Vertical,'string',sprintf('%d',verti));
show_Callback(handles.slide, eventdata, handles);
axes(handles.Image);
hold on;
plot(verti*ones(1,length(DiffPat(:,verti))),1:length(DiffPat(:,verti)),'k','linewidth',1.5)
cla(handles.Cake) % prevent multiple graph overlay 
% with repeated use ofCreate Pattern Centre button
axes(handles.Cake)
% Maged = plot(handles.Cake,PiNormInt);
findpeaks(DiffPat(:,verti),'MinPeakDistance',20,'MinPeakWidth',5,'MinPeakProminence',300,'Annotate','extents');
box on
grid off
legend off
xlabel(handles.Cake,'Radius (pixels)')
ylabel(handles.Cake,'Intensity')
[pks(:,2),pks(:,1),pks(:,3),pks(:,4)] = findpeaks(DiffPat(:,verti),'MinPeakDistance',20,'MinPeakWidth',5,'MinPeakProminence',300,'SortStr','descend');
text(pks(:,1)+.02,pks(:,2),num2str((1:numel(pks(:,2)))'));
pkss = sortrows(pks,2,'descend');
set(handles.PixTable,'Data',pkss);
set(handles.textStatus, 'String', sprintf('Vertical profile plot with x = %d',verti));
end
% Hints: get(hObject,'String') returns contents of Vertical as text
%        str2double(get(hObject,'String')) returns contents of Vertical as a double


% --- Executes during object creation, after setting all properties.
function Vertical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in checkhorizontal.
function checkhorizontal_Callback(hObject, eventdata, handles)
% hObject    handle to checkhorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pgate = get(hObject,'Value');
if pgate == 1
    set(handles.checkvertical, 'value', 0);
    previous = get(handles.horizontal,'String');
    set(handles.textStatus, 'String', sprintf('Horizontal profile plot with y = %s',previous));
    horizontal_Callback(handles.horizontal, eventdata, handles);
else
    set(handles.checkvertical, 'value', 1);
    Vertical_Callback(handles.Vertical, eventdata, handles);
end
% Hint: get(hObject,'Value') returns toggle state of checkhorizontal


% --- Executes on button press in checkvertical.
function checkvertical_Callback(hObject, eventdata, handles)
% hObject    handle to checkvertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pgate = get(hObject,'Value');
if pgate == 1
    set(handles.checkhorizontal, 'value', 0);
    previous = get(handles.Vertical,'String');
    set(handles.textStatus, 'String', sprintf('Vertical profile plot with x = %s',previous));
    Vertical_Callback(handles.Vertical, eventdata, handles);
else
    set(handles.checkhorizontal, 'value', 1);
    horizontal_Callback(handles.horizontal, eventdata, handles);
end
% Hint: get(hObject,'Value') returns toggle state of checkvertical


% --------------------------------------------------------------------
function opend_Callback(hObject, eventdata, handles)
% hObject    handle to opend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FilterSpec = {'*.DiffX'};
DialogTitle = 'Choose a Dataset';
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle);
if FileName == 0
    uiwait(warndlg(sprintf('Error: No file was selected')));
    return
end
filepath = fullfile(PathName,FileName);

load(filepath,'-mat')

% DiffX.Image = DiffPat;
set(handles.PixSizeText,'Value',DiffX.PixSizeText);
set(handles.PixSizeText,'String',num2str(DiffX.PixSizeText));
set(handles.PixTable,'UserData',DiffX.PixTable);
set(handles.RingTable,'Data',DiffX.RingTable);
set(handles.LatticeSpacing,'Data',DiffX.LatticeSpacing);
set(handles.RingNumSlide,'Value',DiffX.RingNumVal)
set(handles.RingNumText,'String',DiffX.RingNumText)
set(handles.CurrentRingPop,'Value',1)
set(handles.CurrentRingPop,'Enable','on')
set(handles.CurrentRingPop,'String',DiffX.CurrentRingPop)

CurrentRingPix = get(handles.PixTable,'UserData');
set(handles.PixTable,'Data',CurrentRingPix(1).Ring)
set(handles.CalcPatCentBut,'Enable','on')
% Force user to open original image
% OpenImageBut_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function copyimage_Callback(hObject, eventdata, handles)
% hObject    handle to copyimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
% set(Fig2, 'Position', [80,100,1000,620]);
set(Fig2, 'color', 'w');
new_axes = copyobj(handles.Image, Fig2);
set(new_axes, 'Units', 'Normalized', 'Position', 'default');
% set(Fig2, 'Position', [80,100,1000,620]);
grid(new_axes, 'off')
set(new_axes,'fontsize',16);
hay = get(new_axes,'Ylabel');
hax = get(new_axes,'Xlabel');
NewFontSize = 16;
set(hay,'Fontsize',NewFontSize);
set(hax,'Fontsize',NewFontSize);
set(Fig2, 'PaperpositionMode', 'auto');

% --------------------------------------------------------------------
function copyhorizontal_Callback(hObject, eventdata, handles)
% hObject    handle to copyhorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
% set(Fig2, 'Position', [80,100,1000,620]);
set(Fig2, 'color', 'w');
new_axes = copyobj(handles.Mag, Fig2);
set(new_axes, 'Units', 'Normalized', 'Position', 'default');
set(Fig2, 'Position', [80,100,1000,620]);
grid(new_axes, 'off')
set(new_axes,'fontsize',16);
hay = get(new_axes,'Ylabel');
hax = get(new_axes,'Xlabel');
NewFontSize = 16;
set(hay,'Fontsize',NewFontSize);
set(hax,'Fontsize',NewFontSize);
set(Fig2, 'PaperpositionMode', 'auto');

% --------------------------------------------------------------------
function copyvertical_Callback(hObject, eventdata, handles)
% hObject    handle to copyvertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
% set(Fig2, 'Position', [80,100,1000,620]);
set(Fig2, 'color', 'w');
new_axes = copyobj(handles.Cake, Fig2);
set(new_axes, 'Units', 'Normalized', 'Position', 'default');
set(Fig2, 'Position', [80,100,1000,620]);
grid(new_axes, 'off')
set(new_axes,'fontsize',16);
hay = get(new_axes,'Ylabel');
hax = get(new_axes,'Xlabel');
NewFontSize = 16;
set(hay,'Fontsize',NewFontSize);
set(hax,'Fontsize',NewFontSize);
set(Fig2, 'PaperpositionMode', 'auto');



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
findcircle_Callback(handles.findcircle, eventdata, handles);
% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findcircle.
function findcircle_Callback(hObject, eventdata, handles)
% hObject    handle to findcircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=get(handles.Image);
for Kids = 1:length(im.Children)
    Child = im.Children(Kids);
    if strcmp(get(Child,'Type'),'image')
        DiffPat=get(im.Children(Kids),'CData');
    end
end
radiu = get(handles.radius,'String');
radiusv = round(str2double(radiu));
sensi = get(handles.sensitivity,'String');
sensit = str2double(sensi);
[centersBright, radiiBright] = imfindcircles(DiffPat,[radiusv-5, radiusv+5],'ObjectPolarity', 'bright','Sensitivity',sensit);
set(handles.textStatus, 'String', sprintf('%d circles are found on image',length(radiiBright)));
if ~isempty(radiiBright)
    Ring = get(handles.RingTable,'Data');
    CurrentRing = get(handles.CurrentRingPop,'Value');
    Ring(CurrentRing,1:3) = [centersBright(1,:), radiiBright(1,:)];
    set(handles.RingTable,'Data',Ring)
    axes(handles.Image);
    hold on;
    hBright = viscircles(centersBright(1,:), radiiBright(1,:),'EdgeColor','r');
    set(handles.CalcPatCentBut,'Enable','on')
end



function sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
findcircle_Callback(handles.findcircle, eventdata, handles);
% Hints: get(hObject,'String') returns contents of sensitivity as text
%        str2double(get(hObject,'String')) returns contents of sensitivity as a double


% --- Executes during object creation, after setting all properties.
function sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormin_Callback(hObject, eventdata, handles)
% hObject    handle to colormin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
min = get(hObject,'string');
cmin = round(str2double(min));
max = get(handles.colormax,'string');
cmax = round(str2double(max));
axes(handles.Image);
caxis([cmin, cmax]);
set(handles.textStatus, 'String', sprintf('Colorbar range changed to [%d %d]',cmin,cmax));
% Hints: get(hObject,'String') returns contents of colormin as text
%        str2double(get(hObject,'String')) returns contents of colormin as a double


% --- Executes during object creation, after setting all properties.
function colormin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormax_Callback(hObject, eventdata, handles)
% hObject    handle to colormax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
max = get(hObject,'string');
cmax = round(str2double(max));
min = get(handles.colormin,'string');
cmin = round(str2double(min));
axes(handles.Image);
caxis([cmin, cmax]);
set(handles.textStatus, 'String', sprintf('Colorbar range changed to [%d %d]',cmin,cmax));
% Hints: get(hObject,'String') returns contents of colormax as text
%        str2double(get(hObject,'String')) returns contents of colormax as a double


% --- Executes during object creation, after setting all properties.
function colormax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function subopen_Callback(hObject, eventdata, handles)
% hObject    handle to subopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider
global sliderVal
clear handles.dat
answer = questdlg('Would you like to substract the background image?', ...
    'Substraction Menu', ...
    'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        sub = 1;
        uiwait(msgbox('Please select the background image file','Select'));
        [filenameall, pathname] = uigetfile({'*.bin';'*.png';'*.tif';'*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'bin')
            handles.backg = ReadspeAndorIndividual(file);
        else
            uiwait(warndlg(sprintf('Error: Not the background bin file')));
        end
    case 'No'
        sub = 0;
        disp('Donot substract the background.')
end
uiwait(msgbox('Please select the data file','Select'));
[filenameall, pathname] = uigetfile({'*.bin';'*.png';'*.tif';'*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if iscell(filenameall) || ischar(filenameall)
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        slider = length(filenameall);
%         delete handles.dat;
        for i = 1:slider
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);            
            if strcmp(filename(dot+1:end), 'bin')
                if sub == 1
                    handles.dat(:,:,i) = ReadspeAndorIndividual(file)-handles.backg;
                else
                    handles.dat(:,:,i) = ReadspeAndorIndividual(file);
                    fprintf('Reading file: %s\n',filename);
                end
            else
                uiwait(warndlg(sprintf('Error: Not the diffraction bin file')));
            end
        end
        fprintf('Done. %d files were loaded\n',slider);
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        slider = 1;
        if strcmp(filename(dot+1:end), 'bin')
            if sub == 1
                handles.dat = ReadspeAndorIndividual(file)-handles.backg;
            else
                handles.dat = ReadspeAndorIndividual(file);
            end
        else
            uiwait(warndlg(sprintf('Error: Not the diffraction bin file')));
        end
    end
    set(handles.textStatus, 'String', sprintf('Opened %d files',slider))
    sliderVal = 1;
    set(handles.slide, 'Value', sliderVal);
    show_Callback(handles.slide, eventdata, handles);
    
    % Save file path for export data function
    set(handles.OpenImageBut,'UserData',file)
    
    % Adjust user control
    % Controls on
    set(handles.RingNumSlide,'Enable','on')
    set(handles.RingNumText,'Enable','on')
    set(handles.slide,'Enable','on')
    set(handles.previous,'Enable','on')
    set(handles.Vertical,'Enable','on')
    set(handles.horizontal,'Enable','on')
    set(handles.checkvertical,'Enable','on')
    set(handles.checkhorizontal,'Enable','on')
    set(handles.Calculate,'Enable','on')
    set(handles.colormin,'Enable','on')
    set(handles.colormax,'Enable','on')
else
    uiwait(warndlg(sprintf('Error: No file was selected')));
end
guidata(hObject, handles);


% --- Executes on button press in radialplotshow.
function radialplotshow_Callback(hObject, eventdata, handles)
% hObject    handle to radialplotshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pgate = get(hObject,'Value');
if pgate == 1
%     set(handles.checkhorizontal, 'value', 0);
%     previous = get(handles.Vertical,'String');
    set(handles.textStatus, 'String', sprintf('Radio plot is shown'));
    CalcPatCentBut_Callback(hObject, eventdata, handles);
else
    set(handles.textStatus, 'String', sprintf('Vertical profile is shown'));
    Vertical_Callback(handles.Vertical, eventdata, handles);
end

% Hint: get(hObject,'Value') returns toggle state of radialplotshow


% --------------------------------------------------------------------
function openind_Callback(hObject, eventdata, handles)
% hObject    handle to openind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider
global sliderVal
clear handles.dat
answer = questdlg('Would you like to substract the background image?', ...
    'Substraction Menu', ...
    'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        sub = 1;
        uiwait(msgbox('Please select the background image file','Select'));
        [filenameall, pathname] = uigetfile({'*.bin';'*.png';'*.tif';'*.hdf5'}, 'Open Data','MultiSelect','on');
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        if strcmp(filename(dot+1:end), 'bin')
            handles.backg = ReadspeIndividual(file);
        else
            uiwait(warndlg(sprintf('Error: Not the background bin file')));
        end
    case 'No'
        sub = 0;
        disp('Donot substract the background.')
end
uiwait(msgbox('Please select the data file','Select'));
[filenameall, pathname] = uigetfile({'*.bin';'*.png';'*.tif';'*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if iscell(filenameall) || ischar(filenameall)
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        slider = length(filenameall);
%         delete handles.dat;
        for i = 1:slider
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);            
            if strcmp(filename(dot+1:end), 'bin')
                if sub == 1
                    handles.dat(:,:,i) = ReadspeIndividual(file)-handles.backg;
                else
                    handles.dat(:,:,i) = ReadspeIndividual(file);                    
                end
                handles.t(i) = str2double(regexp(filename, '\d*(?=fs)', 'match'));
                fprintf('Reading file: %s\n',filename);
            else
                uiwait(warndlg(sprintf('Error: Not the diffraction bin file')));
            end
        end
        fprintf('Done. %d files were loaded\n',slider);
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        slider = 1;
        if strcmp(filename(dot+1:end), 'bin')
            if sub == 1
                handles.dat = ReadspeIndividual(file)-handles.backg;
            else
                handles.dat = ReadspeIndividual(file);
            end
            handles.t = str2double(regexp(filename, '\d*(?=fs)', 'match'));
            fprintf('Reading file: %s\n',filename);
        else
            uiwait(warndlg(sprintf('Error: Not the diffraction bin file')));
        end
    end
    set(handles.textStatus, 'String', sprintf('Opened %d files',slider))
    sliderVal = 1;
    set(handles.slide, 'Value', sliderVal);
    show_Callback(handles.slide, eventdata, handles);
    
    % Save file path for export data function
    set(handles.OpenImageBut,'UserData',file)
    
    % Adjust user control
    % Controls on
    set(handles.RingNumSlide,'Enable','on')
    set(handles.RingNumText,'Enable','on')
    set(handles.slide,'Enable','on')
    set(handles.previous,'Enable','on')
    set(handles.Vertical,'Enable','on')
    set(handles.horizontal,'Enable','on')
    set(handles.checkvertical,'Enable','on')
    set(handles.checkhorizontal,'Enable','on')
    set(handles.Calculate,'Enable','on')
    set(handles.colormin,'Enable','on')
    set(handles.colormax,'Enable','on')
else
    uiwait(warndlg(sprintf('Error: No file was selected')));
end
guidata(hObject, handles);%This sentence is important for return the value for functions


% --------------------------------------------------------------------
function copyimagemovie_Callback(hObject, eventdata, handles)
% hObject    handle to copyimagemovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider
v = VideoWriter('Image.avi');
v.FrameRate = 2;
open(v);
figure;
iptsetpref('ImshowAxesVisible','on');
min = get(handles.colormin,'string');
cmin = str2double(min);
max = get(handles.colormax,'string');
cmax = str2double(max);
xLimits = get(handles.Image,'XLim');  %# Get the range of the x axis
yLimits = get(handles.Image,'YLim');  %# Get the range of the y axis
for i = 1:slider
imhandle = imagesc(handles.dat(:,:,i),[cmin cmax]); 
axis equal;
colormap gray; 
set(gca,'fontsize',14)
xlim(xLimits);
ylim(yLimits);
colorbar;
xlabel('Pixel');
ylabel('Pixel');
set(gcf, 'Position', [160,200,1400,1400]);
% imresize(gcf, 2);
if isempty(handles.t)
    title(sprintf('Scan No.%d',i),'Fontsize',20);
else
    title(sprintf('Delay scan at %g ps',handles.t(i)/1000),'Fontsize',20);
end
frame = getframe(gcf);
writeVideo(v,frame);
end
close(v);

    

% --------------------------------------------------------------------
function assignimage_Callback(hObject, eventdata, handles)
% hObject    handle to assignimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base',sprintf('Diffraction_Image_Data'),handles.dat);
set(handles.textStatus, 'String', sprintf('Raw data was copied to the workspace'));


% --- Executes on button press in maketrue.
function maketrue_Callback(hObject, eventdata, handles)
% hObject    handle to maketrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pgate = get(hObject,'Value');
CalcPatCentBut_Callback(hObject, eventdata, handles);
% Hint: get(hObject,'Value') returns toggle state of maketrue



function mask_rb_min_Callback(hObject, eventdata, handles)
% hObject    handle to mask_rb_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of mask_rb_min as text
%        str2double(get(hObject,'String')) returns contents of mask_rb_min as a double


% --- Executes during object creation, after setting all properties.
function mask_rb_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_rb_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mask_rb_max_Callback(hObject, eventdata, handles)
% hObject    handle to mask_rb_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of mask_rb_max as text
%        str2double(get(hObject,'String')) returns contents of mask_rb_max as a double


% --- Executes during object creation, after setting all properties.
function mask_rb_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_rb_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CreateMask.
function CreateMask_Callback(hObject, eventdata, handles)
% hObject    handle to CreateMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% cen0.x = str2double(get(handles.CenX, 'String'));
% cen0.y = str2double(get(handles.CenY, 'String'));
global sliderVal;
Ring = get(handles.RingTable,'Data');
CurrentRing = get(handles.CurrentRingPop,'Value');
cen0.x = Ring(CurrentRing,1:1);
cen0.y = Ring(CurrentRing,2:2);
IMG = handles.dat(:,:,sliderVal);
bbp_min = 9;%str2double(get(handles.mask_bbp_min, 'String'));
bbp_max = 9;%str2double(get(handles.mask_bbp_max, 'String'));
rb_min = str2double(get(handles.mask_rb_min, 'String'));
rb_max = str2double(get(handles.mask_rb_max, 'String'));

BeamBlock2 = findBeamBlock(IMG, cen0, [bbp_min, bbp_max]); 
RoundMask = fRoundMask(IMG, cen0, rb_max);
CenterMask = ~fRoundMask(IMG, cen0, rb_min);
BeamBlock2 = BeamBlock2 | RoundMask | CenterMask;
% MASK = 1-BeamBlock2;
MASK = ~BeamBlock2;
handles.Mask = MASK;

axes(handles.Mag);
imagesc(MASK); colormap gray; pbaspect([1 1 1]);

axes(handles.Image);
imagesc(IMG.*MASK); colormap gray; pbaspect([1 1 1]);
set(handles.textStatus, 'String', sprintf('Mask for the beam block was shown'));
guidata(hObject, handles);


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Profile.
function Profile_Callback(hObject, eventdata, handles)
% hObject    handle to Profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sliderVal;
DiffPat = handles.dat(:,:,sliderVal);
axes(handles.Image);
[cx,cy,c]=improfile;
hold on;
plot(cx,cy,'k','linewidth',1.5);
h = figure('PaperSize',[8.267716 15.692913]);
% plot(c,'linewidth',1.5);
improfile(DiffPat,[cx(1),cx(end)],[cy(1),cy(end)]);
set(gca,'fontsize',20);
set(h, 'Position', [160,200,700,62*7]);
set(h, 'PaperpositionMode', 'auto');
xlabel('Pixel', 'FontSize', 20);
ylabel('Intensity', 'FontSize', 20);


% --------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function histogram_Callback(hObject, eventdata, handles)
% hObject    handle to histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sliderVal;
DiffPat = handles.dat(:,:,sliderVal);
% [pixelCount, grayLevels] = imhist(DiffPat);
h2 = figure('PaperSize',[8.267716 15.692913]);
histogram(DiffPat); % Plot it as a bar chart.
grid off;
% title('Histogram of original image', 'FontSize', fontSize);
set(gca,'fontsize',20);
xlabel('Gray Level', 'FontSize', 20);
ylabel('Pixel Count', 'FontSize', 20);
xlim([0 max(max(DiffPat))]); % Scale x axis manually.
set(h2, 'Position', [160,200,700,62*7]);
set(h2, 'PaperpositionMode', 'auto');


% --------------------------------------------------------------------
function opentxt_Callback(hObject, eventdata, handles)
% hObject    handle to opentxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider
global sliderVal
clear handles.dat
% global dat
[filenameall, pathname] = uigetfile({'*.txt;*.bmp;*.spe;*.bin;*.png;*.tiff;*.hdf5'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if iscell(filenameall) || ischar(filenameall)
    if iscell(filenameall)
        fprintf('More than one file was selected\n')
        slider = length(filenameall);
%         delete handles.dat;
        for i = 1:slider
            filename = filenameall{1,i};
            file = fullfile(pathname, filename);
            dotall = regexp(filename,'\.');
            dot = max(dotall);            
            if strcmp(filename(dot+1:end), 'spe')
                handles.dat(:,:,i) = ReadsspeIndividual(file);  
                handles.t(i) = str2double(regexp(filename, '\d*(?=fs)', 'match'));
                fprintf('Reading file: %s\n',filename);
            elseif strcmp(filename(dot+1:end), 'bmp')
                handles.dat(:,:,i) = double(imread(file));  
                handles.t(i) = str2double(filename(dot-5:dot-1));
                fprintf('Reading file: %s\n',filename);    
            elseif strcmp(filename(dot+1:end), 'tiff')
                handles.dat(:,:,i) = double(imread(file)); 
                num = (regexp(filename, 'delay(\d+)_', 'tokens'));
                handles.t(i) = str2double(num{1}{1});
                fprintf('Reading file: %s\n',filename);                  
            else
                uiwait(warndlg(sprintf('Error: Not the camera .bmp file')));
            end
        end
        fprintf('Done. %d files were loaded\n',slider);
    else
        fprintf('One file was selected\n')
        filename = filenameall;
        file = fullfile(pathname, filename);
        dotall = regexp(filename,'\.');
        dot = max(dotall);
        slider = 1;
        if strcmp(filename(dot+1:end), 'spe')
            handles.dat = ReadsspeIndividual(file);
            handles.t = str2double(regexp(filename, '\d*(?=fs)', 'match'));
            fprintf('Reading file: %s\n',filename);
        elseif strcmp(filename(dot+1:end), 'bmp')
            handles.dat = double(imread(file));
            handles.t = str2double(filename(dot-5:dot-1));
            fprintf('Reading file: %s\n',filename);
        elseif strcmp(filename(dot+1:end), 'txt')
            loginfo = dim_readMeasurementLog(file);
            fprintf('Reading file: %s\n',filename);
            T = struct2table(loginfo);
            sortedT = sortrows(T,'Delay');
            delayT = sortedT.Delay;
            filenameall = sortedT.File;
            slider = length(filenameall);
            for i = 1:slider
                filename = filenameall{i};
                prefile = fullfile(pathname, filename);
                file = strcat(prefile,'.bmp');
                handles.dat(:,:,i) = double(imread(file));
                handles.t(i) = delayT(i)*1e9;
                fprintf('Reading file: %s\n',filename);
            end
        else
            uiwait(warndlg(sprintf('Error: Not the diffraction spe file')));
        end
    end
    set(handles.textStatus, 'String', sprintf('Opened %d files',slider))
    sliderVal = 1;
    set(handles.slide, 'Value', sliderVal);
    show_Callback(handles.slide, eventdata, handles);
    
    % Save file path for export data function
    set(handles.OpenImageBut,'UserData',file)
    
    % Adjust user control
    % Controls on
    set(handles.RingNumSlide,'Enable','on')
    set(handles.RingNumText,'Enable','on')
    set(handles.slide,'Enable','on')
    set(handles.previous,'Enable','on')
    set(handles.Vertical,'Enable','on')
    set(handles.horizontal,'Enable','on')
    set(handles.checkvertical,'Enable','on')
    set(handles.checkhorizontal,'Enable','on')
    set(handles.Calculate,'Enable','on')
    set(handles.colormin,'Enable','on')
    set(handles.colormax,'Enable','on')
    set(handles.Profile,'Enable','on')
else
    uiwait(warndlg(sprintf('Error: No file was selected')));
end
guidata(hObject, handles);
