#include <ScreenCapture.au3>
#include <Clipboard.au3>

#RequireAdmin
Local $hWnd
Global $user = @UserName
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

;cmdRun('cd Desktop')
;cmdRun('mkdir CSMFiles')


;cmdRun('msinfo32')
;$hWnd = WinWait("System Information", "", 10)
;WinSetState($hWnd, "", @SW_MAXIMIZE)
;snSt($hWnd, "msInfo")

cmdRun('mmc.exe eventvwr.msc /c:"Application" /f:"*[System [(Level=1 or Level=2)]]"')
$hWnd = WinWait("Event Viewer", "", 10)
WinSetState($hWnd, "", @SW_MAXIMIZE)
Sleep(2000)
MouseClick($MOUSE_CLICK_LEFT, 100, 65, 1)
MouseClick($MOUSE_CLICK_LEFT, 150, 65, 1)
MouseClick($MOUSE_CLICK_LEFT, 50, 150, 1)

;Sleep(3000)
;snSt($hWnd, "SystemLog")

;cmdRun('mmc.exe diskmgmt.msc')
;$hWnd = WinWait("[CLASS:MMCMainFrame]", "Event Viewer", 10)
;WinSetState($hWnd, "", @SW_MAXIMIZE)

Func cmdRun($CMD)
   Run(@ComSpec & " /c " & $CMD, "", @SW_HIDE)
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

