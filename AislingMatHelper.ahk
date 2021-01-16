; Recommended for performance and compatibility with future AutoHotkey releases
#NoEnv

; Ensures a consistent starting directory
SetWorkingDir %A_ScriptDir%

; Delay between each command. Increase if operations are skipped
SetKeyDelay, 50, 50

; Force one instance of script
#SingleInstance Force



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

Rating = 4 ; Your current pledge rating
CargoCapacity = 700 ; Should be a multiple of your quota
MaterialType = 2 ; 1 = prep mats, 2 = fort mats

; Hotkeys
BuyOneQuota = F1 ; Purchase a single full quota
BuyAllQuotas = F2 ; Purchase as many quotas as will fit your configured cargo space
Deliver = F3 ; Deliver all materials
Kill = F4 ; Kill script (useful if things go wrong)

; Menu navigation keys
KeyDown = S
KeyRight = D
KeySelect = Space



; ===========================================================
; Only edit the variables below if you need to tweak delay timings
; Timings are in ms
; ===========================================================

; Delay after clicking "Fast track next quota" button
DelayFasttrack = 500

; Delay after clicking confirm (when buying mats)
DelayConfirm = 700

; Delay after clicking confirm on the confirmation screen
DelayLoop = 200

; Delay when loading
; Defines how long to hold "right" when loading mats
; Also defines how big your rating's quota is (in tons)
switch Rating {
	case 1:
		DelayLoad = 700
		Quota = 10
	case 2:
		DelayLoad = 1000
		Quota = 15
	case 3:
		DelayLoad = 1200
		Quota = 20
	case 4:
		DelayLoad = 1500
		Quota = 25
	case 5:
		DelayLoad = 3000
		Quota = 50
}

; Delay when delivering
; Defines how long to hold "right" when delivering mats
; Based on cargo capacity
; ~50ms per ton
DelayDeliver := CargoCapacity * 50



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

; Buy one full quota
JumpBuyOneQuota:

	; Move down to desired material
	Loop, %MaterialType% {
		send, {%KeyDown%}
	}

	; Fast track next quota if necessary and wait for UI change
	send, {%KeySelect%}
	sleep, %DelayFasttrack%

	; Collect
	send, {%KeyRight% down}
	sleep, %DelayLoad%
	send, {%KeyRight% up}

	; Confirm amount
	send, {%KeySelect%}
	; Wait for screen change
	sleep, %DelayConfirm%
	; Confirm confirmation screen
	send, {%KeySelect%}

	Return

; --------------------------------------

; Buy enough quotas to fill configured cargo capacity
JumpBuyAllQuotas:
	
	; Loop
	Loop, %BuyAllLoops% {
		; Move down to desired material
		Loop, %MaterialType% {
			send, {%KeyDown%}
		}

		; Fast track next quota if necessary and wait for UI change
		send, {%KeySelect%}
		sleep, %DelayFasttrack%

		; Collect
		send, {%KeyRight% down}
		sleep, %DelayLoad%
		send, {%KeyRight% up}

		; Confirm amount
		send, {%KeySelect%}
		; Wait for screen change
		sleep, %DelayConfirm%
		; Confirm confirmation screen
		send, {%KeySelect%}
		
		; Loop delay
		sleep, %DelayLoop%
	}
	
	Return

; --------------------------------------

; Unload all
JumpDeliver:

	; Move down 
	send, {%KeyDown%}

	; Unload
	send, {%KeyRight% down}
	sleep, %DelayDeliver%
	send, {%KeyRight% up}

	; Confirm
	send, {%KeySelect%}

	Return
	
*/

; --------------------------------------

; Quick exit option if something goes horribly wrong.
JumpKill:
	
	; In case the script was killed while a key was virtually depressed
	send, {%KeyDown% up}
	send, {%KeyRight% up}
	send, {%KeySelect% up}
	
	ExitApp

; EOF