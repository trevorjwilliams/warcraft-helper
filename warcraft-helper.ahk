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

WowDir := "C:\Program Files (x86)\World of Warcraft"
LogFile := WoWDir . "\Logs\WoWCombatLog.txt"
EnvGet, LogLauncher, ProgramFiles(x86)
LogLauncher := LogLauncher . "\Warcraft Logs Uploader\Warcraft Logs Uploader.exe"
LogWindow := "Warcraft Logs Uploader"

; Would be nice if there were something like Perl's qw() I could use here.
all_binds := [";","q",".","p","y","j","x","1","2","3","4","5","6","u","i","k"]
; Would be REAL nice if I could add newlines in the object definition.
spam_binds := {"u": 1,"i": 1,"k": 1}

BindKeys()
StartLogging()
StartWOW()
WinWaitClose, World of Warcraft
WinClose, %LogWindow%
DeleteFile(LogFile)

ExitApp

f1:: ; toggles all button-repeating behavior
suspend
gosub STOPSPAM
return

~enter:: ; temporarily disables all hotkeys for a few seconds (enough time to send a chat message without the script interfering)
gosub STOPSPAM
suspend on
sleep 20000
suspend off
return

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

BindKeys() {
	global all_binds
	global spam_binds

	for key, value in all_binds
	{
		if spam_binds[value]
		{
			hotkey, $%value%, KEYPRESS, T3
		}
		else
		{
			hotkey, ~%value%, STOPSPAM
		}
	}
}

StartWOW() {
	IfWinNotExist, World of Warcraft
	{
		global WoWDir

		Run battlenet://WoW
		WinWaitActive, World of Warcraft
	}
}

StartLogging() {
	global LogWindow
	IfWinNotExist, %LogWindow%
	{
		global LogFile
		global LogLauncher

		IfNotExist, %LogFile%
		{
			FileAppend,, %LogFile% ; create an empty log file
			If ErrorLevel
				MsgBox, Error creating %LogFile%
		}
		Run %LogLauncher%
		WinWaitActive, %LogWindow%
		Sleep 1000
		Send {tab 2}{space}
		Send {tab 5}{space}
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