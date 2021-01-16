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

; This script is intended to be used with Elite Dangerous, to help those pledged to Aisling Duval buy and deliver fortification and preparation materials.
; Define variables below per your preferences and use the configured hotkeys to purchase/unload full quotas of fortification or preparation materials.
; You must enter the Power Contact screen and highlight the "FULL SYSTEM STATISTICS" option at the top, then press the desired hotkey.
; Make sure your mouse is away from any selectable options, or it may interfere.
; Script originally by CMDR Suladir.
; Rewritten by easier and more flexible use by CMDR Roachy1.

;Requires AutoHotkey v1.1.31.00 or later


; ===========================================================
; Edit these variables
; ===========================================================

; Define your pledge rating:
; This dictates how many tons you can buy at once, which dictates how long the script needs to hold "right" to buy a full quota.

Rating = 4

; --------------------------------------

; Define how much cargo capacity you have,
; or rather how much capacity you want to fill:
; This dictates how many full quotas the script will buy.
; It's recommended to make this a multiple of your rating's quota amount, or you may spend more than you need to.
; Quota amounts are as follows:
; Rating 1: 10t
; Rating 2: 15t
; Rating 3: 20t
; Rating 4: 25t
; Rating 5: 50t

CargoCapacity = 700

; --------------------------------------

; Choose fortification materials or preparation materials:
; Use 1 for prep mats, or 2 for fort mats.
MaterialType = 2

; --------------------------------------

; Define your hotkeys:
; Change "F1", etc. to your desired key
; See these docs for the syntax for other keys and modifiers (like Ctrl):
; https://www.autohotkey.com/docs/Hotkeys.htm
; https://www.autohotkey.com/docs/KeyList.htm

; Purchase a single full quota
BuyOne = F1

; Purchase as many quotas as will fit your configured cargo space
BuyAll = F2

; Deliver all materials
Deliver = F3

; Kill script (useful if things go wrong)
Kill = F4


; ===========================================================
; No need to edit below
; Unless you know what you're doing and need to tweak timings
; ===========================================================

; Map hotkeys to labels
Hotkey, %BuyOne%, JumpBuyOne
Hotkey, %BuyAll%, JumpBuyAll
Hotkey, %Deliver%, JumpDeliver
Hotkey, %Kill%, JumpKill

; Delays

; Delay after clicking fast track
DelayFasttrack = 500

; Delay after clicking confirm the first time
DelayConfirm = 700

; Delay after clicking confirm the second time
DelayLoop = 200


; Delay when loading
; Defines how long to hold "right" when loading mats
switch Rating {
	case 1:
		Quota = 10
		DelayLoad = 700
	case 2:
		Quota = 15
		DelayLoad = 1000
	case 3:
		Quota = 20
		DelayLoad = 1200
	case 4:
		Quota = 25
		DelayLoad = 1500
	case 5:
		Quota = 50
		DelayLoad = 3000
}

; Delay when delivering
; Defines how long to hold "right" when delivering mats
; Based on cargo capacity
; ~50ms per ton
DelayDeliver = CargoCapacity * 50

; End script until hotkey is pressed
Return

; --------------------------------------

; Buy one full quota
JumpBuyOne:

	; Move down to desired material
	Loop, %MaterialType% {
		send, {S}
	}

	; Fast track next quota if necessary and wait for UI change
	send, {Space}
	sleep, %DelayFasttrack%

	; Collect
	send, {D down}
	sleep, %DelayLoad%
	send, {D up}

	; Confirm amount
	send, {Space}
	; Wait for screen change
	sleep, %DelayConfirm%
	; Confirm confirmation screen
	send, {Space}

	Return

; --------------------------------------

; Buy enough quotas to fill configured cargo capacity
JumpBuyAll:

	; Calculate number of loops needed to fill cargo, rounded up
	; e.g. 700t / Rating 5 quota (50t) = 14 loops
	; e.g. 701t / Rating 5 quota (50t) = 15 loops
	Loops := Ceil(CargoCapacity / Quota)
	
	; Loop
	Loop, %Loops% {
		; Move down to desired material
		Loop, %MaterialType% {
			send, {S}
		}

		; Fast track next quota if necessary and wait for UI change
		send, {Space}
		sleep, %DelayFasttrack%

		; Collect
		send, {D down}
		sleep, %DelayLoad%
		send, {D up}

		; Confirm amount
		send, {Space}
		; Wait for screen change
		sleep, %DelayConfirm%
		; Confirm confirmation screen
		send, {Space}
		
		; Loop delay
		sleep, %DelayLoop%
	}
	
	Return

; --------------------------------------

; Unload all
JumpDeliver:

	; Move down 
	send, {S}

	; Unload
	send, {D down}
	sleep, %DelayDeliver%
	send, {D up}

	; Confirm
	send, {Space}

	Return
	
*/

; --------------------------------------

; Quick exit option if something goes horribly wrong.
JumpKill:
	
	; In case the script was killed while a key was virtually depressed
	send, {S up}
	send, {D up}
	send, {Space up}
	
	ExitApp

; EOF