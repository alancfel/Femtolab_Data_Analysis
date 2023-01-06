%%
define_command_codes;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global nofwaveforms;
global recordsize;
global nofrecords;
global ChannelsOnDevice;
global manual
global nofrepes;
% global record;
% global nofpretrig;
% global nofholdoff;
global selected_trigger;
global h;
global xlabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
if isfield(handles, 'current_dataA')
    handles = rmfield(handles,fields);
end
SW_TRIGGER_MODE = 1;
%  recordsize = 35000;
t=0:1/(2000):(recordsize-1)/(2000);
n = 1:recordsize;
% nofrecords = 100;
BoardID=1;
% selected_trigger = SW_TRIGGER_MODE;
% Disarm & arm
%  interface_ADQ('disarmtrigger', [],handles.boardid);
%  interface_ADQ('armtrigger', [],handles.boardid);
%  trigged = 0;
% while trigged == 0
%     %pause
%     if selected_trigger== SW_TRIGGER_MODE
%       interface_ADQ('swtrig', [], handles.boardid); % Trig device
%     end
%     [adq_data, junk, adq_status, adq_valid] = interface_ADQ('getacquiredall', [], handles.boardid); % Check if all records collected
%     trigged = adq_status(1);
%     pause(0.01);
% end
record = 0;
for scan = 1:nofrecords
    %clf;
    for repetition = 1:nofrepes
        record = record+1;
        interface_ADQ('waveformaveragingarm',[],BoardID);
        % Acquisition starts.
        
        %    fprintf(1,'\nLoop number = %d\n',index);
        % CODE FOR DIFFERENT TRIGGER MODES.
        status = [0 0 0];
        if selected_trigger == SW_TRIGGER_MODE
            % If Software trigger is selected, send triggers
            % Check for number of collected waveforms
            %   status = [0 0 0]; % Init status parameter
            tStart = tic;
            while status(2)<nofwaveforms
                % not all waveforms have been triggered. Send one trigger nore
                tElapsed = toc(tStart); % Answer in seconds.
                if tElapsed > 0.5*60 % 1 minutes
                    errorMessage = sprintf('Error: Device could not get trigger \n Please check the trigger');
                    uiwait(warndlg(errorMessage));
                    break;
                end
                interface_ADQ('swtrig',[],BoardID);
                [a b status ] = interface_ADQ('WaveformAveragingGetStatus',[],BoardID);
                set(handles.textStatus, 'String', strcat('Software trigger: Number of waveforms ', num2str(status(2))));
                %   fprintf(1,'Software trigger: Number of waveforms %d\n',status(2));
            end
            
        elseif selected_trigger == LEVEL_TRIGGER_MODE
            tStart = tic;
            while status(2)<nofwaveforms
                % Set up according to app note. Connect trig out to channel A through a
                % 10 dB attenuator
                tElapsed = toc(tStart); % Answer in seconds.
                if tElapsed > 0.5*60 % 1 minutes
                    errorMessage = sprintf('Error: Device could not get trigger \n Please check the trigger');
                    uiwait(warndlg(errorMessage));
                    break;
                end
                interface_ADQ('writetrig',1);
                interface_ADQ('writetrig',0);
                pause(0.1)
                [a b status] = interface_ADQ('WaveformAveragingGetStatus',[],BoardID);
                set(handles.textStatus, 'String', strcat('Level trigger: Number of waveforms ', num2str(status(2))));
                %    fprintf(1,'Level trigger: Number of waveforms %d\n',status(2));
            end
            
        elseif selected_trigger == EXTERNAL_TRIGGER_MODE
            for index = 1:nofwaveforms
                interface_ADQ('writetrig',1);
                interface_ADQ('writetrig',0);
                pause(0.1)
                [a b status] = interface_ADQ('WaveformAveragingGetStatus',[],BoardID);
                set(handles.textStatus, 'String', strcat('External trigger: Number of waveforms ', num2str(status(2))));
                %    fprintf(1,'External trigger: Number of waveforms %d\n',status(2));
            end
            
        elseif selected_trigger == INTERNAL_TRIGGER_MODE
            %fprintf(1,'Internal trigger: Wait for triggers ');
            % Check that all waveforms has been triggered. Wait for triggers. This is
            % specially for EXTERNAL_TRIGGER mode. A time out may indicate missing
            % triggers.
            retrymax = 60; % Wait max 60s.
            retries = 0; % count time
            status = [0 0 0]; % Init status parameter [ready records in_idle]
            while retries<retrymax && status(1)==0
                pause(0.2)
                [a b status d] = interface_ADQ('WaveformAveragingGetStatus',[],BoardID);
                retries = retries+1;
                %fprintf(1,'.');
                %
            end
            if retries==retrymax
                set(handles.textStatus, 'String', sprintf('. Time out.\nInternal trigger: Is the trigger connected?\n'));
                %    fprintf(1,'. Time out.\nInternal trigger: Is the trigger connected?\n');
                break;
            else
                set(handles.textStatus, 'String', strcat(sprintf('. Done.\nInternal trigger: Number of waveforms'), num2str(status(2))));
                %    fprintf(1,'. Done.\nInternal trigger: Number of waveforms %d\n',status(2));
            end
            
        else
            set(handles.textStatus, 'String',  sprintf('\nWrong trigger selected. TriggerMode = %d\n\n',selected_trigger));
            %    fprintf(1,'\nWrong trigger selected. TriggerMode = %d\n\n',TriggerMode);
        end
        
        % ---- GET AVERAGED WAVEFORM FROM DIGITIZER ----
        [a b status d] = interface_ADQ('WaveformAveragingGetStatus',[],BoardID);
        ready_flag = status(1);
        set(handles.textStatus, 'String',  sprintf('\nCheck ready flag. Ready = %d\n',ready_flag));
        %fprintf(1,'\nCheck ready flag. Ready = %d\n',ready_flag);
        if ready_flag==1
            set(handles.textStatus, 'String',  sprintf('\nGet waveforms and plot.\n'));
            %  fprintf(1,'\nGet waveforms and plot.\n');
            data(record,:) = interface_ADQ('waveformaveraginggetwaveform',[],BoardID);
            a = mex_ADQ(MATLAB_GET_FIFO_OVERFLOW, BoardID);
            if (a.Status(1) > 0)
                set(handles.textStatus, 'String',  'FIFO overflow error reported. ');
                %   disp('FIFO overflow error reported. ');
            end
        else
            set(handles.textStatus, 'String',  'Not ready. Do not try to read data. ');
            %  disp('Not ready. Do not try to read data. ');
            break;
        end
        
        % Sort the samples
        if (ChannelsOnDevice == 2)
            data_A = zeros(1, recordsize);
            data_B = zeros(1, recordsize);
            
            data_A1 = data(record,1:16:end);
            data_A2 = data(record,2:16:end);
            data_A3 = data(record,3:16:end);
            data_A4 = data(record,4:16:end);
            data_A5 = data(record,5:16:end);
            data_A6 = data(record,6:16:end);
            data_A7 = data(record,7:16:end);
            data_A8 = data(record,8:16:end);
            
            data_A(1:8:end) = data_A1;
            data_A(2:8:end) = data_A2;
            data_A(3:8:end) = data_A3;
            data_A(4:8:end) = data_A4;
            data_A(5:8:end) = data_A5;
            data_A(6:8:end) = data_A6;
            data_A(7:8:end) = data_A7;
            data_A(8:8:end) = data_A8;
            
            data_B1 = data(record,9:16:end);
            data_B2 = data(record,10:16:end);
            data_B3 = data(record,11:16:end);
            data_B4 = data(record,12:16:end);
            data_B5 = data(record,13:16:end);
            data_B6 = data(record,14:16:end);
            data_B7 = data(record,15:16:end);
            data_B8 = data(record,16:16:end);
            
            data_B(1:8:end) = data_B1;
            data_B(2:8:end) = data_B2;
            data_B(3:8:end) = data_B3;
            data_B(4:8:end) = data_B4;
            data_B(5:8:end) = data_B5;
            data_B(6:8:end) = data_B6;
            data_B(7:8:end) = data_B7;
            data_B(8:8:end) = data_B8;
            %   data_A = zeros(1, nofsamples);
            %   data_B = zeros(1, nofsamples);
            %
            %   data_A1 = data(1:4:end);
            %   data_A2 = data(2:4:end);
            %
            %   data_A(1:2:end) = data_A1;
            %   data_A(2:2:end) = data_A2;
            %
            %   data_B1 = data(3:4:end);
            %   data_B2 = data(4:4:end);
            %
            %   data_B(1:2:end) = data_B1;
            %   data_B(2:2:end) = data_B2;
        end
        % Plot result
        % figure(1); clf; hold on
        set(handles.textStatus, 'String', sprintf('\nStep number = %d\n\nRepetition number = %d',scan,repetition));
        if (ChannelsOnDevice == 2)
            handles.current_dataA(record,:) = double(data_B)/nofwaveforms;
            handles.current_dataB(record,:) = double(data_B)/nofwaveforms;
            handles.current_dataC(record,:) = double(data_A)/nofwaveforms;
            handles.current_dataD(record,:) = double(data_A)/nofwaveforms;
            %   plot(scaled_A, 'r')
            %   plot(scaled_B, 'k')
            %   legend('Channel A', 'Channel B');
        else
            scaled = double(data(1:end-4))/nofwaveforms;
            tmp=scaled(2:4:end);
            scaled(2:4:end)=scaled(3:4:end);
            scaled(3:4:end)=tmp;
            %   plot(scaled, 'k')
        end
        % set(1,'name','ADQ_waveform_averaging_example.m')
        % title('Plot of the averaged waveform')
        
        %      [adq_data, junk, adq_status, adq_valid] = interface_ADQ('collectrecord', record-1, handles.boardid);
        %      handles.current_dataA(record,:) = adq_data.DataA;
        %      set(handles.textStatus, 'String', strcat('Loop numbers: ', num2str(record)));
        %      handles.current_dataB(record,:) = adq_data.DataB;
        %      handles.current_dataC(record,:) = adq_data.DataC;
        %      handles.current_dataD(record,:) = adq_data.DataD;
        switch xlabelmod
            case 1
                x = t;
                xname = 'Time (\mus)';
            case 2
                x = n;
                xname = 'Record Number';
            case 3
                m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
                x = m;
                xname = 'm/q (Da)';
        end
        if isChannelA == 1;
            legA = 'on';
        else
            legA = 'off';
        end
        h(1) = plot(handles.axes1,x,handles.current_dataA(record,:),'r','DisplayName','ChannelA','visible',legA);
        %legend('-DynamicLegend');
        hold (handles.axes1, 'all');
        if isChannelB == 1;
            legB = 'on';
        else
            legB = 'off';
        end
        h(2) = plot(handles.axes1,x,handles.current_dataB(record,:),'g','DisplayName','ChannelB','visible',legB);
        if isChannelC == 1;
            legC = 'on';
        else
            legC = 'off';
        end
        h(3) = plot(handles.axes1,x,handles.current_dataC(record,:),'b','DisplayName','ChannelC','visible',legC);
        if isChannelD == 1;
            legD = 'on';
        else
            legD = 'off';
        end
        h(4) = plot(handles.axes1,x,handles.current_dataD(record,:),'m','DisplayName','ChannelD','visible',legD);
        %plot(x, handles.current_data1(record,:),'r', x, handles.current_data2(record,:),'b');
        %legend('channelB','channelD');
        %     refresh_legend;
        hold (handles.axes1, 'off');
        ymin = get(handles.ymin,'String');
        ymax = get(handles.ymax,'String');
        ylim(handles.axes1,[str2double(ymin), str2double(ymax)]);
        xlabel(handles.axes1, xname)%,'FontSize',20)
        ylabel(handles.axes1, 'Intensity (arb.units)')%,'FontSize',20)
        grid (handles.axes1, 'on');
        refresh_legend;
        pause(0.1);
        %Stop_Callback(hObject, eventdata, handles);
        % hObject    handle to Stop (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        % handles.isDown = get(hObject,'Value');
        %  if handles.isDown
        %     set(handles.textStatus, 'string', 'Stop')
        %  else
        %      set(handles.textStatus, 'string', 'Continue')
        %  end
        % guidata(hObject,handles)
        
        %Stop_Callback(hObject, eventdata, handles);
        % guidata(hObject,handles);
        %handles.isDown = get(hObject,'Value');
        if isDown
            %             isDown = 0;
            break;
            %uiwait;
            %continue;
        end
        %     plot(adq_data.DataA, 'r')
        %     plot(adq_data.DataB, 'g')
        %     plot(adq_data.DataC, 'b')
        %     plot(adq_data.DataD, 'm')
    end
    if isDown
        isDown = 0;
        break;
        %uiwait;
        %continue;
    end
    if manual
        choice = questdlg('Please change the parameters and click continue', ...
            'Scan Menu', ...
            'Break','Continue','Continue');
        % Handle response
        switch choice
            case 'Break'
                break
            case 'Continue'
                set(handles.textStatus,'string','Continue');
        end
    end
end

% Close multirecord
% interface_ADQ('multirecordclose', [], eventdataboardid);