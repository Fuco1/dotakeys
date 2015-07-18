;;##########################################################################################
;;#                                                                                        #
;;#    DotaKeys, the program that allows you to remap keys in Warcraft 3 map DotA:Allstars #
;;#    Copyright (C) 2005-2009  Matus Goljer                                               #
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

;; Made by: RegExReplace("C:\Program Files\AutoHotkey", "(^C)(?=\W).{4}((?i)[GOD])\w{1,4}\s(\D)(?:\w+)*\\(?3)(u|o).*?(k).*" , "$3$4$l1$5$2")
;; dota.keys@gmail.com
;; matus.goljer@gmail.com

;;##########################################################################################
;; Goals of this release ( 1.4, maybe even 2.0 ) are:
;; 1) DEBUG support ( error codes and stuff )
;; 2) Rewriting old parts of code, that can be done more efficient way
;; 3) Creating a little bit more organized source
;; 4) Add "plugin" support ( this may be useful in future )
;; 5) Eliminate most of "labels" and use functions instead ( better for debug, and generally more usefull )


;;##########################################################################################
;; This is the main file of DK project. Here you can find:
;; ----------------------------------------------
;; Updating stuff ( running updater and replacing files if update was succesful )
;; Directives and Main settings ( Variables init/load ... )
;; Hotkey definitions & labels
;; GUI handlers
;; Input handlers ( for codes and commands )
;; ----------------------------------------------
;; All actions here are handled by functions ( well most of them )
;;
;; I tried to do most of functions with some kind of "error capturing" Every function return 1 if
;; there was no error and 0 if there is error. This isnt usual, but i like it more. :)


;;##########################################################################################
;; List of Contributors
;; ----------------------------------------------
;; maTze: for his nice job regarding Lifebar updating
;; Neikius: and his work about herocodes
;; InvalidUser & TheIrishThug: for their .ini file parsers
;; Kitt: Autocast feature


;;##########################################################################################
;; List of Donors
;; ----------------------------------------------
;; John Szpicki



;###########################################################################################
;# Directives                                                                              #
;###########################################################################################

#SingleInstance force
#Persistent
#InstallKeybdHook
#MaxHotkeysPerInterval 200
#include libMainFunc.ahk
#include libGUI.ahk
#include libMacro.ahk
#include libEditor.ahk
#include libUpdate.ahk
#include libLanguage.ahk
#include libPreferences.ahk
;#include inc
;#include IEControl.ahk
;#include CoHelper.ahk



;###########################################################################################
;# Main Settings & Init                                                                    #
;###########################################################################################

;
;Progress, 50 ; Set the position of the bar to 50%.
;Sleep, 4000
;

;; Load strings for the progress & loading routines
iniread , sLanguage , settings.ini , main , sLanguage
f_LoadPreStrings()

Progress, R1-100 , %stage1%... , %loading%..., DotaKeys

;; Turn off all keys
suspend , on

;; Basic settings
gui , +Owner +Theme
SetWorkingDir , %A_ScriptDir%
gui ,font, s10, Western
SetKeyDelay , -1, -1
SetBatchLines -1
fLoaded = 0
fConnected = 1
OnExit , l_ExitLabel
Gui, +lastfound
hWnd := WinExist()
;msgbox BUBU
Progress, 10, %stage2%...
sleep , 180

;; Basic Variables
bDKState := 0  ;; 0 = disabled , 1 = enabled
bChatState := 0 ;; 0 = disabled , 1 = enabled ( this means console is on )
bLifeBarState := 0 ;; 0 = off , 1 = on

;; Registry loads
Regread , sName, HKEY_CURRENT_USER , Software\Blizzard Entertainment\Warcraft III\String, userbnet


Progress, 20 , %stage3%...

;; Install Files
FileCreateDir , %A_WorkingDir%\temp
FileInstall , d:\_ahk\warpath\dotakeys1.4\about.gif , %A_WorkingDir%\temp\about.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\ciara.bmp , %A_WorkingDir%\temp\ciara.bmp , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\update_available.gif , %A_WorkingDir%\temp\update_available.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\update_downloading.gif , %A_WorkingDir%\temp\update_downloading.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\update_checking.gif , %A_WorkingDir%\temp\update_checking.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\update_notfound.gif , %A_WorkingDir%\temp\update_notfound.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\line.gif , %A_WorkingDir%\temp\line.gif , 1
FileInstall , d:\_ahk\warpath\dotakeys1.4\paypal_donate.gif , %A_WorkingDir%\temp\paypal_donate.gif , 1
;msgbox BUBU

