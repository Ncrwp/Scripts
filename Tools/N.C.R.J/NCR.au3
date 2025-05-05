#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <Clipboard.au3>
#include <Date.au3>
;#RequireAdmin
Opt("MouseCoordMode", 0)
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
HotKeySet("+!t", "Terminate")

HotKeySet("^1", "KeySend1")
HotKeySet("^2", "KeySend2")
HotKeySet("^3", "KeySend3")
HotKeySet("^4", "KeySend4")
HotKeySet("^5", "KeySend5")
HotKeySet("^6", "KeySend6")
HotKeySet("^7", "KeySend7")
HotKeySet("^8", "KeySend8")
HotKeySet("^9", "KeySend9")

Global $Answer1 = ""
Global $Answer2 = ""
Global $Answer3 = ""
Global $Answer4 = ""
Global $Answer5 = ""
Global $Answer6 = ""
Global $Answer7 = ""
Global $Answer8 = ""
Global $Answer9 = ""

GUI()

Func GUI()
   if _OSVersion() < 6 Then
	  $paintNm = "untitled"
	  Else
	  $paintNm = "Untitled"
   EndIf

    ; Create a GUI with various controls.
    Global $hGUI = GUICreate("N.C.R", 170, 275)

    ; Create Label controls.
	Global $infoLb = GUICtrlCreateLabel("Auto Fill TOOL", 5, 5, 165, 25)
	Global $infoLb1 = GUICtrlCreateLabel("ctrl + 1", 5, 27, 35, 20)
	Global $infoLb2 = GUICtrlCreateLabel("ctrl + 2", 5, 52, 35, 20)
	Global $infoLb3 = GUICtrlCreateLabel("ctrl + 3", 5, 77, 35, 20)
	Global $infoLb4 = GUICtrlCreateLabel("ctrl + 4", 5, 102, 35, 20)
	Global $infoLb5 = GUICtrlCreateLabel("ctrl + 5", 5, 127, 35, 20)
	Global $infoLb6 = GUICtrlCreateLabel("ctrl + 6", 5, 152, 35, 20)
	Global $infoLb7 = GUICtrlCreateLabel("ctrl + 7", 5, 177, 35, 20)
	Global $infoLb8 = GUICtrlCreateLabel("ctrl + 8", 5, 202, 35, 20)
	Global $infoLb9 = GUICtrlCreateLabel("ctrl + 9", 5, 227, 35, 20)
    Global $exitLb = GUICtrlCreateLabel("Exit (shift + alt + T)", 75, 254, 165, 25)

    ; Create a Text control.
	Global $send1 = GUICtrlCreateInput("", 50, 25, 115, 20)
	Global $send2 = GUICtrlCreateInput("", 50, 50, 115, 20)
	Global $send3 = GUICtrlCreateInput("", 50, 75, 115, 20)
	Global $send4 = GUICtrlCreateInput("", 50, 100, 115, 20)
	Global $send5 = GUICtrlCreateInput("", 50, 125, 115, 20)
	Global $send6 = GUICtrlCreateInput("", 50, 150, 115, 20)
	Global $send7 = GUICtrlCreateInput("", 50, 175, 115, 20)
	Global $send8 = GUICtrlCreateInput("", 50, 200, 115, 20)
	Global $send9 = GUICtrlCreateInput("", 50, 225, 115, 20)

    ; Create a Buttons control.
    Local $idButton_Set = GUICtrlCreateButton("Set", 5, 250, 60, 25)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()

            Case $idButton_Set
			    $Answer1 = GUICtrlRead($send1)
			    $Answer2 = GUICtrlRead($send2)
			    $Answer3 = GUICtrlRead($send3)
			    $Answer4 = GUICtrlRead($send4)
			    $Answer5 = GUICtrlRead($send5)
			    $Answer6 = GUICtrlRead($send6)
			    $Answer7 = GUICtrlRead($send7)
			    $Answer8 = GUICtrlRead($send8)
			    $Answer9 = GUICtrlRead($send9)

			Case $GUI_EVENT_CLOSE
				ExitLoop

        EndSwitch
    WEnd


    GUIDelete($hGUI)
EndFunc

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
 EndFunc   ;==>_IsChecked

Func Terminate()
   Exit
EndFunc

Func KeySend1()
	  Send ($Answer1)
EndFunc

Func KeySend2()
   Send ($Answer2)
EndFunc

Func KeySend3()
   Send ($Answer3)
EndFunc

Func KeySend4()
   Send ($Answer4)
EndFunc

Func KeySend5()
   Send ($Answer5)
EndFunc

Func KeySend6()
   Send ($Answer6)
EndFunc

Func KeySend7()
   Send ($Answer7)
EndFunc

Func KeySend8()
   Send ($Answer8)
EndFunc

Func KeySend9()
   Send ($Answer9)
EndFunc


Func _OSVersion($sHostName = @ComputerName)
   Local $sOSVersion = RegRead('\\' & $sHostName & '\HKLM\Software\Microsoft\Windows NT\CurrentVersion', 'CurrentVersion')
   if @error Then Return SetError(1, 0, 0)
   Return Number($sOSVersion)
   EndFunc
