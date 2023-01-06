%%
global nofrecords;
global recordsize;
% global record;
global selected_trigger;
global isChannelA;
global isChannelB;
global isChannelC;
global isChannelD;
global h;
global xlabelmod;
global delay_trigger;
global mass_calibrate;
global time_calibrate;
fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
handles = rmfield(handles,fields);
SW_TRIGGER_MODE = 1;
%  recordsize = 35000;
% x=0:1/(1000):(recordsize-1)/(1000);
t = 0:1/(1000):(recordsize-1)/(1000);
% m = mass_calibrate*(t-delay_trigger).^2/(time_calibrate-delay_trigger)^2;
n = 1:recordsize;
% nofrecords = 100;
 handles.boardid=1;
% selected_trigger = SW_TRIGGER_MODE;
 % Disarm & arm
 interface_ADQ('disarmtrigger', [],handles.boardid);
 interface_ADQ('armtrigger', [],handles.boardid);
 trigged = 0;
while trigged == 0
    %pause
    if selected_trigger== SW_TRIGGER_MODE
      interface_ADQ('swtrig', [], handles.boardid); % Trig device
    end
    [adq_data, junk, adq_status, adq_valid] = interface_ADQ('getacquiredall', [], handles.boardid); % Check if all records collected
    trigged = adq_status(1);
    pause(0.01);
end
for record=1:nofrecords
    %clf;
     [adq_data, junk, adq_status, adq_valid] = interface_ADQ('collectrecord', record-1, handles.boardid);
     handles.current_dataA(record,:) = adq_data.DataA;
     set(handles.textStatus, 'String', strcat('Loop numbers: ', num2str(record)));
     handles.current_dataB(record,:) = adq_data.DataB;
     handles.current_dataC(record,:) = adq_data.DataC;
     handles.current_dataD(record,:) = adq_data.DataD;
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
         isDown = 0;
         break;
        %uiwait;
     else
       %continue;  
     end
%     plot(adq_data.DataA, 'r')
%     plot(adq_data.DataB, 'g')
%     plot(adq_data.DataC, 'b')
%     plot(adq_data.DataD, 'm')
end

% Close multirecord
% interface_ADQ('multirecordclose', [], eventdataboardid);