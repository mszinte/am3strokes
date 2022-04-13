function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

%% Randomization
rng('default');
rng('shuffle');


%% Colors
const.white                 =   [255,255,255];                                                              % White
const.black                 =   [0,0,0];                                                                    % Black
const.gray                  =   [90,90,90];                                                                 % Gray
const.red                   =   [200,0,0];                                                                  % Red
const.background_color      =   const.gray;                                                                 % Background color

%% Time parameters
const.ini_fix_min_dur       =   0.200;                                                                      % Minimal fixation duration (in seconds)
const.ini_fix_max_dur       =   0.400;                                                                      % Maximal fixation duration (in seconds)
const.ini_fix_steps         =   11;                                                                         % fixation duration steps 
const.ini_fix_dur           =   linspace(const.ini_fix_min_dur,const.ini_fix_max_dur,const.ini_fix_steps);  % Initial fixation (in seconds)
const.ini_fix_nbf           =   round(const.ini_fix_dur/scr.frame_duration);                                % Initial fixation (in frames)

const.stroke_dur            =   0.020;                                                                      % Stroke duration (in seconds)
const.stroke_nbf            =   round(const.stroke_dur/scr.frame_duration);                                 % Stroke duration (in frames)
const.inter_stroke_dur      =   0.040;                                                                      % Inter-stroke duration (in seconds)
const.inter_stroke_nbf      =   round(const.inter_stroke_dur/scr.frame_duration);                           % Inter-stroke duration (in frames)

const.post_stroke_min_dur   =   0.400;                                                                      % Post-stoke duration min (in seconds)
const.post_stroke_max_dur   =   0.650;                                                                      % Post-stoke duration max (in seconds)
const.post_stroke_steps     =   6;                                                                          % Post-stroke duration steps
const.post_stroke_dur       =   linspace(const.post_stroke_min_dur,const.post_stroke_max_dur, const.post_stroke_steps); % Post-stroke duration (in seconds)
const.post_stroke_nbf       =   round(const.post_stroke_dur/scr.frame_duration);                            % Post-stroke duration (in frames)

const.post_saccade_dur      =   1.000;                                                                      % Post-saccade duration (in seconds)
const.post_saccade_nbf      =   round(const.post_saccade_dur/scr.frame_duration);                           % Post-saccade duration (in frames)

%% Space parameter
const.shift_fix_y_dva       =   5;                                                                          % Shift up because of screen defect (in dva)
const.shift_fix_y           =   vaDeg2pix(const.shift_fix_y_dva,scr);                                       % Shift up because of screen defect (in pixels)
const.fix_coord             =   [scr.x_mid,scr.y_mid-const.shift_fix_y];                                    % Initial fixation target position
const.stoke_rad_dva         =   0.25;                                                                       % Stroke radius (in dva)
const.stoke_rad             =   vaDeg2pix(const.stoke_rad_dva,scr);                                         % Stroke radius (in pixels)
const.motion_amp_dva        =   1;                                                                          % Motion amplitude (in dva)
const.motion_amp            =   vaDeg2pix(const.motion_amp_dva,scr);                                        % Motion amplitude (in pixels)

const.mot_ecc_x_dva         =   5;                                                                          % Motion x position ecc
const.mot_ecc_x             =   vaDeg2pix(const.mot_ecc_x_dva,scr);                                          
const.mot_ctr_y_dva         =   3;                                                                         % Motion center y position
const.mot_ctr_y             =   vaDeg2pix(const.mot_ctr_y_dva,scr);

const.mot_coord_x           =   [-const.mot_ecc_x, const.mot_ecc_x];                                        % Motion x coordinates [left, right]

const.mot_coord_y           =   const.mot_ctr_y - ...
                                [-1*const.motion_amp,...                                                    % Motion y coordinates [pos1; 
                                 -0.5*const.motion_amp,...                                                  %                       pos2;
                                 0*const.motion_amp,...                                                     %                       pos3;
                                 0.5*const.motion_amp,...                                                   %                       pos4;
                                 1*const.motion_amp];                                                       %                       pos5]

% x_num [1] = left; x_num [2] = right
% y_num [1] = pos_1 (-1 dva); y_num [2] = pos_2 (-0.5 dva); y_num [3] = pos_3 (0 dva); y_num [4] = pos_4 (0.5 dva); y_num [5] = pos_5 (1 dva)
for x_num = 1:size(const.mot_coord_x,2)
    for y_num = 1:size(const.mot_coord_y,2)
        const.mot_coord{x_num,y_num} = [scr.x_mid+const.mot_coord_x(x_num),scr.y_mid-const.mot_coord_y(y_num)];        
    end
