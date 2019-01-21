
Scriptname DR_VampireMeter_MCMQuest extends SKI_ConfigBase

DR_VampireMeter_WidgetQuest Property Widget auto

string[]	_periodic
string[]	_periodicValues
int _periodicDefault = 2
int _periodicSelectedIndex = 2
string[]	_controlModes
string[]	_controlModeValues
int _controlModeDefault = 0
int _controlModSelectedIndex = 0
int _scaleDefault = 100
float _displayTimeDefault = 15.0
int _alphaDefault = 100
string[]	_horizontalAlignments
string[]	_horizontalAlignmentValues
int _horizonatlAlignmentDefault = 1
int _horizonatlAlignmentIndex = 1
string[]	_verticalAlignments
string[]	_verticalAlignmentValues
int _verticallAlignmentDefault = 2
int _verticallAlignmentIndex = 2
float[]	_horizontalXOffset ; Used by the Horizontal Anchor
float[]	_verticalYOffset ; Used by the Vertical Anchor
float _X_OffsetValue = 0.0
float _defaultX_OffsetValue = 0.0
float _Y_OffsetValue = 0.0
float _defaultY_OffsetValue = 0.0

function loadOptions()
  _periodic = new string[7]
	_periodic[0] = "Every 15 Minutes"
	_periodic[1] = "Every 30 Minutes"
	_periodic[2] = "Every Hour"
	_periodic[3] = "Every 2 Hours"
	_periodic[4] = "Every 3 Hours"
	_periodic[5] = "Every 6 Hours"
	_periodic[6] = "Every 12 Hours"

	_periodicValues = new string[7]
	_periodicValues[0] = "every15min"
	_periodicValues[1] = "every30min"
	_periodicValues[2] = "every1hour"
	_periodicValues[3] = "every2hours"
	_periodicValues[4] = "every3hours"
	_periodicValues[5] = "every6hours"
	_periodicValues[6] = "every12hours"

  _controlModes = new string[4]
	_controlModes[0] = "Always On"
	_controlModes[1] = "Timed Hotkey"
	_controlModes[2] = "Toggled Hotkey"
	_controlModes[3] = "Periodically"

	_controlModeValues = new string[4]
	_controlModeValues[0] = "always"
	_controlModeValues[1] = "timedHotkey"
	_controlModeValues[2] = "toggledHotkey"
	_controlModeValues[3] = "periodically"

  _horizontalAlignments = new string[3]
	_horizontalAlignments[0] = "Left"
	_horizontalAlignments[1] = "Right"
	_horizontalAlignments[2] = "Center"

	_horizontalAlignmentValues = new string[3]
	_horizontalAlignmentValues[0] = "left"
	_horizontalAlignmentValues[1] = "right"
	_horizontalAlignmentValues[2] = "center"

	_verticalAlignments = new string[3]
	_verticalAlignments[0] = "Top"
	_verticalAlignments[1] = "Bottom"
	_verticalAlignments[2] = "Center"

	_verticalAlignmentValues = new string[3]
	_verticalAlignmentValues[0] = "top"
	_verticalAlignmentValues[1] = "bottom"
	_verticalAlignmentValues[2] = "center"

	_horizontalXOffset = new float[3]
	_horizontalXOffset[0] = 0.0
	_horizontalXOffset[1] = 1280.0
	_horizontalXOffset[2] = 640.0

	_verticalYOffset = new float[3]
	_verticalYOffset[0] = 0.0
	_verticalYOffset[1] = 720.0
	_verticalYOffset[2] = 360.0


endFunction

