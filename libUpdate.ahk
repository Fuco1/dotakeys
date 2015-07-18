;;##########################################################################################
;;#                                                                                        #
;;#    DotaKeys, the program that allows you to remap keys in Warcraft 3 map DotA:Allstars #
;;#    Copyright (C) 2005-2009  Matus Goljer                                               #
;;#                                                                                        #
;;#    This file is part of DotaKeys.                                                      #
;;#                                                                                        #
;;#    This program is free software; you can redistribute it and/or modify                #
;;#    it under the terms of the GNU General Public License as published by                #
;;#    the Free Software Foundation; either version 2 of the License, or                   #
;;#    (at your option) any later version.                                                 #
;;#                                                                                        #
;;#    This program is distributed in the hope that it will be useful,                     #
;;#    but WITHOUT ANY WARRANTY; without even the implied warranty of                      #
;;#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                       #
;;#    GNU General Public License for more details.                                        #
;;#                                                                                        #
;;#    You should have received a copy of the GNU General Public License                   #
;;#    along with DotaKeys; If not, see <http://www.gnu.org/licenses/>.                    #
;;#                                                                                        #
;;##########################################################################################

;;##########################################################################################
;; This file handles updating to a new version, or downgrading to last stable build


;###########################################################################################
;# Main Functions
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to check if there is new version available.
;; I will use HTTP over sockets, b/c HTTP is available on every PC, and i just dont have to
;; bother with sockets stuff :)


