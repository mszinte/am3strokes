function drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw on the eyelink display the experiment configuration
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% t : trial number
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 11 / 2020
% Project :     AM3strokes
% ----------------------------------------------------------------------
% o--------------------------------------------------------------------o
% | EL Color index                                                     |
% o----o----------------------------o----------------------------------o
% | Nb |  Other(cross,box,line)     | Clear screen                     |
% o----o----------------------------o----------------------------------o
% |  0 | black                      | black                            |
% o----o----------------------------o----------------------------------o
% |  1 | dark blue                  | dark dark blue                   |
% o----o----------------------------o----------------------------------o
% |  2 | dark green                 | dark blue                        |
% o----o----------------------------o----------------------------------o
% |  3 | dark turquoise             | blue                             |
% o----o----------------------------o----------------------------------o
% |  4 | dark red                   | light blue                       |
% o----o----------------------------o----------------------------------o
% |  5 | dark purple                | light light blue                 |
% o----o----------------------------o----------------------------------o
% |  6 | dark yellow (brown)        | turquoise                        |
% o----o----------------------------o----------------------------------o
% |  7 | light gray                 | light turquoise                  | 
% o----o----------------------------o----------------------------------o
% |  8 | dark gray                  | flashy blue                      |
% o----o----------------------------o----------------------------------o
% |  9 | light purple               | green                            |
% o----o----------------------------o----------------------------------o
% | 10 | light green                | dark dark green                  |
% o----o----------------------------o----------------------------------o
% | 11 | light turquoise            | dark green                       |
% o----o----------------------------o----------------------------------o
% | 12 | light red (orange)         | green                            |
% o----o----------------------------o----------------------------------o
% | 13 | pink                       | light green                      |
% o----o----------------------------o----------------------------------o
% | 14 | light yellow               | light green                      |
% o----o----------------------------o----------------------------------o
% | 15 | white                      | flashy green                     |
% o----o----------------------------o----------------------------------o

% Color config
frameCol                =   15;
ftCol                   =   14;
bgCol                   =   0;

% Clear screen
eyeLinkClearScreen(bgCol);

var1 = expDes.expMat(t,3);
var2 = expDes.expMat(t,4);
rand3 = expDes.expMat(t,7);
rand4 = expDes.expMat(t,8);
jitter_coord = [const.motion_jitter(rand3),-const.motion_jitter(rand4)];
fix_coord = const.fix_coord + jitter_coord;
switch var1
    case 1;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 2;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 3;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 4;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 5;stroke_coord =   const.mot_coord{var2,var1} + jitter_coord;
    case 6;stroke_coord =   const.mot_coord{var2,3} + jitter_coord;
    case 7;stroke_coord =   const.mot_coord{var2,3} + jitter_coord;
end

eyeLinkDrawBox(fix_coord(1),fix_coord(2),const.fix_rad*2,const.fix_rad*2,2,frameCol,ftCol);
eyeLinkDrawBox(fix_coord(1),fix_coord(2),const.stoke_rad*2,const.stoke_rad*2,2,frameCol,ftCol);
eyeLinkDrawBox(stroke_coord(1),stroke_coord(2),const.fix_rad*2,const.fix_rad*2,2,frameCol,ftCol);
eyeLinkDrawBox(stroke_coord(1),stroke_coord(2),const.stoke_rad*2,const.stoke_rad*2,2,frameCol,ftCol);

WaitSecs(0.1);

end