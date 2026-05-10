; G6700.g: SET 4TH AXIS WORKPIECE ZERO
;
; Captures the current A axis position and stores it in the selected
; work coordinate system as the 4th axis offset.

; Make sure this file is not executed by the secondary motion system
if { !inputs[state.thisInput].active }
    M99

if { #move.axes < 4 }
    abort { "G6700: This machine does not have a 4th axis." }

if { !move.axes[3].homed }
    abort { "G6700: 4th axis must be homed before setting a work offset." }

var workOffset = { (exists(param.W) && param.W != null) ? param.W : move.workplaceNumber }
if { var.workOffset < 0 || var.workOffset >= limits.workplaces }
    abort { "Work Offset (W..) must be between 0 and " ^ limits.workplaces-1 ^ "!" }

var wcsNumber = { var.workOffset + 1 }

M291 P"Jog the 4th axis to the desired workpiece zero orientation, then click Continue." R"MillenniumOS: Set 4th Axis Zero" X1 Y1 Z1 T0 S4 K{"Continue","Cancel"} F0
if { input != 0 }
    abort { "G6700: Operation cancelled." }

M5000 P0
var currentA = { global.mosMI[3] }

if { currentA == null }
    abort { "G6700: Unable to read current 4th axis position." }

G10 L2 P{var.wcsNumber} A{currentA}
echo { "MillenniumOS: Stored 4th axis zero for WCS " ^ var.wcsNumber ^ " as A=" ^ currentA }
