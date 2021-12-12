#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 50, 50

; Define navigation keys
KeyUp = w
KeyDown = s
KeyRight = d
KeySelect = Space

; Define hotkeys
Action1 = F1
Kill = F4

; Define delay
Delay = 1000

; Define hotkey labels
Hotkey, %Action1%, JumpAction1
Hotkey, %Kill%, JumpKill

; End script until hotkey is pressed
Return

; Perform Action1
JumpAction1:
	send {%KeyDown%}
	send {%KeySelect%}
	send {%KeyUp%}
	send {%KeyRight% down}
	sleep %Delay%
	send {%KeyRight% up}
	send {%KeySelect%}
	Return

; Kill script
JumpKill:
	; Make sure all virtually-pressed keys are released
	send {%KeyUp% up}
	send {%KeyDown% up}
	send {%KeyRight% up}
	send {%KeySelect% up}
	
	; Exit the script
	ExitApp

; EOF