end

const.motion_jitter_steps   =   11;                                                                         % motion coord jitter steps
const.jitter_amp_dva        =   2.5;                                                                        % motion coord jitter amplitude (in dva)
const.jitter_amp            =   vaDeg2pix(const.jitter_amp_dva,scr);                                        % motion coord jitter amplitude (in pixels)

const.motion_jitter         =   linspace(-const.jitter_amp,const.jitter_amp,const.motion_jitter_steps);     % motion jitter [x,y]


%% Eye-tracking configurations
const.edf2asc               =   'C:\Experiments\am3strokes\stats\edf2asc.exe';                              % edf2asc directory
const.checkfix_rad_dva      =   2;                                                                          % fixation tolerance radius (in dva)
const.checkfix_rad          =   vaDeg2pix(const.checkfix_rad_dva,scr);                                      % fixation tolerance radius (in pixels)
const.timeOut               =   2;                                                                          % maximum fixation check time (in seconds)
const.tCorMin               =   0.200;                                                                      % minimum correct fixation time (in seconds)

% Stim for calibratin
const.fix_out_rim_radVal    =   0.25;                                                                       % radius of outer circle of fixation bull's eye
const.fix_rim_radVal        =   0.75*const.fix_out_rim_radVal;                                              % radius of intermediate circle of fixation bull's eye in degree
const.fix_radVal            =   0.25*const.fix_out_rim_radVal;                                              % radius of inner circle of fixation bull's eye in degrees
const.fix_out_rim_rad       =   vaDeg2pix(const.fix_out_rim_radVal,scr);                                    % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad           =   vaDeg2pix(const.fix_rim_radVal,scr);                                        % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad               =   vaDeg2pix(const.fix_radVal,scr);                                            % radius of inner circle of fixation bull's eye in pixels

% Personal calibrations
rng('default');rng('shuffle');
angle = 0:pi/3:5/3*pi;
 
% compute calibration target locations
const.calib_amp_ratio  = 0.5;
[cx1,cy1] = pol2cart(angle,const.calib_amp_ratio);
[cx2,cy2] = pol2cart(angle+(pi/6),const.calib_amp_ratio*0.5);
cx = round(scr.x_mid + scr.x_mid*[0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid*[0 cy1 cy2]);

% order for eyelink
const.calibCoord = round([  cx(1), cy(1),...   % 1.  center center
                            cx(9), cy(9),...   % 2.  center up
                            cx(13),cy(13),...  % 3.  center down
                            cx(5), cy(5),...   % 4.  left center
                            cx(2), cy(2),...   % 5.  right center
                            cx(4), cy(4),...   % 6.  left up
                            cx(3), cy(3),...   % 7.  right up
                            cx(6), cy(6),...   % 8.  left down
                            cx(7), cy(7),...   % 9.  right down
                            cx(10),cy(10),...  % 10. left up
                            cx(8), cy(8),...   % 11. right up
                            cx(11),cy(11),...  % 12. left down
                            cx(12),cy(12)]);    % 13. right down
      
% compute validation target locations (calibration targets smaller radius)
const.valid_amp_ratio = const.calib_amp_ratio*0.8;
[vx1,vy1] = pol2cart(angle,const.valid_amp_ratio);
[vx2,vy2] = pol2cart(angle+pi/6,const.valid_amp_ratio*0.5);
vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);
 
% order for eyelink
const.validCoord =round( [  vx(1), vy(1),...   % 1.  center center
                             vx(9), vy(9),...   % 2.  center up
                             vx(13),vy(13),...  % 3.  center down
                             vx(5), vy(5),...   % 4.  left center
                             vx(2), vy(2),...   % 5.  right center
                             vx(4), vy(4),...   % 6.  left up
                             vx(3), vy(3),...   % 7.  right up
                             vx(6), vy(6),...   % 8.  left down
                             vx(7), vy(7),...   % 9.  right down
                             vx(10),vy(10),...  % 10. left up
                             vx(8), vy(8),...   % 11. right up
                             vx(11),vy(11),...  % 12. left down
                             vx(12),vy(12)]);    % 13. right down

const.ppd               =   vaDeg2pix(1,scr);                                                  % get one pixel per degree

end