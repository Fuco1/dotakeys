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
;; In this file are all basic and mostly initialisation functionm, then status manipulating
;; functions and utility functions.


;###########################################################################################
;# INI Loading Functions                                                                   #
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for loading Main Settings

f_LoadMainSettings()
{
global
iniread , sVersion , settings.ini , main , sVersion
if ( sVersion = "ERROR" )
	return 0

iniread , sPath , settings.ini , main , sPath
if ( sPath = "ERROR" )
	return 01

iniread , iNumKeys , settings.ini , main , iNumKeys
if ( iNumKeys = "ERROR" )
	return 0

iniread , iNumMacro , settings.ini , main , iNumMacro
if ( iNumMacro = "ERROR" )
        return 0

iniread , sLanguage , settings.ini , main , sLanguage
if ( sLanguage = "ERROR" )
        return 0

iniread , sProfile , settings.ini , main , sProfile
if ( sProfile = "ERROR" )
        return 0

return 1
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for loading Flags

f_LoadFlags()
{
global
iniread , bAutoUpdate , settings.ini , flags , bAutoUpdate
if ( bAutoUpdate = "ERROR" )
	return 0

iniread , bCP , settings.ini , flags , bCP
if ( bCP = "ERROR" )
	return 0

iniread , bToolTip , settings.ini , flags , bToolTip
if ( bToolTip = "ERROR" )
	return 0

iniread , bSilentMode , settings.ini , flags , bSilentMode
if ( bSilentMode = "ERROR" )
	return 0

iniread , bLED , settings.ini , flags , bLED
if ( bLED = "ERROR" )
	return 0

iniread , bKeysBoundToW3 , settings.ini , flags , bKeysBoundToW3
if ( bKeysBoundToW3 = "ERROR" )
	return 0

iniread , bEditReplaceHotKeys , settings.ini , flags , bEditReplaceHotKeys
if ( bEditReplaceHotKeys = "ERROR" )
	return 0

iniread , bCreepSkill5 , settings.ini , flags , bCreepSkill5
if ( bCreepSkill5 = "ERROR" )
	return 0

return 1
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for loading keys ( not user-configs but actual keys )

f_LoadKeys()
{
global
loop , %iNumKeys%
	{
	iniread , kKey%A_Index% , settings.ini , keys , key%A_Index%
	if ( kKey%A_Index% = "ERROR" )
		{
		kKey%A_Index% := "none"
		iniwrite , none , settings.ini , keys , key%A_Index%
		;return 0
		;break
		}
	}
return 1
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for loading Commands

f_LoadCommands()
{
global
loop , 6
	{
	iniread , command%A_Index% , settings.ini , commands , command%A_Index%
	if ( command%A_Index% = "ERROR" )
		{
		if ( A_index = 1 )
			command%A_Index% := "m"
		else if ( A_Index = 2 )
			command%A_Index% := "s"
		else if ( A_Index = 3 )
			command%A_Index% := "h"
		else if ( A_Index = 4 )
			command%A_Index% := "a"
		else if ( A_Index = 5 )
			command%A_Index% := "o"
		else if ( A_Index = 6 )
			command%A_Index% := "p"
		iniwrite , % command%A_Index% , settings.ini , commands , command%A_Index%
		;return 0
		;break
		}
	}
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function for loading Quick messages

f_LoadQuickMsgs()
{
global
loop , 4
	{
	iniread , sQMsg%A_Index% , settings.ini , messages , sQMsg%A_Index%
	if ( sQMsg%A_Index% = "ERROR" )
		{
		return 0
		break
		}
	}
return 1
}




;###########################################################################################
;# "Setup" commands ( old F7,F8,F9 ) , ChatState toggle                                    #
;###########################################################################################

;; modes:
;; 0 = executed from game ( default )
;; 1 = executed from desktop ( disable message )

f_ToggleDKState(mode = 0)
{
global
if ( bChatState = 0 )
	{
	if ( bDKState = 1 )
		{
		;suspend , on
		bDKState = 0
		GuiControl ,, b_MainToggle , %sb3%
		Menu , Tray , Rename , %sb4% , %sb3%
		if ( bSilentMode = 0 and mode = 0 )
			{
			clipboard = /w %sName% DotaKeys: off
			ClipWait
			Send {enter}^v{enter}
			}
		if ( bLED = 1 )
			{
			f_LEDDisable(mode)
			}
		}
	else
		{
	        ;suspend , off
		bDKState = 1
		GuiControl ,, b_MainToggle , %sb4%
		Menu , Tray , Rename , %sb3% , %sb4%
		if ( bSilentMode = 0 and mode = 0 )
			{
			clipboard = /w %sName% DotaKeys: on
			ClipWait
			Send {enter}^v{enter}
			}
		if ( bLED = 1 )
			{
			f_LEDEnable(mode)
			}
		}
	}
return 1
}



f_ToggleChatState()
{
global
if ( bChatState = 1 )
	{
	f_HotkeysOn()
	bChatState = 0
	}
else
	{
	f_HotkeysOff()
	bChatState = 1
	}
return 1
}




f_HotkeysOn()
{
global
hotkey , *$%kKey1% , on , UseErrorLevel
hotkey , *$%kKey2% , on , UseErrorLevel
hotkey , *$%kKey3% , on , UseErrorLevel
hotkey , *$%kKey4% , on , UseErrorLevel
hotkey , *$%kKey5% , on , UseErrorLevel
hotkey , *$%kKey6% , on , UseErrorLevel
hotkey , *$%kKey7% , on , UseErrorLevel
hotkey , *$%kKey8% , on , UseErrorLevel
hotkey , *$%kKey9% , on , UseErrorLevel
hotkey , *$%kKey10% , on , UseErrorLevel
hotkey , *$%kKey11% , on , UseErrorLevel
hotkey , *$%kKey12% , on , UseErrorLevel
hotkey , *$%kKey13% , on , UseErrorLevel
hotkey , *$%kKey14% , on , UseErrorLevel
hotkey , *$%kKey15% , on , UseErrorLevel
hotkey , *$%kKey16% , on , UseErrorLevel
hotkey , *$%kKey17% , on , UseErrorLevel
hotkey , *$%kKey18% , on , UseErrorLevel
hotkey , *$%kKey19% , on , UseErrorLevel
hotkey , *$%kKey20% , on , UseErrorLevel
hotkey , *$%kKey21% , on , UseErrorLevel
hotkey , *$%kKey22% , on , UseErrorLevel
hotkey , *$%kKey23% , on , UseErrorLevel
hotkey , *$%kKey24% , on , UseErrorLevel
hotkey , *$%kKey25% , on , UseErrorLevel
hotkey , *$%kKey26% , on , UseErrorLevel
hotkey , *$%kKey27% , on , UseErrorLevel
hotkey , *$%kKey28% , on , UseErrorLevel
hotkey , *$%kKey29% , on , UseErrorLevel
hotkey , *$%kKey30% , on , UseErrorLevel
hotkey , *$%kKey31% , on , UseErrorLevel
hotkey , *$%kKey32% , on , UseErrorLevel
hotkey , *$%kKey33% , on , UseErrorLevel
hotkey , *$%kKey34% , on , UseErrorLevel

if ( bLED = 1 )
	send , {scrolllock}
return 1
}

f_HotkeysOff()
{
global
hotkey , *$%kKey1% , off , UseErrorLevel
hotkey , *$%kKey2% , off , UseErrorLevel
hotkey , *$%kKey3% , off , UseErrorLevel
hotkey , *$%kKey4% , off , UseErrorLevel
hotkey , *$%kKey5% , off , UseErrorLevel
hotkey , *$%kKey6% , off , UseErrorLevel
hotkey , *$%kKey7% , off , UseErrorLevel
hotkey , *$%kKey8% , off , UseErrorLevel
hotkey , *$%kKey9% , off , UseErrorLevel
hotkey , *$%kKey10% , off , UseErrorLevel
hotkey , *$%kKey11% , off , UseErrorLevel
hotkey , *$%kKey12% , off , UseErrorLevel
hotkey , *$%kKey13% , off , UseErrorLevel
hotkey , *$%kKey14% , off , UseErrorLevel
hotkey , *$%kKey15% , off , UseErrorLevel
hotkey , *$%kKey16% , off , UseErrorLevel
hotkey , *$%kKey17% , off , UseErrorLevel
hotkey , *$%kKey18% , off , UseErrorLevel
hotkey , *$%kKey19% , off , UseErrorLevel
hotkey , *$%kKey20% , off , UseErrorLevel
hotkey , *$%kKey21% , off , UseErrorLevel
hotkey , *$%kKey22% , off , UseErrorLevel
hotkey , *$%kKey23% , off , UseErrorLevel
hotkey , *$%kKey24% , off , UseErrorLevel
hotkey , *$%kKey25% , off , UseErrorLevel
hotkey , *$%kKey26% , off , UseErrorLevel
hotkey , *$%kKey27% , off , UseErrorLevel
hotkey , *$%kKey28% , off , UseErrorLevel
hotkey , *$%kKey29% , off , UseErrorLevel
hotkey , *$%kKey30% , off , UseErrorLevel
hotkey , *$%kKey31% , off , UseErrorLevel
hotkey , *$%kKey32% , off , UseErrorLevel
hotkey , *$%kKey33% , off , UseErrorLevel
hotkey , *$%kKey34% , off , UseErrorLevel
if ( bLED = 1 )
	send , {scrolllock}
return 1
}


;###########################################################################################
;# GUI Show/Hide of CP/Windows                                                             #
;###########################################################################################

f_ShowHideCP(main,misc)
{
global
if ( main = 0 )
	{
	Gui , Show
	Menu , Tray , Rename , %sh4% , %sh5%
	bCPisOn := 1
	}
else
	{
	Gui , Cancel
	Menu , Tray , Rename , %sh5% , %sh4%
	bCPisOn := 0
	}
if ( misc != 0 )
	{
	if ( main = 0 )
		{
		Gui , %misc%:+owner1
		Gui , %misc%:Show
		if ( misc = 2 )
			{
			Gui , 21:+owner2
			Gui , 21:Show
			}
		else if ( misc = 3 )
			{
			Gui , 31:+owner3
			Gui , 32:+owner3
			Gui , 33:+owner3
			Gui , 31:Show
			Gui , 32:Show
			Gui , 33:Show
			}
		}
	else
		{
		Gui , %misc%:Cancel
		if ( misc = 2 )
			Gui , 21:Cancel
		else if ( misc = 3 )
			{
			Gui , 31:Cancel
			Gui , 32:Cancel
			Gui , 33:Cancel
			}
		}
	}
return 1
}


;###########################################################################################
;# Quick MSGS functions                                                                    #
;###########################################################################################

f_SendQMsg(n)
{
global
local msg, flag
msg := sQMsg%n%
StringMid , flag, msg, 1, 1
if ( flag = "+" )
	{
	StringMid , msg, msg, 2
	send , {ctrl down}{enter}{ctrl up}
	sendraw , %msg%
	send , {enter}
	}
else
	{
	send , {enter}
	sendraw , %msg%
	send , {enter}
	}
return 1
}

;###########################################################################################
;# Autobind + manual bind functions                                                        #
;###########################################################################################


f_SetupAutoBind(code)
{
global
local sHero, sHotkey, iPom
IniRead , iPom, %A_WorkingDir%\data\herocodes.ini, %code%, num
if ( iPom <> "ERROR" )
	{
	send , {shift down}{home}{shift up}{del}{enter}
	f_ToggleChatState()
	loop, % iPom
		{
		IniRead , sHotkey, %A_WorkingDir%\data\herocodes.ini, %code%, skill%A_Index%
		if ( sHotkey != "ERROR" )
			ability%A_Index% := sHotkey
		}
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; This function was added by Kitt
	;; It assigns the Autocast keys to the heroes Autocast skill.
	;;
	loop, % 2
	{
        IniRead , sHotkey, %A_WorkingDir%\data\herocodes.ini, %code%, auto%A_Index%
		if ( sHotkey != "ERROR" )
			AutocastCoords%A_Index% := sHotkey
        }
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        IniRead , sHero, %A_WorkingDir%\data\herocodes.ini, %code%, class
	if ( bSilentMode = 0 )
			{
			clipboard = /w %sName% DotaKeys: You control %sHero% [%ability1%,%ability2%,%ability3%,%ability4%]
			ClipWait
			Send {enter}^v{enter}
			}
	;msgbox Normal
	}
else
	{
	IniRead , iPom, %A_WorkingDir%\data\customcodes.ini, %code%, num
	if ( iPom <> "ERROR" )
		{
      		send , {shift down}{home}{shift up}{del}{enter}
		f_ToggleChatState()
       		loop, % iPom
			{
			IniRead , sHotkey, %A_WorkingDir%\data\customcodes.ini, %code%, skill%A_Index%
			if ( sHotkey != "ERROR" )
				ability%A_Index% := sHotkey
			}
	        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	        ;; This function was added by Kitt
	        ;; It assigns the Autocast keys to the heroes Autocast skill.
	        ;;
	        loop, % 2
	        {
                IniRead , sHotkey, %A_WorkingDir%\data\customcodes.ini, %code%, auto%A_Index%
			if ( sHotkey != "ERROR" )
				AutocastCoords%A_Index% := sHotkey
                }
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        	IniRead , sHero, %A_WorkingDir%\data\customcodes.ini, %code%, class
		if ( bSilentMode = 0 )
				{
				clipboard = /w %sName% DotaKeys: You control %sHero% [%ability1%,%ability2%,%ability3%,%ability4%]
				ClipWait
				Send {enter}^v{enter}
				}
	        ;msgbox Custom
		}
	}
return 1
}


f_SetupManualBind(code)
{
global
loop , parse , code
	{
	ability%A_Index% := A_LoopField
	}
	if ( bSilentMode = 0 )
		{
		clipboard = /w %sName% DotaKeys: You typed %ability1%, %ability2%, %ability3%, %ability4%
		ClipWait
		Send {enter}^v{enter}
		}
return 1
}

;###########################################################################################
;# Utility functions                                                                       #
;###########################################################################################

rand(min,max)
{
Random , OutputVar , Min, Max
return OutputVar
}

f_LEDEnable(mode)
{
loop , 9
   	{
       	Sleep 80
   	send , {scrolllock}
       	}
if ( mode = 1 )
	send , {scrolllock}
setscrolllockstate , on
return 1
}


f_LEDDisable(mode)
{
loop , 7
   	{
       	Sleep 200
   	send , {scrolllock}
       	}
if ( mode = 1 )
	send , {scrolllock}
setscrolllockstate , off
return 1
}

f_ReturnKeysFromList(key)
{
if ( key = 1 )
	return "WheelUp"
if ( key = 2 )
	return "WheelDown"
if ( key = 3 )
	return "MButton"
if ( key = 4 )
	return "XButton1"
if ( key = 5 )
	return "XButton2"
if ( key = 6 )
	return "Space"

}

f_ReturnKeyLabel(n)
{
if ( n = 1 )
	return "label1"
if ( n = 2 )
	return "label2"
if ( n = 3 )
	return "label3"
if ( n = 4 )
	return "label4"
if ( n = 5 )
	return "label5"
if ( n = 6 )
	return "label6"
if ( n = 7 )
	return "label7"
if ( n = 8 )
	return "label8"
if ( n = 9 )
	return "label9"
if ( n = 10 )
	return "label10"
if ( n = 11 )
	return "label11"
if ( n = 12 )
	return "label12"
if ( n = 13 )
	return "label13"
if ( n = 14 )
	return "label14"
if ( n = 15 )
	return "label15"
if ( n = 16 )
	return "label16"
if ( n = 17 )
	return "label17"
if ( n = 18 )
	return "label18"
if ( n = 19 )
	return "l_LifeBars"
if ( n = 20 )
	return "l_CreepSkill"
if ( n = 21 )
	return "l_AutoCast1"
if ( n = 22 )
        return "l_AutoCast2"
if ( n = 23 )
	return "l_ToggleDKState"
if ( n = 24 )
	return "l_SetupAbilities"
if ( n = 25 )
	return "l_QuickMsg1"
if ( n = 26 )
	return "l_QuickMsg2"
if ( n = 27 )
	return "l_QuickMsg3"
if ( n = 28 )
	return "l_QuickMsg4"
if ( n = 29 )
	return "l_HeroSelect"
if ( n = 30 )
	return "l_Patrol"
if ( n = 31 )
	return "l_Arrow1"
if ( n = 32 )
	return "l_Arrow2"
if ( n = 33 )
	return "l_Arrow3"
if ( n = 34 )
	return "l_Arrow4"
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This function was developed by "Invalid User", found @ http://www.autohotkey.com/forum/topic5085.html

IniSectionGet(File,Array)
{
   global
   i = 0 ;Index used for array element number
   Loop, Read, %File%
   {
      StringLeft, L, A_LoopReadLine, 1
      ;Possible Section name, so check right side
      If L = [
      {
         StringRight, R, A_LoopReadLine, 1
         ;If its a right bracket Section found
         If R = ]
         {
            i++
            ;Econt = Element Contents
            ECont = %A_LoopReadLine%
            StringTrimLeft, ECont, ECont, 1
            StringTrimRight, ECont, ECont, 1
            %Array%%i% = %ECont%
         }
      }
   }
   %Array%0 = %i%
   return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This function was developed by "Invalid User", found @ http://www.autohotkey.com/forum/topic5085.html
;; ( modified by "TheIrishThug" )

IniKeyGet(File,Sect,Array)
{
  Global
  Local i := 0, LineNum := 0, KeyName0, KeyName1, KeyName2, Section, LineCont, ErrLvl
  Loop, Read, %File%
  {
    LineNum ++
    Section = [%Sect%]
    If A_LoopReadLine = %Section%
    {
      LineNum++
      Loop
      {
        FileReadLine, LineCont, %File%, %LineNum%
        ;Check is line may be a section, not a key name
        If (ErrorLevel OR SubStr(LineCont, 1, 1) = "[")
        {
          ;Declare Array0 Value
          %Array%0 := i
          Return i
        }
        ;Line not a key
        If LineCont Not Contains =
        {
          LineNum++
          Continue
        }
        i++
        StringSplit, KeyName, LineCont, =
        %Array%%i% := KeyName1
        LineNum++
      }
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Error Handling, mostly for startup

f_ErrorHandle(error)
{
Progress, hide
if ( error = "main" )
	{
	msgbox , 16, Error,Can't load main settings!
	}
else if ( error = "flags" )
	{
	msgbox , 16, Error,Can't load flags!
	}
else if ( error = "keys" )
	{
	msgbox , 16, Error,Can't load hotkeys!
	}
else if ( error = "commands" )
	{
	msgbox , 16, Error,Can't load hotkeys for commands ( attack`, move etc. )!
	}
else if ( error = "language" )
	{
	IniWrite , english, settings.ini, main, sLanguage
	msgbox , 16 , Error , Can't load strings!`nThe language file is probably corrupted. Resetting back to English.`nIf DotaKeys will not reload please restart application.
	}
else if ( error = "message" )
	{
	msgbox , 16, Error, Can't load Quick messages!
	}

reload
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This function was developed by "Kitt"
;; Rightclick the n-th position of the skill grid and move mouse back to the original position

ClickSkill(SkillSpot, type = "Left")
{
   if(SkillSpot <> none)
   {
        CoordMode, Mouse, Relative
        MouseGetPos,xMouse,yMouse
        WinGetPos,,,Width,Height,A

        xSpot := Mod(SkillSpot - 1, 4)
        ySpot := (SkillSpot - xSpot + 1)/4

        Width  := Width*(0.80 + xSpot*0.055)
        Height := Height*(0.78 + ySpot*0.07)
        ;Click %type%,%Width%,%Height%
	MouseClick ,%type% , %Width%,%Height%, 1 , 0

        MouseMove,xMouse,yMouse,0
    }
}
