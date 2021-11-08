function [my_key]=keyConfig
% ----------------------------------------------------------------------
% [my_key]=keyConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and define structure containing each key names
% ----------------------------------------------------------------------
% Input(s) :
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');

my_key.escapeVal        =   'escape';               % escape button
my_key.spaceVal         =   'space';                % space button
my_key.escape           =   KbName(my_key.escapeVal);
my_key.space            =   KbName(my_key.spaceVal);

my_key.keyboard_idx     =   GetKeyboardIndices;
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueCreate(my_key.keyboard_idx(keyb));
    KbQueueFlush(my_key.keyboard_idx(keyb));
    KbQueueStart(my_key.keyboard_idx(keyb));
end

[~,keyCodeMat]   = KbQueueCheck(my_key.keyboard_idx(1));
my_key.keyCodeNum  = numel(keyCodeMat);

end