Progress, 25, %stage4%...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UPDATE
;;
;; Update will be added soon...
iniread , sVersion , settings.ini , main , sVersion
iniread , bAutoUpdate , settings.ini , flags , bAutoUpdate

;; clear old update folder
If ( FileExist("update") != "" )
	{
	FileRemoveDir , update , 1
	}

if ( bAutoUpdate = 1 )
	{
	if 1 != /n
       		{
       		if ( f_UpdateCheck() = 1 )
	  		{
			Progress, 100 , %stage5%...
			sleep 400
			Progress, off
			f_GUICreateUpdate2()
			return
			}
		}
	}
else
	{
	UrlDownloadToFile , http://gjgt.sk/~fuller/dotakeys/1.4/version_net.txt?file=42, version_net.txt
	if ( errorlevel = 1 )
		{
		fConnected = 0
		FileDelete , version_net.txt
		}
	}

fLoaded = 1

; update settings.ini
f_UpdateSettings()
f_UpdateSettingsAutocast()
f_UpdateDKPFiles()                                              ;; Added by Kitt to Update the old .dkp file to support Autocasting.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Progress, 30 , %stage6%...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOADING
;;
;; Loading of base settings such as dyn. hotkeys, paths to executables, version, macros and so on...


if ( f_LoadMainSettings() = 0 )
	{
	f_ErrorHandle("main")
	}
Progress, 35 , %stage7%...

if ( f_LoadFlags() = 0 )
	{
	f_ErrorHandle("flags")
	}
Progress, 40 , %stage8%...

if ( f_LoadKeys() = 0 )
	{
	f_ErrorHandle("keys")
	}
Progress, 45 , %stage9%...

if ( f_LoadCommands() = 0 )
	{
	f_ErrorHandle("commands")
	}
Progress, 50 , %stage10%...
sleep , 250

if ( f_LoadStrings() = 0 )
	{
	f_ErrorHandle("language")
	}
Progress, 55 , %stage11%...

if ( f_LoadQuickMsgs() = 0 )
	{
	f_ErrorHandle("message")
	}
Progress, 60 , %stage12%...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SETTING DYNAMIC HOTKEYS
;;
;; Settings and creating of dynamic hotkeys. This hotkeys will work only in W3

;; This should be always on, disable it only for testing purposes
if ( bKeysBoundToW3 = 1 )
	Hotkey , IfWinActive , Warcraft III

;; This loop will set skills, commands, items and "hero" skill ( the red + )
loop , 18
	{
	pom1 = label%A_Index%
	pom2 := kKey%A_Index%
	if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
		{
		hotkey , *$%pom2% , %pom1%
		}
	}

pom1 = l_LifeBars
pom2 := kKey19
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_CreepSkill
pom2 := kKey20
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_AutoCast1
pom2 := kKey21
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_AutoCast2
pom2 := kKey22
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

;; Quick messages ( 24-27 )
pom1 = l_QuickMsg1
pom2 := kKey25
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_QuickMsg2
pom2 := kKey26
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_QuickMsg3
pom2 := kKey27
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_QuickMsg4
pom2 := kKey28
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_HeroSelect
pom2 := kKey29
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_ToggleDKState
pom2 := kKey23
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_SetupAbilities
pom2 := kKey24
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

pom1 = l_Patrol
pom2 := kKey30
if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
	{
	hotkey , *$%pom2% , %pom1%
	}

loop, 4
	{
	pom1 = l_Arrow%A_Index%
	i := A_Index + 30
	pom2 := kKey%i%
	if (( isLabel( pom1 ) <> 0 ) and ( pom2 <> "none" ))
       		{
		hotkey , *$%pom2% , %pom1%
		}
	}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Static keys ( enter and stuff )

hotkey , ~*$Enter , l_Enter
hotkey , ~*$NumpadEnter , l_NumpadEnter
hotkey , ~*Esc , l_Esc
Progress, 70 , %stage13%...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI CREATION
;;
;; Create GUIs

if ( f_GUICreateMainMenu() = 0 )
	{
	Progress, hide
	msgbox ,16, Error, Can't create Main Menu!
	Progress, show
	}

if ( f_GUICreateTrayMenu() = 0 )
	{
	Progress, hide
	msgbox ,16, Error,Can't create Tray Menu!
	Progress, show
	}

