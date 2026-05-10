; G6702.g: RESET 4TH AXIS WORKPIECE ZERO
;
; Resets the A-axis offset for the selected work coordinate system to zero.

; Make sure this file is not executed by the secondary motion system
if { !inputs[state.thisInput].active }
    M99

if { #move.axes < 4 }
    abort { "G6702: This machine does not have a 4th axis." }

var workOffset = { (exists(param.W) && param.W != null) ? param.W : move.workplaceNumber }
if { var.workOffset < 0 || var.workOffset >= limits.workplaces }
    abort { "Work Offset (W..) must be between 0 and " ^ limits.workplaces-1 ^ "!" }

var wcsNumber = { var.workOffset + 1 }

M291 P"This will reset the A-axis offset for the selected work coordinate system to zero. Continue?" R"MillenniumOS: Reset 4th Axis Zero" T0 S4 K{"Yes","No"} F0
if { input != 0 }
    abort { "G6702: Operation cancelled." }

G10 L2 P{var.wcsNumber} A0
echo { "MillenniumOS: Reset 4th axis zero for WCS " ^ var.wcsNumber }
