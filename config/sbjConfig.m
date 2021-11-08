function [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define subject configurations (initials, gender...)
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

if const.expStart
    const.sjctNum           =  input(sprintf('\n\tParticipant number: '));
    if isempty(const.sjctNum)
        error('Incorrect participant number');
    end
    if const.sjctNum > 9
        const.sjct              =  sprintf('sub-%i',const.sjctNum);
    else
        const.sjct              =  sprintf('sub-0%i',const.sjctNum);
    end
end

const.runNum            =   input(sprintf('\n\tRun number (1 to %i): ',const.numRun));
if isempty(const.runNum)
    error('Incorrect run number');
end
if const.runNum > const.numRun
    error('Only %i runs to play',const.numRun);
end

if const.runNum > 9
    const.run_txt   =  sprintf('run-%i',const.runNum);
else
    const.run_txt   =  sprintf('run-0%i',const.runNum);
end

const.cond1_txt = 'AM3strokes';
fprintf(1,'\n\tTask: %s\n',const.cond1_txt);

const.recEye        =   1;
if ~const.expStart
    const.sjct          =   'sub-0X';
    const.recEye        =   1;
end

end