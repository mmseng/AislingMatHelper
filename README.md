# Summary
This is an Autohotkey script which helps to automate tedious keystrokes in Elite Dangerous.  

Specifically, this was designed for players pledged to the Aisling Duval power, to automate the keystrokes required to purchase and load preparation and fortification materials, and deliver these materials.  

# Pre-requisites
- Windows
- PC version of Elite Dangerous
- [https://www.autohotkey.com](Autohotkey) v1.1.31.00 or newer installed

# Usage

### Configure and run the script
1. Download `AislingMatHelper.ahk`
2. Open it using a text editor
3. Configure the variables near the top, based on the documentation below
4. Run the script
5. You may want to create multiple copies of the script with different variable values for different purposes

### Use in game
1. Open the Power Contact menu
2. Make sure the top button is selected ("FULL SYSTEM STATISTICS")
3. Make sure your mouse cursor is away from any buttons, as it can interfere
4. Press your configured hotkey

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
Rating 1: 10t  
Rating 2: 15t  
Rating 3: 20t  
Rating 4: 25t  
Rating 5: 50t  

For example if your rating is 5, and you have 704 cargo capacity, set this to 700. Otherwise the script will buy another 50, but you'll only have room for 4 more.  

### MaterialType
Defines which material type to buy.  
`1` = preperation materials (media materials).  
`2` = fortification materials (programme materials).  
Default is `2`.  

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

# Timing Variables
Only configure these if the script is not working as expected.  
All timings are in milliseconds (ms).  

### DelayFasttrack
The delay after clicking the "FAST TRACK NEXT QUOTA" button.  
Needed because the UI pauses briefly after clicking this, before allowing you to load materials.  
This delay (and the button click) happen regardless of whether you actually need to click the button or not, because it doesn't hurt anything.  

### DelayConfirm
The delay after clicking the "CONFIRM" button after loading materials.  
Needed because the UI pauses briefly before showing you the confirmation screen.  

### DelayLoop
The delay after clicking the "CONFIRM" button on the confirmation screen.  
Needed because the UI pauses briefly before bringing you back to the Power Contact screen.  
Only applies to the `BuyAllQuotas` action.  

### DelayLoad
The delay after pressing the "right" key before releasing it, when loading materials. 
The delay depends on the quota size, which depends on your `Rating`.  

### DelayDeliver
The delay after pressing the "right" key before releasing it, when delivering materials.  
The delay depends on your `CargoCapacity`.  
Testing shows that an acceptable value is something around 50ms per ton delivered.  

# Notes
- Script concept originally by CMDR Suladir
- Overhauled for ease of use and flexibility by CMDR Roachy1
- For the Princess!