Event OnPageReset(string page)
  loadOptions()

  If (Page == "") ;This is always the first page we see when we first enter, or click on the menu.
    SetCursorFillMode(TOP_TO_BOTTOM)
    SetCursorPosition(0)
    AddHeaderOption("Display Control")

    AddEmptyOption() ;Adds a space before the next option is added.
    AddMenuOptionST("Control_Mode", "Control Mode", _controlModes[_controlModSelectedIndex], OPTION_FLAG_NONE)
    AddMenuOptionST("Periodic", "Periodic Setting", _periodic[_periodicSelectedIndex], get_Periodic_Flag())
		AddSliderOptionST("Display_Time", "Display Time", Widget.DisplayTime, "{0} Seconds", get_Display_Time_Flag())

    AddEmptyOption() ;Adds a space before the next option is added.
    AddKeyMapOptionST("Hotkey", "Toggle Meter Hotkey", Widget.Hotkey, get_Hotkey_Flag())

    string unbindMsg = ""
    if (Widget.Hotkey > -1)
      unbindMsg = "Unbind Hotkey"
    endif
    AddTextOptionST("Hotkey_Unbind", "", unbindMsg, get_Hokey_Unbind_Flag())
    AddEmptyOption() ;Adds a space before the next option is added.
    AddEmptyOption() ;Adds a space before the next option is added.
    AddHeaderOption("Other")
    AddEmptyOption() ;Adds a space before the next option is added.
    AddToggleOptionST("SunToggle", "Sun Toggle", Widget.SunToggle)
    AddToggleOptionST("CellChangeToggle", "Cell Change Toggle", Widget.CellChangeToggle)

    SetCursorPosition(1)
    AddHeaderOption("Display Position/Size")
    AddEmptyOption() ;Adds a space before the next option is added.
		AddSliderOptionST("Scale", "Scale", Widget.Scale, "{0}%", OPTION_FLAG_NONE)
		AddSliderOptionST("Alpha", "Alpha", Widget.WidgetAlpha, "{0}%", OPTION_FLAG_NONE)
    AddMenuOptionST("Horizontal_Anchor", "Horizontal Anchor", _horizontalAlignments[_horizonatlAlignmentIndex], OPTION_FLAG_NONE)
		AddSliderOptionST("X_Offset", "Horizontal Offset", _X_OffsetValue, "{0}", OPTION_FLAG_NONE)
    AddMenuOptionST("Vertical_Anchor", "Vertical Anchor", _verticalAlignments[_verticallAlignmentIndex], OPTION_FLAG_NONE)
		AddSliderOptionST("Y_Offset", "Vertical Offset", _Y_OffsetValue, "{0}", OPTION_FLAG_NONE)

    AddEmptyOption() ;Adds a space before the next option is added.
    AddHeaderOption("")
		;AddSliderOptionST("X_Offset", "Horizontal Offset", _horizontalXOffset, "{0}", OPTION_FLAG_NONE)
		;AddSliderOptionST("Y_Offset", "Vertical Offset", _verticalYOffset, "{0}", OPTION_FLAG_NONE)
  EndIf
EndEvent


int function get_Periodic_Flag()
  if _controlModSelectedIndex == 3
    return OPTION_FLAG_NONE
  endIf
  return OPTION_FLAG_DISABLED
endFunction

int function get_Display_Time_Flag()
  if _controlModSelectedIndex == 1 ||  _controlModSelectedIndex == 3
    return OPTION_FLAG_NONE
  endIf
  return OPTION_FLAG_DISABLED
endFunction

int function get_Hotkey_Flag()
  if _controlModSelectedIndex == 1 ||  _controlModSelectedIndex == 2
    return OPTION_FLAG_WITH_UNMAP
  endIf
  return OPTION_FLAG_DISABLED
endFunction

int function get_Hokey_Unbind_Flag()
  if Widget.Hotkey > -1
    return OPTION_FLAG_NONE
  endIf
  return OPTION_FLAG_HIDDEN
endFunction



state Periodic ; Menu
  event OnMenuOpenST()
		SetMenuDialogOptions(_periodic) ; Options
		SetMenuDialogStartIndex(_periodicSelectedIndex) ; Selected
		SetMenuDialogDefaultIndex(_periodicDefault) ; Default
	endEvent

	event OnMenuAcceptST(int index)
		_periodicSelectedIndex = index
		Widget.Period = _periodicValues[_periodicSelectedIndex]
		SetMenuOptionValueST(_periodic[_periodicSelectedIndex])
	endEvent

	event OnDefaultST()
		_periodicSelectedIndex = _periodicDefault
		Widget.Period = _periodicValues[_periodicSelectedIndex]
		SetMenuOptionValueST(_periodic[_periodicSelectedIndex])
	endEvent

	event OnHighlightST()
		SetInfoText("How often to show the meter, when using Periodic Control Mode.")
	endEvent
endState

