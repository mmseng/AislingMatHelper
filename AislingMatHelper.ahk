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

; See full script documentation at: https://github.com/mmseng/AislingMatHelper

; Script originally by CMDR Suladir.
; Overhauled for ease of use and flexibility by CMDR Roachy1.

; Requires AutoHotkey v1.1.31.00 or later



; ===========================================================
; Edit these variables
; See script documentation on GitHub for details
; ===========================================================

GameVersion = 1 ; 1 = Horizons, 2 = Odyssey
Rating = 5 ; Your current pledge rating
CargoCapacity = 700 ; Should be a multiple of your quota
MaterialType = 2 ; 1 = prep mats, 2 = fort mats

; Hotkeys
BuyOneQuota = F1 ; Purchase a single full quota
BuyAllQuotas = F2 ; Purchase as many quotas as will fit your configured cargo space
Deliver = F3 ; Deliver all materials
Kill = F4 ; Kill script (useful if things go wrong)

; Menu navigation keys
KeyUp = w
KeyDown = s
KeyRight = d
KeySelect = Space



; ===========================================================
; Only edit the variables below if you need to tweak delay timings
; Timings are in ms
; ===========================================================

; Delay after clicking "FAST TRACK NEXT QUOTA FOR X CR." button
DelayFasttrack = 800

; Delay after clicking "CONFIRM" (when buying mats)
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
}

; Increase delay if the script confirms before loading all mats
; Decrease delay if the script waits for a while before confirming after loading all mats
; ~60ms per ton is optimal in my testing
; ~70ms per ton to be safe
DelayLoad := Quota * 60

; Delay when delivering
; Defines how long to hold "right" when delivering mats
; Based on cargo capacity
; ~51ms per ton is optimal in my testing
; ~55ms per ton to be safe
DelayDeliver := CargoCapacity * 51



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
Hotkey, %Kill%, JumpKill

; End script until hotkey is pressed
Return

; --------------------------------------

; When returned to the Power Contact screen, highlight the "FULL SYSTEM STATISTICS" button.
; Necessary because this behavior differs between Horizons and Odyssey.
; In Horizons, after buying prep mats, the "FULL SYSTEM STATISTICS" button is selected.
; In Odyssey, for some reason, it highlights the prep mats "FAST TRACK..." button instead.
; This is only the case for buying prep mats. Buying fort mats still returns to highlighting "FULL SYSTEMS STATISTICS", just like in Horizons.

HighlightFSS:
	if((GameVersion == 2) and (MaterialType == 1)) {
		send {%KeyUp%}
	}
	Return

; --------------------------------------

; Move down to desired material

HighlightMat:
	Loop %MaterialType% {
		send {%KeyDown%}
	}
	Return

; --------------------------------------

; Click "FAST TRACK..." if necessary and buy a full quota

Buy:
	; Fast track next quota if necessary and wait for UI change
	send {%KeySelect%}
	sleep %DelayFasttrack%

	; Collect
	send {%KeyRight% down}
	sleep %DelayLoad%
	send {%KeyRight% up}

	; Click "CONFIRM"
	send {%KeySelect%}
	; Wait for "ACTION RESULTS" page to load
	sleep %DelayConfirm%
	; Click "BACK TO MAIN PAGE"
	send {%KeySelect%}
	
	; Loop delay
	sleep %DelayLoop%

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
}

; --------------------------------------

; Buy one full quota
JumpBuyOneQuota:
	BuyQuota(1)
	Return

; --------------------------------------

; Buy enough quotas to fill configured cargo capacity
JumpBuyAllQuotas:
	BuyQuota(BuyAllLoops)
	Return

; --------------------------------------

; Unload all
; User must highlight the material manually, as the menu order depends on the system state and the user's ship inventory.
; Usually, the desired material to deliver is the first option (fort mats to systems which need fortification when fort mats are in the inventory, or prep mats to systems which need prep when prep mats are in the inventory), but I'm not going to assume that in the script as a misclick can result in buying an unwanted quota.
JumpDeliver:
	; Unload
	send {%KeyRight% down}
	sleep %DelayDeliver%
	send {%KeyRight% up}

	; Confirm
	send {%KeySelect%}

	Return

; --------------------------------------

; Quick exit option in case something goes horribly wrong.
JumpKill:
	; Make sure all virtually-pressed keys are released
	send {%KeyDown% up}
	send {%KeyRight% up}
	send {%KeySelect% up}
	; Exit the script
	ExitApp

; EOF