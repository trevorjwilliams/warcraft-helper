;
; AutoHotkey Version: 1.0.48
; Language:       English
; Platform:       Win9x/NT
; Author:         Trevor Williams
;
; Script Function:
;	Pressing any of the defined "keybinds" will start spamming that button until either a second keybind is pressed, the first keybind is pressed again, or enter is pressed.  Useful so that the user doesn't need to spam an ability manually to ensure its fastest possible execution in WoW.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetKeyDelay, 100 ; This only works when we switch the SendMode, but we always want this value when we switch it.

WowDir := "C:Program Files (x86)\World of Warcraft"
LogFile := WoWDir . "\Logs\WoWCombatLog.txt"
Password := "hopefully something secure, though this really isn't needed anymore with the battle.net launcher"
WOLLauncher := A_Desktop . "\WoL.jnlp"

BindKeys()
;StartWOLInteractive()
;StartWOW()
WinWaitClose, World of Warcraft
WinClose, World of Logs - Live Report Updater
DeleteFile(LogFile)

ExitApp

f1:: ; toggles all button-repeating behavior
suspend
gosub STOPSPAM
return

~enter:: ; temporarily disables all hotkeys for a few seconds (enough time to send a chat message without the script interfering)
gosub STOPSPAM
suspend on
sleep 10000
suspend off
return

BindKeys() {
	spambinds := "2,3,4"
	loop,parse,spambinds,CSV
	{
		hotkey, $%A_LoopField%, KEYPRESS, T3
	}

	stopbinds := "1,5,6,7,8,9,0,left,right,-,=,numpaddot,numpad0,numpad1,numpad2,numpad3,numpad4,numpad6,numpad7,numpad8,up,down,[,],end,NumpadMult,``"
	loop,parse,stopbinds,CSV
	{
		hotkey, ~%A_LoopField%, STOPSPAM
	}
}

STOPSPAM:
Spamkey := false
return

KEYPRESS:
if not SpamKey
{
	SpamKey := SubStr(A_ThisHotkey, 2)
	loop
	{
		if not SpamKey
			break
		else
			if StrLen(SpamKey) > 1
			{
				Send {%SpamKey%}
			}
			else
			{
				Send %SpamKey%
			}
			Random, rand, -5, 5
			Sleep (50 + rand)
	}
	return
}
else
{
	SpamKey := SubStr(A_ThisHotkey, 2)
	return
}

StartWOW() {
	IfWinNotExist, World of Warcraft
	{
		global WoWDir
		global Password

		Run %WoWDir%\Wow-64.exe
		;WinWaitActive, World of Warcraft
		;Sleep 7000
		;Send %Password%{Enter}
	}
}

StartWOLInteractive() {
	IfWinNotExist, World of Logs - Live Report Updater
	{
		global LogFile
		global WOLLauncher

		IfNotExist, %LogFile%
		{
			FileAppend,, %LogFile% ; create an empty log file
			If ErrorLevel
				MsgBox, Error creating %LogFile%
		}
		Run %WOLLauncher%
		WinWaitActive, World of Logs - Data Uploader
		SendMode Event ; We need delays between keypresses for java apps and Input doesn't support delays
		Sleep 1000
		Send +{tab}{space}
		SendMode Input
	}
}

DeleteFile(fileName) {
	FileGetSize, fileSize, %fileName%
	if (fileSize) {
		try {
			FileRecycle, %fileName%
		}
		catch {
			MsgBox, Error deleting %fileName%
			Exit
		}
	}
}