% clear mex
% %addpath(get_adq_installer_path)
% % clc
% 
% handles.boardid = 1;
% 
% % Constants
% SW_TRIGGER_MODE = 1;
% EXTERNAL_TRIGGER_MODE = 2;
% LEVEL_TRIGGER_MODE = 3;
% RISING_EDGE = 1;
% FALLING_EDGE = 0;
% CLK_INTREF = 0;
% CLK_EXTREF = 1;
% CLK_EXT = 2;
% NO_CH = 0;
% CH_A = 1;
% CH_B = 2;
% CH_C = 4;
% CH_D = 8;
% ANY_CH = 15;
% 
% FS_1400 = 280;
% FS_1500 = 300;
% FS_1600 = 320;
% FS_1700 = 340;
% FS_1800 = 360;
% 
% INTERLEAVING = 1;  % 2 channels
% NON_INTERLEAVING = 0; % 4 channels
% 
% %% get data
% 
% % Set internal clocking frequency
% % This call may take a few seconds
% % interface_ADQ('setpll', [FS_1400 2 1 1], boardid);
% 
% % Set clock source
% % interface_ADQ('setclocksource',CLK_INTREF, boardid); 
% 
% % Set interleaving mode
% % interface_ADQ('setinterleavingmode', INTERLEAVING, boardid);
% 
% % Select trigger
% %selected_trigger = SW_TRIGGER_MODE;  % EXTERNAL_TRIGGER_MODE
% global selected_trigger;
% interface_ADQ('settriggermode', selected_trigger, handles.boardid);
% 
% 
% % Setup multitrig, one record, 35000 samples
% % eventdatanofrecords = 100;
% % recordsize = 35000;
% [adq_data, junk, adq_status, adq_valid] = interface_ADQ('multirecordsetup', [nofrecords recordsize], handles.boardid);
% % 
% % x=0:1/(1000):(recordsize-1)/(1000);
% % figure(1);clf;hold on
% 
% % % Disarm & arm
% %  interface_ADQ('disarmtrigger', [],eventdata.boardid);
% %  interface_ADQ('armtrigger', [],eventdata.boardid);
% % 
% % trigged = 0;
% % while trigged == 0
% %     %pause
% %     if selected_trigger== SW_TRIGGER_MODE
% %       interface_ADQ('swtrig', [], eventdata.boardid); % Trig device
% %     end
% %     [adq_data, junk, adq_status, adq_valid] = interface_ADQ('getacquiredall', [], eventdata.boardid); % Check if all records collected
% %     trigged = adq_status(1);
% %     pause(0.01);
% % end
% 
% %%
% 
% 
clear mex
%clc; clear all; close all;
% addpath(get_adq_installer_path)

% This example is for ADQ412 devices
global  ChannelsOnDevice
% Constants
define_command_codes;
BoardID = 1;
% Define flags
WFAVG_FLAG_COMPENSATE_EXT_TRIG	= hex2dec('0001');
WFAVG_FLAG_COMPENSATE_LEVEL_TRIG	= hex2dec('0002');
WFAVG_FLAG_READOUT_FAST	=	hex2dec('0004');
WFAVG_FLAG_READOUT_MEDIUM = hex2dec('0008');
WFAVG_FLAG_READOUT_SLOW = hex2dec('0010');
WFAVG_FLAG_ENABLE_LEVEL_TRIGGER	=	hex2dec('0020');
WFAVG_FLAG_ENABLE_WAVEFORM_GET	=	hex2dec('0040');
WFAVG_FLAG_ENABLE_AUTOARMNREAD	=	hex2dec('0080');
WFAVG_FLAG_READOUT_A_ONLY	=	hex2dec('0100');
WFAVG_FLAG_READOUT_B_ONLY	= hex2dec('0200');
WFAVG_FLAG_IMMEDIATE_READOUT	= hex2dec('0400');
wfavg_flags=0;
ready_flag = 0;
% For custom settings, change the parameters below
% constants are defined in define_command_codes.m
ChannelsOnDevice = 1;
a = mex_ADQ(MATLAB_GET_ADQ_TYPE);
if a.Status(1)==412;%214
  ChannelsOnDevice = 2;
