function [xdata, ydata] = menu_file_open_ns_scan
% hObject    handle to menu_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global isChannelA;
% global isChannelB;
% global isChannelC;
% global isChannelD;
% global recordsize;
% global nofrecords;
% global nofcycle;
% global sliderVal;
% global nofwaveforms;
% global selected_trigger;
% global nofrepes;
% global machename;
% global xdata;
% global ind;
% global figurename;
% global filenumber;
% global settings;
[filenameall, pathname] = uigetfile({'*.hdf5';'*.h5';'*.mat';'*.hdf'}, 'Open Data','MultiSelect','on'); % When open more than one file, please be carful the order is right in file explorer
if ~isempty(filenameall)
    clear handles.current_dataA handles.current_dataB handles.current_dataC handles.current_dataD
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
%                 if isfield(info.Groups,'Attributes') && isempty(info.Groups(1).Attributes)
                 if isfield(info.Groups(1).Attributes,'Value')
                    samplerate = 2e+09; %info.Groups(1).Attributes(6).Value;
                    if samplerate == 2e+09
%                             recordsize = info.Groups(1).Attributes(5).Value; %Samples per record
                            nofrecords = length(info.Groups); % measurement number = xdata number * cycle number
                            nofrepes = 1; % info.Groups(1).Attributes(2).Value; % software average number settings.scan_niterations
                            nofcycle = 1;% iteration number
                            nofwaveforms = str2double(char(info.Groups(1).Attributes(1).Value(3))); % hardware average number
                            selected_trigger = 'External'; %info.Groups(1).Attributes(4).Value; % find(strcmp(string_list,info.Groups(1).Attributes(6).Value));
                            machename = char(info.Groups(1).Attributes((strmatch('Settings',char(info.Groups(1).Attributes.Name)))).Value(1));
                            stepvalue = [];
                        for att = 1:nofrecords
                            if strcmp(machename,'laser power')
                                stepvalue = [stepvalue,str2double(char(info.Groups(att).Attributes(1).Value(2)))*1e6];
                            else if strcmp(machename,'vertical')
                                    stepvalue = [stepvalue,str2double(char(info.Groups(att).Attributes(1).Value(2)))/800];
                                else
                                    stepvalue = 1:nofrecords;
                                end
                            end
                        end
                        if stepvalue(1) < stepvalue(2)
                            xdata = sort(stepvalue);
                        else
                            xdata = sort(stepvalue,'descend');
                        end
                        ydata = [];
                        for i = 1:nofrecords
                                    dataA = h5read(file,strcat('/',num2str(i),'/power meter'));
                                    ydata = [ydata, mean(dataA)];
                     
                        end                        
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
    else
        uiwait(warndlg(sprintf('Error: No file selected')));

end
