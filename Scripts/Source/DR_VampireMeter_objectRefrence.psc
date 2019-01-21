Scriptname DR_VampireMeter_objectRefrence extends ObjectReference

; https://www.creationkit.com/index.php?title=Detect_Player_Cell_Change_(Without_Polling)
DR_VampireMeter_WidgetQuest property Widget auto
Actor property playerRef auto

Event OnCellDetach()
  Utility.Wait(0.1) ;maybe not necessary
  MoveTo(playerRef)
  Widget.showOnCellChange(playerRef)
EndEvent
