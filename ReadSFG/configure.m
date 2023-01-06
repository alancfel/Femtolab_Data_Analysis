clear mex
%addpath(get_adq_installer_path)
% clc

handles.boardid = 1;
define_command_codes;
% Constants
SW_TRIGGER_MODE = 1;
EXTERNAL_TRIGGER_MODE = 2;
LEVEL_TRIGGER_MODE = 3;
RISING_EDGE = 1;
FALLING_EDGE = 0;
CLK_INTREF = 0;
CLK_EXTREF = 1;
CLK_EXT = 2;
NO_CH = 0;
CH_A = 1;
CH_B = 2;
CH_C = 4;
CH_D = 8;
ANY_CH = 15;

FS_1400 = 280;
FS_1500 = 300;
FS_1600 = 320;
FS_1700 = 340;
FS_1800 = 360;

INTERLEAVING = 1;  % 2 channels
NON_INTERLEAVING = 0; % 4 channels

%% get data

% Set internal clocking frequency
% This call may take a few seconds
% interface_ADQ('setpll', [FS_1400 2 1 1], boardid);

% Set clock source
% interface_ADQ('setclocksource',CLK_INTREF, boardid); 

% Set interleaving mode
% interface_ADQ('setinterleavingmode', INTERLEAVING, boardid);

% Select trigger
%selected_trigger = SW_TRIGGER_MODE;  % EXTERNAL_TRIGGER_MODE
global selected_trigger;
interface_ADQ('settriggermode', selected_trigger, handles.boardid);
BoardID = 1;
% SET UP TRIGGER.
TriggerMode = selected_trigger;
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
 % wfavg_flags = wfavg_flags+WFAVG_FLAG_ENABLE_LEVEL_TRIGGER+WFAVG_FLAG_COMPENSATE_LEVEL_TRIG;
  % Set parameters
  % SET DATA FORMAT! 
  % The WFA is set up for level trigger using data format 0. The level
  % trigger parameters has to use the same data format. 
  interface_ADQ('setdataformat',0,BoardID);
%   LvlTrigLevelTwosComp = 2000; %-8192 - 8191
%   LvlTrigEdge = RISING_EDGE; %RISING_EDGE or FALLING_EDGE
%   LvlTrigCh = CH_B; %NO_CH, CH_A, CH_B or ANY_CH
  % SET UP LEVEL TRIGGER in digitizer
  interface_ADQ('setlvltriglevel',LvlTrigLevelTwosComp,BoardID);
  interface_ADQ('setlvltrigedge',LvlTrigEdge,BoardID);
%  if (ChannelsOnDevice > 1)
    interface_ADQ('setlvltrigchannel',LvlTrigCh,BoardID);
%  end
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
% Setup multitrig, one record, 35000 samples
% eventdatanofrecords = 100;
% recordsize = 35000;
[adq_data, junk, adq_status, adq_valid] = interface_ADQ('multirecordsetup', [nofrecords recordsize], handles.boardid);
% 
% x=0:1/(1000):(recordsize-1)/(1000);
% figure(1);clf;hold on

% % Disarm & arm
%  interface_ADQ('disarmtrigger', [],eventdata.boardid);
%  interface_ADQ('armtrigger', [],eventdata.boardid);
% 
% trigged = 0;
% while trigged == 0
%     %pause
%     if selected_trigger== SW_TRIGGER_MODE
%       interface_ADQ('swtrig', [], eventdata.boardid); % Trig device
%     end
%     [adq_data, junk, adq_status, adq_valid] = interface_ADQ('getacquiredall', [], eventdata.boardid); % Check if all records collected
%     trigged = adq_status(1);
%     pause(0.01);
% end

%%


