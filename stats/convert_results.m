function convert_results(subject,num_run,plot_res)
% ----------------------------------------------------------------------
% convert_results(subject,num_run)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert resutls in .mat format
% ----------------------------------------------------------------------
% Input(s) :
% subject : subject name
% num_run : number of runs to analyse
% ----------------------------------------------------------------------
% Output(s):
% .mat results
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 30 / 07 / 2020
% Project :     natImSac
% Version :     1.0
% ----------------------------------------------------------------------

%% Get data
% load reference to image
ref;

% define files names
file_dir = sprintf('%s/data/%s',cd,subject);
task1_txt = 'FreeView';

list_filename = {   sprintf('%s_task-%s_run-01',subject,task1_txt),sprintf('%s_task-%s_run-02',subject,task1_txt),...
                    sprintf('%s_task-%s_run-03',subject,task1_txt),sprintf('%s_task-%s_run-04',subject,task1_txt),...
                    sprintf('%s_task-%s_run-05',subject,task1_txt),sprintf('%s_task-%s_run-06',subject,task1_txt),...
                    sprintf('%s_task-%s_run-07',subject,task1_txt),sprintf('%s_task-%s_run-08',subject,task1_txt),...
                    sprintf('%s_task-%s_run-09',subject,task1_txt),sprintf('%s_task-%s_run-10',subject,task1_txt),...
                    sprintf('%s_task-%s_run-11',subject,task1_txt),sprintf('%s_task-%s_run-12',subject,task1_txt),...
                    sprintf('%s_task-%s_run-13',subject,task1_txt),sprintf('%s_task-%s_run-14',subject,task1_txt),...
                    sprintf('%s_task-%s_run-15',subject,task1_txt),sprintf('%s_task-%s_run-16',subject,task1_txt),...
                    sprintf('%s_task-%s_run-17',subject,task1_txt),sprintf('%s_task-%s_run-18',subject,task1_txt),...
                    sprintf('%s_task-%s_run-19',subject,task1_txt),sprintf('%s_task-%s_run-20',subject,task1_txt)};


% software for edf conversion
if ismac
    edf2asc_dir = '/Applications/Eyelink/EDF_Access_API/Example';
    end_file = '';
elseif ispc 
    edf2asc_dir = 'C:\Experiments\natImSac\stats\';
    end_file ='.exe';
end


