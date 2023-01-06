function [data_A, data_B, status, validation] = interface_ADQ(action, in_args, boardid)
% [data_A, data_B, status, validation] = interface_ADQ(action, in_args)
% Interface function for ADQxxx.
%
%   Input:
%     action      The action that is going  to be executed.
%                 See API user's guide for commands and arguments
%     in_args     Arguments for the selected action
%                 See API user's guide for commands and arguments
%     boardid     Identify board if several units are connected
%
%   Output:
%     data_A      Data for channel A or for all channels if there are more
%                   than two channels
%     data_B      Data for channel B   (set to 0 if the ADQ has one or
%                   four channels)
%     status      Answer from command
%     validation  Deprecated
%
%


data_A = [];
data_B = [];
status = 0;
validation = [];

% Define command codes
define_command_codes;

if nargin < 3
    boardid = 1;
end
if nargin < 1
    action = 'revision';
end


switch lower(action)

    case 'list_devices' % Set up ADQ ---------------------------------------------------------------------------
        mex_ADQ;
    
    case 'getnofchannels'
        a = mex_ADQ(MATLAB_GET_NOF_CHANNELS, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getpllfreqdivider'
        a = mex_ADQ(MATLAB_GET_PLL_FREQ_DIVIDER, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getclocksource'
        a = mex_ADQ(MATLAB_GET_CLOCK_SOURCE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getexternalclockreferencestatus'
        a = mex_ADQ(MATLAB_GET_EXTERNAL_CLOCK_REFERENCE_STATUS, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'gettriggermode'
        a = mex_ADQ(MATLAB_GET_TRIGGER_MODE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getusbaddress'
        a = mex_ADQ(MATLAB_GET_USB_ADDRESS, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getpcieaddress'
        a = mex_ADQ(MATLAB_GET_PCIE_ADDRESS, boardid);
        status = a.Status;
        data_A = a.Status(1);
    
    case 'isusbdevice'
        a = mex_ADQ(MATLAB_IS_USB_DEVICE, boardid);
        status = a.Status;
        data_A = a.Status(1);
    
    case 'ispciedevice'
        a = mex_ADQ(MATLAB_IS_PCIE_DEVICE, boardid);
        status = a.Status;
        data_A = a.Status(1);
    
    case 'isalive'
        a = mex_ADQ(MATLAB_IS_ALIVE, boardid);
        status = a.Status;
        data_A = a.Status(1);
       
    case 'isstartedok'
        a = mex_ADQ(MATLAB_IS_STARTED_OK, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'reset_device' 'resetdevice'}
        if (nargin==2 || nargin==3)
            ResetLevel = in_args(1);
            a = mex_ADQ([MATLAB_RESET_DEVICE ResetLevel], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'rebootadqfromflash'}
        a = mex_ADQ(MATLAB_REBOOT_ADQ_FROM_FLASH, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'resetoverheat'}
        a = mex_ADQ(MATLAB_RESET_OVERHEAT, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'rebootcomfpgafromsecondaryimage'}
        a = mex_ADQ(MATLAB_REBOOT_COM_FPGA_FROM_SECONDARY_IMAGE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'rebootalgfpgafromprimaryimage'}
        a = mex_ADQ(MATLAB_REBOOT_ALG_FPGA_FROM_PRIMARY_IMAGE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'resetinterleavingip'}        
        if ((nargin==2 || nargin==3))
            if (length(in_args) >= 1)
                IPInstanceAddr = in_args(1);
            else
                IPInstanceAddr = 0;
            end
        else
            IPInstanceAddr = 0;
        end        
        a = mex_ADQ([MATLAB_RESET_INTERLEAVING_IP IPInstanceAddr], boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'set_clock_source' 'setclocksource'}
        if (nargin==2 || nargin==3)
            clk_source = in_args(1);
            a = mex_ADQ([MATLAB_SET_CLOCK_SOURCE clk_source], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_clock_frequency_mode' 'setclockfrequencymode'}
        if (nargin==2 || nargin==3)
            clockmode = in_args(1);
            if (clockmode == 0 || clockmode == 1)
                a = mex_ADQ([MATLAB_SET_CLOCK_FREQUENCY_MODE clockmode], boardid);
                status = a.Status(1);
                data_A = a.Status(1);
                if (status == 0)
                    error('Clock mode change not succesful');
                end
            else
                error('Bad clockmode (0 = Low frequency, 1 = High frequency)');
            end
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_data_format' 'setdataformat'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            dataformat = in_args(1);
            a = mex_ADQ([MATLAB_SET_DATA_FORMAT dataformat], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

        % ******************** AFE Functions *************************'
    case {'set_afe_switch' 'setafeswitch'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            afe_mode = in_args(1);
            a = mex_ADQ([MATLAB_SET_AFE_SWITCH afe_mode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getafeswitch'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            channel = in_args(1);
            a = mex_ADQ([MATLAB_GET_AFE_SWITCH channel], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setgainandoffset'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 3)
            channel = in_args(1);
            gain = in_args(2);
            offset = in_args(3);
            a = mex_ADQ([MATLAB_SET_GAIN_OFFSET channel gain offset], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getgainandoffset'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            channel = in_args(1);
            a = mex_ADQ([MATLAB_GET_GAIN_OFFSET channel], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end



        % ***** SETUP TRIGGER FUNCTIONS ******************************
    case {'set_trigger_mode' 'settriggermode'}
        % Set trigger mode
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            TriggerMode = in_args(1);
            a = mex_ADQ([MATLAB_SET_TRIGGER_MODE TriggerMode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'setexterntrigedge'}
        % Set trigger mode
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            TriggerMode = in_args(1);
            a = mex_ADQ([MATLAB_SET_EXTERN_TRIG_MODE TriggerMode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_trigger_level' 'setlvltriglevel'}
        % Set level for level trigger
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            LvlTriggLevelTwosComp = in_args(1);
            a = mex_ADQ([MATLAB_SET_LVL_TRIGGER_LEVEL LvlTriggLevelTwosComp], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error('Wrong number of in arguments for action "set_trigger_level"');
        end

    case {'set_trigger_level_treshold' 'settriglevelresetvalue'}
        % Set threshold level for level trigger
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            trigger_level_treshold = in_args(1);
            a = mex_ADQ([MATLAB_SET_LEVEL_TRIG_RESET_LEVEL trigger_level_treshold], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_trigger_channel' 'setlvltrigchannel'}
        % The following command only works for ADQ214
        % Set channel for level trigger
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            LvlTriggCh = in_args(1);
            a = mex_ADQ([MATLAB_SET_LVL_TRIGGER_CHANNEL LvlTriggCh], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_trigger_edge' 'setlvltrigedge'}
        % Set trigger edge for level trigger
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            LvlTriggEdge = in_args(1);
            a = mex_ADQ([MATLAB_SET_LVL_TRIGGER_EDGE LvlTriggEdge], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case { 'setconfigurationtrig' }
        % Configure trigger setup for V5 boards
        if (nargin>=2 && size(in_args,2) == 3)
            Mode = in_args(1);
            PulseLength = in_args(2);
            InvertOutput = in_args(3);
            a = mex_ADQ([MATLAB_SET_CONFIGURATION_TRIG Mode PulseLength InvertOutput], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setinterleavingmode'}
        % Set interleaving mode for ADQ412
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            InterleavingMode = in_args(1);
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_MODE InterleavingMode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_freq_divider' 'setpllfreqdivider'}
        % Set trigger edge for level trigger
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            freqdiv = in_args(1);
            a = mex_ADQ([MATLAB_SET_PLL_FREQ_DIVIDER freqdiv], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_trigger_holdoff' 'settriggerholdoffsamples'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            TrigHoldOffSamples = in_args(1);
            a = mex_ADQ([MATLAB_SET_TRIGGER_HOLDOFF_SAMPLES TrigHoldOffSamples], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_pretrig' 'setpretrigsamples'}
        if (nargin==2 || nargin==3)
            preTrigSamples = in_args(1);
            a = mex_ADQ([MATLAB_SET_PRE_TRIGGER_SAMPLES preTrigSamples], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end


        % ***** END SETUP  TRIGGER FUNCTIONS *****

    case 'set_buffer_size_pages'
        disp('Warning deprecated function. Use ''setbuffersize''')
        if ( (nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            BufferSizePages = in_args(1);
            a = mex_ADQ([MATLAB_SET_BUFFER_SIZE_PAGES BufferSizePages], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_buffer_size' 'setbuffersize'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            BufferSize    = in_args(1);
            a = mex_ADQ([MATLAB_SET_BUFFER_SIZE BufferSize], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error('Wrong number of in arguments for action "set_buffer_size". Type "help interface_ADQ" for help');
        end

    case {'set_sample_width' 'setsamplewidth'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            SampleWidth = in_args(1);
            a = mex_ADQ([MATLAB_SET_SAMPLE_WIDTH SampleWidth], boardid);
            status = a.Status;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setnofbits'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            NofBits = in_args(1);
            if NofBits==32 || NofBits==28 || NofBits==24
                a = mex_ADQ([MATLAB_SET_NUMBER_OF_BITS NofBits], boardid);
                status = a.Status;
                data_A = a.Status(1);
            else
                error('Number of bits has to be 32, 28 or 24');
            end
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_direction_gpio' 'setdirectiongpio'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            direction = in_args(1);
            mask = in_args(2);
            a = mex_ADQ([MATLAB_SET_DIRECTION_GPIO direction mask], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_test_pattern_mode' 'settestpatternmode'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            testpatternmode = in_args(1);
            a = mex_ADQ([MATLAB_SET_TEST_PATTERN_MODE testpatternmode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'settestpatternconstant'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            testpatternconstant = in_args(1);
            a = mex_ADQ([MATLAB_SET_TEST_PATTERN_CONSTANT testpatternconstant], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_gpio' 'writegpio'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            data = in_args(1);
            mask = in_args(2);
            a = mex_ADQ([MATLAB_WRITE_GPIO data mask], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'read_gpio' 'readgpio'}
        a = mex_ADQ(MATLAB_READ_GPIO, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'set_direction_trig' 'setdirectiontrig'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            direction = in_args(1);
            a = mex_ADQ([MATLAB_SET_DIRECTION_TRIG direction], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_trig' 'writetrig'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            data = in_args(1);
            a = mex_ADQ([MATLAB_WRITE_TRIG data], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case 'read_trig'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        a = mex_ADQ(MATLAB_READ_TRIG, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'reset_trigger' 'resettrigger'}
        % disp(['---interface_ADQ--- reset trigger ' boardid])
        % disarm has to be done before arm. This MATLAB command has no direct counterpart in the API
        a = mex_ADQ(MATLAB_DISARM_TRIGGER, boardid);
        status = a.Status;
        a = mex_ADQ(MATLAB_ARM_TRIGGER, boardid);
        status = status .* a.Status;
        data_A = status(1);

    case {'disarmtrigger' }
        % disp(['---interface_ADQ--- disarm trigger ' boardid])
        a = mex_ADQ(MATLAB_DISARM_TRIGGER, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'armtrigger' }
        % disp(['---interface_ADQ--- arm trigger ' boardid])
        a = mex_ADQ(MATLAB_ARM_TRIGGER, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'trigger' 'usb_trig' 'swtrig'}
        a = mex_ADQ(MATLAB_SW_TRIG, boardid);
        status = a.Status;
        data_A = a.Status(1);
        %disp('---interface_ADQ--- software triggered board')

    case {'get_trig_type' 'gettrigtype'}
        a =  mex_ADQ(MATLAB_GET_TRIG_TYPE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_waiting_for_trigger' 'getwaitingfortrigger'}
        a =  mex_ADQ(MATLAB_GET_WAITING_FOR_TRIGGER, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_trigged' 'get_acquired' 'gettrigged' 'getacquired'}
        a =  mex_ADQ(MATLAB_GET_ACQUIRED, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_trigged_records' 'get_acquired_records' 'gettriggedrecords' 'getacquiredrecords'}
        a =  mex_ADQ(MATLAB_GET_ACQUIRED_RECORDS, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_trigged_all' 'get_acquired_all' 'gettriggedall' 'getacquiredall' }
        a =  mex_ADQ(MATLAB_GET_ACQUIRED_ALL, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'gettrigpoint' }
        a = mex_ADQ(MATLAB_GET_TRIG_POINT, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'gettriggedch' }
        a = mex_ADQ(MATLAB_GET_TRIGGED_CH, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getoverflow' }
        a = mex_ADQ(MATLAB_GET_OVERFLOW, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'multi_record_setup' 'multirecordsetup'}
        if (nargin==2 || nargin==3 ) && ( size(in_args,2) == 2 )
            % Custom settings
            nofrecords = in_args(1);
            recordsize    = in_args(2);
            a = mex_ADQ([MATLAB_MULTI_TRIGGER_SETUP nofrecords recordsize], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getdatamultirecordsetup'}
        if (nargin==2 || nargin==3 ) && ( size(in_args,2) == 2 )
            % Custom settings
            nofrecords = in_args(1);
            recordsize    = in_args(2);
            a = mex_ADQ([MATLAB_GET_DATA_MULTI_RECORD_SETUP nofrecords recordsize], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'multi_record_close' 'multirecordclose'}
        a = mex_ADQ(MATLAB_MULTI_TRIGGER_CLOSE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'set_pll' 'setpll'}
        if (nargin==2 || nargin==3 ) && ( size(in_args,2) == 4 )
            % Custom settings
            n_divider = in_args(1);
            r_divider = in_args(2);
            vco_divider = in_args(3);
            channel_divider = in_args(4);
            a = mex_ADQ([MATLAB_SET_PLL n_divider r_divider vco_divider channel_divider], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error('Wrong number of in arguments for action "setpll".');
        end
        
    case {'collect_record' 'collectrecord'}
        record_num = 0;
        if (nargin ~= 1)
            record_num = in_args;
        end

        a = mex_ADQ(MATLAB_GET_ADQ_TYPE, boardid);
        ADQ_type = a.Status(1);

        a = mex_ADQ(MATLAB_GET_FIFO_OVERFLOW, boardid);
        if (a.Status(1) > 0)
            disp('FIFO overflow error reported. ');
        end
        status = a.Status;
        
        % Receive data
        if ((ADQ_type == 214) || (ADQ_type == 212))
            a = mex_ADQ([MATLAB_COLLECT_RECORD record_num], boardid);
            data_A = a.DataA;
            data_B = a.DataB;
            %     elseif (ADQ_type == 412)
            %       a = mex_ADQ([MATLAB_COLLECT_RECORD record_num], boardid);
            %       % clear data_A;
            %       data_A = a.DataA;
        elseif ((ADQ_type == 412) || (ADQ_type == 14) || (ADQ_type == 1600) || (ADQ_type == 108) || (ADQ_type == 208))
            a = mex_ADQ([MATLAB_COLLECT_RECORD record_num], boardid);
            % clear data_A;
            data_A.DataA = a.DataA;
            data_A.DataB = a.DataB;
            data_A.DataC = a.DataC;
            data_A.DataD = a.DataD;
        elseif ((ADQ_type == 114) || (ADQ_type == 112))
            a = mex_ADQ([MATLAB_COLLECT_RECORD record_num], boardid);
            data_A = a.DataA;
        end
        
    
    case {'setstreamstatus' 'set_stream_status'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            stream_status = in_args(1);
            a = mex_ADQ([MATLAB_SET_STREAM_STATUS stream_status], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
    
    case 'collectdatanextpage'
        a = mex_ADQ(MATLAB_COLLECT_DATA_NEXT_PAGE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case 'getdatastream'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            NofBytesToCopy = in_args(1);
            a = mex_ADQ([MATLAB_GET_DATA_STREAM NofBytesToCopy], boardid);
            status = a.Status;
            data_A = a.DataA;            
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'collect_stream_data' 'collectstreamdata'}    
        if (nargin==2 || nargin==3 ) && ( size(in_args,2) == 1 )
            samples_to_stream    = in_args(1);
            a = mex_ADQ([MATLAB_COLLECT_STREAM_DATA samples_to_stream], boardid);
            data_A.DataA = a.DataA;
            data_A.DataB = a.DataB;
            data_A.DataC = a.DataC;            
            data_A.DataD = a.DataD;
            status = a.Status;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
	case 'getdata'
        target_buffer_size = in_args(1);
        target_bytes_per_sample = in_args(2);
        StartRecordNumber = in_args(3);
        NumberOfRecords = in_args(4);
        ChannelsMask = in_args(5);
        StartSample = in_args(6);
        nSamples = in_args(7);
		a = mex_ADQ([MATLAB_GET_DATA target_buffer_size target_bytes_per_sample ...
            StartRecordNumber NumberOfRecords ChannelsMask ...
            StartSample nSamples], boardid);
        data_A.DataA = a.DataA;
        data_A.DataB = a.DataB;
        data_A.DataC = a.DataC;
        data_A.DataD = a.DataD;
        status = a.Status;

    case 'getdatawh'
        target_buffer_size = in_args(1);
        target_bytes_per_sample = in_args(2);
        StartRecordNumber = in_args(3);
        NumberOfRecords = in_args(4);
        ChannelsMask = in_args(5);
        StartSample = in_args(6);
        nSamples = in_args(7);
		a = mex_ADQ([MATLAB_GET_DATA_WH target_buffer_size target_bytes_per_sample ...
            StartRecordNumber NumberOfRecords ChannelsMask ...
            StartSample nSamples], boardid);
        data_A.DataA = a.DataA;
        data_A.DataB = a.DataB;
        data_A.DataC = a.DataC;
        data_A.DataD = a.DataD;
        data_A.DataHeaders = a.DataHeaders;
        status = a.Status;
        
    case 'getdatawhts'
        target_buffer_size = in_args(1);
        target_bytes_per_sample = in_args(2);
        StartRecordNumber = in_args(3);
        NumberOfRecords = in_args(4);
        ChannelsMask = in_args(5);
        StartSample = in_args(6);
        nSamples = in_args(7);
		a = mex_ADQ([MATLAB_GET_DATA_WHTS target_buffer_size target_bytes_per_sample ...
            StartRecordNumber NumberOfRecords ChannelsMask ...
            StartSample nSamples], boardid);
        data_A.DataA = a.DataA;
        data_A.DataB = a.DataB;
        data_A.DataC = a.DataC;
        data_A.DataD = a.DataD;
        data_A.DataHeaders = a.DataHeaders;
        data_A.DataTimestamps = a.DataTimestamps;
        status = a.Status;
        
	case 'getdataspeedtest'
		target_buffer_size = in_args(1);
        target_bytes_per_sample = in_args(2);
        StartRecordNumber = in_args(3);
        NumberOfRecords = in_args(4);
        ChannelsMask = in_args(5);
        StartSample = in_args(6);
        nSamples = in_args(7);
		a = mex_ADQ([MATLAB_GET_DATA_SPEED_TEST target_buffer_size target_bytes_per_sample ...
            StartRecordNumber NumberOfRecords ChannelsMask ...
            StartSample nSamples], boardid);
        data_A.DataA = a.DataA;
        data_A.DataB = a.DataB;
        data_A.DataC = a.DataC;
        data_A.DataD = a.DataD;
        status = a.Status;

    case {'settransferbuffers'}
        NumberOfBuffers = in_args(1);
        BufferSize = in_args(2);
        a = mex_ADQ([MATLAB_SET_TRANSFER_BUFFERS NumberOfBuffers BufferSize], boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'settransfertimeout'}
        TimeoutValue = in_args(1);
        a = mex_ADQ([MATLAB_SET_TRANSFER_TIMEOUT TimeoutValue], boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'setcachesize'}
        CacheSizeInBytes = in_args(1);
        a = mex_ADQ([MATLAB_SET_CACHE_SIZE CacheSizeInBytes], boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'collect_data' 'collectdata'}% ----------------------------------
        clk = clock; % Timer
        time = floor(clk(6));
        triggered = 0;
        a =  mex_ADQ(MATLAB_GET_TRIGGER_MODE, boardid);
        TriggerMode = a.Status(1);

        if(TriggerMode == USB_TRIGGER_MODE)
            mex_ADQ(MATLAB_SW_TRIG, boardid);
        end

        a = mex_ADQ(MATLAB_GET_ADQ_TYPE, boardid);
        ADQ_type = a.Status(1);

        while (~triggered) %Check if triggered (external/level trigger mode)
            a =  mex_ADQ(MATLAB_GET_ACQUIRED, boardid);
            triggered = a.Status;
            clk = clock;
            if (time+2 < floor(clk(6)))
                disp('Waiting for trigger and data capture to occur');

                a = mex_ADQ(MATLAB_GET_FIFO_OVERFLOW, boardid);
                if (a.Status(1) > 0)
                    disp('FIFO overflow error reported. ');
                end
                % Retry trigger once again
                if(TriggerMode == USB_TRIGGER_MODE)
                    mex_ADQ(MATLAB_SW_TRIG, boardid);
                end
                time = floor(clk(6));
            end
        end

        % Get data
        if ((ADQ_type == 114) || (ADQ_type == 214) || (ADQ_type == 212))
            c = mex_ADQ(MATLAB_GET_DATA_PT_16BIT, boardid);
        elseif ((ADQ_type == 112))
            c = mex_ADQ(MATLAB_GET_DATA_PT, boardid);
        end
        data_A = c.DataA;
        data_B = c.DataB;

        status = [0 0 0];
        a = mex_ADQ(MATLAB_GET_OVERFLOW, boardid);
        status214 = a.Status;
        status(1) = status214(1);
        a = mex_ADQ(MATLAB_GET_TRIG_POINT, boardid);
        status214 = a.Status;
        status(2) = status214(1);
        a = mex_ADQ(MATLAB_GET_TRIGGERED_CH, boardid);
        status214 = a.Status;
        status(3) = status214(1);

    case {'bcd_device' 'getbcddevice'} %Return bcd_device --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_BCD_DEVICE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        disp(sprintf('BcdDevice: %lu', status(1)));

    case {'revision' 'getrevision'} %Return revision register --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_REVISION, boardid);
        % FPGA Numner 1
        status = a.Status;
        fprintf('FPGA #1\n');
        disp(sprintf('Revision: %lu', a.DataA(1)));
        tmpindex = 1;
        clear data_A;
        data_A(tmpindex).FPGA = 1;
        data_A(tmpindex).revision = a.DataA(1);
        if (a.DataA(2))
            data_A(tmpindex).SVNstatus = 'Local Copy';
            display('Local Copy');
        else
            data_A(tmpindex).SVNstatus = 'SVN Managed';
            display('SVN Managed');
        end
        if (a.DataA(3))
            data_A(tmpindex).SVNupdated = 'Mixed Revision';
            display('Mixed Revision');
        else
            data_A(tmpindex).SVNupdated = 'SVN Updated';
            display('SVN Updated');
        end
        % FPGA number 2
        tmpindex = 2;
        data_A(tmpindex).FPGA = 2;
        data_A(tmpindex).revision = status(1);
        fprintf('FPGA #2\n');
        disp(sprintf('Revision: %lu', status(1)));
        if (status(2))
            data_A(tmpindex).SVNstatus = 'Local Copy';
            display('Local Copy');
        else
            data_A(tmpindex).SVNstatus = 'SVN Managed';
            display('SVN Managed');
        end
        if (status(3))
            data_A(tmpindex).SVNupdated = 'Mixed Revision';
            display('Mixed Revision');
        else
            data_A(tmpindex).SVNupdated = 'SVN Updated';
            display('SVN Updated');
        end

    case {'processor_command' 'sendlongprocessorcommand' 'sendprocessorcommand'} %Return processor value ----------------------------
        if (nargin==2 || nargin==3 ) && ( size(in_args,2) == 4 )
            % Custom settings
            uB_command = in_args(1);
            uB_addr    = in_args(2);
            uB_mask    = in_args(3);
            uB_data    = in_args(4);
            a = mex_ADQ([MATLAB_SEND_LONG_PROCESSOR_COMMAND uB_command uB_addr uB_mask uB_data], boardid);
            status = a.Status;
        elseif ((nargin==2 || nargin==3) && size(in_args,2) > 0 && size(in_args,2) < 3)
            % Custom settings
            uB_command = in_args(1);
            if ((nargin==2 || nargin==3) && size(in_args,2) > 1)
                uB_arguments = in_args(2);
            else
                uB_arguments = 0;
            end

            a = mex_ADQ([MATLAB_SEND_PROCESSOR_COMMAND uB_command uB_arguments], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_register' 'writeregister'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 3)
            % Custom settings
            uB_addr    = double(in_args(1));    %Casting of type double enable the register address to be stored in a variable.
            uB_mask    = double(in_args(2));
            uB_data    = double(in_args(3));

            a = mex_ADQ([MATLAB_WRITE_REGISTER uB_addr uB_mask uB_data], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'read_register' 'readregister'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            uB_addr    = double(in_args(1));
            a = mex_ADQ([MATLAB_READ_REGISTER uB_addr], boardid);
            status = a.Status;
            data_A = status(1);
        else if ((nargin==2 || nargin==3) && ischar(in_args) == 1)  %If input is a string, find the register address first
                reg_name = double(in_args);
                a = mex_ADQ([MATLAB_REGISTER_ADDRESS reg_name], boardid);
                status = a.Status;
                uB_addr = double(status(1));
                a = mex_ADQ([MATLAB_READ_REGISTER uB_addr], boardid);
                status = a.Status;
                data_A = status(1);
            else
                error(['Wrong number of in arguments for action "' action '"']);
            end
        end

    case 'writeuserregister'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 4)
            ultarget = double(in_args(1));
            regnum  = double(in_args(2));
            mask    = double(in_args(3));
            data    = double(in_args(4));

            a = mex_ADQ([MATLAB_WRITEUSERREGISTER ultarget regnum mask data], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case 'readuserregister'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            ultarget = double(in_args(1));
            regnum = double(in_args(2));
            a = mex_ADQ([MATLAB_READUSERREGISTER ultarget regnum], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'register_addr' 'get_register_addr' 'registeraddr' 'getregisteraddr'}
        %example command
        %interface_ADQ('getregisteraddr','TRIGGER_HOLD_OFF_ADDR')
        if ((nargin==2 || nargin==3) && ischar(in_args) == 1)
           reg_name = double(in_args);
           a = mex_ADQ([MATLAB_REGISTER_ADDRESS reg_name], boardid);
           status = a.Status;
           data_A = status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_algo_register' 'writealgoregister'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            % Custom settings
            uB_addr    = in_args(1);
            uB_data    = in_args(2);
            a = mex_ADQ([MATLAB_WRITE_ALGO_REGISTER uB_addr uB_data], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'read_algo_register' 'readalgoregister'}%Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            uB_addr    = in_args(1);
            a = mex_ADQ([MATLAB_READ_ALGO_REGISTER uB_addr], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_algo_status' 'setalgostatus'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            algo_status = in_args(1);
            if ismember(algo_status,[0 1])
                a = mex_ADQ([MATLAB_SET_ALGO_STATUS algo_status], boardid);
                status = a.Status;
                data_A = a.Status(1);
            else
                error(['Wrong argument for action "' action '"']);
            end
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'set_algo_nyquist' 'setalgonyquistband'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            algo_staus = in_args(1);
            if ismember(algo_staus,[0 1])
                a = mex_ADQ([MATLAB_SET_ALGO_NYQUIST algo_staus], boardid);
                status = a.Status;
                data_A = a.Status(1);
            else
                error(['Wrong argument for action "' action '"']);
            end
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setinterleavingipestimationmode'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            % Custom settings
            IPInstanceAddr = in_args(1);
            estimation_mode = in_args(2);
            if ismember(estimation_mode,[0 1 2])
                a = mex_ADQ([MATLAB_SET_INTERLEAVING_IP_ESTIMATION_MODE IPInstanceAddr estimation_mode], boardid);
                status = a.Status;
                data_A = a.Status(1);
            else
                error(['Wrong argument for action "' action '"']);
            end
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getinterleavingipestimationmode'}
        if ((nargin==2 || nargin==3))
            if (length(in_args) >= 1)
                IPInstanceAddr = in_args(1);
            else
                IPInstanceAddr = 0;
            end
        else
            IPInstanceAddr = 0;
        end
        a = mex_ADQ([MATLAB_GET_INTERLEAVING_IP_ESTIMATION_MODE IPInstanceAddr], boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'setinterleavingipfrequencycalibrationmode'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            % Custom settings
            IPInstanceAddr = in_args(1);
            freqcalmode = in_args(2);
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_IP_FREQUENCY_CALIBRATION_MODE IPInstanceAddr freqcalmode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

        % USE 'setinterleavingipcalibration' INSTEAD, as this matches the
        % API guide better!
    case {'set_ip_calibration' 'setipcalibration'}
        if ((nargin==2 || nargin==3))
            prog_vect  = double(in_args);
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_IP_CALIBRATION 0 prog_vect], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        %%%%

    case {'setinterleavingipcalibration'}
        if ((nargin==2 || nargin==3))
            IPInstanceAddr = in_args(1);
            prog_vect  = double(in_args(2:end));
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_IP_CALIBRATION IPInstanceAddr prog_vect], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getinterleavingipbypassmode'}
        if ((nargin==2 || nargin==3))
            IPInstanceAddr = in_args(1);
            a = mex_ADQ([MATLAB_GET_INTERLEAVING_IP_BYPASS_MODE IPInstanceAddr], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setinterleavingipbypassmode'}
        if ((nargin==2 || nargin==3))
            IPInstanceAddr = in_args(1);
            bypass = in_args(2);
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_IP_BYPASS_MODE IPInstanceAddr bypass], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_ip_calibration' 'getipcalibration' 'getinterleavingipcalibration'}      
        if ((nargin==2 || nargin==3))
            if (length(in_args) >= 1)
                IPInstanceAddr = in_args(1);
            else
                IPInstanceAddr = 0;
            end
        else
            IPInstanceAddr = 0;
        end
        
        a = mex_ADQ([MATLAB_GET_INTERLEAVING_IP_CALIBRATION IPInstanceAddr], boardid);
        data_A = a.IPCalibrationData;
        status = a.Status;

    case {'read_eeprom_byte' 'readeeprom'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            uB_addr    = in_args(1);
            a = mex_ADQ([MATLAB_READ_EEPROM uB_addr], boardid);
            status = a.Status;
            data_A = status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_eeprom_byte' 'writeeeprom'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) >= 2)
            % Custom settings
            uB_addr    = in_args(1);
            uB_data    = in_args(2);
            accesscode = 0;
            if (size(in_args, 2) == 3)
                accesscode = in_args(3);
            end
            a = mex_ADQ([MATLAB_WRITE_EEPROM uB_addr uB_data accesscode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'read_eeprom_byte_db' 'readeepromdb'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            uB_addr = in_args(1);
            a = mex_ADQ([MATLAB_READ_EEPROM_DB uB_addr], boardid);
            status = a.Status;
            data_A = status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_eeprom_byte_db' 'writeeepromdb'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) >= 2)
            % Custom settings
            uB_addr    = in_args(1);
            uB_data    = in_args(2);
            accesscode = 0;
            if (size(in_args, 2) == 3)
                accesscode = in_args(3);
            end
            a = mex_ADQ([MATLAB_WRITE_EEPROM_DB uB_addr uB_data accesscode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_temperature' 'gettemperature'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            uB_addr    = in_args(1);
            a = mex_ADQ([MATLAB_GET_TEMPERATURE uB_addr], boardid);
            status = double(a.Status(1))/256;
            data_A = status;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_api_revision' 'getapirevision' 'adqapi_getrevision'} %Return status value (adqapi_getrevision is the real name)-------
        a = mex_ADQ(MATLAB_GET_ADQAPI_REVISION, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getadqtype'}
        a = mex_ADQ(MATLAB_GET_ADQ_TYPE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_error_vector' 'geterrorvector'} %Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_ERROR_VECTOR, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getlasterror'}
        a = mex_ADQ(MATLAB_GET_LAST_ERROR, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getlvltriglevel'}
        a = mex_ADQ(MATLAB_GET_LVL_TRIG_LEVEL, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getlvltrigedge'}
        a = mex_ADQ(MATLAB_GET_LVL_TRIG_EDGE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getlvltrigchannel'}
        a = mex_ADQ(MATLAB_GET_LVL_TRIGGER_CHANNEL, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getsampleskip'}
        a = mex_ADQ(MATLAB_GET_SAMPLE_SKIP, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getsampledecimation'}
        a = mex_ADQ(MATLAB_GET_SAMPLE_DECIMATION, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getexterntrigedge'}
        a = mex_ADQ(MATLAB_GET_EXTERN_TRIG_EDGE, boardid);
        status = a.Status;
        data_A = a.Status(1);
        
    case {'getoutputwidth'}
        a = mex_ADQ(MATLAB_GET_OUTPUT_WIDTH, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'get_fifo_overflow' 'getstreamoverflow'} %Return status value ----OBS! should be named getstreamoverflow!-----------------------------
        a = mex_ADQ(MATLAB_GET_FIFO_OVERFLOW, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getstreamstatus'}
        a = mex_ADQ(MATLAB_GET_STREAM_STATUS, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getdataformat'}
        a = mex_ADQ(MATLAB_GET_DATA_FORMAT, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getrecordsize'}
        a = mex_ADQ(MATLAB_GET_RECORD_SIZE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getnofrecords'}
        a = mex_ADQ(MATLAB_GET_NOF_RECORDS, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getsamplesperpage'}
        a = mex_ADQ(MATLAB_GET_SAMPLES_PER_PAGE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'display_board_serial_number' 'displayboardserialnumber'} %Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_DISPLAY_BOARD_SERIAL_NUMBER, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'getboardserialnumber'}
        a = mex_ADQ(MATLAB_GET_BOARD_SERIAL_NUMBER, boardid);
        data_A = a.DataA;

    case {'getcardoption'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 0)
            a = mex_ADQ(MATLAB_GET_CARD_OPTION, boardid);
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_trigger_information' 'gettriggerinformation'} %Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_TRIGGER_INFORMATION, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'set_trigtimemode' 'settrigtimemode'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            sync = in_args(1);
            a = mex_ADQ([MATLAB_SET_TRIGTIMEMODE sync], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_sample_skip' 'setsampleskip'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            skip = in_args(1);
            a = mex_ADQ([MATLAB_SET_SAMPLE_SKIP skip], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_trigtime' 'gettrigtime'}%Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_TRIGTIME, boardid);
        status = a.Status64(1);
        data_A = a.Status64(1);

    case {'gettrigtimesyncs'}%Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_TRIGTIME_SYNCS, boardid);
        status = a.Status64(1);
        data_A = a.Status64(1);

    case {'gettrigtimecycles'}%Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_TRIGTIME_CYCLES, boardid);
        status = a.Status64(1);
        data_A = a.Status64(1);

    case {'gettrigtimestart'}%Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_TRIGTIME_START, boardid);
        status = a.Status64(1);
        data_A = a.Status64(1);

    case {'reset_trigtimer' 'resettrigtimer'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            restart = in_args(1);
        else
            restart = 1;
        end
        a = mex_ADQ([MATLAB_RESET_TRIGTIMER restart], boardid);
        status = a.Status64;
        data_A = a.Status64(1);

    case {'get_multirecordheader' 'getmultirecordheader'} %Return status value --------------------------------------------------------------------
        a = mex_ADQ(MATLAB_GET_MULTIRECORDHEADER, boardid);
        status = a.Status64;
        data_A = a.Status64(1);

    case {'read_memory' 'memorydump'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            % Custom settings
            mem_addr_begin    = double(in_args(1));
            mem_addr_end    = double(in_args(2));
            a = mex_ADQ([MATLAB_MEMORY_DUMP mem_addr_begin mem_addr_end], boardid);
            data_A = a.ByteBuffer;
            status = a.Status(2);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'memoryshadow'} %Return status value --------------------------------------------------------------------
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            % Custom settings
            BytesSize   = double(in_args(1));
            a = mex_ADQ([MATLAB_MEMORY_SHADOW BytesSize], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_interleaving_mode' 'setinterleavingmode'}
        if (nargin==2 || nargin==3)
            interleaving = in_args(1);
            a = mex_ADQ([MATLAB_SET_INTERLEAVING_MODE interleaving], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'enable_clock_ref_out' 'enableclockrefout'}
        if (nargin==2 || nargin==3)
            enable = in_args(1);
            a = mex_ADQ([MATLAB_ENABLE_CLOCK_REF_OUT enable], boardid);
            status = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'adccalibrate'}
        a =mex_ADQ(MATLAB_ADC_CALIBRATE, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'read_adc_calibration' 'readadccalibration'}
        if (nargin==2 || nargin==3)
            adcno = in_args(1);
            a = mex_ADQ([MATLAB_READ_ADC_CALIBRATION adcno], boardid);
            status = a.ADCCalibration;
            data_A = a.ADCCalibration;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'write_adc_calibration' 'writeadccalibration'}
        if (nargin==2 || nargin==3)
            allinputsincludingadcno = in_args(1:end);
            a = mex_ADQ([MATLAB_WRITE_ADC_CALIBRATION allinputsincludingadcno], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_ppt_burst_mode' 'setpptburstmode'}
        if (nargin==2 || nargin==3)
            enable = in_args(1);
            a = mex_ADQ([MATLAB_SET_PPT_BURST_MODE enable], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_ppt_active' 'setpptactive'}
        if (nargin==2 || nargin==3)
            enable = in_args(1);
            a = mex_ADQ([MATLAB_SET_PPT_ACTIVE enable], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_ppt_period' 'setpptperiod'}
        if (nargin==2 || nargin==3)
            period = in_args(1);
            a = mex_ADQ([MATLAB_SET_PPT_PERIOD period], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_ppt_init_offset' 'setpptinitoffset'}
        if (nargin==2 || nargin==3)
            period = in_args(1);
            a = mex_ADQ([MATLAB_SET_PPT_INIT_OFFSET period], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'get_ppt_status' 'getpptstatus'}
        a = mex_ADQ(MATLAB_GET_PPT_STATUS, boardid);
        status = a.Status(1);
        data_A = status(1);

    case {'init_ppt' 'initppt'}
        a =mex_ADQ(MATLAB_INIT_PPT, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'set_sample_decimation' 'setsampledecimation'}
        if (nargin==2 || nargin==3)
            factor = in_args(1);
            a = mex_ADQ([MATLAB_SET_SAMPLE_DECIMATION factor], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_external_trigger_delay' 'setexternaltriggerdelay'}
        if (nargin==2 || nargin==3)
            trigger_delay = in_args(1);
            a = mex_ADQ([MATLAB_SET_EXTERNAL_TRIGGER_DELAY trigger_delay], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'set_internal_trigger_frequency' 'setinternaltriggerfrequency'}
        if (nargin==2 || nargin==3)
            period = in_args(1);
            a = mex_ADQ([MATLAB_SET_INTERNAL_TRIGGER_FREQUENCY period], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'set_internal_trigger_period' 'setinternaltriggerperiod'}
        if (nargin==2 || nargin==3)
            period = in_args(1);
            a = mex_ADQ([MATLAB_SET_INTERNAL_TRIGGER_PERIOD period], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'waveform_averaging_arm' 'waveformaveragingarm'}
        a = mex_ADQ(MATLAB_WFAVG_ARM, boardid);
        status = a.Status(1);
        data_A = a.Status(1);
        
    case {'waveform_averaging_disarm' 'waveformaveragingdisarm'}
        a = mex_ADQ(MATLAB_WFAVG_DISARM, boardid);
        status = a.Status(1);
        data_A = a.Status(1);
    case {'waveform_averaging_getwaveform_without_arm' 'waveformaveraginggetwaveformwithoutarm'}
        if (nargin==2)
            maxretry = in_args(1);
            a = mex_ADQ([MATLAB_WFAVG_GETWAVEFORM maxretry], boardid);
        else
            a = mex_ADQ(MATLAB_WFAVG_GETWAVEFORM, boardid);
        end
        data_A = a.Waveform;
        status = a.Status(1);

    case {'waveform_averaging_setup' 'waveformaveragingsetup'}
        if (nargin==2 || nargin==3)
            nofwaveforms = in_args(1);
            nofsamples = in_args(2);
            nofpretrig = in_args(3);
            nofholdoff = in_args(4);
            flags = in_args(5);
            a = mex_ADQ([MATLAB_WFAVG_SETUP nofwaveforms nofsamples nofpretrig nofholdoff flags], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'waveform_averaging_getwaveform' 'waveformaveraginggetwaveform'}
        a = mex_ADQ(MATLAB_WFAVG_GETWAVEFORM , boardid);
        data_A = a.Waveform;
        status = a.Status(1);

    case {'waveformaveraginggetstatus'}
        a = mex_ADQ(MATLAB_WFAVG_GETSTATUS , boardid);
        status = a.Status;
        
    case {'triggeredstreamingsetup'}
        if (nargin==2 || nargin==3)
            nofrecords = in_args(1);
            nofsamples = in_args(2);
            nofpretrig = in_args(3);
            nofholdoff = in_args(4);
            channelsmask = in_args(5);
            a = mex_ADQ([MATLAB_TS_SETUP nofrecords nofsamples nofpretrig nofholdoff channelsmask], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'gettriggeredstreamingrecords'}
        if (nargin==2 || nargin==3)
            nofrecordstoread = in_args(1);
            a = mex_ADQ([MATLAB_GET_TS_RECORDS nofrecordstoread]);
            status = [a.Status(1) a.Status(2)];
            data_A.DataA = a.DataA;
            data_A.DataB = a.DataB;
            data_A.DataC = a.DataC;
            data_A.DataD = a.DataD;
            data_A.DataHeaders = a.DataHeaders;        
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'triggeredstreaminggetnofrecordscompleted'}
        if (nargin==2 || nargin==3)
            channelsmask = in_args(1);
            a = mex_ADQ([MATLAB_TS_GET_NOF_RECORDS_COMPLETED channelsmask]);
            status = a.Status(1);
            data_A = a.Status(2);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'settriggeredstreamingheaderregister'}
        if (nargin==2 || nargin==3)
            registervalue = in_args(1);
            a = mex_ADQ([MATLAB_TS_SETREGISTER registervalue], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'settriggeredstreamingheaderserial'}
        if (nargin==2 || nargin==3)
            serialnumber = in_args(1);
            a = mex_ADQ([MATLAB_TS_SETSERIAL serialnumber], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end   
        
    case {'triggeredstreamingarm'}
        a = mex_ADQ(MATLAB_TS_ARM, boardid);
        status = a.Status(1);
        data_A = a.Status(1);
        
    case {'triggeredstreamingdisarm'}
        a = mex_ADQ(MATLAB_TS_DISARM, boardid);
        status = a.Status(1);
        data_A = a.Status(1);
        
    case {'packetstreamingsetup'}
        if (nargin==2 || nargin==3)
            PacketSizeSamples = in_args(1);
            NofHoldoffSamples = in_args(2);
            IncludeHeader = in_args(3);
            a = mex_ADQ([MATLAG_PACKET_STREAMING_SETUP PacketSizeSamples NofHoldoffSamples IncludeHeader], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'packetstreamingarm'}
        a = mex_ADQ(MATLAB_PACKET_STREAMING_ARM , boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        
    case {'packetstreamingdisarm'}
        a = mex_ADQ(MATLAB_PACKET_STREAMING_DISARM , boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'setsendlength'}
        if (nargin==2 || nargin==3)
            sendlength = in_args(1);
            a = mex_ADQ([MATLAB_SETSENDLENGTH sendlength], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'inittransfer'}
        a = mex_ADQ(MATLAB_INITTRANSFER, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'getdspdata'}
        a = mex_ADQ(MATLAB_GETDSPDATA, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'getdspdatanowait'}
        a = mex_ADQ(MATLAB_GETDSPDATANOWAIT, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'collectdspdata'}
        a = mex_ADQ(MATLAB_COLLECT_DSPDATA, boardid);
        data_A = a.DataA;
        status = a.Status(1);

    case {'writedatatoep'}
        if (nargin==2 || nargin==3)
            len = in_args(1);
            data = in_args(2:end);
            a = mex_ADQ([MATLAB_WRITETODATAEP len data], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'waitforpciedmafinish'}
        if (nargin==1 || nargin==2)
            waitlength = in_args(1);
            a = mex_ADQ([MATLAB_WAITFORPCIEDMAFINISH, waitlength], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        end

    case {'getsendlength'}
        a = mex_ADQ(MATLAB_GETSENDLENGTH, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case {'trigouten'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            en = in_args(1);
            a = mex_ADQ([MATLAB_TRIG_OUT_EN en], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getphysicaladdress'}
        a = mex_ADQ(MATLAB_GETPHYSICALADDRESS, boardid);
        status = a.Status;
        data_A = a.Status(1);

    case {'setdacoffsetvoltage' 'setoffsetvoltage'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            v = in_args(2);
            a = mex_ADQ([MATLAB_SET_DAC_OFFSET_VOLTAGE channel v], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgmalloc'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 5)
            channel = in_args(1);
            len = in_args(2:5);
            a = mex_ADQ([MATLAB_AWG_MALLOC channel len], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgsegmentmalloc'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 4)
            channel = in_args(1);
            segid = in_args(2);
            segmentlength = in_args(3);
            realloc = in_args(4);
            a = mex_ADQ([MATLAB_AWG_SEGMENTMALLOC channel segid segmentlength realloc], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgwritesegment'}
        if ((nargin==2 || nargin==3) && size(in_args,2) > 6)
            channel = in_args(1);
            seg = in_args(2);
            enable = in_args(3);
            NofLaps = in_args(4);
            len = in_args(5);
            data = in_args(6:len+5);
            a = mex_ADQ([MATLAB_AWG_WRITE_SEGMENT channel seg enable NofLaps len data], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgenablesegments'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            enable = in_args(2);
            a = mex_ADQ([MATLAB_AWG_ENABLE_SEGMENTS channel enable], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgautorearm'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            enable = in_args(2);
            a = mex_ADQ([MATLAB_AWG_AUTO_REARM channel enable], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgcontinuous'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            enable = in_args(2);
            a = mex_ADQ([MATLAB_AWG_CONTINUOUS channel enable], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgtrigmode'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            trigmode = in_args(2);
            a = mex_ADQ([MATLAB_AWG_TRIGMODE channel trigmode], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgarm'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            channel = in_args(1);
            a = mex_ADQ([MATLAB_AWG_ARM channel], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgdisarm'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            channel = in_args(1);
            a = mex_ADQ([MATLAB_AWG_DISARM channel], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setethernetpllfreq'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            eth10freq = in_args(1);
            eth1freq = in_args(2);
            a = mex_ADQ([MATLAB_SETETHERNETPLLFREQ eth10freq eth1freq], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setpointtopointpllfreq'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            ppfreq = in_args(1);
            a = mex_ADQ([MATLAB_SETPOINTTOPOINTPLLFREQ ppfreq], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setethernetpll'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 8)
            refdiv = in_args(1);
            useref2 = in_args(2);
            a = in_args(3);
            b = in_args(4);
            p = in_args(5);
            vcooutdiv = in_args(6);
            eth10_outdiv = in_args(7);
            eth1_outdiv = in_args(8);
            a = mex_ADQ([MATLAB_SETETHERNETPLL refdiv useref2 a b p vcooutdiv eth10_outdiv eth1_outdiv], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setpointtopointpll'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 8)
            refdiv = in_args(1);
            useref2 = in_args(2);
            a = in_args(3);
            b = in_args(4);
            p = in_args(5);
            vcooutdiv = in_args(6);
            ppoutdiv = in_args(7);
            ppsyncoutdiv = in_args(8);
            a = mex_ADQ([MATLAB_SETPOINTTOPOINTPLL refdiv useref2 a b p vcooutdiv ppoutdiv ppsyncoutdiv], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setdirectionmlvds'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            direction = in_args(1);
            a = mex_ADQ([MATLAB_SETDIRECTIONMLVDS direction], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'offsetdacspiwrite' 'offset_dac_spi_write' 'offsetdac_spi_write'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            data = in_args(2);
            a = mex_ADQ([MATLAB_OFFSETDAC_SPI_WRITE channel data], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'dacspiwrite' 'dac_spi_write'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 3)
            channel = in_args(1);
            address = in_args(2);
            data = in_args(3);
            a = mex_ADQ([MATLAB_DAC_SPI_WRITE channel address data], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case {'dacspiread' 'dac_spi_read'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            channel = in_args(1);
            address = in_args(2);
            a = mex_ADQ([MATLAB_DAC_SPI_READ channel address], boardid);
            status = bitand(a.Status(1), hex2dec('FF'));
            data_A = status;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'sendipcommand' 'send_ip_command'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 4)
            ip_instance = in_args(1);
            cmd = in_args(2);
            arg1 = in_args(3);
            arg2 = in_args(4);
            a = mex_ADQ([MATLAB_SEND_IP_COMMAND ip_instance cmd arg1 arg2], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getngcpartnumber'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 0)
            a = mex_ADQ(MATLAB_GETNGCPARTNUMBER, boardid);
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'getuserlogicpartnumber'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 0)
            a = mex_ADQ(MATLAB_GETUSERLOGICPARTNUMBER, boardid);
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'writestarbdelay'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            starbdelay = in_args(1);
            writetoeeprom = in_args(2);
            a = mex_ADQ([MATLAB_WRITESTARBDELAY starbdelay writetoeeprom], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'enablepxietriggers'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            port = in_args(1);
            bitflags = in_args(2);
            a = mex_ADQ([MATLAB_ENABLEPXIETRIGGERS port bitflags], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'enablepxietrigout'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            trigsource = in_args(1);
            bitflags = in_args(2);
            a = mex_ADQ([MATLAB_ENABLEPXIETRIGOUT trigsource bitflags], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'pxiesoftwaretrigger'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 0)
            a = mex_ADQ(MATLAB_PXIESOFTWARETRIGGER, boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'setpxietrigdirection'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            trig0output = in_args(1);
            trig1output = in_args(2);
            a = mex_ADQ([MATLAB_SETPXIETRIGDIRECTION trig0output trig1output], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgsetuptrigout'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 5)
            dacid = in_args(1);
            trigoutmode = in_args(2);
            pulselength = in_args(3);
            enableflags = in_args(4);
            autorearm = in_args(5);
            a = mex_ADQ([MATLAB_AWGSETUPTRIGOUT dacid trigoutmode pulselength enableflags autorearm], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgtrigoutarm'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            dacid = in_args(1);
            a = mex_ADQ([MATLAB_AWGTRIGOUTARM dacid], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgtrigoutdisarm'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            dacid = in_args(1);
            a = mex_ADQ([MATLAB_AWGTRIGOUTDISARM dacid], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end

    case {'awgsettriggerenable'}
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            dacid = in_args(1);
            bitflags = in_args(2);
            a = mex_ADQ([MATLAB_AWGSETTRIGGERENABLE dacid bitflags], boardid);
            status = a.Status(1);
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
    
    case {'getpcielinkwidth'}
        a = mex_ADQ(MATLAB_GET_PCIE_LINK_WIDTH, boardid);
        status = a.Status(1);
        data_A = a.Status(1);
    
    case {'getpcielinkrate'}
        a = mex_ADQ(MATLAB_GET_PCIE_LINK_RATE, boardid);
        status = a.Status(1);
        data_A = a.Status(1);

    case 'getstuff'
        if (nargin==2 || nargin==3)
            stuffindex = in_args(1);
            a = mex_ADQ([MATLAB_GET_STUFF stuffindex], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'trigoutenable'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            bitflags = in_args(1);
            a = mex_ADQ([MATLAB_TRIGOUTENABLE bitflags], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'setexttrigthreshold'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 2)
            trignum = in_args(1);
            vthresh = in_args(2);
            a = mex_ADQ([MATLAB_SETEXTTRIGTHRESHOLD trignum vthresh], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
    case 'hastrighardware'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            trignum = in_args(1);
            a = mex_ADQ([MATLAB_HASTRIGHARDWARE trignum], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
    case 'hastrigouthardware'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            trignum = in_args(1);
            a = mex_ADQ([MATLAB_HASTRIGOUTHARDWARE trignum], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
    case 'hasvariabletrigthreshold'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            trignum = in_args(1);
            a = mex_ADQ([MATLAB_HASVARIABLETRIGTHRESHOLD trignum], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'listdevices'
        a = mex_ADQ(MATLAB_LISTDEVICES, boardid);
        status = a;
        data_A = a;
        
    case 'opendeviceinterface'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            devicenum = in_args(1);
            a = mex_ADQ([MATLAB_OPENDEVICEINTERFACE devicenum], boardid);
            status = a;
            data_A = a;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'setupdevice'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            devicenum = in_args(1);
            a = mex_ADQ([MATLAB_SETUPDEVICE devicenum], boardid);
            status = a;
            data_A = a;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'enableerrortrace'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            depth = in_args(1);
            a = mex_ADQ([MATLAB_ENABLEERRORTRACE depth], boardid);
            status = a;
            data_A = a;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'enableerrortraceappend'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            depth = in_args(1);
            a = mex_ADQ([MATLAB_ENABLEERRORTRACEAPPEND depth], boardid);
            status = a;
            data_A = a;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'getmaxnofrecordsfromnofsamples'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            nofsamples = in_args(1);
            a = mex_ADQ([MATLAB_GETMAXNOFRECORDSFROMNOFSAMPLES nofsamples], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'getmaxnofsamplesfromnofrecords'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            nofrecords = in_args(1);
            a = mex_ADQ([MATLAB_GETMAXNOFSAMPLESFROMNOFRECORDS nofrecords], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    case 'hasadjustablebias'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 0)
            a = mex_ADQ(MATLAB_HASADJUSTABLEBIAS, boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end     
        
    case 'setbiasdacpercentage'
        if ((nargin==2 || nargin==3) && size(in_args,2) == 1)
            percent = in_args(1);
            a = mex_ADQ([MATLAB_SETBIASDACPERCENTAGE percent], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end             
        
    case 'spisend'
        if ((nargin==2 || nargin==3))
            addr = in_args(1);
            data = in_args(2:end-2);
            datalength = in_args(end-1);
            negedge = in_args(end);
            if (datalength ~= length(data))
                error(['Wrong number of in arguments for action "' action '"']);
            end
            a = mex_ADQ([MATLAB_SPISEND addr datalength data negedge], boardid);
            status = a.Status;
            data_A = a.DataA;
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end   
     
    case 'setupleveltrigger'
        if ((nargin==2 || nargin==3))
            if (length(in_args) == 5)
                levels = in_args(1);
                edges = in_args(2);
                resetlevels = in_args(3);
                channelsmask = in_args(4);
                individual_mode = in_args(5);
            elseif (length(in_args) == 8)
                levels = in_args(1:2);
                edges = in_args(3:4);
                resetlevels = in_args(5:6);
                channelsmask = in_args(7);
                individual_mode = in_args(8);
            elseif (length(in_args) == 14)
                levels = in_args(1:4);
                edges = in_args(5:8);
                resetlevels = in_args(9:12);
                channelsmask = in_args(13);
                individual_mode = in_args(14);
            else
                error(['Wrong number of in arguments for action "' action '"']);
            end
            a = mex_ADQ([MATLAB_SETUPLEVELTRIGGER  levels edges resetlevels channelsmask individual_mode], boardid);
            status = a.Status;
            data_A = a.Status(1);
        else
            error(['Wrong number of in arguments for action "' action '"']);
        end
        
    otherwise
        error('Unknown action. Type "help interface_ADQ" for help');
end

%clear mex; %Disconnect matlab from mex-dll file. This may be needed if a function is unexpectedly interrupted
%DO NOT DO THIS IF NOT NEEDED, WILL RESET ALL SETTINGS

