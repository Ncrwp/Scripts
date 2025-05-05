#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <Clipboard.au3>
#RequireAdmin

Global $user = @UserName
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client




GUI()

Func GUI()
    ; Create a GUI with various controls.
    Local $hGUI = GUICreate("Auto CSM", 300, 200)

    ; Create a checkboxs control.
    Local $idCheckbox = GUICtrlCreateCheckbox("Hide Panel", 100, 10, 185, 25)
    ; Create a Buttons control.
    Local $idButton_Run = GUICtrlCreateButton("Run", 100, 170, 85, 25)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()

            Case $idButton_Run
			   ;cmdRun('cd Desktop')
			   ;cmdRun('mkdir CSMFiles')


               ;cmdRun('msinfo32')
			   ;mxWnd('System Information')
			   ;Sleep(3000)
			   ;snSt($hWnd, "msInfo")

			   ;cmdRun('mmc.exe eventvwr.msc /c:"Application" /f:"*[System [(Level=1 or Level=2)]]"')
			   ;mxWnd('Event Viewer')
			   ;snSt($hWnd, "ApplicationLog")

			    If _IsChecked($idCheckbox) Then
				    Sleep(2000)
			        MouseClick($MOUSE_CLICK_LEFT, 100, 65, 1)
		            MouseClick($MOUSE_CLICK_LEFT, 150, 65, 1)
			        MouseClick($MOUSE_CLICK_LEFT, 50, 150, 1)
				 EndIf

			    ;cmdRun('mmc.exe diskmgmt.msc')
			    ;mxWnd('Disk Management')

				Run (@ComSpec & " /k " & @SystemDir & "\ipconfig.exe /all", @SystemDir, @SW_SHOW)

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
    WinSetState($hWnd, "", @SW_MAXIMIZE)
EndFunc

Func snSt($ptSh, $fName)
   WinActivate("$ptSH")
   $hBitmap = _ScreenCapture_CaptureWnd("", $ptSH)

   _ClipBoard_Open($ptSH)
   _ClipBoard_Empty()
   _ClipBoard_SetDataEx($hBitmap, $CF_BITMAP)
   _ClipBoard_Close()

   Run("mspaint.exe")
   WinWait("Untitled - Paint", "", 10)
   WinActivate("Untitled - Paint")
   WinSetState("Untitled - Paint", "", @SW_MAXIMIZE)
   Send("^v")
   Sleep(1000)
   ;Send("^s")
   WinClose("Untitled - Paint")
   Send("{ENTER}")
   WinWaitActive("Save As", "", 10)
    Sleep(500)
   ControlSetText("Save As","","Edit1", @DesktopDir & "\CSMFiles\" & $fName & ".png")
   Sleep(1000)
   ControlClick("Save As","","Button2")
   WinClose($ptSh)

EndFunc