%% General experimenter launcher
%  =============================
% By :      Martin SZINTE
% Projet :  AM3stroke
% With :    Kevin Blaize, Anna Montagnini & Frederic Chavane
% Version:  1.0

% Version description
% ===================
% 3 stokes apparent motion task with participants having to saccade towards the lastly presented stoke

% design idea
% -----------
% 3 runs of 540 trials (X:XX min, about Xh in total)
% 2 variables : (1) stim side (2) sequence 
% Stim side: left vs right
% Sequences: s1_pos1, s1_pos2, s1_pos3, s1_pos4, s1_pos5, s3up_pos3, s3down_pos3
% 4 random values : (1) initial fixation duratin (2) post-stim duration (3) jitter x (4) jitter y
% Monocular recording

% To do
% -----
% - write conversion of data to asc on windows
% - check duration of a run
% - collect data on me
% - code analysis in Python
% - do video

% First settings
% --------------
Screen('CloseAll');clear all;clear mex;clear functions;close all;home;AssertOpenGL;

% General settings
% ----------------
const.expName           =   'AM3strokes';   % experiment name
const.expStart          =   1;              % Start of a recording exp                          0 = NO  , 1 = YES
const.checkTrial        =   0;              % Print trial conditions (for debugging)            0 = NO  , 1 = YES
const.mkVideo           =   0;              % Make a video of a run                             0 = NO  , 1 = YES

% External controls
% -----------------
const.tracker           =   1;              % run with eye tracker                              0 = NO  , 1 = YES

% Run order and number per condition
% ----------------------------------
const.numRun            =   3;              % number of run
const.nb_trials         =   120;            % number of trials per conditions

% Desired screen setting
% ----------------------
const.desiredFD         =   100;            % Desired refresh rate
%fprintf(1,'\n\n\tDon''t forget to change before testing\n');
const.desiredRes        =   [1920,1080];    % Desired resolution

% Path
% ----
dir                     =   (which('expLauncher'));
cd(dir(1:end-18));

% Add Matlab path
% ---------------
addpath('config','main','conversion','eyeTracking','instructions','trials','stim','stats');

% Subject configuration
% ---------------------
[const]                 =   sbjConfig(const);

% Main run
% --------
main(const);
