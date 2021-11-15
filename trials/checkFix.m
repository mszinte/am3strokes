function [fix,expDes]=checkFix(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% [fix,expDes]=checkFix(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Check the correct fixation of the participant
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : experimental design configuration
% my_key : structure containing keyboard configurations
% t : trial meter
% ----------------------------------------------------------------------
% Output(s):
% fix : fixation check (1 = yes, 2 = no)
% expDes : experimental design configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

% Eye movement config
% -------------------
fixRad  = const.checkfix_rad;% fixation tolerance radius
timeout = const.timeOut;     % maximum fixation check time
tCorMin = const.tCorMin;     % minimum correct fixation time

rand3 = expDes.expMat(t,7);  % x spatial jitter value
rand4 = expDes.expMat(t,8);  % y spatial jitter value

jitter_coord = [const.motion_jitter(rand3),-const.motion_jitter(rand4)];
fix_coord = const.fix_coord + jitter_coord;

% Eye data coordinates
% --------------------
% Write in log/edf
log_txt = sprintf('trial %i check fixation at %f\n',t,GetSecs);
if const.tracker
    Eyelink('message','%s',log_txt);
end

tstart = GetSecs;
fix = 0;
corStart = 0;
tCor = 0;
t = tstart;

while ((t-tstart)<timeout && tCor<= tCorMin)

    Screen('FillRect',scr.main,const.background_color);
    
    
    [x,y] = getCoord(scr,const);
    if sqrt((x-fix_coord(1))^2+(y-fix_coord(2))^2) < fixRad
        fix = 1;
    else
        fix = 0;
    end
    
    Screen('DrawDots',scr.main,[x,y],const.stoke_rad*2, [100,0,0], [], 2);

    % Draw fixation target
    Screen('DrawDots',scr.main,fix_coord,const.stoke_rad*2, const.white, [], 2);

    Screen('Flip',scr.main);
    if const.mkVideo
        expDes.vid_num          =   expDes.vid_num + 1;
        image_vid               =   Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,expDes.vid_num));
        writeVideo(const.vid_obj,image_vid);
    end

    if fix == 1 && corStart == 0
        tCorStart = GetSecs;
        corStart = 1;
    elseif fix == 1 && corStart == 1
        tCor = GetSecs-tCorStart;
    else
        corStart = 0;
    end
    t = GetSecs;

    % Check keyboard
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

end