; ===========================================================
; Script execution behavior
; You can ignore this first section
; ===========================================================
; Recommended for performance and compatibility with future AutoHotkey releases
#NoEnv
; Force one instance of script
#SingleInstance Force
; Ensures a consistent starting directory
SetWorkingDir %A_ScriptDir%
; Delay between each command. Increase if operations are skipped
SetKeyDelay, 50, 50



; ===========================================================
; Information
; ===========================================================

; Script version: 1.5 (Date TBD)
; See full script documentation at: https://github.com/mmseng/AislingMatHelper

; Script originally by CMDR Suladir.
; Overhauled for ease of use and flexibility by CMDR Roachy1.

; Requires AutoHotkey v1.1.31.00 or later



; ===========================================================
; Edit these variables
; See script documentation on GitHub for details
; ===========================================================

; Important variables
GameVersion = 1 ; 1 = Horizons, 2 = Odyssey
Rating = 5 ; Your current pledge rating
CargoCapacity = 700 ; Should be a multiple of your quota
MaterialType = 2 ; 1 = prep mats, 2 = fort mats, 3 = expansion mats

; Hotkey variables
; See these docs for the syntax for other keys and key modifiers (such as Ctrl):
; - https://www.autohotkey.com/docs/Hotkeys.htm
; - https://www.autohotkey.com/docs/KeyList.htm
BuyOneQuota = F1 ; Purchase a single full quota
BuyAllQuotas = F2 ; Purchase as many quotas as will fit your configured cargo space
Deliver = F3 ; Deliver all materials
ReloadKey = F4 ; Kill and reload script (useful if things go wrong)
Kill = +F4 ; Kill script entirely (useful for when you're done playing)

; Menu navigation variables
KeyUp = w
KeyDown = s
KeyRight = d
KeySelect = Space

; Audible feedback variables
EnableBeeps = True ; True = enable beeps to provide audible feedback when you press a hotkey, False = disable beeps
HighBeep = 2000 ; Frequency
MidBeep = 1500 ; Frequency
LowBeep = 1000 ; Frequency
BeepLength = 100 ; Milliseconds

; This variable determines whether, when pressing the `Deliver` hotkey, the script immediately begins unloading, or whether it navigates down one menu option first and then unloads.
; 0 = unload immediately. Player is required to highlight the delivery option before hitting the Deliver hotkey. Adds a manual keystroke in exchange for guarantee that the wrong menu option is not selected.
; 1 = navigate down first, then unload. Player hits Deliver hotkey while "FULL SYSTEM STATISTICS" button is highlighted, and the script navigates down one before delivering. Saves a manual keystroke, but if the menu state is not as expected, this could result in accidentally purchasing ("fast-tracking") a quota of an undesired material, wasting credits.
; This is because the menu order depends on other factors, such as the state of the system, and the materials present in the ship's inventory.
; In _most_ usual circumstances (i.e. delivering fort mats to systems which need fortification when fort mats are in the inventory, or delivering prep mats to systems which need prep when prep mats are in the inventory), the desired material to deliver is the first option.
; Change to `0` if you're finding this is not the case.
AssumeFirstDeliveryOption = 1



; ===========================================================
; Only edit the variables below if you need to tweak delay timings
; Timings are in ms
; ===========================================================

; Delay after clicking "FAST TRACK NEXT QUOTA FOR X CR." button
DelayFasttrack = 800

; Delay after loading all items and before clicking "CONFIRM"
DelayLoadUnload = 200

; Delay after clicking "CONFIRM"
DelayConfirm = 1000

; Delay after clicking "BACK TO MAIN PAGE" on the "ACTION RESULTS" page
DelayLoop = 200

; Delay when loading
; Defines how long to hold "right" when loading mats
; Based on your quota size (in tons)
; This switch statement is what requires v1.1.31.00 or later, as it didn't exist before that. If for some bizarre reason you need to use an older version, you could replace this with several if statements.
switch Rating {
	case 1: Quota = 10
	case 2: Quota = 15
	case 3: Quota = 20
	case 4: Quota = 25
	case 5: Quota = 50
	Default:
		MsgBox Rating variable not set correctly!
		Goto JumpKill
}

; Increase delay if the script confirms before loading all mats
; Decrease delay if the script waits for a while before confirming after loading all mats
; ~60ms per ton is optimal in my testing
; ~70ms per ton to be safe
DelayLoadItems := Quota * 60

; Delay when unloading
; Defines how long to hold "right" when unloading mats
; Based on cargo capacity
; ~51ms per ton is optimal in my testing
; ~55ms per ton to be safe
DelayUnloadItems := CargoCapacity * 51



; ===========================================================
; No need to edit below
; ===========================================================

; Calculate number of loops needed to fill cargo, rounded up
; e.g. 700t / Rating 5 quota (50t) = 14 loops
; e.g. 701t / Rating 5 quota (50t) = 15 loops
BuyAllLoops := Ceil(CargoCapacity / Quota)

; Map hotkeys to labels
Hotkey, %BuyOneQuota%, JumpBuyOneQuota
Hotkey, %BuyAllQuotas%, JumpBuyAllQuotas
Hotkey, %Deliver%, JumpDeliver
Hotkey, %ReloadKey%, JumpReload
Hotkey, %Kill%, JumpKill

; Beep to signal that initial processing is done and the script is awaiting hotkeys to be pressed
SoundBeep, %HighBeep%, %BeepLength%

; End script until hotkey is pressed
Return



; ===========================================================
; Subroutines and functions
; ===========================================================

; When returned to the Power Contact screen, highlight the "FULL SYSTEM STATISTICS" button.
; Necessary because this behavior differs between Horizons and Odyssey.
; In Horizons, after buying prep mats, the "FULL SYSTEM STATISTICS" button is selected.
; In Odyssey, for some reason, it highlights the prep mats "FAST TRACK..." button instead.
; This is only the case for buying prep mats. Buying fort mats still returns to highlighting "FULL SYSTEMS STATISTICS", just like in Horizons.
; This is the case as of 2021-12-05, but it's possible this inconsistency may be fixed at some point, and this logic will need to be removed.

HighlightFSS:
	if((GameVersion == 2) and (MaterialType == 1)) {
		Send {%KeyUp%}
	}
	Return

; --------------------------------------

; Move down to desired material

HighlightMat:
	GoDownX = 0
	switch MaterialType {
		case 1: GoDownX = 1
		case 2: GoDownX = 2
		case 3: GoDownX = 1
		Default:
			MsgBox MaterialType variable is not set correctly!
			Goto JumpKill
	}

	Loop %GoDownX% {
		Send {%KeyDown%}
	}
	Return

; --------------------------------------

; Click "FAST TRACK..." if necessary and buy a full quota

Buy:
	; Fast track next quota if necessary and wait for UI change
	Send {%KeySelect%}
	Sleep %DelayFasttrack%

	; Collect
	Send {%KeyRight% down}
	Sleep %DelayLoadItems%
	Send {%KeyRight% up}

	; Click "CONFIRM"
	Send {%KeySelect%}
	; Wait for "ACTION RESULTS" page to load
	Sleep %DelayConfirm%
	; Click "BACK TO MAIN PAGE"
	Send {%KeySelect%}
	
	; Loop delay
	Sleep %DelayLoop%

	Return

; --------------------------------------

; Once on the desired material, buy X quotas
BuyQuota(x) {
	Loop %x% {
		; Move down to desired material
		Gosub HighlightMat
		
		; Buy a full quota
		Gosub Buy
		
		; Move up to "FULL SYSTEM STATISTICS" button again
		Gosub HighlightFSS
	}
	
	; Delay before clicking "CONFIRM", because clicking it too quickly sometimes causes the "Power Contact not available" error.
	Sleep %DelayLoadUnload%
}

; --------------------------------------

; Beep logic
Beep(Action) {
	global EnableBeeps
	
	if(EnableBeeps) {
		global LowBeep
		global MidBeep
		global HighBeep
		global BeepLength
		
		switch Action {
			case "BuyOne":
				SoundBeep, %LowBeep%, %BeepLength%
				SoundBeep, %MidBeep%, %BeepLength%
			case "BuyAll":
				SoundBeep, %LowBeep%, %BeepLength%
				SoundBeep, %MidBeep%, %BeepLength%
				SoundBeep, %MidBeep%, %BeepLength%
			case "Deliver":
				SoundBeep, %MidBeep%, %BeepLength%
				SoundBeep, %LowBeep%, %BeepLength%
			case "Complete":
				SoundBeep, %HighBeep%, %BeepLength%
			case "Reload":
				SoundBeep, %LowBeep%, %BeepLength%
				SoundBeep, %MidBeep%, %BeepLength%
				SoundBeep, %LowBeep%, %BeepLength%
			case "Kill":
				SoundBeep, %LowBeep%, %BeepLength%
				SoundBeep, %LowBeep%, %BeepLength%
				SoundBeep, %LowBeep%, %BeepLength%
			Default:
				MsgBox Invalid Action sent to Beep function!
				ExitApp
		}
	}
}

; --------------------------------------

; Release any keys that might be virtually depressed, in preparation for reloading or killing
Release:
	Send {%KeyUp% up}
	Send {%KeyDown% up}
	Send {%KeyRight% up}
	Send {%KeySelect% up}
	Return

; ===========================================================
; Hotkey labels
; ===========================================================

; Buy one full quota
JumpBuyOneQuota:
	Beep("BuyOne")
	BuyQuota(1)
	Beep("Complete")
	Return

; --------------------------------------

; Buy enough quotas to fill configured cargo capacity
JumpBuyAllQuotas:
	Beep("BuyAll")
	BuyQuota(BuyAllLoops)
	Beep("Complete")
	Return

; --------------------------------------

; Unload all
JumpDeliver:
	Beep("Deliver")

	; Navigate down to the first delivery option, or don't, depending on AssumeFirstDeliveryOption.
	if(AssumeFirstDeliveryOption == 1) {
		Send {%KeyDown%}
	}
	
	; For some reason expansion mats just provide a single button to deliver all mats
	; Why tf isn't this the case for other materials?
	if(MaterialType != 3) {
		; Unload
		Send {%KeyRight% down}
		Sleep %DelayUnloadItems%
		Send {%KeyRight% up}
	}
	
	; Delay before clicking "CONFIRM", because clicking it too quickly sometimes causes the "Power Contact not available" error.
	Sleep %DelayLoadUnload%
	
	; Confirm
	Send {%KeySelect%}

	Beep("Complete")
	Return

; --------------------------------------

; Quick exit option in case something goes horribly wrong
JumpReload:
	Beep("Reload")

	; Make sure all virtually-pressed keys are released
	GoSub Release
	
	; Reload the script instead, so we don't have to manually relaunch it
	; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=97746&p=434107#p434107
	Reload
	
	; To prevent anything below this from running before the script is finished being killed and reloaded
	Return

; --------------------------------------

; Quick exit option in case something goes horribly wrong
JumpKill:
	Beep("Kill")

	; Make sure all virtually-pressed keys are released
	GoSub Release
	
	; Exit the script
	ExitApp

; ===========================================================
; EOF
; ===========================================================