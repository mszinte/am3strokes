function write_meta(scr,const,el)
% ----------------------------------------------------------------------
% write_meta(scr,const,el)
% ----------------------------------------------------------------------
% Goal of the function :
% Write a json metadata file BIDS compatible
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% const : struct containing constant configurations
% el : eyelink configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 16 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

json_el.TaskName                = const.expName;
json_el.InstitutionName         = "Institut des Neurosciences de la Timone";
json_el.InstitutionAdress       = "12 avenue Jean Moulin, 13008 Marseille, France";
json_el.Manufacturer            = "SR-Research";
json_el.ManufacturersModelName  = "EYELINK II CL v5.12 May 12 2017";
json_el.TaskDescription         = "Saccade to static and 3 strokes apparent motion target";
json_el.Instructions            = "When the fixation dot disappears, move your eyes towards the last dot shown in periphery.";
json_el.SamplingFrequency       = el.samp_rate;
json_el.SampleCoordinateUnit    = "pixel";
json_el.SampleCoordinateSystem  = "gaze-on-screen";
json_el.EnvironmentCoordinates  = 'top-left';
json_el.StartMessage            = "RECORD_START";
json_el.EndMessage              = "RECORD_STOP";
json_el.EndMessage              = "Left";
json_el.ScreenSize              = [scr.disp_sizeX/10, scr.disp_sizeY/10];
json_el.ScreenResolution        = [scr.scr_sizeX, scr.scr_sizeY];
json_el.ScreenDistance          = scr.dist;
json_el.PupilPositionType       = "raw pupil position on screen";

encoded_json = jsonencode(json_el); 
fprintf(const.eyelink_local_meta_fid, prettyjson(encoded_json)); 
fclose(const.eyelink_local_meta_fid);
end