function [const] = runExp(scr,const,expDes,el,my_key)
% ----------------------------------------------------------------------
% [const] = runExp(scr,const,expDes,el,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch experiement instructions and connection with eyelink
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

% Configuration of videos
% -----------------------
if const.mkVideo
    expDes.vid_num          =   0;
    const.vid_obj           =   VideoWriter(const.movie_file,'MPEG-4');
    const.vid_obj.FrameRate =   60;
	const.vid_obj.Quality   =   100;
    open(const.vid_obj);
end

% Save all config at start of the block
% -------------------------------------
config.scr              =   scr;
config.const            =   const;
config.expDes           =   expDes;
config.my_key           =   my_key;
save(const.mat_file,'config');

% First mouse config
% ------------------
if const.expStart
    HideCursor;
    for keyb = 1:size(my_key.keyboard_idx,2)
        KbQueueFlush(my_key.keyboard_idx(keyb));
    end
end

% Initial calibrations
% --------------------
if const.tracker
    fprintf(1,'\tEye tracking instructions - press space or right button-\n');
    eyeLinkClearScreen(el.bgCol);
    eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'CALIBRATION INSTRUCTION - PRESS SPACE');
    instructionsIm(scr,const,my_key,sprintf('Calibration'),0);
    calibresult =   EyelinkDoTrackerSetup(el);
    if calibresult == el.TERMINATE_KEY
        return
    end
end

% Keyboad configuration
% ---------------------
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end

% Start Eyelink
% -------------
record = 0;
while ~record
    if const.tracker
        if ~record
            Eyelink('startrecording');
            key = 1;
            while key ~=  0
                key = EyelinkGetKey(el);
            end
            error = Eyelink('checkrecording');
            if error == 0
                record = 1;
                Eyelink('message', 'RECORD_START');
            else
                record = 0;
                Eyelink('message', 'RECORD_FAILURE');
            end
        end
    else
        record = 1;
    end
end

% Task instructions 
if const.tracker
    eyeLinkClearScreen(el.bgCol);
    eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'TASK INSTRUCTIONS - PRESS SPACE')
end
instructionsIm(scr,const,my_key,sprintf('%s',const.cond1_txt),0);
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end

% Main trial loop
% ---------------
expDone = 0;
endJ = size(expDes.expMat,1);
if const.mkVideo;endJ = 1;end

while ~expDone
    for t = 1:endJ
        trialDone = 0;
        while ~trialDone
            
            if const.tracker
                Eyelink('command', 'record_status_message ''TRIAL %d / %d''', t,endJ);
                Eyelink('message', 'TRIALID %d', t);
            end

            fix = 0;
            while fix ~= 1
                
                % Check fixation
                if fix ~= 1
                    if const.tracker
                        drawTrialInfoEL(scr,const,expDes,t);
                    end
                    [fix,expDes] = checkFix(scr,const,expDes,my_key,t);
                end
                
                % Calib problems
                if fix ~= 1
                    if const.tracker
                        eyeLinkClearScreen(el.bgCol);
                        eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'CALIBRATION INSTRUCTION - PRESS SPACE');
                        instructionsIm(scr,const,my_key,sprintf('Calibration'),0);
                        EyelinkDoTrackerSetup(el);
                    end
                end
            end
            
            % Run Trial
            if fix 
                [expDes] = runTrials(scr,const,expDes,my_key,t);
                trialDone = 1;
            end
        end
    end
end

% Compute/Write mean/std behavioral data
% --------------------------------------
behav_txt_head{1}       =   'onset';                        behav_mat_res{1}        =   expDes.expMat(:,9);
behav_txt_head{2}       =   'duration';                     behav_mat_res{2}        = 	expDes.expMat(:,10) - expDes.blockMat(:,9);
behav_txt_head{3}       =   'run_number';                   behav_mat_res{3}        = 	expDes.expMat(:,1);
behav_txt_head{4}       =   'trial_number';                 behav_mat_res{4}        = 	expDes.expMat(:,2);
behav_txt_head{5}       =   'trial_sequence';               behav_mat_res{5}        = 	expDes.expMat(:,3);
behav_txt_head{6}       =   'saccade_direction';            behav_mat_res{6}        = 	expDes.expMat(:,4);
behav_txt_head{7}       =   'fixation_duration';            behav_mat_res{7}        = 	expDes.expMat(:,5);
behav_txt_head{8}       =   'post_stim_duration';           behav_mat_res{8}        = 	expDes.expMat(:,6);
behav_txt_head{9}       =   'spatial_jitter_x';             behav_mat_res{9}        = 	expDes.expMat(:,7);
behav_txt_head{10}      =   'spatial_jitter_y';             behav_mat_res{10}       = 	expDes.expMat(:,8);

head_line               =   [];
for trial = 1:size(expDes.expMat,1)
    % header line
    if trial == 1
        for tab = 1:size(behav_txt_head,2)
            if tab == size(behav_txt_head,2)
                head_line               =   [head_line,sprintf('%s',behav_txt_head{tab})];
            else  
                head_line               =   [head_line,sprintf('%s\t',behav_txt_head{tab})];
            end
        end
        fprintf(const.behav_file_fid,'%s\n',head_line);
    end
    
	% trials line
    trial_line              =   [];
    for tab = 1:size(behav_mat_res,2)
        if tab == size(behav_mat_res,2)
            if isnan(behav_mat_res{tab}(trial))
                trial_line              =   [trial_line,sprintf('n/a')];
            else
                trial_line              =   [trial_line,sprintf('%1.10g',behav_mat_res{tab}(trial))];
            end
        else
            if isnan(behav_mat_res{tab}(trial))
                trial_line              =   [trial_line,sprintf('n/a\t')];
            else
                trial_line              =   [trial_line,sprintf('%1.10g\t',behav_mat_res{tab}(trial))];
            end
        end
    end
    fprintf(const.behav_file_fid,'%s\n',trial_line);
end

% End messages
% ------------
if const.runNum == const.numRun
    instructionsIm(scr,const,my_key,'End',1);
else
    instructionsIm(scr,const,my_key,'End_block',1);
end

% Save all config at the end of the block (overwrite start made at start)
% ---------------------------------------
config.scr = scr; config.const = const; config.expDes = expDes; config.my_key = my_key;
save(const.mat_file,'config');

% Stop Eyelink
% ------------
if const.tracker
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
    WaitSecs(1);
    Eyelink('stoprecording');
    Eyelink('message', 'RECORD_STOP');
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'THE END - PRESS SPACE OR WAIT');
end

end