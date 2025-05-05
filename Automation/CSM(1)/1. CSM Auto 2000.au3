#include <GUIConstantsEx.au3>
;#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <Clipboard.au3>
#include <Date.au3>
#RequireAdmin

Global $user = @UserName
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Global $fCnt = 0

GUI()

Func GUI()
    ; Create a GUI with various controls.
    Global $hGUI = GUICreate("Auto CSM", 180, 180)

    ; Create a checkboxs control.
    Global $idCbdskUtil = GUICtrlCreateCheckbox("Run Check Disk", 5, 0, 185, 25)
	Global $idCbFilter = GUICtrlCreateCheckbox("Filter Events", 5, 25, 185, 25)
	Global $idCbClearLog = GUICtrlCreateCheckbox("Clear Event Log", 5, 50, 185, 25)

    ; Create a Buttons control.
    Local $idButton_Run = GUICtrlCreateButton("Run", 60, 150, 60, 25)
	Local $Label1 = GUICtrlCreateLabel ("Step Time", 5, 85, 60, 25)
	Global $timeModIn = GUICtrlCreateInput("1000", 5, 100, 100, 20)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()

            Case $idButton_Run
			   $fCnt = $fCnt + 1
			   DirCreate(@DesktopDir & "\CSM(" & $fCnt & ")")

			   if _IsChecked($idCbdskUtil) Then
			   ;Run (@ComSpec & " /k " & 'defrag c:', @SystemDir, @SW_SHOW)
			   Run (@ComSpec & " /k " & 'chkdsk', @SystemDir, @SW_SHOW)
			   EndIf

               cmdRun('sysdm.cpl')
			   mxWnd('System Properties')
			   Sleep(GUICtrlRead($timeModIn))
			   snSt($hWnd, "1. System Info")
			   WinClose($hWnd)

			   eventLog()

			   cmdRun('diskmgmt.msc')
			   mxWnd('Disk Management')
			   snSt($hWnd, "5. Storage Info")
			   WinClose($hWnd)
			   
			   cmdRun('dfrg.msc')
			   mxWnd('Disk Defragmenter')
			   ControlClick("Disk Defragmenter","","Button2")
			   WinWait("Defragmentation Complete")
			   ControlClick("Defragmentation Complete","","Button1")
			   WinWait("Defragmentation Report")
			   ControlClick("Defragmentation Report","","Edit1")
			   MouseWheel("down", 2)
			   snSt("Defragmentation Report", "6. Defrag Info")
			   ControlClick("Defragmentation Report","","Button3")
			   WinClose("Disk Defragmenter")

			 Case $GUI_EVENT_CLOSE
				ExitLoop
        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc   ;==>Example

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
 EndFunc   ;==>_IsChecked

 Func cmdRun($CMD)
   Run(@ComSpec & " /c " & $CMD, "", @SW_HIDE)
EndFunc

Func mxWnd($wndNm)
    Global $hWnd = WinWait($wndNm, "", 10)
	WinActivate($hWnd)
    WinWaitActive($hWnd)
    WinSetState($hWnd, "", @SW_MAXIMIZE)
EndFunc

Func snSt($ptSh, $fName)
   WinActivate($ptSH)
   WinWaitActive($ptSH)
   Sleep(GUICtrlRead($timeModIn))
   ;$hBitmap = _ScreenCapture_CaptureWnd("", $ptSH)

   ;_ClipBoard_Open($ptSH)
   ;_ClipBoard_Empty()
   ;_ClipBoard_SetDataEx($hBitmap, $CF_BITMAP)
   ;_ClipBoard_Close()
   
   Send("{PRINTSCREEN}")

   Run("mspaint.exe")
   WinWait("untitled - Paint", "", 10)
   WinActivate("untitled - Paint")
   WinSetState("untitled - Paint", "", @SW_MAXIMIZE)
   Send("^v")
   WinWaitActive("Paint", "", 10)
   Send("{ENTER}")
   Sleep(GUICtrlRead($timeModIn))
   ;Send("^s")
   WinClose("untitled - Paint")
   Send("{ENTER}")
   WinWaitActive("Save As", "", 10)
    Sleep(GUICtrlRead($timeModIn))
   ControlSetText("Save As","","Edit1", @DesktopDir & "\CSM(" & $fCnt & ")\" & $fName & ".png")
   Sleep(GUICtrlRead($timeModIn))
   ControlClick("Save As","","Button2")
   ;WinClose($ptSh)
   WinActivate($ptSH)
EndFunc

Func evlFil()
   if _IsChecked($idCbFilter) Then
   WinWaitActive($hWnd, "", 1)
   MouseClick("left", 75, 35, 1)
   WinWaitActive("#32768", "", 1)
   MouseClick("left", 80, 100, 1)
   $wndNm = ""
   $actv = 0

   if WinExists("Application Log Properties") Then
	  $wndNm = "Application Log Properties"
	  $actv = 1
   ElseIf WinExists("Security Log Properties") Then
	  $wndNm = "Security Log Properties"
	  $actv = 1
   ElseIf WinExists("System Log Properties") Then
	  $wndNm = "System Log Properties"
	  $actv = 1
   EndIf

   if $actv == 1 Then
	  WinWaitActive($wndNm, "", 1)
      ControlClick($wndNm,"","Button2")
      ControlClick($wndNm,"","Button3")
      ControlClick($wndNm,"","Button5")
      ControlClick($wndNm,"","Button6")
      ControlClick($wndNm,"","Button8")
	  $actv = 0
   EndIf
EndIf
   Sleep(GUICtrlRead($timeModIn))
EndFunc

Func evPic($logCnt)

   MouseClick("left", 220, 95, 1)
   Send("{ENTER}")
   WinWaitActive("Event Properties", "", 1)

   if WinExists("Event Properties") Then
	  Sleep(GUICtrlRead($timeModIn))
	  ;WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "1")
	  Sleep(GUICtrlRead($timeModIn))
	  ControlClick("Event Properties","","Button2")
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "2")
	  Sleep(GUICtrlRead($timeModIn))
	  ControlClick("Event Properties","","Button2")
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "3")
	  WinClose("Event Properties")
   EndIf

   Send("{TAB}")
   Send("{TAB}")

   if _IsChecked($idCbClearLog) Then
   MouseClick("left", 35, 35, 1)
   WinWaitActive("#32768", "", 1)
   MouseClick("left", 35, 105, 1)
   WinWaitActive("Event Viewer", "", 1)
   ControlClick("Event Viewer","","Button2")
   snSt($hWnd, $logCnt & "Cleared")
   EndIf


EndFunc

Func eventLog()
   cmdRun('eventvwr.msc')
   mxWnd('Event Viewer')
   Send("{UP}")
   Send("{UP}")
   evlFil()
   snSt($hWnd, "2. ApplicationLog")
   evPic("ApplicationLog")
   Send("{DOWN}")
   evlFil()
   snSt($hWnd, "3. SecurityLog")
   evPic("SecurityLog")
   Send("{DOWN}")
   evlFil()
   snSt($hWnd, "4. SystemLog")
   evPic("SystemLog")
   WinClose($hWnd)
EndFunc
