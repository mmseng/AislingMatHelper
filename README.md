# Summary
This is an Autohotkey script which helps to automate tedious keystrokes in Elite Dangerous.  

Specifically, this was designed for players pledged to the Aisling Duval power, to automate the keystrokes required to purchase and load preparation and fortification materials, and deliver these materials.  

This is an overhaul of an [original script](https://pastebin.com/9MFvm8ek) by CMDR Oraki/Sulandir. This updated script features complete modularization of all hard-coded aspects into easy-to-use variables, full documentation (below), and fully commented code.  

<p align='center'>
	<img src='aisling.png' /><br />
	o7<br />
	== CMDR Roachy1
</p>



# Pre-requisites
- Windows
- PC version of Elite Dangerous
- [Autohotkey](https://www.autohotkey.com) v1.1.31.00 or newer installed

# Usage

### Configure and run the script
1. Download `AislingMatHelper.ahk`
2. Open it using a text editor
3. Configure the variables near the top, based on the documentation below
4. Run the script
5. You may wish to create multiple copies of the script with different variable values for different purposes

### Use in game
1. Dock at a station and open the Power Contact menu
2. Make sure the top button is selected ("FULL SYSTEM STATISTICS")
3. Make sure your mouse cursor is away from any buttons, as it can interfere
4. Press your configured hotkey for the desired action
5. Don't touch anything while the script takes control of your inputs

# Important variables
Make sure to configure these three variables, or the script won't behave as expected.  

### Rating
Set this to your current pledge rating.  
Should be `1`, `2`, `3`, `4`, or `5`.  
Default is `5`.  
Dictates the size of your quotas (how many tons you're allowed to buy at once), which dictates how long the script needs to hold "right" to buy a full quota.

### CargoCapacity
Set this to the number of tons you want to buy and deliver.  
Default is `700`.  
This dictates how many full quotas the script will buy.  
It's highly recommended to make this a multiple of your rating's quota amount, or you may spend more credits than you need to.  

Quota amounts are as follows:  
- Rating 1: 10t  
- Rating 2: 15t  
- Rating 3: 20t  
- Rating 4: 25t  
- Rating 5: 50t  

For example if your rating is 5, and you have 704 cargo capacity, set this to 700. Otherwise the script will buy another 50, but you'll only have room to load 4 more.  

### MaterialType
Defines which material type to buy.  
`1` = preperation materials (media materials).  
`2` = fortification materials (programme materials).  
Default is `2`.  
Theoretically `3` could work for expansion materials (sealed contracts), but this is untested.  

# Hotkey variables
These variables define which hotkeys do what.  
See these docs for the syntax for other keys and modifiers (like Ctrl):  
- https://www.autohotkey.com/docs/Hotkeys.htm
- https://www.autohotkey.com/docs/KeyList.htm

### BuyOneQuota
Buys one full quota of the configured material.  
Default is `F1`.  

### BuyAllQuotas
Buys as many quotas as you can hold.  
Depends on the value of `CargoCapacity` and the size of your quota based on your `Rating`.  
Default is `F2`.  
e.g. If your `CargoCapacity` is 700, and your `Rating` is 5, then this will buy 700/50 = 14 full quotas.  

### Deliver
Delivers as many tons as you can hold.  
Depends on the value of `CargoCapacity`.  
Default is `F3`.  

### Kill
Kills the script.  
Useful if things go wrong, like if you click outside the game window while the script is working, or the timings are off and the autoclicks are out of sync with the menu state.  
Default is `F4`.  

# Menu Navigation Variables
These are the keystrokes used by the script to navigate through menu options.  
If you use custom keybinds for this in Elite Dangerous, edit these accordingly.  
Note: it's recommended to use lowercase letters to avoid conflicts with Shift keys.  

### KeyDown
The keystroke used to navigate down in menus.  
Default is `s`.  

### KeyRight
The keystroke used to navigate right in menus.  
Default is `d`.  

### KeySelect
The keystroke used to select/click options/buttons.  
Default is `Space`.  

# Timing Variables
Only configure these if the script is not working as expected.  
All timings are in milliseconds (ms).  

### DelayFasttrack
The delay after clicking the "FAST TRACK NEXT QUOTA FOR X CR." button.  
Default is `500`.  
Needed because the UI pauses briefly after clicking this, before allowing you to load materials.  
This delay (and the button click) happen regardless of whether you actually need to click the button or not, because it doesn't hurt anything.  

### DelayConfirm
The delay after clicking the "CONFIRM" button after loading materials.  
Default is `700`.  
Needed because the UI pauses briefly before continuing to the "ACTION RESULTS" page.  

### DelayLoop
The delay after clicking the "BACK TO MAIN PAGE" button on the "ACTION RESULTS" page.  
Default is `200`.  
Needed because the UI pauses briefly before returning to the Power Contact screen.  
Only applies to the `BuyAllQuotas` action.  

### DelayLoad
The delay after pressing the "right" key before releasing it, when loading materials.  
The delay depends on the quota size, which depends on your `Rating`.  
Testing shows that an acceptable value is something around 60ms per ton loaded, conservatively.  

### DelayDeliver
The delay after pressing the "right" key before releasing it, when delivering materials.  
The delay depends on your `CargoCapacity`.  
Testing shows that an acceptable value is something around 60ms per ton delivered, conservatively.  

# Notes
- [Original script](https://pastebin.com/9MFvm8ek) by CMDR Oraki/Sulandir
- Overhauled for ease of use and flexibility by CMDR Roachy1
- For the Princess!
