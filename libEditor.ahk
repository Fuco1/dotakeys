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


;###########################################################################################
;# Key Loading                                                                             #
;###########################################################################################


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that create hotkey list when LV is first created
f_EditorCreateList()
{
global
LV_Add("","", "Skill 1")
LV_Add("","", "Skill 2")
LV_Add("","", "Skill 3")
LV_Add("","", "Skill 4 ( ulti )")
LV_Add("","", "Skill 5")
LV_Add("","", "Skill 6")
LV_Add("","", "Move")
LV_Add("","", "Stop")
LV_Add("","", "Hold Position")
LV_Add("","", "Attack")
LV_Add("","", "Item 1 ( num 7 )")
LV_Add("","", "Item 2 ( num 8 )")
LV_Add("","", "Item 3 ( num 4 )")
LV_Add("","", "Item 4 ( num 5 )")
LV_Add("","", "Item 5 ( num 1 )")
LV_Add("","", "Item 6 ( num 2 )")
LV_Add("","", "Hero skills")
LV_Add("","", "Hero center")
LV_Add("","", "Toggle life bars")
LV_Add("","", "Creep's Skills")
;; Original line
;;LV_Add("","", "Autocast")
LV_Add("","", "Autocast 1")                   ;; Added by Kitt for creating custom autocast
LV_Add("","", "Autocast 2")                   ;; Added by Kitt for creating custom autocast
LV_Add("","", "DK Toggle (old F8)")
LV_Add("","", "Manual Bind (old F7)")
LV_Add("","", "QuickMsg 1 (old F3)")
LV_Add("","", "QuickMsg 2 (old F4)")
LV_Add("","", "QuickMsg 3 (old F5)")
LV_Add("","", "QuickMsg 7 (old F6)")
LV_Add("","", "Select hero (F1 remap)")
LV_Add("","", "Patrol")
LV_Add("","", "Up Arrow")
LV_Add("","", "Down Arrow")
LV_Add("","", "Right Arrow")
LV_Add("","", "Left Arrow")
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that update hotkeys in list ( array kKey => LV )
f_EditorUpdateKeysList()
{
global
if ( f_LoadKeys() = 0 )
	msgbox Can't Load Hotkeys!

;Gui , 2:Default

loop % iNumKeys
	{
	;LV_Modify( A_Index , "col1" , kKey%A_Index% )
	;if ( errorlevel = 0 )
	if ( LV_Modify( A_Index , "col1" , kKey%A_Index% ) = 0 )
		{
		msgbox % a_index error
		return 0
		break
		}
	}
loop % iNumKeys
	{
	kOldKey%A_Index% := kKey%A_Index%
	}

return 1
}


;###########################################################################################
;# Profile Saving/Loading                                                                  #
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that save user profile to .dkp file
f_EditorSaveProfile()
{
global
if ( sProfile = "Default" )
	{
	f_EditorSaveAsProfile()
	return 1
	}
loop % iNumKeys
	{
	IniWrite , % kKey%A_Index% , settings.ini , keys, key%A_Index%
	IniWrite , % kKey%A_Index% , %sProfile%.dkp , keys , key%A_Index%
	}
f_EditorRedefineKeys()
f_EditorSetOldKeys()
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that save/as user profile to .dkp file ( create new/overwrite file )
f_EditorSaveAsProfile()
{
global
;FileSelectFile, OutputVar [, Options, RootDir\Filename, Prompt, Filter]
FileSelectFile , sSaveFile, S16, %A_WorkingDir%, Save File As..., DotaKeys Profile (*.dkp)
SplitPath , sSaveFile , sSaveFile
if sSaveFile contains .dkp
	StringReplace , sSaveFile, sSaveFile, .dkp
if ( sSaveFile <> "" )
	{
	sProfile := sSaveFile
	IniWrite , %sProfile% , settings.ini , main, sProfile
	loop % iNumKeys
		{
		IniWrite , % kKey%A_Index% , settings.ini , keys, key%A_Index%
		IniWrite , % kKey%A_Index% , %sProfile%.dkp , keys , key%A_Index%
		}
	}
WinSetTitle , DotaKeys Editor ,, DotaKeys Editor - %sProfile%
f_EditorRedefineKeys()
f_EditorSetOldKeys()
return 1
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that load user's profile
f_EditorLoadProfile()
{
global
FileSelectFile , sLoadFile, 3, %A_WorkingDir%, Save File As..., DotaKeys Profile (*.dkp)

;; ##################### Kitt #######################
;; ##
        FileRead, FileContents, %sLoadFile%                 ;; Load each file's contents into a variable.
        IfNotInString, FileContents, key30                  ;; If the file doesn't contain "key30" then it is an old .dkp, and display an error message.
        {
            msgbox ,16, Error, Profile is old and incompatable. Try placing it in the Dota Keys folder, and reload DotA Keys to fix this.
            return 0
        }
;; ##################################################

SplitPath , sLoadFile , sLoadFile
if sLoadFile contains .dkp
	StringReplace , sLoadFile, sLoadFile, .dkp
if ( sLoadFile <> "" )
	{
	sProfile := sLoadFile
	loop % iNumKeys
		{
		IniRead , kKey%A_Index% , %sProfile%.dkp , keys , key%A_Index%
		IniWrite , % kKey%A_Index% , settings.ini , keys , key%A_Index%
		}
	Gui , 2:Default
	;if ( f_EditorUpdateKeysList() = 0 )
	;	msgbox Can't update hotkey list
	f_LoadKeys()
	loop % iNumKeys
		{
		LV_Modify( A_Index , "col1" , kKey%A_Index% )
		}
	IniWrite , %sProfile% , settings.ini , main, sProfile
	WinSetTitle , DotaKeys Editor ,, DotaKeys Editor - %sProfile%
	f_EditorRedefineKeys()
	f_EditorSetOldKeys()
	}
return 1
}



;###########################################################################################
;# Redefining keys                                                                         #
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that update keys array when profile is saved/loaded
;;  It will turn off all unused keys and update/create new
f_EditorRedefineKeys()
{
global
local pom
loop % iNumKeys
	{
	pom := kOldKey%A_Index%
	if ( pom <> "none" )
		hotkey , *$%pom% , off
	}
loop % iNumKeys
	{
	pom := kKey%A_Index%
	if ( pom <> "none" )
       		{
       		hotkey , *$%pom% , % f_ReturnKeyLabel(A_Index)
		hotkey , *$%pom% , on
		}
	}
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that re-set old keys to actual
f_EditorSetOldKeys()
{
global
loop % iNumKeys
	{
	kOldKey%A_Index% := kKey%A_Index%
	}
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that re-set actual keys to backup ( old ) keys
f_EditorRestoreKeys()
{
global
loop % iNumKeys
	{
	kKey%A_Index% := kOldKey%A_Index%
	}
return 1
}



;###########################################################################################
;# Key Editing                                                                             #
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that edit row in the LV
;;  Function will do check if there is no duplicate/key is valid.
;;  Params: num - line number
f_EditorEditKey(num)
{
global
local keyold, iPom
keyold := EditedKeyCont
if ( EditorRadioGroup1 <> 0 )
	EditedKeyP := f_ReturnKeysFromList(EditorRadioGroup1)
else
	EditedKeyP = %EditorHotkeyEdit%
if ( EditedKeyP <> "" )
	{
	StringReplace, EditedKeyP, EditedKeyP , !
	StringReplace, EditedKeyP, EditedKeyP , ^
	StringReplace, EdiatedKeyP, EditedKeyP , +
	}
else
	EditedKeyP := "none"
iPom := f_EditorCheckKey(EditedKeyP,num)
if ( iPom = 0 )
	{
	Gui , 2:Default
	kKey%num% = %EditedKeyP%
	LV_Modify( num , "" , kKey%num% )
	return 1
	}
else
	{
	if ( bEditReplaceHotKeys = 0 )
		{
		msgbox , 16 , Error, You have duplicated hotkey!
		return 0
		}
	else
		{
		Gui , 2:Default
		kKey%num% = %EditedKeyP%
		kKey%iPom% := "none"
		LV_Modify( num , "" , kKey%num% )
		LV_Modify( iPom , "" , "none" )
		return 1
		}

	}
}


f_EditorClearAll()
{
global
loop , %iNumKeys%
	{
	kKey%A_Index% := "none"
	LV_Modify(A_Index , "" , "none")
	}
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that will check if there is duplicated hotkey
;;  Params: key - key to be checked
;;          num - line number
;;  Errorsystem of this function is different then others, 0 means success and return value means colision row
f_EditorCheckKey(key,num)
{
global
flag := 0
if ( key = "none" )
	return 0
loop , %iNumKeys%
	{
	if ( A_Index != num )
		{
		;msgbox % a_index  "    " key "    " kKey%a_index%
		if ( key = kKey%A_Index% )
			{
			flag := A_Index
			return flag
			}
		}
	}
return flag
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that will check if there are changes that should be saved when exiting editor
f_EditorExitCheck()
{
global
flag := 1
loop , %iNumKeys%
	{
	if ( kKey%A_Index% != kOldKey%A_Index% )
		{
		Gui 2:+OwnDialogs
		msgbox , 8243 , DotaKeys Editor, File %sProfile%.dkp has changed.`n`nDo you want to save changes?
		IfMsgBox , Cancel
			{
			return 0
			}
		IfMsgBox , No
			{
			flag := A_Index
		        return flag
			}
		IFMsgBox , Yes
			{
			f_EditorSaveProfile()
			flag := A_Index
		        return flag
			}
		}
	}
return flag
}
