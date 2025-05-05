#include <MsgBoxConstants.au3>
HotKeySet("+!e", "Terminate")
Global $sAnswer = InputBox("Sleep Cancell", "Time", "", "", 50, 125) * 1000

While 1
    Sleep($sAnswer)
	MsgBox($MB_SYSTEMMODAL, "Title", "This message box will timeout after 10 seconds or select the OK button.", 5)
WEnd

Func Terminate()
   Exit
EndFunc