state Control_Mode ; Menu
  event OnMenuOpenST()
		SetMenuDialogOptions(_controlModes) ; Options
		SetMenuDialogStartIndex(_controlModSelectedIndex) ; Selected
		SetMenuDialogDefaultIndex(_controlModeDefault) ; Default
	endEvent

	event OnMenuAcceptST(int index)
    _controlModSelectedIndex = index
    Widget.ControlMode = _controlModeValues[_controlModSelectedIndex]
    SetMenuOptionValueST(_controlModes[_controlModSelectedIndex])
    SetOptionFlagsST(get_Periodic_Flag(), false, "Periodic")
    SetOptionFlagsST(get_Display_Time_Flag(), false, "Display_Time")
    SetOptionFlagsST(get_Hotkey_Flag(), false, "Hotkey")
	endEvent

	event OnDefaultST()
    _controlModSelectedIndex = _controlModeDefault
    Widget.ControlMode = _controlModeValues[_controlModSelectedIndex]
    SetMenuOptionValueST(_controlModes[_controlModSelectedIndex])
    SetOptionFlagsST(get_Periodic_Flag(), false, "Periodic")
    SetOptionFlagsST(get_Display_Time_Flag(), false, "Display_Time")
    SetOptionFlagsST(get_Hotkey_Flag(), false, "Hotkey")
	endEvent

	event OnHighlightST()
		SetInfoText("How and When to display the meter.")
	endEvent
endState

state Display_Time ; Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(Widget.DisplayTime)
		SetSliderDialogDefaultValue(_displayTimeDefault)
		SetSliderDialogRange(1, 300)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		Widget.DisplayTime = value
		SetSliderOptionValueST(Widget.DisplayTime, "{0} Seconds")
	endEvent

	event OnDefaultST()
		Widget.DisplayTime = _displayTimeDefault
		SetSliderOptionValueST(Widget.DisplayTime, "{0} Seconds")
	endEvent

	event OnHighlightST()
		SetInfoText("How long in seconds will the display be shown, when using Timed Hotkey or Periodical Control Modes.")
	endEvent
endState

;https://www.creationkit.com/index.php?title=Input_Script#DXScanCodes
state Hotkey ; Keymap
  event OnKeyMapChangeST(int theKeyCode, string conflictControl, string conflictName)
    int oldHotKey = Widget.Hotkey

    if (CheckNewHotkey(conflictControl, conflictName))
			if oldHotKey
        unregisterForKey(oldHotKey)
      endIf
      SetKeyMapOptionValueST(theKeyCode)
      Widget.Hotkey = theKeyCode
      registerForKey(theKeyCode)
      SetTextOptionValueST("Unbind Hotkey", false, "Hotkey_Unbind")
      SetOptionFlagsST(get_Hokey_Unbind_Flag(), false, "Hotkey_Unbind")
		endIf
  endEvent

  event OnHighlightST()
    SetInfoText("Hotkey to use when using any of the hotkey enabled control mode options.")
  endEvent
endState

state Hotkey_Unbind
	event OnSelectST()
    int Hotkey = Widget.Hotkey
    if (Hotkey > -1)
      if ShowMessage("Do you want to unbind the hotkey?", true, "Unbind", "Cancel")
        SetTextOptionValueST("")
        unregisterForKey(Widget.Hotkey)
        SetKeyMapOptionValueST(-1, false, "Hotkey")
        Widget.Hotkey = -1
        SetOptionFlagsST(OPTION_FLAG_DISABLED, false)
      endIf
    endif
	endEvent

	event OnHighlightST()
    int Hotkey = Widget.Hotkey
    if (Hotkey > -1)
      SetInfoText("Will unbind the hotkey.")
    endif
	endEvent
endState

state Scale ; Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(Widget.Scale)
		SetSliderDialogDefaultValue(_scaleDefault)
		SetSliderDialogRange(1, 200)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		Widget.Scale = value as int
		SetSliderOptionValueST(Widget.Scale, "{0}%")

    Widget.HAnchor = _horizontalAlignmentValues[0]
	  Widget.X = _horizontalXOffset[0]
    Widget.HAnchor = _horizontalAlignmentValues[_horizonatlAlignmentIndex]
	  Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex]
    _X_OffsetValue = 0
    SetSliderOptionValueST(_X_OffsetValue, "{0}", false, "X_Offset")

    Widget.VAnchor = _verticalAlignmentValues[0]
	  Widget.Y = _verticalYOffset[0]
    Widget.VAnchor = _verticalAlignmentValues[_verticallAlignmentIndex]
	  Widget.Y = _verticalYOffset[_verticallAlignmentIndex]
    _Y_OffsetValue = 0
    SetSliderOptionValueST(_Y_OffsetValue, "{0}", false, "Y_Offset")
	endEvent

	event OnDefaultST()
		Widget.Scale = _scaleDefault
		SetSliderOptionValueST(Widget.Scale, "{0}%")

    Widget.HAnchor = _horizontalAlignmentValues[0]
	  Widget.X = _horizontalXOffset[0]
    Widget.HAnchor = _horizontalAlignmentValues[_horizonatlAlignmentIndex]
	  Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex]
    _X_OffsetValue = 0
    SetSliderOptionValueST(_X_OffsetValue, "{0}", false, "X_Offset")

    Widget.VAnchor = _verticalAlignmentValues[0]
	  Widget.Y = _verticalYOffset[0]
    Widget.VAnchor = _verticalAlignmentValues[_verticallAlignmentIndex]
	  Widget.Y = _verticalYOffset[_verticallAlignmentIndex]
    _Y_OffsetValue = 0
    SetSliderOptionValueST(_Y_OffsetValue, "{0}", false, "Y_Offset")
	endEvent

	event OnHighlightST()
		SetInfoText("Scales the meter in size.")
	endEvent
