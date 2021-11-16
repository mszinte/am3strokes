function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files name and fid.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 03 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

% Create directories
if ~isfolder(sprintf('data/%s/func/',const.sjct))
    mkdir(sprintf('data/%s/func/',const.sjct))
end
if ~isfolder(sprintf('data/%s/eyetrack/',const.sjct))
    mkdir(sprintf('data/%s/eyetrack/',const.sjct))
end
if ~isfolder(sprintf('data/%s/add/',const.sjct))
    mkdir(sprintf('data/%s/add/',const.sjct))
end

% Define directories
const.dat_output_file       =   sprintf('data/%s/func/%s_task-%s_%s',const.sjct,const.sjct,const.cond1_txt,const.run_txt);
const.eyetrack_output_file  =   sprintf('data/%s/eyetrack/%s_task-%s_%s',const.sjct,const.sjct,const.cond1_txt,const.run_txt);
const.add_output_file       =   sprintf('data/%s/add/%s_task-%s_%s',const.sjct,const.sjct,const.cond1_txt,const.run_txt);

% Eye data
const.eyelink_temp_file         =   'XX.edf';
const.eyelink_local_file        =   sprintf('%s_eyetrack.edf',const.eyetrack_output_file);
const.eyelink_local_meta        =   sprintf('%s_eyetrack.json',const.eyetrack_output_file);
const.eyelink_local_meta_fid    =   fopen(const.eyelink_local_meta, 'w');

% Behavioral data
const.behav_file        =   sprintf('%s_events.tsv',const.dat_output_file);
if const.expStart
    if exist(const.behav_file,'file')
        aswErase = upper(strtrim(input(sprintf('\n\tThis file allready exist, do you want to erase it ? (Y or N): '),'s')));
        if upper(aswErase) == 'N'
            error('Please restart the program with correct input.')
        elseif upper(aswErase) == 'Y'
        else
            error('Incorrect input => Please restart the program with correct input.')
        end
    end
end
const.behav_file_fid    =   fopen(const.behav_file,'w');

% Define .mat saving file
const.mat_file  =   sprintf('%s_matFile.mat',const.add_output_file);

% experimental matrix file
const.expMat_file    =   sprintf('data/%s/add/%s_expMat.mat',const.sjct,const.sjct);

% Movie file
if const.mkVideo
    if ~isfolder(sprintf('others/%s_vid/',const.cond1_txt))
        mkdir(sprintf('others/%s_vid/',const.cond1_txt))
    end
    const.movie_image_file  =   sprintf('others/%s_vid/%s_vid',const.cond1_txt,const.cond1_txt);
    const.movie_file        =   sprintf('others/%s_vid.mp4',const.cond1_txt);
end

end