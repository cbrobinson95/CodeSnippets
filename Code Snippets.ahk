#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

paragraph1 =
(
This is a descriptive paragraph.
Maybe it has instructions.
All we know is that it has multiple lines.
)

paragraph2 =
(
Click here first to get the command
for retrieving Interface Index:
)

GuiMainStart:
Gui, Main:Destroy
Gui, Main:Show, w275 h150
;Gui, Main:Add, Text,, %paragraph1%
Gui, Main:Add, Text,, Select your code snippet:
Gui, Main:Add, Checkbox, x+60 vLocalMode, Local Mode
Gui, Main:Add, Radio, xs vRadio1, Disable Password Expiration
Gui, Main:Add, Radio, vRadio2, Set DNS servers
Gui, Main:Add, Radio, vRadio3, List Printers
Gui, Main:Add, Radio, vRadio4, Rename Printer
Gui, Main:Add, Text,,
Gui, Main:Add, Button, default, OK
Gui, Main:Add, Button, x+20, Clear Selection
return

MainGuiClose:
Gui, Cancel
;MsgBox, Cancelled or closed.
ExitApp
return

MainButtonClearSelection:
GuiControl,,Radio1,0
GuiControl,,Radio2,0
GuiControl,,Radio3,0
GuiControl,,Radio4,0
return

MainButtonOK:
Gui, Submit
if (Radio1 = 1) {
    gosub DPE
    ExitApp
} else if (Radio2 = 1) {
    gosub DNS
} else if (Radio3 = 1) {
    gosub LP
    ExitApp
} else if (Radio4 = 1) {
    gosub RP
} else {
    MsgBox, You must make a selection.
    gosub GuiMainStart
}
return

; ----------------------------------------------------------------

DPE:
InputBox, Username, Disable PW Expiry, Enter a username: , ,200,125
if (ErrorLevel == 1) {

} else {
    if (Username = "") {
        MsgBox, 0,, Value cannot be blank!
        gosub DPE
    } else {
        if (LocalMode = 1) {
            Send, #r
            Sleep, 1000
            Send, powershell
            Send, {Enter}
            Sleep, 2000
            Send, WMIC USERACCOUNT WHERE Name="%Username%" SET PasswordExpires=FALSE
            Send, {Enter}
            return
        }
            Clipboard := "WMIC USERACCOUNT WHERE Name='" . Username . "' SET PasswordExpires=FALSE"
            TrayTip Woohoo!,Code snippet generated and copied to clipboard
            Sleep 5000
            HideTrayTip() {
        	    TrayTip
            }
        }
}
return

; ----------------------------------------------------------------

DNS:
Index :=
DNSprimary :=
DNSsecondary :=
DNS2:
Gui, 2:Default
Gui, 2:Show, w275 h255
;Gui, 2:Add, Text,, %paragraph1%
Gui, 2:Add, Text,, %paragraph2%
Gui, 2:Add, Button, x+20, Get it
Gui, 2:Add, Text, xs, Then fill out the following fields:
Gui, 2:Add, Text,, Interface Index:
Gui, 2:Add, Edit, w100 vIndex, %Index%
Gui, 2:Add, Text,, Primary DNS:
Gui, 2:Add, Edit, w100 vDNSprimary, %DNSprimary%
Gui, 2:Add, Text,, Secondary DNS:
Gui, 2:Add, Edit, w100 vDNSsecondary, %DNSsecondary%
Gui, 2:Add, Text,,
Gui, 2:Add, Button, default, OK
Gui, 2:Add, Button,x+20, Set to DHCP
Gui, 2:Add, Text, x+5, <-- Just enter Index
return

2GuiClose:
Gui, 2:Cancel
ExitApp
return

2ButtonGetit:
Clipboard := "Get-DnsClientServerAddress"
TrayTip Command copied to clipboard, Paste into Powershell on target system
Sleep 5000
HideTrayTip()
return

