#include <GUIConstantsEx.au3>
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
   if _OSVersion() < 6 Then
	  $paintNm = "untitled"
	  Else
	  $paintNm = "Untitled"
   EndIf

    ; Create a GUI with various controls.
    Global $hGUI = GUICreate("N.C.R", 170, 225)

    ; Create Label controls.
	Global $infoLb = GUICtrlCreateLabel("Auto CSM TOOL               WV" & _OSVersion(), 5, 5, 165, 25)
    Global $infoLb1 = GUICtrlCreateLabel("Exit (shift + alt + T)", 5, 210, 165, 25)

    ; Checkboxs control.
    Global $infoCb = GUICtrlCreateCheckbox("PC Info", 5, 25, 75, 25)
	GUICtrlSetState ( $infoCb, $GUI_CHECKED)
	Global $eventCb = GUICtrlCreateCheckbox("Event Logs", 5, 50, 75, 25)
	GUICtrlSetState ( $eventCb, $GUI_CHECKED)
	Global $spaceinCb = GUICtrlCreateCheckbox("Storage Info", 5, 75, 75, 25)
	GUICtrlSetState ( $spaceinCb, $GUI_CHECKED)
    Global $defragCb = GUICtrlCreateCheckbox("Defrag Disk", 5, 100, 75, 25)
	GUICtrlSetState ( $defragCb, $GUI_CHECKED)
	Global $chkDskCb = GUICtrlCreateCheckbox("Check Disk", 5, 125, 75, 25)
	GUICtrlSetState ( $chkDskCb, $GUI_CHECKED)

    Global $clearevCb = GUICtrlCreateCheckbox("Clear Events", 5, 150, 75, 25)
	GUICtrlSetState ( $clearevCb, $GUI_CHECKED)


    ; Create a Text control.
	Global $infoTb = GUICtrlCreateInput("0", 85, 25, 35, 20)
	Global $eventTb = GUICtrlCreateInput("0", 85, 50, 35, 20)
	Global $spaceinTb = GUICtrlCreateInput("0", 85, 75, 35, 20)
	Global $defragTb = GUICtrlCreateInput("0", 85, 100, 35, 20)
	Global $chkDskTb = GUICtrlCreateInput("0", 85, 125, 35, 20)

    Global $infoTb1 = GUICtrlCreateInput("0", 130, 25, 35, 20)
	Global $eventTb1 = GUICtrlCreateInput("0", 130, 50, 35, 20)
	Global $spaceinTb1 = GUICtrlCreateInput("0", 130, 75, 35, 20)
	Global $defragTb1 = GUICtrlCreateInput("0", 130, 100, 35, 20)
	Global $chkDskTb1 = GUICtrlCreateInput("0", 130, 125, 35, 20)



    ; Create a Buttons control.
    Local $idButton_Run = GUICtrlCreateButton("Run", 5, 180, 60, 25)
	Local $idButton_prtSc = GUICtrlCreateButton("ScreenShot", 70, 180, 95, 25)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()

            Case $idButton_Run
			   $fCnt = $fCnt + 1
			   DirCreate(@DesktopDir & "\CSM(" & $fCnt & ")")

			   Sleep(GUICtrlRead($infoTb))
			   sysInf()
			   Sleep(GUICtrlRead($eventTb))
			   eventLog()
			   Sleep(GUICtrlRead($spaceinTb))
			   dskInf()
			   Sleep(GUICtrlRead($defragTb))
			   defDisk()
			   Sleep(GUICtrlRead($chkDskTb))
			   cskDsk()

			Case $idButton_prtSc

			   GUISetState(@SW_HIDE, $hGUI)
			   Sleep(1000)
			   Send("{PRINTSCREEN}")
			   GUISetState(@SW_SHOW, $hGUI)
			   Run("mspaint.exe")
			   WinWait("untitled - Paint")
			   WinActivate("untitled - Paint")
			   WinSetState("untitled - Paint", "", @SW_MAXIMIZE)
			   Send("^v")
			   WinWaitActive("Paint", "", 10)
			   Send("{ENTER}")
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
   WinWait("untitled - Paint", "", 10)
   WinActivate("untitled - Paint")
   WinSetState("untitled - Paint", "", @SW_MAXIMIZE)
   Send("^v")
   WinWaitActive("Paint", "", 10)
   Send("{ENTER}")
   WinClose("untitled - Paint")
   WinWait("Paint", "", 10)
   WinActive("Paint")
   WinWaitActive("Paint", "", 10)
   Send("{ENTER}")
   WinWait("Save As", "", 10)
   WinActive("Save As")
   WinWaitActive("Save As", "", 10)
   ControlSetText("Save As","","Edit1", @DesktopDir & "\CSM(" & $fCnt & ")\" & $fName & ".png")
   Send("{ENTER}")
   WinActivate($ptSH)
EndFunc


;PC Info Task
Func sysInf()
   if _IsChecked($infoCb) Then
   cmdRun('sysdm.cpl')
   Sleep(GUICtrlRead($infoTb1))
   mxWnd('System Properties')
   Sleep(GUICtrlRead($infoTb1))
   snSt($hWnd, "1. System Info")
   Sleep(GUICtrlRead($infoTb1))
   WinClose($hWnd)
   EndIf
   EndFunc

;Event Log Tasks
Func eventLog()
   if _IsChecked($eventCb) Then
   cmdRun('eventvwr.msc')
   mxWnd('Event Viewer')
   Sleep(GUICtrlRead($eventTb1))
   Send("{UP}")
   Send("{UP}")
   Sleep(GUICtrlRead($eventTb1))
   evlFil()
   Sleep(GUICtrlRead($eventTb1))
   snSt($hWnd, "2. ApplicationLog")
   Sleep(GUICtrlRead($infoCb))
   evPic("ApplicationLog")
   Sleep(GUICtrlRead($eventTb1))
   Send("{DOWN}")
   Sleep(GUICtrlRead($eventTb1))
   evlFil()
   Sleep(GUICtrlRead($eventTb1))
   snSt($hWnd, "3. SecurityLog")
   Sleep(GUICtrlRead($eventTb1))
   evPic("SecurityLog")
   Sleep(GUICtrlRead($eventTb1))
   Send("{DOWN}")
   Sleep(GUICtrlRead($eventTb1))
   evlFil()
   Sleep(GUICtrlRead($eventTb1))
   snSt($hWnd, "4. SystemLog")
   Sleep(GUICtrlRead($eventTb1))
   evPic("SystemLog")
   Sleep(GUICtrlRead($eventTb1))
   WinClose($hWnd)
   EndIf
EndFunc
Func evlFil()
   WinWaitActive($hWnd, "", 1)
   Sleep(GUICtrlRead($eventTb1))
   MouseClick("left", 75, 35, 1)
   Sleep(GUICtrlRead($eventTb1))
   WinWaitActive("#32768", "", 1)
   Sleep(GUICtrlRead($eventTb1))
   MouseClick("left", 80, 100, 1)
   Sleep(GUICtrlRead($eventTb1))
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
	  Sleep(GUICtrlRead($eventTb1))
      ControlClick($wndNm,"","Button2")
	  Sleep(GUICtrlRead($eventTb1))
      ControlClick($wndNm,"","Button3")
	  Sleep(GUICtrlRead($eventTb1))
      ControlClick($wndNm,"","Button5")
	  Sleep(GUICtrlRead($eventTb1))
      ControlClick($wndNm,"","Button6")
	  Sleep(GUICtrlRead($eventTb1))
      ControlClick($wndNm,"","Button8")
	  $actv = 0
   EndIf

   Sleep(GUICtrlRead($eventTb1))
EndFunc
Func evPic($logCnt)
   Sleep(GUICtrlRead($eventTb1))
   MouseClick("left", 220, 95, 1)
   Sleep(GUICtrlRead($eventTb1))
   Send("{ENTER}")
   WinWaitActive("Event Properties", "", 1)

   if WinExists("Event Properties") Then
	  Sleep(GUICtrlRead($eventTb1))
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "1")
	  Sleep(GUICtrlRead($eventTb1))
	  ControlClick("Event Properties","","Button2")
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "2")
	  Sleep(GUICtrlRead($eventTb1))
	  ControlClick("Event Properties","","Button2")
	  WinWaitActive("Event Properties", "", 1)
	  snSt("Event Properties", $logCnt & "3")
	  Sleep(GUICtrlRead($eventTb1))
	  WinClose("Event Properties")
   EndIf

   Sleep(GUICtrlRead($eventTb1))
   Send("{TAB}")
   Sleep(GUICtrlRead($eventTb1))
   Send("{TAB}")

   if _IsChecked($clearevCb) Then
   Sleep(GUICtrlRead($eventTb1))
   MouseClick("left", 35, 35, 1)
   Sleep(GUICtrlRead($eventTb1))
   WinWaitActive("#32768", "", 1)
   MouseClick("left", 35, 105, 1)
   Sleep(GUICtrlRead($eventTb1))
   WinWaitActive("Event Viewer", "", 1)
   ControlClick("Event Viewer","","Button2")
   Sleep(GUICtrlRead($eventTb1))
   snSt($hWnd, $logCnt & "Cleared")
   EndIf

