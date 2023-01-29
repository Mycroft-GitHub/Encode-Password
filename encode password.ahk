/*============================================================
Dynamic Password  from Reddit Post
Reddit Link:  https://www.reddit.com/r/AutoHotkey/comments/10o18my/i_need_to_remap_a_key_each_day_for_a_dynamically/
Modified from Joe Glines' approach from the-Automator.com  [They are great for beginners to learn! Give them a follow.]
YouTube Chanel:  https://www.youtube.com/@JoeGlines-Automator
Simple Encrypt / Decrypt functions so you don't store your passwords as plain text:  https://www.youtube.com/watch?v=bYIuZ1u3Ux0

Uses F1 to encode a password and F2 to decode the password.  Change to your preference.
Remove message boxes when you no longer want to see the process.

NOTE:  I am sure this approach could be improved.  However, it works based on the post requirements and was fun for a QUICK try.
=============================================================
Last Updated:  January 29, 2023 5:45 AM
=============================================================
*/

#SingleInstance, Force										;	Limit on running version of this script.
#NoEnv																;	Avoids checking empty variables to see if they are environment variables.
#Requires AutoHotkey v1.1.33+						;	Displays an error and quits if a version requirement is not met.
SetWorkingDir %A_ScriptDir%							;	Ensures a consistent starting directory for the location of this script.
Menu, Tray, Icon, shell32.dll, 45							;	Tray Icon selection.

ini_folder := A_ScriptDir . "\Settings"					;	INI stored in Settings folder
settings_ini = %ini_folder%\dynamic.ini				;	INI path and file name

Constant:="51239946"										; Change this value to any numeric value you want for password encoding.


; =============================================================
F1::																		;	Hotkey to encode new password.
; ********************  Encode  ********************
	InputBox, Pass, Encode,Dynamic Password to encode?,,400,150
	if ErrorLevel
	{
		MsgBox, CANCEL was pressed.
		return
	}
	else
	Encoded:=Encrypt(Pass,Constant)
	FileDelete, %settings_ini%
	; ********************  Decoded  ********************
	MsgBox, % "----- Encoded Password----- `n" Encoded "`n`n----- Decoded Password -----`n" Decrypt(Encoded,Constant) "`n`nNOTE:  Use your hotkey to retrieve your stored password."
	gosub, Dynamic
	return

Encrypt(OutputVar,Constant){
	Loop, Parse, OutputVar
	{
		GuiControl,, Char, %A_LoopField%
		Transform, OutputVar, Asc, %A_LoopField%
		Outputvar-=Constant, NewVar.=OutputVar . "a"
		}Return, NewVar
}

Decrypt(OutputVar,Constant){
	Loop, Parse, OutputVar, a
		Decrypted.= (Chr(A_LoopField+Constant))
		return, Decrypted
}

Dynamic:
	If !FileExist(ini_folder) {  										;	Verify ini folder path exists, create if not
        FileCreateDir, %ini_folder%
    }
    IniWrite, %Encoded%, %settings_ini% , Dynamic, ;	Write encoded password to the INI file.
return

; =============================================================
F2::																				;	Hotkey to retrive and decrypt current password.
IniRead, Encoded, %settings_ini%, Dynamic
Password := Decrypt(Encoded,Constant)
MsgBox, % "----- Encoded Password ----- `n" Encoded "`n`n----- Decoded Password ----- `n" Password "`n`nNOTE:  The decoded password will sent to the active Window.  Remove this message box when you no longer want to see it."
Send, % Password
return

!esc::ExitApp																;	[Alt]+[Esc] to exit the app