2ButtonSettoDHCP:
Gui, Submit
if (Index = "") {
    MsgBox, 0,, Index cannot be blank!
    Gui,2:Destroy
    gosub DNS2
} else {
    if (LocalMode = 1) {
        Send, #r
        Sleep, 1000
        Send, powershell
        Send, {Enter}
        Sleep, 2000
        Send, Set-DnsClientServerAddress -InterfaceIndex "%Index%" -ResetServerAddresses
        ExitApp
        return        
    } else {
    Clipboard := "Set-DnsClientServerAddress -InterfaceIndex '" . Index . "' -ResetServerAddresses"
    TrayTip Woohoo!,Code snippet generated and copied to clipboard
    Sleep 5000
    HideTrayTip()
    ExitApp
}
}
return

2ButtonOK:
Gui, Submit

if (Index = "" and DNSprimary = "") {
    MsgBox, 0,, Index and Primary DNS cannot be blank!
    Gui, 2:Destroy
    gosub DNS2
} else if (Index = "") {
    MsgBox, 0,, Index cannot be blank!
    Gui, 2:Destroy
    gosub DNS2
} else if (DNSprimary = "") {
    MsgBox, 0,, Primary DNS cannot be blank!
    Gui, 2:Destroy
    gosub DNS2
} else {
    if (LocalMode = 1) {
        Send, #r
        Sleep, 1000
        Send, powershell
        Send, {Enter}
        Sleep, 2000
        Send, Set-DnsClientServerAddress -InterfaceIndex "%Index%" -ServerAddresses ("%DNSprimary%", "%DNSsecondary%")
        ExitApp
        return
    } else {
        Clipboard := "Set-DnsClientServerAddress -InterfaceIndex '" . Index . "' -ServerAddresses ('" . DNSprimary . "','" . DNSsecondary . "')"
        TrayTip Woohoo!,Code snippet generated and copied to clipboard
        Sleep 5000
        HideTrayTip()  
        ExitApp
    }
}
return

; ----------------------------------------------------------------

LP:
if (LocalMode = 1) {
    Send, #r
    Sleep, 1000
    Send, powershell
    Send, {Enter}
    Sleep, 2000
    Send, Get-Printer | Format-List Name,Location,Portname,Status
    Send, {Enter}
    return
} else {
    Clipboard := "powershell.exe -command " "Get-Printer | Format-List Name,Location,Portname,Status"
    TrayTip Woohoo!,Code snippet generated and copied to clipboard
    Sleep 5000
    HideTrayTip()
    return
}
return

; ----------------------------------------------------------------

RP:
OldName :=
NewName :=
RP2:
Gui, 3:Default
Gui, 3:Show, w275 h175
;Gui, 3:Add, Text,, %paragraph1%
Gui, 3:Add, Text,, Fill out the following fields:
Gui, 3:Add, Text,, Old Name:
Gui, 3:Add, Edit, w100 vOldName, %OldName%
Gui, 3:Add, Text,, New Name:
Gui, 3:Add, Edit, w100 vNewName, %NewName%
Gui, 3:Add, Text,,
Gui, 3:Add, Button, default, OK
return

3GuiClose:
Gui, 3:Cancel
ExitApp
return
3ButtonOK:
Gui, Submit
GuiControlGet, OldName
GuiControlGet, NewName
if (OldName = "" and NewName = "") {
    MsgBox, 0,, Literally why would you leave them both blank
    Gui, 3:Destroy
    gosub RP2
} else if (OldName = "" or NewName = "") {
        MsgBox, 0,, Values cannot be blank!
        Gui, 3:Destroy
        gosub RP2
        } else {
            if (LocalMode = 1) {
                Send, #r
                Sleep, 1000
                Send, powershell
                Send, {Enter}
                Sleep, 2000
                Send, Rename-Printer -Name "%OldName%" -NewName "%NewName%"
                Send, {Enter}
                ExitApp
                return
                } else {
                    Clipboard := "Rename-Printer -Name '" . OldName . "' -NewName '" . NewName . "'"
                    TrayTip Woohoo!,Code snippet generated and copied to clipboard
                    Sleep 5000
                    HideTrayTip()
                    ExitApp
            }
        }
return
