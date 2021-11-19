function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

%% Experimental random variables

% Var 1: Sequence (7 modalities)
% =====
expDes.oneV             =   [1;2;3;4;5;6;7];
expDes.nb_var1          =   7;
expDes.txt_var1         =   {'s1_pos1','s1_pos2','s1_pos3','s1_pos4','s1_pos5','s3_up','s3_down'};
% 01 = s1_pos1 (static position 1)
% 01 = s1_pos2 (static position 2)
% 03 = s1_pos3 (static position 3)
% 04 = s1_pos4 (static position 4)
% 05 = s1_pos5 (static position 5)
% 06 = s3_up (apparent motion up)
% 06 = s3_down (apparent motion down)

% Var 2: Saccade direction (2 modalities)
% =====
expDes.twoV             =   [1;2];
expDes.nb_var2          =   2;
expDes.txt_var2         =   {'left','right'};
% 01 = left saccades
% 02 = right saccades

% Rand 1: Intial fixation duration (11 modalities)
% ======
expDes.oneR             =   [1:const.ini_fix_steps]';
expDes.nb_rand1         =   const.ini_fix_steps;
expDes.txt_rand1        =   {'200 ms','220 ms','240 ms','260 ms','280 ms','300 ms','320 ms','340 ms','360 ms','380 ms','400 ms'};

% Rand 2: Post-stimulus duration (6 modalities)
% ======
expDes.twoR             =   [1:const.post_stroke_steps]';
expDes.nb_rand2         =   const.post_stroke_steps;
expDes.txt_rand2        =   {'100 ms','120 ms','140 ms','160 ms','180 ms','200 ms'};

% Rand 3: Spatial jitter X (11 modalities)
% ======
expDes.threeR           =   [1:const.motion_jitter_steps]';
expDes.nb_rand3         =   const.motion_jitter_steps;
expDes.txt_rand3        =   {'-2.5 dva','-2 dva','-1.5 dva','-1.0 dva','-0.5 dva','0','0.5 dva','1 dva','1.5 dva','2.0 dva','2.5 dva'};

% Rand 4: Spatial jitter Y (11 modalities)
% ======
expDes.fourR            =   [1:const.motion_jitter_steps]';
expDes.nb_rand4         =   const.motion_jitter_steps;
expDes.txt_rand4        =   {'-2.5 dva','-2 dva','-1.5 dva','-1.0 dva','-0.5 dva','0','0.5 dva','1 dva','1.5 dva','2.0 dva','2.5 dva'};

%% Experimental configuration :
expDes.nb_var           =   2;
expDes.nb_trials        =   round((expDes.nb_var1 * expDes.nb_var2 * const.nb_trials)/const.numRun);
expDes.nb_repeat        =   const.nb_trials/const.numRun;

%% Experimental loop
rng('default');rng('shuffle');

trialMat = zeros(expDes.nb_trials,expDes.nb_var);
ii = 0;
for rep = 1:expDes.nb_repeat
    for var1 = 1:expDes.nb_var1
        for var2 = 1:expDes.nb_var2
            ii = ii + 1;
            trialMat(ii, 1) = var1;
            trialMat(ii, 2) = var2;
        end
    end
end

trialMat = trialMat(randperm(expDes.nb_trials)',:);

for t_trial = 1:expDes.nb_trials

    rand_var1   = expDes.oneV(trialMat(t_trial,1),:);
    rand_var2   = expDes.twoV(trialMat(t_trial,2),:);

    randVal1    = randperm(numel(expDes.oneR));     rand_rand1  =   expDes.oneR(randVal1(1));
    randVal2    = randperm(numel(expDes.twoR));     rand_rand2  =   expDes.twoR(randVal2(1));
    randVal3    = randperm(numel(expDes.threeR));   rand_rand3  =   expDes.threeR(randVal3(1));
    randVal4    = randperm(numel(expDes.fourR));    rand_rand4  =   expDes.fourR(randVal4(1));

    % Processing experimental matrix
    expDes.expMat(t_trial,:)= [const.runNum, t_trial, rand_var1, rand_var2, rand_rand1, rand_rand2, rand_rand3, rand_rand4];
end

end