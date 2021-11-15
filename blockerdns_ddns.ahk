#SingleInstance, Force
#Persistent
SendMode Input
SetWorkingDir, %A_ScriptDir%

Menu, tray, Add
Menu, tray, Add, Enable running at startup, enableHandler
Menu, tray, Add, Disable running at startup, disableHandler

name = blockerDNS-DDNS
baseurl = dns.blockerdns.com

IniRead, basicusername, blockerdnssettings.ini, Settings, BasicUsername, 0
IniRead, basicpassword, blockerdnssettings.ini, Settings, BasicPassword, 0

if ( basicusername != 0 and basicpassword != 0 ) {
    url := "https://" baseurl "?username=" basicusername "&password=" basicpassword
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
    response := whr.ResponseText
    IniWrite, %A_Now%, blockerdnssettings.ini, Log, LastUpdate
    IniWrite, %response%, blockerdnssettings.ini, Log, LastUpdateResult
}
else {
    InputBox, basicusernamenew, Setup, Enter username
    if ErrorLevel
        ExitApp

    InputBox, basicpasswordnew, Setup, Enter password
    if ErrorLevel
        ExitApp

    IniWrite, %basicusernamenew%, blockerdnssettings.ini, Settings, BasicUsername
    IniWrite, %basicpasswordnew%, blockerdnssettings.ini, Settings, BasicPassword

    Reload
}

SetTimer, Update, 60000
return

Update:
    name = blockerDNS DDNS
    baseurl = dns.blockerdns.com

    IniRead, basicusername, blockerdnssettings.ini, Settings, BasicUsername, 0
    IniRead, basicpassword, blockerdnssettings.ini, Settings, BasicPassword, 0

    if ( basicusername != 0 and basicpassword != 0 ) {
        url := "https://" baseurl "?username=" basicusername "&password=" basicpassword
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, true)
        whr.Send()
        whr.WaitForResponse()
        response := whr.ResponseText
        IniWrite, %A_Now%, blockerdnssettings.ini, Log, LastUpdate
        IniWrite, %response%, blockerdnssettings.ini, Log, LastUpdateResult
    }
    else {
        InputBox, basicusernamenew, Setup, Enter username
        if ErrorLevel
            ExitApp

        InputBox, basicpasswordnew, Setup, Enter password
        if ErrorLevel
            ExitApp

        IniWrite, %basicusernamenew%, blockerdnssettings.ini, Settings, BasicUsername
        IniWrite, %basicpasswordnew%, blockerdnssettings.ini, Settings, BasicPassword

        Reload
    }
Return

enableHandler() {
    name = blockerDNS-DDNS
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run,%name%,%A_ScriptFullPath%
}

disableHandler() {
    name = blockerDNS-DDNS
    RegDelete, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run,%name%
}