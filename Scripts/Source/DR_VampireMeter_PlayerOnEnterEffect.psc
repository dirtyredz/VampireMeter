Scriptname DR_VampireMeter_PlayerOnEnterEffect extends ActiveMagicEffect
{ability that will be activated when player is not in the same cell as invisibleObject}

; https://www.creationkit.com/index.php?title=Detect_Player_Cell_Change_(Without_Polling)
Actor property playerRef auto ; Do i need this? can I use akCaster?
DR_VampireMeter_WidgetQuest property Widget auto
ObjectReference property DR_VampireMeter_InvisibleObject auto
; refrence to an invisable "xmarker" placed somewhere in tamerial (I randomly placed it....)

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Utility.Wait(0.1) ; Required.
  DR_VampireMeter_InvisibleObject.MoveTo(playerRef)
  Widget.showOnCellChange(playerRef)
EndEvent