if ( f_GUICreateControlPanel(bCP) = 0 )
	{
	Progress, hide
	msgbox ,16, Error, Can't create Control Panel!
	IfMsgBox OK
		ExitApp
	}
if ( bCP = 1 )
	{
	Gui , 1:+Disabled
	settimer , EnableWindow , 1000
	Progress, 80, %stage14%...
	}
else
	{
	Progress, off
	}
	;f_GUICreateControlPanel()

;Progress, Off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TIMERS
;;
;;

settimer , l_timedLifebarRefreshing , 2000
settimer , l_timedLifebarRefreshing , Off
SetTimer , l_timedWarcraftActive , 1000  ;run it once [TODO is there a nicer way to run a thread once?]

return

EnableWindow:
Gui , 1:-Disabled
Progress, off
settimer ,EnableWindow, off
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI LABELS & FUNCTIONS
;;
;; Handles for GUI controls

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Control Panel

l_MainQMsg1:
  gui , submit , nohide
  sQMsg1 := MainQMsg1
return

l_MainQMsg2:
  gui , submit , nohide
  sQMsg2 := MainQMsg2
return

l_MainQMsg3:
  gui , submit , nohide
  sQMsg3 := MainQMsg3
return

l_MainQMsg4:
  gui , submit , nohide
  sQMsg4 := MainQMsg4
return

l_MainCommandsSetup:
  f_GUICreatePreferences(3)
return

l_MainCustomCodesSetup:
  f_GUICreatePreferences(2)
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Main Menu

l_MenuReboot:
  reload
return

l_MenuExit:
  exitApp
return

l_MenuDKEditor:
  f_GUICreateEditor()
return

l_MenuMacroEditor:
return

l_MenuPreferences:
  f_GUICreatePreferences()
return

l_MenuHelp:
return

l_MenuHomepage:
  run , http://dotakeys.forumer.com
return