t_trial = 0;
for t_run = 1:num_run
    
    % get data
    tsv_filename = sprintf('%s/func/%s_events.tsv',file_dir,list_filename{t_run});
    val = tdfread(tsv_filename);
    image_blank_size = val.image_blank_size;
    image_blank_num = val.image_blank_num;
        
	mat_filename = sprintf('%s/add/%s_matFile.mat',file_dir,list_filename{t_run});
    load(mat_filename);
    edf_filename = sprintf('%s/func/%s_eyeData',file_dir,list_filename{t_run});
    
    % get .msg and .dat file
    if ~exist(sprintf('%s_left.dat',edf_filename),'file') || ~exist(sprintf('%s_left.msg',edf_filename),'file')
        [~,~] = system(sprintf('%s/edf2asc%s %s.edf -e -y',edf2asc_dir,end_file,edf_filename));
        movefile(sprintf('%s.asc',edf_filename),sprintf('%s_left.msg',edf_filename));
        [~,~] = system(sprintf('%s/edf2asc%s %s.edf -s -l -miss -1.0 -y',edf2asc_dir,end_file,edf_filename));
        movefile(sprintf('%s.asc',edf_filename),sprintf('%s_left.dat',edf_filename));
    end
    if ~exist(sprintf('%s_right.dat',edf_filename),'file') || ~exist(sprintf('%s_right.msg',edf_filename),'file')
        [~,~] = system(sprintf('%s/edf2asc%s %s.edf -e -r -y',edf2asc_dir,end_file,edf_filename));
        movefile(sprintf('%s.asc',edf_filename),sprintf('%s_right.msg',edf_filename));
        [~,~] = system(sprintf('%s/edf2asc%s %s.edf -s -r -miss -1.0 -y',edf2asc_dir,end_file,edf_filename));
        movefile(sprintf('%s.asc',edf_filename),sprintf('%s_right.dat',edf_filename));
    end
    
    % get stim time stamps
    stim_onset = [];
    stim_offset = [];
    msgfid = fopen(sprintf('%s_left.msg',edf_filename),'r');
    record_stop = 0;
    while ~record_stop
        line_read = fgetl(msgfid);
        if ~isempty(line_read)                           % skip empty lines
            la = textscan(line_read,'%s');
            % get first time
            if size(la{1},1) > 5
                if strcmp(la{1}(3),'stim') && strcmp(la{1}(5),'onset')
                    stim_onset = [stim_onset;str2double(la{1}(2))];
                end
                if strcmp(la{1}(3),'stim') && strcmp(la{1}(5),'offset')
                    stim_offset = [stim_offset;str2double(la{1}(2))];
                end
                if strcmp(la{1}(3),'trial') && strcmp(la{1}(5),'stopped') && strcmp(la{1}(4),num2str(config.const.trial_per_block))
                    record_stop = 1;
                end
            end
        end
    end
    fclose(msgfid);
    
    
    % load eye coord data
    datafid_left  = fopen(sprintf('%s_left.dat',edf_filename),'r');
    eye_dat_left = textscan(datafid_left,'%f%f%f%f%s');
    eye_data_left = [eye_dat_left{1},eye_dat_left{2},eye_dat_left{3},eye_dat_left{4}];
    
    datafid_right = fopen(sprintf('%s_right.dat',edf_filename),'r');
	eye_dat_right = textscan(datafid_right,'%f%f%f%f%s');
    eye_data_right = [eye_dat_right{1},eye_dat_right{2},eye_dat_right{3},eye_dat_right{4}];
    
    for tBlock = 1:config.const.trial_per_block
        
        t_trial  = t_trial + 1;
        
        % get image name
        image_blank_size_val = image_blank_size(tBlock);
        image_blank_num_val = image_blank_num(tBlock);
        if image_blank_size_val == 1
            if image_blank_num_val > 80
                res(t_trial).trialname = 'blank_large';
            else
                res(t_trial).trialname = ref_img(image_blank_num_val).large;
                im_ref = sprintf('im%i_large',image_blank_num_val);
                matX = [-20,20];
                matY = [-15,15];
            end
        elseif image_blank_size_val == 2
            if image_blank_num_val > 80
                res(t_trial).trialname = 'blank_small';
            else
                res(t_trial).trialname = ref_img(image_blank_num_val).small;
                im_ref = sprintf('im%i_small',image_blank_num_val);
                matX = [-10,10];
                matY = [-7.5,7.5];
            end
        end
        
        % get corresponding data
        datapix_left  = transpose(eye_data_left(eye_data_left(:,1) >= stim_onset(tBlock) & eye_data_left(:,1) <= stim_offset(tBlock),:));
        datapix_right = transpose(eye_data_right(eye_data_right(:,1) >= stim_onset(tBlock) & eye_data_right(:,1) <= stim_offset(tBlock),:));
        
        % convert datapix to data in degrees from screen center
        screen_size = [config.scr.scr_sizeX,config.scr.scr_sizeY];
        ppd = config.const.ppd;

        res(t_trial).data_left = datapix_left;
        res(t_trial).data_right = datapix_right;
        res(t_trial).data_left(2,:) = (res(t_trial).data_left(2,:) - (screen_size(1)/2))/ppd;
        res(t_trial).data_left(3,:) = (-1*(res(t_trial).data_left(3,:) - screen_size(2)/2))/ppd;
        res(t_trial).data_right(2,:) = (res(t_trial).data_right(2,:) - (screen_size(1)/2))/ppd;
        res(t_trial).data_right(3,:) = (-1*(res(t_trial).data_right(3,:) - screen_size(2)/2))/ppd;

        % blink time for left eye
        blink_start = 0;
        blinkNum = 0;
        blink_onset_offset = [];
        for tTime = 1:size(datapix_left,2)
            if ~blink_start
                if datapix_left(2,tTime)==-1
                    blinkNum = blinkNum + 1;
                    timeBlinkOnset = datapix_left(1,tTime);
                    blink_start = 1;
                    blink_onset_offset(blinkNum,:) = [timeBlinkOnset,NaN];
                end
            end
            if blink_start
                if datapix_left(2,tTime)~=-1
                    timeBlinkOfffset = datapix_left(1,tTime);
                    blink_start = 0;
                    blink_onset_offset(blinkNum,2) = timeBlinkOfffset;
                end
            end
        end
        res(t_trial).blink_left = blink_onset_offset;
        
        % blink time for right eye
        blink_start = 0;
        blinkNum = 0;
        blink_onset_offset = [];
        for tTime = 1:size(datapix_right,2)
            if ~blink_start
                if datapix_right(2,tTime)==-1
                    blinkNum = blinkNum + 1;
                    timeBlinkOnset = datapix_right(1,tTime);
                    blink_start = 1;
                    blink_onset_offset(blinkNum,:) = [timeBlinkOnset,NaN];
                end
            end
            if blink_start
                if datapix_right(2,tTime)~=-1
                    timeBlinkOfffset = datapix_right(1,tTime);
                    blink_start = 0;
                    blink_onset_offset(blinkNum,2) = timeBlinkOfffset;
                end
            end
        end
        
        res(t_trial).blink_right = blink_onset_offset;
        
        % plot data
        if plot_res == 1
            if image_blank_num_val <= 80
                im = imread(sprintf('stim/im/%s.jpg',im_ref));
                image(im,'XData', matX, 'YData', matY); hold on;
                plot(res(t_trial).data_left(2,:),-res(t_trial).data_left(3,:),'w');
                pause(2);
                hold off;
            end
        end
        
    end

    fclose(datafid_left);
    fclose(datafid_right);
    delete(sprintf('%s_left.msg',edf_filename))
    delete(sprintf('%s_left.dat',edf_filename))
    delete(sprintf('%s_right.dat',edf_filename))
    delete(sprintf('%s_right.msg',edf_filename))

end
file_dir = sprintf('%s/data/%s',cd,subject);

save(sprintf('%s/%s_resmat.mat',file_dir,subject),'res')



end