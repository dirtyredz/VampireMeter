scriptname DR_WidgetBase extends SKI_WidgetBase

; region ------------------ Private variables ------------------
bool _shown = false
int _frame = 1
int _widgetAlpha = 100
int _scale = 100
string _controlMode = "periodically"
string _period = "every1hour"
int _hotkey = -1
float _displayTime = 10.0
bool _displayed = false
bool _menuOpen = false
; endRegion

; region ------------------ Properties -------------------------

GlobalVariable property Timescale auto
{This is the global timescale of the game}

bool property Shown
	{Set to true to show the widget}
	bool function get()
		return _shown
	endFunction

	function set(bool isShown)
		_shown = isShown
		updateShown()
	endFunction
endProperty

int property WidgetAlpha
	{Set the alpha value of the widget (in percent 0 ... 100)}
	int function get()
		return _widgetAlpha
	endFunction

	function set(int theAlpha)
		_widgetAlpha = theAlpha
		updateShown()
	endFunction
endProperty

int property Scale
	{Set the scale of the widget (in percent 0 ... 100)}
	int function get()
		return _scale
	endFunction

	function set(int theScale)
		_scale = theScale
		if(Ready)
			updateScale()
		endIf
	endFunction
endProperty

string property ControlMode
	{The mode the widget is displayed. Possible values are "always", "timedHotkey", "toggledHotkey" and "periodically".}
	string function get()
		return _controlMode
	endFunction

	function set(string mode)
		_controlMode = mode
		updateConfig()
	endFunction
endProperty

string property Period
	{The period the widget is displayed.}
	string function get()
		return _period
	endFunction

	function set(string mode)
		_period = mode
		updateConfig()
	endFunction
endProperty

int property Hotkey
	{The hotkey used to display the widget.}
	int function get()
		return _hotkey
	endFunction

	function set(int myHotkey)
		_hotkey = myHotkey
		updateConfig()
	endFunction
endProperty

float property DisplayTime
	{The time the widget is displayed if control mode is set to "timedHotkey".}
	float function get()
		return _displayTime
	endFunction

	function set(float time)
		_displayTime = time
	endFunction
endProperty

; endRegion

; region ------------------ Events -----------------------------

; @override SKI_WidgetBase
event OnWidgetReset()
	; Update the scale *before* calling OnWidgetReset prevents the widget to
	; be displayed at a wrong position if scale != 100%.
	updateScale()

	parent.OnWidgetReset()

	; Update event registrations
	UnregisterForAllMenus()

	RegisterForMenu("BarterMenu")
	RegisterForMenu("Book Menu")
	RegisterForMenu("Console")
	RegisterForMenu("Console Native UI Menu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Crafting Menu")
	RegisterForMenu("Credits Menu")
	RegisterForMenu("Cursor Menu")
	RegisterForMenu("Debug Text Menu")
	RegisterForMenu("Dialogue Menu")
	RegisterForMenu("Fader Menu")
	RegisterForMenu("FavoritesMenu")
	RegisterForMenu("GiftMenu")
	RegisterForMenu("HUD Menu")
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("Kinect Menu")
	RegisterForMenu("LevelUp Menu")
	RegisterForMenu("Loading Menu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("MagicMenu")
	RegisterForMenu("Main Menu")
	RegisterForMenu("MapMenu")
	RegisterForMenu("MessageBoxMenu")
	RegisterForMenu("Mist Menu")
	RegisterForMenu("Overlay Interaction Menu")
	RegisterForMenu("Overlay Menu")
	RegisterForMenu("Quantity Menu")
	RegisterForMenu("RaceSex Menu")
	RegisterForMenu("Sleep/Wait Menu")
	RegisterForMenu("StatsMenu")
	RegisterForMenu("TitleSequence Menu")
	RegisterForMenu("Top Menu")
	RegisterForMenu("Training Menu")
	RegisterForMenu("Tutorial Menu")
	RegisterForMenu("TweenMenu ")

	; Register all needed events
	updateConfig()
	RegisterForModEvent("Periodically", "OnPeriodically")
endEvent

; @override SKI_WidgetBase
event OnWidgetLoad()
	; Don't call the parent event since it will display the widget regardless of the "Shown" property.
	;parent.OnWidgetLoad()

	OnWidgetReset()

	; Determine if the widget should be displayed
	updateShown()
endEvent

event OnMenuOpen(String menuName)
	_menuOpen = true

	if(Ready)
		;UI.Invoke(HUD_MENU, WidgetRoot + ".PauseUpdate") 
	endIf
endEvent

event OnMenuClose(String menuName)
	_menuOpen = false
endEvent

event OnKeyUp(int keyCode, float holdTime)
	if(!_menuOpen && _shown)
		if(_controlMode == "timedHotkey" || _controlMode == "periodically")
			showTimed()
		else
			if(_displayed)
				hideWidget()
				_displayed = false
			else
				showWidget()
				_displayed = true
			endIf
		endIf
	endIf
endEvent

; This even occurs ever 15 in-game minutes and decides if the widget should
; be shown because of the periodic control mode.
event OnPeriodically(string eventName, string strArg, float numArg, Form sender)
	if(_controlMode == "periodically")
		bool showIt = false
		int hour = Math.Floor(numArg / 60) as int
		int minute = (numArg as int) % 60 as int

		if(_period == "every15min" && minute % 15 == 0)
			showIt = true
		elseIf(_period == "every30min" && minute % 30 == 0)
			showIt = true
		elseIf(minute == 0)
			if(_period == "every1hour")
				showIt = true
			elseIf(_period == "every2hours" && hour % 2 == 0)
				showIt = true
			elseIf(_period == "every3hours" && hour % 3 == 0)
				showIt = true
			elseIf(_period == "every6hours" && hour % 6 == 0)
				showIt = true
			elseIf(_period == "every12hours" && hour % 12 == 0)
				showIt = true
			endIf
		endIf

		if(showIt)
			showTimed()
		endIf
	endIf
endEvent

;endRegion

; region ------------------ Functions --------------------------

; Shows the widget for _displayTime seconds.
function showTimed()
	showWidget()
	Utility.Wait(_displayTime)
	; The control mode might have changed, so check again.
	if(_controlMode == "timedHotkey" || _controlMode == "periodically")
		hideWidget()
	endIf
endFunction

; Shows the widget if the control mode is set to always, registers
; the hotkey otherwise.
function updateConfig()
	; Cleanup
	UnregisterForAllKeys()

	if(_controlMode == "always" && _shown)
		showWidget()
	else
		hideWidget()
		_displayed = false
		RegisterForKey(_hotkey)
		if(_controlMode != "periodically")
			_period = "none"
		endIf
	endIf
endFunction

; Shows the widget if it should be shown, hides it otherwise.
function updateShown()
	if(_shown && (_controlMode == "always" || (_controlMode == "toggledHotkey" && _displayed)))
		showWidget()
	else
		hideWidget()
	endIf
endFunction

; Shows the widget.
function showWidget()
	if(Ready)
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", true)
		UpdateWidgetModes()
		FadeTo(_widgetAlpha, 0.2)
	endIf
endFunction

; Hides the widget.
function hideWidget()
	if(Ready)
		FadeTo(0, 0.2)
	endIf
endFunction

; Populates the scale to the widget.
function updateScale()
	UI.SetInt(HUD_MENU, WidgetRoot + ".Scale", _scale)
endFunction

;endRegion