endState

state Alpha ; Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(Widget.WidgetAlpha)
		SetSliderDialogDefaultValue(_alphaDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		Widget.WidgetAlpha = value as int
		SetSliderOptionValueST(Widget.WidgetAlpha, "{0}%")
	endEvent

	event OnDefaultST()
		Widget.WidgetAlpha = _alphaDefault
		SetSliderOptionValueST(Widget.WidgetAlpha, "{0}%")
	endEvent

	event OnHighlightST()
		SetInfoText("Sets the Opacity of the meter.")
	endEvent
endState

state Horizontal_Anchor ; Menu
  event OnMenuOpenST()
		SetMenuDialogOptions(_horizontalAlignments) ; Options
		SetMenuDialogStartIndex(_horizonatlAlignmentIndex) ; Selected
		SetMenuDialogDefaultIndex(_horizonatlAlignmentDefault) ; Default
	endEvent

	event OnMenuAcceptST(int index)
		_horizonatlAlignmentIndex = index

		Widget.HAnchor = _horizontalAlignmentValues[_horizonatlAlignmentIndex]
	  Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex]
    _X_OffsetValue = 0
    SetSliderOptionValueST(_X_OffsetValue, "{0}", false, "X_Offset")

		SetMenuOptionValueST(_horizontalAlignments[_horizonatlAlignmentIndex])
	endEvent

	event OnDefaultST()
		_horizonatlAlignmentIndex = _horizonatlAlignmentDefault

		Widget.HAnchor = _horizontalAlignmentValues[_horizonatlAlignmentIndex]
	  Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex]
    _X_OffsetValue = 0
    SetSliderOptionValueST(_X_OffsetValue, "{0}", false, "X_Offset")

		SetMenuOptionValueST(_horizontalAlignments[_horizonatlAlignmentIndex])
	endEvent

	event OnHighlightST()
		SetInfoText("The Horizontal Anchor of the meter.")
	endEvent
endState

state Vertical_Anchor ; Menu
  event OnMenuOpenST()
		SetMenuDialogOptions(_verticalAlignments) ; Options
		SetMenuDialogStartIndex(_verticallAlignmentIndex) ; Selected
		SetMenuDialogDefaultIndex(_verticallAlignmentDefault) ; Default
	endEvent

	event OnMenuAcceptST(int index)
		_verticallAlignmentIndex = index

		Widget.VAnchor = _verticalAlignmentValues[_verticallAlignmentIndex]
	  Widget.Y = _verticalYOffset[_verticallAlignmentIndex]
    _Y_OffsetValue = 0
    SetSliderOptionValueST(_Y_OffsetValue, "{0}", false, "Y_Offset")

		SetMenuOptionValueST(_verticalAlignments[_verticallAlignmentIndex])
	endEvent

	event OnDefaultST()
		_verticallAlignmentIndex = _verticallAlignmentDefault

		Widget.VAnchor = _verticalAlignmentValues[_verticallAlignmentIndex]
	  Widget.Y = _verticalYOffset[_verticallAlignmentIndex]
    _Y_OffsetValue = 0
    SetSliderOptionValueST(_Y_OffsetValue, "{0}", false, "Y_Offset")

		SetMenuOptionValueST(_verticalAlignments[_verticallAlignmentIndex])
	endEvent

	event OnHighlightST()
		SetInfoText("The Vertical Anchor of the meter.")
	endEvent
endState