f_UpdateCheck()
{
global
;; For a fake/test update set fake to "fake/" else leave it blank
fake := "" ;;"fake/"
;regexmatch("14.-0.1.5", "^\d\.\d[-]\d.*?\.\d.*?\.\d.*?$")
;msgbox , http://gjgt.sk/~fuller/dotakeys/1.4/%fake%version_net.txt?file=42
UrlDownloadToFile , http://gjgt.sk/~fuller/dotakeys/1.4/%fake%version_net.txt?file=42, version_net.txt
if ( errorlevel = 1 )
	{
	msgbox , 4112, Error, There was an error when connecting to server!`nMake sure you are connected to the Internet and try again. If it will not work, the failure might be on our server.`nSorry for any inconveniences.
	fConnected = 0
	FileDelete , version_net.txt
	return -1
	}
FileReadLine , nVersion, version_net.txt, 1
if ( regexmatch(nVersion, "^\d\.\d[-]\d.*?\.\d.*?\.\d.*?$") = 0 )
	{
	FileDelete , version_net.txt
	return 0
	}
if ( nVersion <= sVersion )
	{
	FileDelete , version_net.txt
	return 0
	}
FileDelete , version_net.txt
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function that will download files, and create batch file to replace old after download

f_UpdateDownload()
{
global
FileCreateDir , update
FileDelete , update\move.bat
UrlDownloadToFile , http://gjgt.sk/~fuller/dotakeys/1.4/%fake%update_list.txt?file=42, update\update_list.txt
i:=0
Loop, read , update\update_list.txt
	{
	if ((SubStr(A_LoopReadLine,1,1) != "#" ) && (A_LoopReadLine != "" ))
		i++
	}
j:=0
Loop, read , update\update_list.txt
	{
	if ((SubStr(A_LoopReadLine,1,1) != "#" ) && (A_LoopReadLine != "" ))
		{
		j++
		StringSplit , sArray, A_LoopReadLine , %A_Space%
		StringSplit , filename, sArray1 , /
		file := filename%filename0%
		GuiControl ,, upgT_updatetext, Updating DotaKeys %sVersion% - %sArray1%
		UrlDownloadToFile , http://gjgt.sk/~fuller/dotakeys/1.4/%fake%%sArray1%?file=42, update\%file%
		FileAppend , copy /Y /V %file% ..\%sArray2%`n , update\move.bat
		GuiControl ,, upgP_total, % j*100/i
		}
	}
GuiControl ,, upgT_updatetext, Updating DotaKeys %sVersion% - Done
FileAppend , start ..\dotakeys.exe`n , update\move.bat
FileAppend , exit , update\move.bat
GuiControl , enable , bFinish
GuiControl ,, upgT_success, Update from version %sVersion% to version %nVersion% was successfuly comleted. Thanks for using DotaKeys.
IniWrite , %nVersion%, settings.ini, main, sVersion
;RunWait %comspec% /c move.bat , update
;ExitApp
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to rewrite/update settings.ini after succesfull update
;; It will add or replace all keys included in update_settings.ini

f_UpdateSettings()
{
global
if ( FileExist("update_settings.ini") != "" )
	{
	IniSectionGet("update_settings.ini","section")
	loop , % section0
		{
		IniKeyGet("update_settings.ini",section%A_Index%,"keylabel")
		i := A_Index
		loop , % keylabel0
			{
			iniread , pom , update_settings.ini , % section%i% , % keylabel%A_Index%
			iniwrite , %pom% , settings.ini , % section%i% , % keylabel%A_Index%
			}
		}
	FileDelete , update_settings.ini
	}
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to start updating

f_UpdateUpdate()
{
global
f_GUIDestroyUpdate2()
f_GUICreateUpdate4()
f_UpdateDownload()
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to cancel/deny updating

f_UpdateNoUpdate(flag=0)
{
global
if (flag = 0)
	f_GUIDestroyUpdate2()
else
	f_GUIDestroyUpdate3()
if ( fLoaded = 0 )
	{
	if ( A_IsCompiled = 1 )
		run , %A_WorkingDir%\dotakeys.exe /r /n
	else
		run , %A_AhkPath% /r %A_ScriptFullPath% /n
	}
return
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to finish and restart after successful update

f_UpdateFinish()
{
global
Run %comspec% /c move.bat , update
ExitApp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Added by Kitt
;; Function to update settings.ini in order to be compatable with Autocasting.

f_UpdateSettingsAutocast()
{
	IniRead , key, settings.ini, keys, key30
	if ( key = "ERROR" )
	{
		loop , 8
		{
			i := 30 - A_Index
			j := i + 1
			IniRead , key, settings.ini, keys, key%i%
			IniWrite , %key% , settings.ini, keys, key%j%
		}
		IniWrite , none , settings.ini, keys, key22
	}
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Added by Kitt
;; Function to update any old .dkp files in order to be compatable with Autocasting.

f_UpdateDKPFiles()
{
    ;; Find all files in the DotAKeys directory that have the extension .dkp, and modify them, one at a time.
    Loop, *.dkp, 0, 1
    {
            FileRead, FileContents, %A_LoopFileLongPath%        ;; Load each file's contents into a variable.
            IfNotInString, FileContents, key30                  ;; If the file doesn't contain "key30" then it needs to be updated.
            {
                Loop, Read, %A_LoopFileLongPath%                ;; Read and edit each line of the file, appending it to a temporary file.
                {
                    if(A_Index = 22)    ;; If the line contains key21 (Autocast 1), then we need to add key22 (Autocast 2) below it. (default value to "none")
                    {
                        FileAppend, %A_LoopReadLine%`nkey22=none`n, TempDKPFile
                    }
                    else if(A_Index > 22)   ;; If the line contains a key above key21 (Autocast 1), then we increase it's number by one, to make room for a new key22 (Autocast 2)
                    {
                        ;; we just use A_Index for its number because the Index is always one ahead of the key number (because of "[keys]" at the top of the file.
                        EditedLine := SubStr(A_LoopReadLine, 1, 3) . A_Index . SubStr(A_LoopReadLine, 6, StrLen(A_LoopReadLine))
                        FileAppend, %EditedLine%`n, TempDKPFile
                    }
                    else    ;; Otherwise, for any keys below key 21 (Autocast 1), don't change them.
                    {
                        FileAppend, %A_LoopReadLine%`n, TempDKPFile
                    }
                }

                ;; After we have generated an updated .dkp file, delete our old .dkp file, and make our temporary file (TempDKPFile) the new .dkp file.
                FileDelete, %A_LoopFileLongPath%
                FileMove, TempDKPFile, %A_LoopFileLongPath%
            }
    }
}
