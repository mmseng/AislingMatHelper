# Summary
This is an Autohotkey (AHK) script which helps to automate tedious keystrokes in Elite Dangerous.  

Specifically, this was designed for players pledged to the Aisling Duval power, to automate the keystrokes required to purchase, load, and deliver powerplay materials.  

This is an overhaul of an [original script](https://pastebin.com/9MFvm8ek) by CMDR Oraki/Sulandir. This updated script features complete modularization of all hard-coded aspects into easy-to-use variables, full documentation (below), and fully commented code.  

<p align='center'>
	<img src='aisling.png' /><br />
	o7<br />
	== CMDR Roachy1
</p>
<br />

# Pre-requisites
- Windows
- PC version of Elite Dangerous
- [Autohotkey](https://www.autohotkey.com) v1.1.31.00 or newer installed
<br />

# Usage

### Configure and run the script
1. Download <a href='https://raw.githubusercontent.com/mmseng/AislingMatHelper/main/AislingMatHelper.ahk'>AislingMatHelper.ahk</a> (right click the link and select `Save link as...`).
2. Open it using a text editor.
3. Configure the "important" variables near the top. See the <a href='#important-variables'>Variables</a> documented below.
4. Run the script. While the script is running you should see the Autohotkey icon in your system tray (white "H" on green background).

### Use in game
1. Dock at a station and open the Power Contact menu.
2. If you have a salary to claim, claim it and reopen the Power Contact menu, to remove that menu option.
3. Make sure the top menu button is highlighted (i.e. `FULL SYSTEM STATISTICS`).
4. Make sure your mouse cursor is away from any buttons, as it can interfere.
5. Press your configured hotkey for the desired action.
6. Don't move your mouse or press any keys while the script takes control of your inputs. Once it's done you can continue playing as usual.

### Usage notes
- If the timings aren't quite right for your specific rig, see the <a href='#timing-variables'>Timing Variables</a> section below.
- If you find that your `Deliver` hotkey isn't selecting the right menu option, see <a href='#assumefirstdeliveryoption'>AssumeFirstDeliveryOption</a> below.
- If you get sidetracked like I always do and end up clicking out of game or otherwise interfering with the script's inputs, use the `Kill` hotkey (default `F4`) to exit the script. You'll need to re-launch it.
- You may wish to create multiple copies of the script with different variable values for different purposes. For example, you could have one copy for fortifying at rating 1 with cargo capacity of 300 in Horizons, and one copy for prepping at rating 5 with cargo capacity of 700 in Odyssey.
- For repeated editing of the script I recommend using <a href='https://notepad-plus-plus.org/'>Notepad++</a> and installing the <a href='https://stackoverflow.com/questions/45466733/autohotkey-syntax-highlighting-in-notepad'>AHK language definition</a> for syntax highlighting.
<br />

# Important variables
Make sure to configure these four variables, or the script won't behave as expected.  

### GameVersion
Set this to `1` for use with Horizons.  
Set this to `2` for use with Odyssey.  
Default is `1`.  
Only needed when buying prep mats due to a menu navigation inconsistency in Odyssey.  

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

For example if your rating is 5, and you have 704 cargo capacity, set this to 700. If you set it to 704, the script will buy another 50, but you'll only have room to load 4 more.  

### MaterialType
Defines which material type to buy.  
`1` = preperation materials (media materials).  
`2` = fortification materials (programme materials).  
Default is `2`.  
Theoretically `3` could work for expansion materials (sealed contracts), but this is untested, and depends on various factors. Aisling powerplay generally revolves strictly around hauling fortification materials from Cubeo, so that is the primary purpose of this script.  
<br />

# Hotkey variables
These variables define which hotkeys do what.  
See these docs for the syntax for other keys and key modifiers (such as `Ctrl`):  
- https://www.autohotkey.com/docs/Hotkeys.htm
- https://www.autohotkey.com/docs/KeyList.htm

### BuyOneQuota
Buys one full quota of the configured material.  
Default is `F1`.  

### BuyAllQuotas
Buys as many quotas as you can hold.  
Depends on the value of `CargoCapacity` and the size of your quota based on your `Rating`.  
Default is `F2`.  
e.g. If your `CargoCapacity` is 700, and your `Rating` is 5, then this will buy 700 / 50 = 14 full quotas.  

### Deliver
Delivers as many tons as you can hold.  
Depends on the value of `CargoCapacity`.  
Default is `F3`.  
i.e. This just selects the first delivery option and holds the right arrow for roughly as long as it should take to deliver your whole payload before confirming.  
Also see: <a href='#assumefirstdeliveryoption'>AssumeFirstDeliveryOption</a>.  

### Kill
Kills the script.  
Useful if things go wrong, like if you click outside the game window while the script is working, or the timings are off and the autoclicks are out of sync with the menu state.  
Default is `F4`.  
<br />

# Menu Navigation Variables
These are the keystrokes used by the script to navigate through menu options.  
If you use custom keybinds for this in Elite Dangerous, edit these accordingly.  
Note: it's recommended to use lowercase letters to avoid conflicts with Shift keys.  

### KeyUp
The keystroke used to navigate up in menus.  
Default is `w`.  
Only needed when buying prep mats due to a menu navigation inconsistency in Odyssey.  

### KeyDown
The keystroke used to navigate down in menus.  
Default is `s`.  

### KeyRight
The keystroke used to navigate right in menus.  
Default is `d`.  

### KeySelect
The keystroke used to select/click options/buttons.  
Default is `Space`.  

### AssumeFirstDeliveryOption
This variable determines, after pressing the `Deliver` hotkey, whether the script immediately begins unloading, or whether it navigates down one menu option first and then unloads.  

`0` = unload immediately.
  - Player is required to highlight the delivery option before hitting the Deliver hotkey. Adds a manual keystroke in exchange for guarantee that the wrong menu option is not selected.

`1` = navigate down first, then unload.
  - Player hits Deliver hotkey while "FULL SYSTEM STATISTICS" button is highlighted, and the script navigates down one before delivering. Saves a manual keystroke, but if the menu state is not as expected, this could result in accidentally purchasing ("fast-tracking") a quota of an undesired material, wasting credits.

Default is `1`.  
This is because the menu order depends on other factors, such as the state of the system, and the materials present in the ship's inventory.  
In _most_ usual circumstances (i.e. delivering fort mats to systems which need fortification when fort mats are in the inventory, or delivering prep mats to systems which need prep when prep mats are in the inventory), the desired material to deliver is the first option.  
Change to `0` if you're finding this is not the case.  
<br />

# Timing Variables
Only configure these if the script is not working as expected.  
All timings are in milliseconds (ms).  
Note: Sometimes, when the game servers (or your internet connection) are being slow, the "STAND BY" animation between screens may take longer than usual, and will throw off the script timings. There's not much you can do to predict this, but you can try to accommodate for it by extending the relevant timings, noted below.  

### DelayFasttrack
The delay after clicking the `FAST TRACK NEXT QUOTA FOR X CR.` button.  
Default is `800`.  
Needed because the UI pauses briefly after clicking this, before allowing you to load materials.  
This delay (and the button click) happen regardless of whether you actually need to click the button or not, because it doesn't hurt anything.  

### DelayConfirm
The delay after clicking the `CONFIRM` button after loading materials.  
Default is `1000`.  
Needed because the UI pauses briefly before continuing to the `ACTION RESULTS` page.  

### DelayLoop
The delay after clicking the `BACK TO MAIN PAGE` button on the `ACTION RESULTS` page.  
Default is `200`.  
Needed because the UI pauses briefly before returning to the Power Contact screen.  
Only applies to the `BuyAllQuotas` action.  

### DelayLoad
The delay after pressing the right arrow key before releasing it, when loading materials.  
The delay depends on the quota size, which depends on your `Rating`.  
Testing shows that an acceptable value is something around 60-70ms per ton loaded.  
Default is `60`.  

### DelayDeliver
The delay after pressing the "right" key before releasing it, when delivering materials.  
The delay depends on your `CargoCapacity`.  
Testing shows that an acceptable value is something around 50-60ms per ton delivered.  
Default is `51`.  
<br />

# Changelog

### Beta: v1.2 (2021-12-12)
- Tweaks to support purchase and delivery of expansion materials.

### Latest: v1.1 (2021-12-05)
- Added code to correct for an inconsistency in the menu navigation in Odyssey.
  - When returning to the Power Contact screen from buying/loading prep mats, Odyssey highlights the "FAST TRACK..." button for prep mats again, rather than the "FULL SYSTEM STATISTICS" button, as with every other such interaction. This is only the case for buying prep mats in Odyssey. Horizons, and buying fort mats in either version, is unaffected.
  - To facilitate this, a new important variable was added (`GameVersion`).
- Tested timings and updated so that the default timings work in both Horizons and Odyssey (based on my testing with a decent computer).
- Simplified and de-duplicated some logic by making use of functions and subroutines.
- Added AssumeFirstDeliveryOption variable and documentation. See <a href='#assumefirstdeliveryoption'>AssumeFirstDeliveryOption</a> for details.

### v1.0 (pre-2021-12-05)
- Changes were not tracked before v1.1.
<br />

# Notes
- If you discover an issue, have suggestions or questions, please feel free to open an <a href='https://github.com/mmseng/AislingMatHelper/issues'>Issue</a>.
- [Original script](https://pastebin.com/9MFvm8ek) by CMDR Oraki/Sulandir
- Overhauled for ease of use and flexibility by CMDR Roachy1
- Ignore `AislingMatHelper-beta.ahk`. I use this to test changes before making them live in `AislingMatHelper.ahk`.
- For the Princess!
