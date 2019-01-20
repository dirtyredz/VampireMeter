Scriptname DR_VampireMeter_WidgetQuest extends DR_WidgetBase

; region ------------------ Properties -------------------------

GlobalVariable property GameDaysPassed Auto
GlobalVariable Property PlayerIsVampire Auto
GlobalVariable Property GameHour Auto

WorldSpace Property Sovngarde Auto ;
{Grab the vanilla player vampire quest script (Controlls feeding/progression)}
playervampirequestscript Property VampQuest Auto


; endRegion

; region ------------------ Private variables ------------------

int _currentStage = 0
int _currentFrame = 0
float _lastFeedTime = 0.0
float _timeSinceFeeding = 0.0
int _lastStage = 4
bool _sunToggle = false

bool property SunToggle
	{Set to true to show the widget}
	bool function get()
		return _sunToggle
	endFunction

	function set(bool isShown)
		_sunToggle = isShown
	endFunction
endProperty

; endRegion

; region ------------------ Events -----------------------------

; @overrides SKI_WidgetBase
string function GetWidgetSource()
	return "VampireMeter/VampireMeterWidget.swf"
endFunction

; @overrides SKI_WidgetBase
string function GetWidgetType()
	return "DR_VampireMeter_WidgetQuest"
endFunction

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()

	; Update event registrations
  UnregisterForUpdateGameTime() ; Unregister this event because it could be registered by an old save
	UnregisterForUpdate()
	RegisterForSingleUpdate(10.0) ; in-game seconds, ignores menus
  UpdateWidget()
endEvent

event OnUpdate()
	; Set the time to ensure the correct periodic display.
	RegisterForSingleUpdate(10.0) ; in-game seconds, ignores menus
  UpdateWidget()
endEvent

event OnMenuClose(String menuName)
	parent.OnMenuClose(menuName)
  UpdateWidget()
endEvent

;endRegion

; region ------------------ Functions --------------------------

function UpdateWidget()
  if PlayerIsVampire.GetValue()
    ; Show the widget
    Shown = true

    ; Update stats
    updateVampireStats()

    ; Update Staging
    updateStage()

    ; Update Frames
    updateFrame()

    ; check for progression
    progressionCheck()
  else
    Shown = false
  endIf
  if _sunToggle
    CheckForSunlight()
  endIf
endFunction

function CheckForSunlight()
  actor player = Game.GetPlayer()
  bool isInInterior = player.IsInInterior()
  bool isPlayerInSovngarde = player.GetWorldSpace() == Sovngarde

  if !isInInterior && isDuringDay() && !isPlayerInSovngarde
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setSunVisibility", true)
  else
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setSunVisibility", false)
  endIf
endFunction

bool function isDuringDay()
  float currentHour = GameHour.GetValue()
  if currentHour >= 5 && currentHour <= 19
    return true
  endIf
  return false
endFunction

function updateStage()
  _currentStage = VampQuest.VampireStatus
  UI.InvokeString(HUD_MENU, WidgetRoot + ".setStage", _currentStage as int)
endFunction

function updateFrame()
  if _currentStage >= _lastStage ; keep the frames on full while in stage 4
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setMeterFrame", 100)
  else
    int feedTimeAdjustment = _currentStage - 1
    _currentFrame = Math.Floor((_timeSinceFeeding - feedTimeAdjustment) * 100)

    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setMeterFrame", _currentFrame as int)
  endIf
endFunction

function updateVampireStats()
  _lastFeedTime = VampQuest.LastFeedTime
  _timeSinceFeeding = GameDaysPassed.Value - _lastFeedTime
endFunction

function progressionCheck()
  int stageBeforeLast = _lastStage - 1
  if _currentFrame > 100 && _currentStage <= stageBeforeLast; Force the VampQuest to update itself since it only checks ever 12 hours.
    VampQuest.OnUpdateGameTime()
  endIf
endFunction
; endRegion