end

% --------- SELECTED TRIGGER -------------
TriggerMode = selected_trigger;%EXTERNAL_TRIGGER_MODE;%SW_TRIGGER_MODE; %SW_TRIGGER_MODE, EXTERNAL_TRIGGER_MODE, LEVEL_TRIGGER_MODE or INTERNAL_TRIGGER_MODE
% set up trigger
interface_ADQ('settriggermode',TriggerMode,BoardID);

% SET UP TRIGGER.
if TriggerMode == INTERNAL_TRIGGER_MODE
  % Use internal trigger for getting started.
  % Set parameters
  InternalTriggerFrequency = 1.34245e3; % Set to 1 kHz
  InternalTriggerPeriodStep = 5e-9; % 5e-9 for 214/114 (3.6e-9 for 112/212)
  InternalTriggerSetting = (1/InternalTriggerFrequency)/InternalTriggerPeriodStep;
  interface_ADQ('setinternaltriggerperiod', InternalTriggerSetting,BoardID);
  % Use setup in app note. 
  interface_ADQ('setconfigurationtrig',[hex2dec('41'),0,0]);
end

if TriggerMode == LEVEL_TRIGGER_MODE
  wfavg_flags = wfavg_flags+WFAVG_FLAG_ENABLE_LEVEL_TRIGGER+WFAVG_FLAG_COMPENSATE_LEVEL_TRIG;
  % Set parameters
  % SET DATA FORMAT! 
  % The WFA is set up for level trigger using data format 0. The level
  % trigger parameters has to use the same data format. 
  interface_ADQ('setdataformat',0,BoardID);
  LvlTrigLevelTwosComp = 2000; %-8192 - 8191
  LvlTrigEdge = RISING_EDGE; %RISING_EDGE or FALLING_EDGE
  LvlTrigCh = CH_B; %NO_CH, CH_A, CH_B or ANY_CH
  % SET UP LEVEL TRIGGER in digitizer
  interface_ADQ('setlvltriglevel',LvlTrigLevelTwosComp,BoardID);
  interface_ADQ('setlvltrigedge',LvlTrigEdge,BoardID);
  if (ChannelsOnDevice > 1)
    interface_ADQ('setlvltrigchannel',LvlTrigCh,BoardID);
  end
  % SETUP according to App note. Use internal trigger to generate level
  % triggers. Connect trigger output to channel A through a 10dB
  % attenuator.
  interface_ADQ('setdirectiontrig',1);
  interface_ADQ('writetrig',0);

end

if TriggerMode == EXTERNAL_TRIGGER_MODE
  % Use external trigger for getting started.
  % Set parameters
  interface_ADQ('setdirectiontrig',1);
  interface_ADQ('writetrig',0);
end
%%--------SET UP INTERLEAVINGMODE-------------
INTERLEAVING = 2;
interface_ADQ('setinterleavingmode', INTERLEAVING);
% ------ SET UP WAVEFORM AVERAGING --------
% Define parameters
% nofloops = 2;
% nofwaveforms = 10;%10;
% nofsamples = 65536;%65536;
% nofpretrig = 0;%96;
% nofholdoff = 0;%3800*2;
%scaled_A=zeros(nofrecords, nofsamples);
%scaled_B=zeros(nofloops, nofsamples);
%data = zeros(nofloops, 2*nofsamples);
% Select flags
wfavg_flags = wfavg_flags+WFAVG_FLAG_ENABLE_WAVEFORM_GET + WFAVG_FLAG_READOUT_SLOW;
interface_ADQ('waveformaveragingsetup', [nofwaveforms recordsize nofpretrig nofholdoff wfavg_flags],BoardID);
% ARM WFA
%interface_ADQ('waveformaveragingarm',[],BoardID);

