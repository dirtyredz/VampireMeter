scriptname DR_WidgetBase extends SKI_WidgetBase

bool _visible = false
int _frame = 1
int _widgetAlpha = 100
int _scale = 100
string _controlMode = "always"
string _period = "every1hour"
int _hotkey = -1
float _displayTime = 10.0
bool _displayed = false
bool _menuOpen = false

GlobalVariable property Timescale auto
{This is the global timescale of the game}

bool property Visible
	{Set to true to show the widget}
	bool function get()
		return _visible
	endFunction

	function set(bool visibility)
		_visible = visibility
		updateVisibility()
	endFunction
endProperty

int property WidgetAlpha
	{Set the alpha value of the widget (in percent 0 ... 100)}
	int function get()
		return _widgetAlpha
	endFunction

	function set(int theAlpha)
		_widgetAlpha = theAlpha
		updateVisibility()
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
		updateControl()
	endFunction
endProperty

string property Period
	{The period the widget is displayed.}
	string function get()
		return _period
	endFunction

	function set(string mode)
		_period = mode
		updateControl()
	endFunction
endProperty

int property Hotkey
	{The hotkey used to display the widget.}
	int function get()
		return _hotkey
	endFunction

	function set(int myHotkey)
		_hotkey = myHotkey
		updateControl()
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


; @override SKI_WidgetBase
event OnWidgetReset()
  debug.trace(self + " - OnWidgetReset ran.")
	; Update the scale *before* calling OnWidgetReset prevents the widget to
	; be displayed at a wrong position if scale != 100%.
	updateScale()

	parent.OnWidgetReset()

	; Update event registrations
	UnregisterForAllMenus()
  UnregisterForUpdateGameTime() ; Unregister this event because it could be registered by an old save
	UnregisterForUpdate()

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
	updateControl()
endEvent

event OnUpdateGameTime()
  setPeriodicUpdate()
  showTimed()
endEvent

; @override SKI_WidgetBase
event OnWidgetLoad()
	; Don't call the parent event since it will display the widget regardless of the "Shown" property.
	;parent.OnWidgetLoad()

	OnWidgetReset()

	; Determine if the widget should be displayed
	updateVisibility()
endEvent

event OnMenuOpen(String menuName)
	_menuOpen = true
endEvent

event OnMenuClose(String menuName)
	_menuOpen = false
endEvent

event OnKeyUp(int keyCode, float holdTime)
  if keyCode == _hotkey
    if(!_menuOpen && _visible)
      if(_controlMode == "timedHotkey" || _controlMode == "periodically")
        showTimed()
      else
        if(_controlMode == "toggledHotkey")
          _displayed = !_displayed
          updateVisibility()
        endIf
      endIf
    endIf
  endIf
endEvent


; Shows the widget for _displayTime seconds.
function showTimed(float displayTimeOverride = 0.0)
  ; debug.trace(self + " - showTimed, " + _displayTime + ", " + _controlMode)
  float time = _displayTime
  if displayTimeOverride > 0.0
    time = displayTimeOverride
  endIf
	showWidget()
	Utility.Wait(time)
  _displayed = false
	; The control mode might have changed, so check again.
	if(_controlMode == "timedHotkey" || _controlMode == "periodically")
		hideWidget()
  elseIf(_controlMode == "toggledHotkey")
    updateVisibility()
	endIf
endFunction

; Shows the widget if the control mode is set to always, registers
; the hotkey otherwise.
function updateControl()
  ; debug.trace(self + " - updateControl, " + _visible + ", " + _controlMode)
	; Cleanup
	UnregisterForAllKeys()
  UnregisterForUpdateGameTime()

  updateVisibility()
  RegisterForKey(_hotkey)
  if(_controlMode == "periodically")
    setPeriodicUpdate()
  endIf
endFunction

function setPeriodicUpdate()
  UnregisterForUpdateGameTime()

  if(_period == "every15min")
    RegisterForSingleUpdateGameTime(0.25)
  elseIf(_period == "every30min")
    RegisterForSingleUpdateGameTime(0.50)
  elseif(_period == "every1hour")
    RegisterForSingleUpdateGameTime(1)
  elseIf(_period == "every2hours")
    RegisterForSingleUpdateGameTime(2)
  elseIf(_period == "every3hours")
    RegisterForSingleUpdateGameTime(3)
  elseIf(_period == "every6hours")
    RegisterForSingleUpdateGameTime(6)
  elseIf(_period == "every12hours")
    RegisterForSingleUpdateGameTime(12)
  endIf
endFunction

; Shows the widget if it should be shown, hides it otherwise.
function updateVisibility()
  ; debug.trace(self + " - updateVisibility, " + _visible + ", " + _controlMode + ", " + _displayed)
	if(_visible && (_controlMode == "always" || (_controlMode == "toggledHotkey" && _displayed)))
		showWidget()
	else
		hideWidget()
	endIf
endFunction

; Shows the widget.
function showWidget()
  ; debug.trace(self + " - showWidget, " + _widgetAlpha)
	if(Ready)
    _displayed = true
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", true)
		UpdateWidgetModes()
		FadeTo(_widgetAlpha, 0.2)
	endIf
endFunction

; Hides the widget.
function hideWidget()
  ; debug.trace(self + " - hideWidget")
	if(Ready)
    _displayed = false
		FadeTo(0, 0.2)
	endIf
endFunction

; Populates the scale to the widget.
function updateScale()
  ; debug.trace(self + " - updateScale, " + _scale)
	UI.SetInt(HUD_MENU, WidgetRoot + ".Scale", _scale)
endFunction