EndFunc

;Disk Info Task
Func dskInf()
   if _IsChecked($spaceinCb) Then
   cmdRun('diskmgmt.msc')
   mxWnd('Disk Management')
   Sleep(GUICtrlRead($spaceinTb1))
   snSt($hWnd, "5. Storage Info")
   Sleep(GUICtrlRead($spaceinTb1))
   WinClose($hWnd)
   EndIf
EndFunc

;Defragmentation Task
Func defDisk()
   if _IsChecked($defragCb) Then
	  cmdRun('dfrg.msc')
	  Sleep(GUICtrlRead($defragTb1))
	  mxWnd('Disk Defragmenter')
	  Sleep(GUICtrlRead($defragTb1))
	  ControlClick("Disk Defragmenter","","Button2")
	  WinWait("Defragmentation Complete")
	  ControlClick("Defragmentation Complete","","Button1")
	  Sleep(GUICtrlRead($defragTb1))
	  WinWait("Defragmentation Report")
	  ControlClick("Defragmentation Report","","Edit1")
	  Sleep(GUICtrlRead($defragTb1))
	  MouseWheel("down", 2)
	  snSt("Defragmentation Report", "6. Defrag Info")
	  Sleep(GUICtrlRead($defragTb1))
	  ControlClick("Defragmentation Report","","Button3")
	  Sleep(GUICtrlRead($defragTb1))
	  WinClose("Disk Defragmenter")
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

Func _OSVersion($sHostName = @ComputerName)
   Local $sOSVersion = RegRead('\\' & $sHostName & '\HKLM\Software\Microsoft\Windows NT\CurrentVersion', 'CurrentVersion')
   if @error Then Return SetError(1, 0, 0)
   Return Number($sOSVersion)
   EndFunc