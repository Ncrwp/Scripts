#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <Clipboard.au3>
#include <Date.au3>
#RequireAdmin
Opt("MouseCoordMode", 0)
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
HotKeySet("+!t", "Terminate")
Global $user = @UserName
Global $fCnt = 0


GUI()

Func GUI()
    ; Create a GUI with various controls.
    Global $hGUI = GUICreate("Auto CSM", 180, 180)

    ; Checkboxs control.
    Global $infoCb = GUICtrlCreateCheckbox("PC Info", 5, 0, 185, 25)
	Global $eventCb = GUICtrlCreateCheckbox("Event Logs", 5, 25, 185, 25)
	Global $spaceinCb = GUICtrlCreateCheckbox("Storage Info", 5, 50, 185, 25)
    Global $defragCb = GUICtrlCreateCheckbox("Defrag Disk", 5, 75, 185, 25)
	Global $chkDskCb = GUICtrlCreateCheckbox("Check Disk", 5, 100, 185, 25)


    ; Create a Buttons control.
    Local $idButton_Run = GUICtrlCreateButton("Run", 5, 150, 60, 25)
	Local $idButton_prtSc = GUICtrlCreateButton("ScreenShot", 70, 150, 60, 25)
	;Local $Label1 = GUICtrlCreateLabel ("Step Time", 5, 85, 60, 25)
	;Global $timeModIn = GUICtrlCreateInput("250", 5, 100, 100, 20)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()

            Case $idButton_Run
			   $fCnt = $fCnt + 1
			   DirCreate(@DesktopDir & "\CSM(" & $fCnt & ")")

			   sysInf()
			   eventLog()
			   dskInf()
			   defDisk()
			   cskDsk()

			Case $idButton_prtSc

			   GUISetState(@SW_HIDE, $hGUI)
			   Sleep(1000)
			   Send("{PRINTSCREEN}")
			   GUISetState(@SW_SHOW, $hGUI)
			   Run("mspaint.exe")
			   WinWait("Untitled - Paint")
			   WinActivate("Untitled - Paint")
			   WinSetState("Untitled - Paint", "", @SW_MAXIMIZE)
			   Send("^v")
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

;Tools Func
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
   WinWait($ptSh)
   WinActivate($ptSH)
   WinWaitActive($ptSH)

   Send("{PRINTSCREEN}")

   Run("mspaint.exe")
   WinWait("Untitled - Paint")
   WinActivate("Untitled - Paint")
   WinSetState("Untitled - Paint", "", @SW_MAXIMIZE)
   Send("^v")
   WinClose("Untitled - Paint")
   WinWait("Paint", "", 10)
   WinActive("Paint")
   WinWaitActive("Paint", "", 10)
   Send("{ENTER}")
   WinWait("Save As", "", 10)
   WinActive("Save As")
   WinWaitActive("Save As", "", 10)
   ControlSetText("Save As","","Edit1", @DesktopDir & "\CSM(" & $fCnt & ")\" & $fName & ".png")

   Send("{RIGHT}")
   Send("{SPACE}")
   Send("{BS}")
   ControlClick("Save As","","Button1")

   WinActivate($ptSH)
EndFunc


;PC Info Task
Func sysInf()
   if _IsChecked($infoCb) Then
   cmdRun('sysdm.cpl')
   mxWnd('System Properties')
   snSt($hWnd, "1. System Info")
   WinClose($hWnd)
   EndIf
   EndFunc

;Event Log Tasks
Func eventLog()
   if _IsChecked($eventCb) Then
   cmdRun('mmc.exe eventvwr.msc /c:"Application" /f:"*[System [(Level=1 or Level=2)]]"')
   mxWnd('Event Viewer')
   snSt($hWnd, "2. ApplicationLog")
   evPic("ApplicationLog", 60, 145)
   WinClose($hWnd)

   cmdRun('mmc.exe eventvwr.msc /c:"Security" /f:"*[System [(Level=1 or Level=2)]]"')
   mxWnd('Event Viewer')
   snSt($hWnd, "3. SecurityLog")
   evPic("SecurityLog", 60, 165)
   WinClose($hWnd)

   cmdRun('mmc.exe eventvwr.msc /c:"System" /f:"*[System [(Level=1 or Level=2)]]"')
   mxWnd('Event Viewer')
   snSt($hWnd, "4. SystemLog")
   evPic("SystemLog", 60, 200)
   WinClose($hWnd)
   EndIf
EndFunc
Func evlFil()
   if _IsChecked($idCbFilter) Then
   WinWaitActive($hWnd, "", 1)
   MouseClick($MOUSE_CLICK_LEFT, 105, 40, 1)
   WinWaitActive("#32768", "", 1)
   MouseClick($MOUSE_CLICK_LEFT, 120, 110, 1)
   $wndNm = ""
   $actv = 0

   if WinExists("Application Properties") Then
	  $wndNm = "Application Properties"
	  $actv = 1
   ElseIf WinExists("Security Properties") Then
	  $wndNm = "Security Properties"
	  $actv = 1
   ElseIf WinExists("System Properties") Then
	  $wndNm = "System Properties"
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
Func evPic($logCnt, $mX, $mY)

   MouseClick($MOUSE_CLICK_LEFT, 225, 170, 1)
   Send("{ENTER}")
   WinWait("Event Properties", "", 1)
   WinActivate("Event Properties")
   WinWaitActive("Event Properties", "", 1)

   if WinExists("Event Properties") Then

	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "1")

	  MouseClick($MOUSE_CLICK_LEFT, 600, 225, 1)
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "2")

	  Send("{ENTER}")
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "3")
	  WinClose("Event Properties")
	  WinActive("Event Viewer")
   EndIf

   WinWaitActive("Event Viewer", "", 1)

   MouseClick($MOUSE_CLICK_RIGHT, $mX, $mY, 1)
   WinWaitActive("#32768", "", 1)
   Send("{DOWN 4}")
   Send("{ENTER}")

   WinWait("Event Viewer", "You can save the contents of this log before clearing it", 10)
   WinWaitActive("Event Viewer", "You can save the contents of this log before clearing it", 1)
   Send("{RIGHT}")
   Send("{ENTER}")
   WinWaitActive("Event Viewer", "", 1)
   snSt($hWnd, $logCnt & "Cleared")



EndFunc

;Disk Info Task
Func dskInf()
   if _IsChecked($spaceinCb) Then
   cmdRun('mmc.exe diskmgmt.msc')
   mxWnd('Disk Management')
   snSt($hWnd, "5. Storage Info")
   WinClose($hWnd)
   EndIf
EndFunc

;Defragmentation Task
Func defDisk()
   if _IsChecked($defragCb) Then
   Run (@ComSpec & " /k " & 'defrag c:', @SystemDir, @SW_SHOW)
   EndIf
   EndFunc

;Check Disk Task
Func cskDsk()
   if _IsChecked($chkDskCb) Then
   Run (@ComSpec & " /k " & 'chkdsk', @SystemDir, @SW_SHOW)
   EndIf
EndFunc

Func Terminate()
   Exit
EndFunc