l_MenuDonate:
 run , https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=dota`%2ekeys`%40gmail`%2ecom&item_name=DotaKeys&no_shipping=0&no_note=1&tax=0&currency_code=EUR&lc=SK&bn=PP`%2dDonationsBF&charset=UTF`%2d8
return

l_MenuUpdate:
  f_GUICreateUpdate1()
  s:=0
  loop
	{
	if ( s < 100 )
		{
		s := s + rand(5,18)
		GuiControl ,, upgP_check , %s%
		sleep 80
		}
	else
		break
	}
  if ( f_UpdateCheck() = 1 )
	{
	;Progress, 100 , Update found! Updating...
	;sleep 400
	;Progress, off
	f_GUIDestroyUpdate1()
	f_GUICreateUpdate2()
	return
	}
  f_GUIDestroyUpdate1()
  f_GUICreateUpdate3()
return

l_MenuAbout:
  f_GUICreateAbout()
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for About Window

l_email:
  run , mailto:dota.keys@gmail.com
return

l_License:
  run , GNULicense.txt
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Tray Menu ( only those which are not common with main menu )

l_MenuShowHideCP:
  f_ShowHideCP(bCPisOn,iMiscWindow)
return

l_MenuToggleDKState:
  suspend
  f_ToggleDKState(1)
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Editor

l_EditorOpen:
  f_EditorLoadProfile()
return

l_EditorSave:
  f_EditorSaveProfile()
return

l_EditorSaveAs:
  f_EditorSaveAsProfile()
return

l_EditorClear:
return

l_EditorClearAll:
  f_EditorClearAll()
return

l_EditorDefault:
return

l_EditorDefaultSubmit:
GuiControlGet, FocusedControl, FocusV
if ( FocusedControl = "EditorListView" )
  {
  EditedKeyNum := LV_GetNext(0,"Focused")
  LV_GetText(EditedKeyCont, EditedKeyNum)
  f_GUICreateKeyWnd(EditedKeyCont)
  }
return

l_EditorLVEvent:
  if ( A_GuiEvent = "DoubleClick" )
	{
	EditedKeyNum := A_EventInfo
	LV_GetText(EditedKeyCont, EditedKeyNum)
	f_GUICreateKeyWnd(EditedKeyCont)
	}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Preferences

l_CBGenStatusChange:
  f_CBGenStatusChange(A_GuiControl)
return

l_DDLCommandChange:
  Gui, 3:submit, nohide
  f_DDLCommandChange(A_GuiControl)
return

l_BBrowseLang:
  f_BBrowseLang()
return

l_PrefListView1:
  Critical
  f_PrefListView1(A_GuiEvent,A_EventInfo,errorlevel)
return

l_PrefListView2:
  Critical
  f_PrefListView2(A_GuiEvent,A_EventInfo,errorlevel)
return

l_PrefCustomHeroSwitch:
  f_PrefCustomHeroSwitch()
return

l_PrefAddCode:
  f_GUICreateNewCodeWnd()
return

l_PrefDeleteCode:
  f_PrefDeleteCode(sCode,sCodeLine)
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Update

9GuiClose:
l_UpdateFinish:
  f_UpdateFinish()
return

7GuiClose:
l_UpdateLater:
  f_UpdateNoUpdate()
return

8GuiClose:
l_UpdateNoUpdate:
  f_UpdateNoUpdate(1)
return

l_UpdateUpdate:
  f_UpdateUpdate()
return

l_UpdateShowChangelog:
  run , http://www.gjgt.sk/~fuller/dotakeys/1.4/changelog.txt
return


;=====

l_EditorExit:
2GuiClose:
2GuiEscape:
  if ( f_EditorExitCheck() != 0 )
  	f_GUIDestroyEditor()
return

l_PreferencesExit:
3GuiClose:
3GuiEscape:
  f_GUIDestroyPreferences()
return

l_AboutExit:
4GuiClose:
4GuiEscape:
  f_GUIDestroyAbout()
return

l_KeyWndSubmit:
  Gui , 21:Submit , nohide
  f_EditorEditKey(EditedKeyNum)
  f_GUIDestroyKeyWnd()
return

l_CodeWndSubmit:
  Gui , 31:Submit , nohide
  ;msgbox % ddlcode "|" editcode "|" numcode "|" sCodeMode
  if ( DDLCode != "" )
	{
	sPom := DDLCode
	}
  else if ( EditCode != "" )
	{
	sPom := EditCode
	}
  else if ( EditNum != "" )
	{
	sPom := EditNum
	}
  f_PrefEditCode(sCodeLine,sCodeMode,sPom)
  f_GUIDestroyCodeWnd()
return

l_EditNewNum:
  Gui , 32:Submit , nohide
  if ( EditNewNum = 4 )
	{
	GuiControl , 32:Hide , DDLNewSkill5
	GuiControl , 32:Hide , DDLNewSkill6
	GuiControl , 32:Hide , TextNewSkill5
	GuiControl , 32:Hide , TextNewSkill6
	}
  if ( EditNewNum = 5 )
	{
  	GuiControl , 32:Show , DDLNewSkill5
	GuiControl , 32:Show , TextNewSkill5
	GuiControl , 32:Hide , DDLNewSkill6
	GuiControl , 32:Hide , TextNewSkill6
	}
  if ( EditNewNum = 6 )
	{
	GuiControl , 32:Show , DDLNewSkill5
  	GuiControl , 32:Show , DDLNewSkill6
	GuiControl , 32:Show , TextNewSkill5
	GuiControl , 32:Show , TextNewSkill6
	}
return

l_NewCodeWndSubmit:
  Gui , 32:Submit , nohide
  ;; Original line
  ;; f_PrefAddCode(EditNewCode,EditNewClass,EditNewNum,DDLNewSkill1,DDLNewSkill2,DDLNewSkill3,DDLNewSkill4,DDLNewSkill5,DDLNewSkill6)
  ;; Edited by Kitt for creating custom autocast
  f_PrefAddCode(EditNewCode,EditNewClass,EditNewNum,DDLNewSkill1,DDLNewSkill2,DDLNewSkill3,DDLNewSkill4,DDLNewSkill5,DDLNewSkill6,DDLNewSkill7,DDLNewSkill8)
  f_GUIDestroyNewCodeWnd()
return

l_NewHeaderWndSubmit:
  Gui , 33:Submit , nohide
  f_PrefEditCodeHeader(EditNewHeader,sCode,sCodeLine)
  f_GUIDestroyNewCodeHeaderWnd()
return


21GuiClose:
21GuiEscape:
  f_GUIDestroyKeyWnd()
return

31GuiClose:
31GuiEscape:
  f_GUIDestroyCodeWnd()
return

32GuiClose:
32GuiEscape:
  f_GUIDestroyNewCodeWnd()
return

33GuiClose:
33GuiEscape:
  f_GUIDestroyNewCodeHeaderWnd()
return

GuiClose:
  exitApp
return

GuiSize:
{
if errorlevel = 1
	{
	Gui , Cancel
       	Menu , Tray , Rename , %sh5% , %sh4%
      	bCPisOn := 0
	}
return
}


/*
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorOpen, %seb1%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorSave, %seb2%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorSaveAs, %seb3%
Gui , 2:Add, GroupBox, x328 y+5 w120 h126 cblack,
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorClear, %seb4%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorClearAll, %seb5%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorDefault, %seb6%
Gui , 2:Add, GroupBox, x328 y+5 w120 h46 cblack,
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorExit, %sb5%
*/




;###########################################################################################
;# HOTKEYS LABELS AND NON-DYNAMIC HOTKEYS                                                  #
;###########################################################################################



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for Toggling DK state  ( old F8 )


l_ToggleDKState:
  suspend
  IfWinActive , Warcraft III
	f_ToggleDKState()
  else
	f_ToggleDKState(1)  ;; executed from desktop  || add mode = 1 here later...
return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for Setuping ablilities manually ( old F7 )

l_SetupAbilities:
{
if ( bChatState = 0 )
	{
	f_ToggleChatState()
	}
Regread , sName, HKEY_CURRENT_USER , Software\Blizzard Entertainment\Warcraft III\String, userbnet
if ( bSilentMode = 0 )
	{
	clipboard = /w %sName% DotaKeys: Please type Hero's ORIGINAL hotkeys...
	ClipWait
	send {enter}^v{enter}
	}

Input , sSkillCode , L4 I
f_SetupManualBind(sSkillCode)
if ( bChatState = 1 )
	{
	f_ToggleChatState()
	}
return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Quick Messages

!F4:: send , {alt down}{F4}{alt up}

l_QuickMsg1:
{
f_SendQMsg(1)
return
}

l_QuickMsg2:
{
f_SendQMsg(2)
return
}

l_QuickMsg3:
{
f_SendQMsg(3)
return
}

l_QuickMsg4:
{
f_SendQMsg(4)
return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for LifeBars

l_LifeBars:
{
if ( bLifeBarState = 0 )
	bLifeBarState := 1
else
	bLifeBarState := 0
; refresh lifebars
OutputDebug , Toggle lifebars executed: new value is %bLifeBarState%
gosub l_refreshLifebars
return
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for Creeps

l_CreepSkill:
{
send , {t}
send , {w}
send , {g}
send , {f}
send , {b}
send , {r}
send , {c}
return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for AutoCast1 and AutoCast2

l_AutoCast1:
{
    ClickSkill(AutocastCoords1,"Right")
    return
}

l_AutoCast2:
{
    ClickSkill(AutocastCoords2,"Right")
    return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Skills

label1:
{
send , %ability1%
return
}

label2:
{
send , %ability2%
return
}

label3:
{
send , %ability3%
return
}

label4:
{
send , %ability4%
return
}

label5:
{
send , %ability5%

if ( bCreepSkill5 = 1 )
	{
	send , {t}
	send , {w}
	send , {g}
	send , {f}
	send , {b}
	send , {r}
	send , {c}
	}
return
}

label6:
{
send , %ability6%
return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Commands

label7:
{
send , %command1%
return
}

label8:
{
send , %command2%
return
}

label9:
{
send , %command3%
return
}

label10:
{
send , %command4%
return
}

l_Patrol:
{
send , %command6%
return
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Items

label11:
{
send , {Numpad7}
return
}

label12:
{
send , {Numpad8}
return
}

label13:
{
send , {Numpad4}
return
}

label14:
{
send , {Numpad5}
return
}

label15:
{
send , {Numpad1}
return
}

label16:
{
send , {Numpad2}
return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for New Skill

label17:
{
send , %command5%
return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for Hero Center & Hero Select

label18:
{
send , {F1}{F1}
return
}

l_HeroSelect:
{
send , {F1}
return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Label for Arrows

l_Arrow1:
{
;msgbox %kKey31%
send , {up down}
keywait , %kKey31%
send , {up up}
return
}

l_Arrow2:
{
;msgbox %kKey32%
send , {down down}
keywait , %kKey32%
send , {down up}
return
}

l_Arrow3:
{
;msgbox %kKey33%
send , {right down}
keywait , %kKey33%
send , {right up}
return
}

l_Arrow4:
{
;msgbox %kKey34%
send , {left down}
keywait , %kKey34%
send , {left up}
return
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Labels for Static Keys


l_Enter:
{
f_ToggleChatState()
return
}

l_NumpadEnter:
{
f_ToggleChatState()
return
}

l_Esc:
{
if ( bChatState = 1 )
	{
	f_ToggleChatState()
	}
return
}

*ScrollLock::
  suspend permit
  if ( bDKState = 1 )
	setscrolllockstate , on
  else
	setscrolllockstate , off
return

^l::
suspend
listhotkeys
return



;###########################################################################################
;# INPUT HANDLE                                                                            #
;###########################################################################################


~$NumpadDiv::
~$NumpadAdd::
~$\::
{
Regread , sName, HKEY_CURRENT_USER , Software\Blizzard Entertainment\Warcraft III\String, userbnet
Input ,  sHeroCode , V L4 I
f_SetupAutoBind(sHeroCode)
return
}


;###########################################################################################
;# TIMERS SUBROUTINES                                                                      #
;###########################################################################################


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check if WC3 is active ( The main work on this part is done by maTze, i just improved it a little bit :)
;;
;; [ to enable/disable lifebar refresh ]

; This function enables/disables the refreshing of the lifebars. When WC3 is
; the active window, refreshing is enabled.
l_timedWarcraftActive:
{
    ; wait till wc3 is active, then enable lifebars
    WinWaitActive, Warcraft III
    OutputDebug , Warcraft III has been activated, lifebar timer active
    SetTimer , l_timedLifebarRefreshing , On

    ; wait till wc3 becomes inactive. turn lifebar refreshing off. set lifebars to false
    WinWaitNotActive, Warcraft III
    OutputDebug , Warcraft III has been deactivated, lifebar timer shutdown
    SetTimer , l_timedLifebarRefreshing , Off
    ; manually down the keys
    ;bLifeBarState_ := bLifeBarState
    ;bLifeBarState := 0
    ;gosub , l_refreshLifebars
    ;bLifeBarState := bLifeBarState_
    f_assureDown("[" , 0)
    f_assureDown("]" , 0)
    f_assureDown("ú" , 0)
    f_assureDown(")" , 0)
    ;f_assureDown("ß" , hasToBeDown)
    f_assureDown("´" , hasToBeDown)
    f_assureDown("^" , hasToBeDown)
return
}


;;########################################################
;;#  Timer dealing with retoggling lifebars		 #
;;#                                                      #
;;#                                                      #
;;#                                                      #
;;########################################################

l_timedLifebarRefreshing:
{
  ; just do a refresh
  if ( bChatState = 0 )
  	gosub l_refreshLifebars
  return
}

; performs a refresh of the lifebar key states [perform a up/down if required]
l_refreshLifebars:
{
        OutputDebug , Actual value is %bLifeBarState%
	hasToBeDown := 0
	if ( bLifeBarState = 1 )
		hasToBeDown := 1

	;f_assureDown("ß" , hasToBeDown)
	f_assureDown("´" , hasToBeDown)
	;f_assureDown("l" , hasToBeDown)
	;f_assureDown("ä" , hasToBeDown)
	f_assureDown("ú" , hasToBeDown)
	f_assureDown(")" , hasToBeDown)
	f_assureDown("[" , hasToBeDown)
	f_assureDown("]" , hasToBeDown)
	f_assureDown("^" , hasToBeDown)
	return
}

; executes the down/up of the given key corresponding to the value of isdown
; isdown = 1 => key has to be down; isdown = 0 => key has to be up
f_assureDown(key, isdown)
{
state := GetKeyState(key)
;OutputDebug , % "Actual key state(1): " GetKeyState(key)
; have to set down?
if ( state = 0 )
	{
	if ( isdown = 1 )
		{
		; key is up
	  	OutputDebug , Setting key state of key %key% to down
	  	Send , {%key% down}
    		}
	}

; have to set up?
;OutputDebug , % "Actual key state(2): " GetKeyState(key)
if ( state = 1 )
	{
	if ( isdown = 0 )
		{
	  	; key is down and has to be upped
	  	OutputDebug , Setting key state of key %key% to up
	  	Send , {%key% up}
		}
	}
;OutputDebug , % "Actual key state(3): " GetKeyState(key)
return
}


;###########################################################################################
;# Exit Label                                                                              #
;###########################################################################################

l_ExitLabel:
{
a=1
setscrolllockstate , off
FileRemoveDir , %A_WorkingDir%\temp , 1
iniwrite , %sQMsg1% , settings.ini , messages, sQMsg1
iniwrite , %sQMsg2% , settings.ini , messages, sQMsg2
iniwrite , %sQMsg3% , settings.ini , messages, sQMsg3
iniwrite , %sQMsg4% , settings.ini , messages, sQMsg4
exitApp
return
}
