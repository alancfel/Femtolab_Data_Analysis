function [current_dataA, current_dataB, current_dataC, current_dataD, attA] = getdata(filename, file, dot, iter)
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
global settings;
% global ind;
% global figurename;
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
    %     fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
    %     handles = rmfield(handles,fields);
    current_dataA = zeros(nofrecords*nofrepes,recordsize);
    current_dataC = zeros(nofrecords*nofrepes,recordsize);
    current_dataB = channeldata.(char(names(2,:)));
    current_dataD = channeldata.(char(names(1,:)));
    sliderVal = 1;
    %     set(handles.show, 'Value', sliderVal);
    %     show_Callback(handles.show, eventdata, handles)
elseif strcmp(filename(dot+1:end), 'spe')
    dat = loadSPE(file);
    [~, nofframe] = size((squeeze(dat.int))');
    if nofframe == 1
        [nofrecords, recordsize] = size((squeeze(dat.int)));
        current_dataD = (squeeze(dat.int));
    else
        [nofrecords, recordsize] = size((squeeze(dat.int))');
        current_dataD = (squeeze(dat.int))';
    end
    nofrepes = 1;
    nofwaveforms = 1;
    nofcycle = 1;
    selected_trigger = 2;
    machename = 'PIMAX4';
    isChannelA = 0;
    isChannelB = 0;
    isChannelC = 0;
    isChannelD = 1;
    current_dataA = dat.wavelength(dat.roix+1:dat.xdim+dat.roix);
    current_dataC = zeros(nofrecords*nofrepes,recordsize);
    current_dataB = zeros(nofrecords*nofrepes,recordsize);
    sliderVal = 1;
%     attdata = i:nofcycle:records*nofrepes*nofcycle;
    attA = zeros(1,nofrecords*nofrepes);
elseif strcmp(filename(dot+1:end), 'hdf5') || strcmp(filename(dot+1:end), 'h5') || strcmp(filename(dot+1:end), 'hdf')
    info = h5info(file);
    if isempty(info.Datasets) %ismember ('Name',fieldnames(info.Datasets))
        nofrecords = nofrecords/nofcycle;
        nofcycle = 1;
        %                     nofcycle = iter;
    else
        settings = h5read(file,strcat('/',info.Datasets.Name));
        recordsize = double(settings.adq_recordLength); %info.Groups(1).Attributes(5).Value; %Samples per record
        %             nofrecords = length(info.Groups.Groups.Groups(1).Groups);%*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
        nofrepes = double(settings.adq_nRecords);% settings.scan_niterations; %settings.adq_nRecords; %info.Groups(1).Attributes(2).Value; % software average number settings.scan_niterations
        nofcycle = 1; %double(settings.scan_niterations);% iteration number
        nofwaveforms = double(settings.adq_nAverages); %info.Groups(1).Attributes(3).Value; % hardware average number
        selected_trigger = 'External'; %info.Groups(1).Attributes(4).Value; % find(strcmp(string_list,info.Groups(1).Attributes(6).Value));
        machename = settings.scanChannel; %char(info.Groups(1).Attributes((strmatch('Settings',char(info.Groups(1).Attributes.Name)))).Value(1));
        %                     stepvalue = [];
        %                     for att = 1:nofrecords
    end
    if strcmp(machename,'Channel.A')
        stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))*1e6];
        if length(stepvalue) == ceil(nofrecords/nofcycle)
            step = stepvalue;
        else if length(stepvalue) > ceil(nofrecords/nofcycle)
                step = stepvalue(1:ceil(nofrecords/nofcycle) );
        else
            step = [stepvalue (double(settings.scan_to)/1000)];
        end
        end
    else if strcmp(machename,'Channel.B')
            stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %-settings.scan_stepSize/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))/800];
            if length(stepvalue) == ceil(nofrecords/nofcycle)
                step = stepvalue;
            else if length(stepvalue) > ceil(nofrecords/nofcycle)
                    step = stepvalue(1:ceil(nofrecords/nofcycle) );
            else
                step = [stepvalue (double(settings.scan_to)/1000)];
            end
            end
    else
        step = 1:ceil(nofrecords/nofcycle) ;
    end
    end
    if isfield(info.Groups,'Attributes') && isempty(info.Groups(1).Attributes)
        %                 if isfield(info.Groups(1).Attributes,'Value')
        samplerate = 2e+09; %info.Groups(1).Attributes(6).Value;
        if samplerate == 2e+09
            string_list{1} = 'Software';
            string_list{2} = 'External';
            string_list{3} = 'Level';
            string_list{4} = 'Internal';
            %                 if isempty(info.Datasets) %ismember ('Name',fieldnames(info.Datasets))
            %                     nofrecords = nofrecords/nofcycle;
            %                     nofcycle = 1;
            %                     %                     nofcycle = iter;
            %                 else
            %                     settings = h5read(file,strcat('/',info.Datasets.Name));
            %                     recordsize = double(settings.adq_recordLength); %info.Groups(1).Attributes(5).Value; %Samples per record
            nofrecords = length(info.Groups.Groups.Groups(1).Groups);%*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
            %                     nofrepes = double(settings.adq_nRecords);% settings.scan_niterations; %settings.adq_nRecords; %info.Groups(1).Attributes(2).Value; % software average number settings.scan_niterations
            %                     nofcycle = 1; %double(settings.scan_niterations);% iteration number
            %                     nofwaveforms = double(settings.adq_nAverages); %info.Groups(1).Attributes(3).Value; % hardware average number
            %                     selected_trigger = 'External'; %info.Groups(1).Attributes(4).Value; % find(strcmp(string_list,info.Groups(1).Attributes(6).Value));
            %                     machename = settings.scanChannel; %char(info.Groups(1).Attributes((strmatch('Settings',char(info.Groups(1).Attributes.Name)))).Value(1));
            %                     %                     stepvalue = [];
            %                     %                     for att = 1:nofrecords
            %                 end
            if ((length(cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name))) == ceil(nofrecords/nofcycle)) && ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',0)),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name))))
                fprintf('The first check: \n The hdf5 structure is well organised\n')
                nofrecords = length(info.Groups.Groups.Groups(1).Groups)*1;%double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number
            else
                fprintf('The first check: \n The hdf5 structure is not well organised\n')
                nofrecords = length(info.Groups.Groups.Groups(1).Groups)+1;%*double(settings.scan_niterations); %length(info.Groups); % measurement number = step number * cycle number %if one record was missing,it will give the right nofrecords value
                if ceil(nofrecords/nofcycle) ~= floor(nofrecords/nofcycle)
                    nofrecords = ceil(nofrecords/nofcycle)*nofcycle;
                end
            end
            %                 if strcmp(machename,'Channel.A')
            %                     stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))*1e6];
            %                     if length(stepvalue) == ceil(nofrecords/nofcycle)
            %                         step = stepvalue;
            %                     else if length(stepvalue) > ceil(nofrecords/nofcycle)
            %                             step = stepvalue(1:ceil(nofrecords/nofcycle) );
            %                         else
            %                             step = [stepvalue (double(settings.scan_to)/1000)];
            %                         end
            %                     end
            %                 else if strcmp(machename,'Channel.B')
            %                         stepvalue = (double(settings.scan_from)/1000):(double(settings.scan_stepSize)/1000):(double(settings.scan_to)/1000); %-settings.scan_stepSize/1000); %[stepvalue,str2double(char(info.Groups(att).Attributes((strmatch('Settings',char(info.Groups(att).Attributes.Name)))).Value(2)))/800];
            %                         if length(stepvalue) == ceil(nofrecords/nofcycle)
            %                             step = stepvalue;
            %                         else if length(stepvalue) > ceil(nofrecords/nofcycle)
            %                                 step = stepvalue(1:ceil(nofrecords/nofcycle) );
            %                             else
            %                                 step = [stepvalue (double(settings.scan_to)/1000)];
            %                             end
            %                         end
            %                     else
            %                         step = 1:ceil(nofrecords/nofcycle) ;
            %                     end
            %                 end
            %                     end

            %                     if stepvalue(1) < stepvalue(length(stepvalue))
            %                         stepraw = sort(stepvalue);
            %                     else
            %                         stepraw = sort(stepvalue,'descend');
            %                     end
            %                     step = stepvalue; %unique(stepraw);%, 'stable');
            %                     nofcycle = length(stepraw)/length(step);
            channel = {'Channel A','Channel B','Channel C','Channel D'}; %,'current_dataC'}; %cellstr(cat(1,info.Groups(1).Datasets.Name));
            fields = {'current_dataA','current_dataB','current_dataC','current_dataD'};
            %                 handles = rmfield(handles,fields);
            if ismember('Channel A',channel)
                isChannelA = 1;
            else
                isChannelA = 0;
                current_dataA = zeros(nofrecords*nofrepes,recordsize);
            end
            if ismember('Channel B',channel)
                isChannelB = 1;
            else
                isChannelB = 0;
                current_dataB = zeros(nofrecords*nofrepes,recordsize);
            end
            if ismember('Channel C',channel)
                isChannelC = 1;
            else
                isChannelC = 0;
                current_dataC = zeros(nofrecords*nofrepes,recordsize);
            end
            if ismember('Channel D',channel)
                isChannelD = 1;
            else
                isChannelD = 0;
                current_dataD = zeros(nofrecords*nofrepes,recordsize);
            end
            attA = zeros(1,nofrecords*nofrepes);
            %                 set(handles.ChannelA, 'Value', isChannelA);
            %                 set(handles.ChannelB, 'Value', isChannelB);
            %                 set(handles.ChannelC, 'Value', isChannelC);
            %                 set(handles.ChannelD, 'Value', isChannelD);
            record = 0;
            if ((length(cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name))) == ceil(nofrecords/nofcycle)) && ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',0)),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name))))
                fprintf('The hdf5 structure is well organised\n')
                for i = 1:nofrecords/nofcycle; %[1:1044,1047:1263,1265:nofrecords]
                    %                         infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                    %                         infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                    %                         infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                    %                         infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                    for k = iter:iter
                        if ismember(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d',i-1)),cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name)))
                            infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                        else
                            infoA = [];
                            fprintf(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i-1), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',i-1)),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name)))
                            infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                        else
                            infoB = [];
                            fprintf(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i-1), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d',i-1)),cellstr(char(info.Groups.Groups.Groups(3,1).Groups.Name)))
                            infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                        else
                            infoC = [];
                            fprintf(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i-1), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d',i-1)),cellstr(char(info.Groups.Groups.Groups(4,1).Groups.Name)))
                            infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i-1)));
                        else
                            infoD = [];
                            fprintf(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i-1), 'is not exist in file\n'));
                        end
                        for j = 1:nofrepes
                            record = record+1;%i;%record+1;
                            if isChannelA == 1;
                                if ~isempty(infoA) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoA.Datasets.Name)))
                                    dataA = h5read(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                    %                                         current_dataA(record,:) = single(dataA(1,:)/nofwaveforms);
                                    current_dataA(record,:) = single(dataA(1,:)*4096/0.8);
                                    attA(record) = h5readatt(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)),'timestamp');
                                else
                                    if record ~= 1
                                        current_dataA(record,:) = current_dataA(record-1,:); %dataA(1,:);
                                        attA(record) = attA(record-1);
                                        fprintf('Channel A scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        attA(record) = 0;
                                        current_dataA(record,:) = zeros(1,recordsize);
                                        fprintf('Channel A scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                    end
                                end
                            end
                            if isChannelB == 1;
                                if ~isempty(infoB) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoB.Datasets.Name)))
                                    dataB = h5read(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                    %                                         current_dataB(record,:) = single(dataB(1,:)/nofwaveforms);
                                    current_dataB(record,:) = single(dataB(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataB(record,:) = current_dataB(record-1,:); %dataA(1,:);
                                        fprintf('Channel B scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataB(record,:) = zeros(1,recordsize);
                                        fprintf('Channel B scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                    end
                                end
                                %                                     dataB = h5read(file,strcat('/',num2str(i),'/Channel B'));
                                %                                     handles.current_dataB(record,:) = single(dataB(j,:));
                            end
                            if isChannelC == 1;
                                if ~isempty(infoC) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoC.Datasets.Name)))
                                    dataC = h5read(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                    %                                         current_dataC(record,:) = single(dataC(1,:)/nofwaveforms);
                                    current_dataC(record,:) = single(dataC(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataC(record,:) = current_dataC(record-1,:); %dataC(1,:);
                                        fprintf('Channel C scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataC(record,:) = zeros(1,recordsize);
                                        fprintf('Channel C scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                    end
                                    %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                end
                            end
                            if isChannelD == 1;
                                if ~isempty(infoD) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoD.Datasets.Name)))
                                    dataD = h5read(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',i-1,k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                    %                                         current_dataD(record,:) = single(dataD(1,:)/nofwaveforms);
                                    current_dataD(record,:) = single(dataD(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataD(record,:) = current_dataD(record-1,:); %dataC(1,:);
                                        fprintf('Channel D scanpoint_%02d/trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataD(record,:) = zeros(1,recordsize);
                                        fprintf('Channel D scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',i-1,k-1,j-1);
                                    end
                                    %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                end
                            end
                        end
                    end
                end
            else
                fprintf('The hdf5 structure is not well organised\n')
                for m = 1:ceil(nofrecords/nofcycle) ; %[1:1044,1047:1263,1265:nofrecords]
                    %                         infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                    %                         infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                    %                         infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                    %                         infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',i)));
                    for k = iter:iter
                        if ismember(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))),cellstr(char(info.Groups.Groups.Groups(1,1).Groups.Name)))
                            infoA = h5info(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))));
                        else
                            infoA = [];
                            fprintf(strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1)), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))),cellstr(char(info.Groups.Groups.Groups(2,1).Groups.Name)))
                            infoB = h5info(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))));
                        else
                            infoB = [];
                            fprintf(strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1)), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))),cellstr(char(info.Groups.Groups.Groups(3,1).Groups.Name)))
                            infoC = h5info(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))));
                        else
                            infoC = [];
                            fprintf(strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1)), 'is not exist in file\n'));
                        end
                        if ismember(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))),cellstr(char(info.Groups.Groups.Groups(4,1).Groups.Name)))
                            infoD = h5info(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1))));
                        else
                            infoD = [];
                            fprintf(strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1)), 'is not exist in file\n'));
                        end
                        for j = 1:nofrepes
                            record = record+1;%i;%record+1;
                            if isChannelA == 1;
                                if ~isempty(infoA) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoA.Datasets.Name)))
                                    dataA = h5read(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                    current_dataA(record,:) = single(dataA(1,:)*4096/0.8);
                                    attA(record) = h5readatt(file,strcat(info.Groups.Groups.Groups(1,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1)),'timestamp');
                                else
                                    if record ~= 1
                                        current_dataA(record,:) = current_dataA(record-1,:); %dataA(1,:);
                                        attA(record) = attA(record-1);
                                        fprintf('Channel A scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)-1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        attA(record) = 0;
                                        current_dataA(record,:) = zeros(1,recordsize);
                                        fprintf('Channel A scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)-1),k-1,j-1);
                                    end
                                end
                            end
                            if isChannelB == 1;
                                if ~isempty(infoB) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoB.Datasets.Name)))
                                    dataB = h5read(file,strcat(info.Groups.Groups.Groups(2,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1)))';%1_%d',record-1)))'; %strcat('/',num2str(i),'/Channel A'));
                                    current_dataB(record,:) = single(dataB(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataB(record,:) = current_dataB(record-1,:); %dataA(1,:);
                                        fprintf('Channel B scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataB(record,:) = zeros(1,recordsize);
                                        fprintf('Channel B scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);
                                    end
                                end
                                %                                     dataB = h5read(file,strcat('/',num2str(i),'/Channel B'));
                                %                                     handles.current_dataB(record,:) = single(dataB(j,:));
                            end
                            if isChannelC == 1;
                                if ~isempty(infoC) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoC.Datasets.Name)))
                                    dataC = h5read(file,strcat(info.Groups.Groups.Groups(3,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                    current_dataC(record,:) = single(dataC(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataC(record,:) = current_dataC(record-1,:); %dataC(1,:);
                                        fprintf('Channel C scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataC(record,:) = zeros(1,recordsize);
                                        fprintf('Channel C scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);
                                    end
                                    %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                end
                            end
                            if isChannelD == 1;
                                if ~isempty(infoD) && ismember(sprintf('trace_%02d_%04d',k-1,j-1),cellstr(char(infoD.Datasets.Name)))
                                    dataD = h5read(file,strcat(info.Groups.Groups.Groups(4,1).Name,'/', sprintf('scanpoint_%02d/trace_%02d_%04d',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1)))'; %strcat('/',num2str(i),'/Channel C'));
                                    current_dataD(record,:) = single(dataD(1,:)*4096/0.8);
                                else
                                    if record ~= 1
                                        current_dataD(record,:) = current_dataD(record-1,:); %dataC(1,:);
                                        fprintf('Channel D scanpoint_%02d/trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);%set(handles.textStatus, 'String', sprintf('trace_%d_%d is not exist in file',k-1,j-1))
                                    else
                                        current_dataD(record,:) = zeros(1,recordsize);
                                        fprintf('Channel D scanpoint_%02d/Attribute trace_%02d_%04d is not exist in file\n',m-1+(k-1)*(ceil(nofrecords/nofcycle)+1),k-1,j-1);
                                    end
                                    %                                         set(handles.textStatus, 'String', sprintf('trace_0_%d is not exist in file',record-1))
                                end
                            end
                        end
                    end
                end
            end
            %                 [~,ind] = sort(attA);
            %                     handles.current_dataA = handles.current_dataA(ind,:);
            %                     handles.current_dataC = handles.current_dataC(ind,:);
            sliderVal = 1;
            %                 set(handles.show, 'Value', sliderVal);
            %                 show_Callback(handles.show, eventdata, handles);
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