state X_Offset ; Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(_X_OffsetValue)
		SetSliderDialogDefaultValue(_defaultX_OffsetValue)
    float min = -(_horizontalXOffset[2] / 2)
    float max = _horizontalXOffset[2] / 2
    if _horizontalAlignmentValues[_horizonatlAlignmentIndex] == "left"
      min = -25
    elseIf _horizontalAlignmentValues[_horizonatlAlignmentIndex] == "right"
      max = 25
    endIf
		SetSliderDialogRange(min, max)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_X_OffsetValue = a_value
		Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex] + _X_OffsetValue
    SetSliderOptionValueST(_X_OffsetValue, "{0}")
	endEvent

	event OnDefaultST()
		_X_OffsetValue = _defaultX_OffsetValue
		Widget.X = _horizontalXOffset[_horizonatlAlignmentIndex] + _X_OffsetValue
    SetSliderOptionValueST(_X_OffsetValue, "{0}")
	endEvent

	event OnHighlightST()
		SetInfoText("Sets the Horizontal Offset of the Meter.")
	endEvent
endState

state Y_Offset ; Slider
		event OnSliderOpenST()
		SetSliderDialogStartValue(_Y_OffsetValue)
		SetSliderDialogDefaultValue(_defaultY_OffsetValue)
    float min = -(_verticalYOffset[2] / 2)
    float max = _verticalYOffset[2] / 2
    if _verticalAlignmentValues[_verticallAlignmentIndex] == "top"
      min = -25
    elseIf _verticalAlignmentValues[_verticallAlignmentIndex] == "bottom"
      max = 25
    endIf
		SetSliderDialogRange(min, max)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_Y_OffsetValue = a_value
		Widget.Y = _verticalYOffset[_verticallAlignmentIndex] + _Y_OffsetValue
    SetSliderOptionValueST(_Y_OffsetValue, "{0}")
	endEvent

	event OnDefaultST()
		_Y_OffsetValue = _defaultY_OffsetValue
		Widget.Y = _verticalYOffset[_verticallAlignmentIndex] + _Y_OffsetValue
    SetSliderOptionValueST(_Y_OffsetValue, "{0}")
	endEvent

	event OnHighlightST()
		SetInfoText("Sets the Vertical Offset of the Meter.")
	endEvent
endState

state SunToggle
  Event OnHighlightST()
    SetInfoText("Will display the Sun Icon when your being exposed by the sun.")
  EndEvent

  Event OnSelectST()
    If Widget.SunToggle ;If the ToggleA Global Variable is 1, or rather, if our toggle option in the menu is checked
      Widget.SunToggle = false ;sets the Global Variable to 0
      SetToggleOptionValueST(0) ;Sets the toggle display in the menu to unchecked. Optionally disable something in your mod here, or use the ToggleA global variable elsewhere.
    else ;If the ToggleA is 0, or rather, if our toggle option is unchecked
      Widget.SunToggle = true ;set’s the Global Variable to 1
      SetToggleOptionValueST(1) ;Set’s the toggle display in the menu to checked. Optionally enable something in your mod here, or use the ToggleA global variable elsewhere.
    EndIf
  EndEvent
EndState

state CellChangeToggle
  Event OnHighlightST()
    SetInfoText("Will display the meter when loading into a new cell (going through a load screen).")
  EndEvent

  Event OnSelectST()
    If Widget.CellChangeToggle ;If the ToggleA Global Variable is 1, or rather, if our toggle option in the menu is checked
      Widget.CellChangeToggle = false ;sets the Global Variable to 0
      SetToggleOptionValueST(0) ;Sets the toggle display in the menu to unchecked. Optionally disable something in your mod here, or use the ToggleA global variable elsewhere.
    else ;If the ToggleA is 0, or rather, if our toggle option is unchecked
      Widget.CellChangeToggle = true ;set’s the Global Variable to 1
      SetToggleOptionValueST(1) ;Set’s the toggle display in the menu to checked. Optionally enable something in your mod here, or use the ToggleA global variable elsewhere.
    EndIf
  EndEvent
EndState

; Checks if the newly assigned key is conflicting with another mod and asks
; the user if we should go on. Return true if no conflict or ignore.
bool function CheckNewHotkey(string conflictControl, string conflictName)
	if (conflictControl != "")
		string msg
		if (conflictName != "")
			msg = "This Key mapped to mod {" + conflictControl + "}{" + conflictName + "}"
		else
			msg = "This Key mapped to game {" + conflictControl + "}"
		endIf

		return ShowMessage(msg, true, "$Yes", "$No")
	endIf

	return true
endFunction
