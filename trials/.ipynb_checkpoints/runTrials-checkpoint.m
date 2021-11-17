function [expDes] = runTrials(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% [expDes]=runTrials(scr,const,expDes,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% t : trial number
% ----------------------------------------------------------------------
% Output(s):
% resMat : experimental results (see below)
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

% Write in log/edf
expDes.expMat(t,9) = GetSecs;
log_txt = sprintf('trial %i started at %f\n',t,expDes.expMat(t,9));
if const.tracker
    Eyelink('message','%s',log_txt);
end

% Compute and simplify var and rand
% ---------------------------------
var1 = expDes.expMat(t,3);
var2 = expDes.expMat(t,4);
rand1 = expDes.expMat(t,5);
rand2 = expDes.expMat(t,6);
rand3 = expDes.expMat(t,7);
rand4 = expDes.expMat(t,8);

if const.checkTrial && const.expStart == 0
    fprintf(1,'\n\n\t========================  TRIAL %3.0f ========================\n',t);
    fprintf(1,'\n\tSequence                     =\t%s',expDes.txt_var1{var1});
    fprintf(1,'\n\tSacade direction             =\t%s',expDes.txt_var2{var2});
    fprintf(1,'\n\tIntial fixation duration     =\t%s',expDes.txt_rand1{rand1});
    fprintf(1,'\n\tPost-stimulus duration       =\t%s',expDes.txt_rand2{rand2});
    fprintf(1,'\n\tSpatial jitter X             =\t%s',expDes.txt_rand3{rand3});
    fprintf(1,'\n\tSpatial jitter Y             =\t%s',expDes.txt_rand4{rand4});
end

% Positions
jitter_coord = [const.motion_jitter(rand3),-const.motion_jitter(rand4)];
fix_coord = const.fix_coord + jitter_coord;
switch var1
    case 1;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 2;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 3;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 4;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 5;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 6;stroke_coord =   [const.mot_coord{var2,5} + jitter_coord;...
                             const.mot_coord{var2,4} + jitter_coord;...
                             const.mot_coord{var2,3} + jitter_coord];
    case 7;stroke_coord =   [const.mot_coord{var2,1} + jitter_coord;...
                             const.mot_coord{var2,2} + jitter_coord;...
                             const.mot_coord{var2,3} + jitter_coord];
end

% Time
fix_nbf_onset = 1;
s1_nbf_onset = const.ini_fix_nbf(rand1) + 1;
s1_nbf_offset = s1_nbf_onset + const.stroke_nbf - 1;
if size(stroke_coord,1) > 1
    s2_nbf_onset = s1_nbf_offset + const.inter_stroke_nbf + 1;
    s2_nbf_offset = s2_nbf_onset + const.stroke_nbf - 1;
    s3_nbf_onset = s2_nbf_offset + const.inter_stroke_nbf + 1;
    s3_nbf_offset = s3_nbf_onset + const.stroke_nbf - 1;
    fix_nbf_offset = s3_nbf_offset + const.post_stroke_nbf(rand2);
else
    fix_nbf_offset = s1_nbf_offset + const.post_stroke_nbf(rand2);
end

trial_offset = fix_nbf_offset + const.post_saccade_nbf;

% Trial loop
% ----------

nbf = 0;
while nbf <= trial_offset
    
    % Flip count
    nbf = nbf + 1;
    
    % Draw background
    Screen('FillRect', scr.main, const.background_color);
    
    % Fixation target
    if nbf >= fix_nbf_onset && nbf <= fix_nbf_offset
        % draw fixation
        Screen('DrawDots', scr.main, fix_coord, const.stoke_rad*2, const.white, [], 2);
    end
    
    % Stroke(s)
    if nbf >= s1_nbf_onset && nbf <= s1_nbf_offset
        % Draw s1
        Screen('DrawDots', scr.main, stroke_coord(1,:), const.stoke_rad*2, const.white, [], 2);
    end
    if size(stroke_coord,1) > 1
        if nbf >= s2_nbf_onset && nbf <= s2_nbf_offset
            % Draw s2
            Screen('DrawDots', scr.main, stroke_coord(2,:), const.stoke_rad*2, const.white, [], 2);
        end
        if nbf >= s3_nbf_onset && nbf <= s3_nbf_offset
            % Draw s3
            Screen('DrawDots', scr.main, stroke_coord(3,:), const.stoke_rad*2, const.white, [], 2);
        end
    end
    
    % Screen flip
    Screen('Flip',scr.main);
    
    % Create movie
    if const.mkVideo
        expDes.vid_num = expDes.vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,expDes.vid_num));
        writeVideo(const.vid_obj,image_vid);
    end
    
    % Save trials times
    if nbf == fix_nbf_onset
        log_txt = sprintf('fix %i onset at %f',t,GetSecs);
        if const.tracker;Eyelink('message','%s',log_txt);end
    end
    if nbf == fix_nbf_offset
        log_txt = sprintf('fix %i offset at %f',t,GetSecs);
        if const.tracker;Eyelink('message','%s',log_txt);end
    end
    if nbf == s1_nbf_onset
        log_txt = sprintf('s1 %i onset at %f',t,GetSecs);
        if const.tracker;Eyelink('message','%s',log_txt);end
    end
    if nbf == s1_nbf_offset
        log_txt = sprintf('s1 %i offset at %f',t,GetSecs);
        if const.tracker;Eyelink('message','%s',log_txt);end
    end
    if size(stroke_coord,1) > 1
        if nbf == s2_nbf_onset
            log_txt = sprintf('s2 %i onset at %f',t,GetSecs);
            if const.tracker;Eyelink('message','%s',log_txt);end
        end
        if nbf == s2_nbf_offset
            log_txt = sprintf('s2 %i offset at %f',t,GetSecs);
            if const.tracker;Eyelink('message','%s',log_txt);end
        end
        if nbf == s3_nbf_onset
            log_txt = sprintf('s3 %i onset at %f',t,GetSecs);
            if const.tracker;Eyelink('message','%s',log_txt);end
        end
        if nbf == s3_nbf_offset
            log_txt = sprintf('s3 %i offset at %f',t,GetSecs);
            if const.tracker;Eyelink('message','%s',log_txt);end
        end
    end
    
    % Check keyboard
    % --------------
    keyPressed              =   0;
    keyCode                 =   zeros(1,my_key.keyCodeNum);
    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC]            =   KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed              =   keyPressed+keyP;
        keyCode                 =   keyCode+keyC;
    end
    
    if keyPressed
        if keyCode(my_key.escape)
            if const.expStart == 0
                overDone(const,my_key);
                error('Escape button pressed');
            end
        end
    end
end

% Write in log/edf
expDes.expMat(t,10) = GetSecs;
log_txt = sprintf('trial %i ended at %f\n',t,expDes.expMat(t,10));
if const.tracker
    Eyelink('message','%s',log_txt);
end

end