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
;# Function for handling preferences window                                                #
;###########################################################################################


f_InitPreferences()
{
global
local sList, sPom

if ( bAutoUpdate = 1 )
	GuiControl,3: , cbAutoUpdate, 1
if ( bCP = 1 )
	GuiControl,3: , cbCP, 1
if ( bToolTip = 1 )
	GuiControl,3: , cbToolTip, 1
if ( bSilentMode = 1 )
	GuiControl,3: , cbSilentMode, 1
if ( bLED = 1 )
	GuiControl,3: , cbLED, 1
if ( bKeysBoundToW3 = 1 )
	GuiControl,3: , cbKeysBoundToW3, 1
if ( bEditReplaceHotKeys = 1 )
	GuiControl,3: , cbEditReplaceHotKeys, 1
if ( bCreepSkill5 = 1 )
	GuiControl,3: , cbCreepSkill5, 1


GuiControl, 3:ChooseString, DDLCommand1, %Command1%
GuiControl, 3:ChooseString, DDLCommand2, %Command2%
GuiControl, 3:ChooseString, DDLCommand3, %Command3%
GuiControl, 3:ChooseString, DDLCommand4, %Command4%
GuiControl, 3:ChooseString, DDLCommand5, %Command5%
GuiControl, 3:ChooseString, DDLCommand6, %Command6%

return 1

}


f_CBGenStatusChange(Box)
{
global
local value
StringTrimLeft , value, box, 1
if ( %value% = 1 )
	{
	%value% := 0
	IniWrite , 0, settings.ini, flags, %value%
	;IniWrite, Value, Filename, Section, Key
	}
else
	{
	%value% := 1
	IniWrite , 1, settings.ini, flags, %value%
	}
}

f_DDLCommandChange(ddl)
{
global
local value, pom
StringTrimLeft , value, ddl, 3
pom := %ddl%
%value% := pom
IniWrite , %pom%, settings.ini, commands, %value%
}

f_BBrowseLang()
{
global
FileSelectFile , Language , 3, %A_Workingdir%\langs, Select Language, *.ini
if ( ErrorLevel = 1 )
	return 0
Language := RegExReplace(Language,"^.*langs\\(.*)\.ini","$1")
;msgbox , % language
IniWrite , %language%, settings.ini, main, sLanguage
reload
}
;sLanguage=english


/*
[flags]
bAutoUpdate=0
bCP=1
bToolTip=0
bSilentMode=0
bLED=1
bKeysBoundToW3=0
*/


f_PreferencesUpdate()
{
global
return 1
}


;###########################################################################################
;# Function for handling Hero/Custom Codes                                                 #
;###########################################################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Fill "Code" LV ( the first one ) - Load all sections from INI
;;  Prams: Mode - Hero/custom codes
f_FillPrefListViews(mode)
{
global
local sec
if ( IniSectionGet("data\" mode "codes.ini","sec") != 1 )
	return 0
Gui, 3:ListView, PrefListView1
if ( sec0 != 0 )
	{
	loop , %sec0%
		{
		LV_Add("",sec%a_index%)
		}
	}
if ( sec0 != 0 )
	{
	LV_Modify(1,"Focus, Select")
	f_LoadCustomCode(sec1,mode)
	}
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Fill Data|Value ( Second LV ) - Load skills & Class from INI
;;  Params: sec - Section ( Code of hero )
;;          mode - Hero/custom
f_LoadCustomCode(sec,mode)
{
global
Gui, 3:ListView, PrefListView2
LV_Delete()
if ( sec = "" )
	return
IniRead , iPom, data\%mode%codes.ini, %sec%, num
LV_Add("","num",iPom)
if ( iPom <> "ERROR" )
	{
      	loop, % iPom
		{
		IniRead , sHotkey, data\%mode%codes.ini, %sec%, skill%A_Index%
		LV_Add("","skill" a_index, sHotkey)
		}
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;; Added by Kitt to display custom auto cast codes
        ;; in the custom code editor.
        loop, % 2
        	{
            	IniRead , sHotkey, data\%mode%codes.ini, %sec%, auto%A_Index%
		LV_Add("","auto"a_index, sHotkey)
        	}
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
 	IniRead , sHero, data\%mode%codes.ini, %sec%, class
	LV_Add("","class", sHero)
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Handle events on first LV ( Code )
;;  Params: event - Code of event in LV
;;          info,level - additional info about event ( line, what happened etc.. )
f_PrefListView1(event,info,level)
{
global
Gui, 3:ListView, PrefListView1
if ( info = 0 )
	return 0
if ( event = "I" )
	{
	if level contains S,F
		{
		LV_GetText(sec,info)
		f_LoadCustomCode(sec,sCodesMode)
		sCode := sec
		sCodeLine := info
		}
	}
else if ( event = "Normal" )
	{
		LV_GetText(sec,info)
		f_LoadCustomCode(sec,sCodesMode)
		sCode := sec
		sCodeLine := info
	}
else if ( event = "DoubleClick" )
	{
		if ( sCodesMode != "hero" )
		       {
			LV_GetText(sec,info)
			sCode := sec
			sCodeLine := info
			f_GUICreateNewCodeHeaderWnd(sec)
			}
	}
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Handle events on second LV ( Data|Value )
;;  Params: event - Code of event in LV
;;          info,level - additional info about event ( line, what happened etc.. )
f_PrefListView2(event,info,level)
{
global
Gui, 3:ListView, PrefListView2
if ( event = "DoubleClick" )
	{
	LV_GetText(mode,info)
	LV_GetText(value,info,2)
	;msgbox , You are editing row %info% , %mode% , %value%
	sCodeLine := info
	sCodeMode := mode
	f_GUICreateCodeWnd(mode,value)
	}
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Handle "Edit" event on second LV ( Data|Value )  ( Edits value for num/skills/class )
;;  Params: line - Number of line
;;          mode - "Data" value ( what we are going to edit )
;;          value - new value being set
f_PrefEditCode(line,mode,value)
{
global
Gui, 3:Default
Gui, 3:ListView, PrefListView2
;IniWrite, Value, Filename, Section, Key
if mode contains skill
	{
	LV_Modify(line,"Col2",value)
	}
else if mode contains class
	{
	LV_Modify(line,"Col2",value)
	}
else if mode contains num
	{
	LV_Modify(line,"Col2",value)
	}
;; ########### Kitt ##########
else if mode contains auto
	{
	LV_Modify(line,"Col2",value)
	}
;; ###########################

iniwrite , %value% , data\%sCodesMode%codes.ini , %sCode% , %mode%
if mode contains num
	f_LoadCustomCode(sCode,sCodesMode)
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that switch view from Hero => custom and vice versa
;;  Params: none
f_PrefCustomHeroSwitch()
{
global
if ( sCodesMode = "custom" )
	{
	sCodesMode := "hero"
	Gui, 3:Default
	GuiControl ,3:, b_PrefCustomHeroSwitch , %spb3%
	Gui, 3:ListView, PrefListView1
	LV_Delete()
	Gui, 3:ListView, PrefListView2
	LV_Delete()
	f_FillPrefListViews(sCodesMode)
	GuiControl , Disable , b_PrefAddCode
	GuiControl , Disable , b_PrefDeleteCode
	}
else
	{
	sCodesMode := "custom"
	Gui, 3:Default
	GuiControl ,3:, b_PrefCustomHeroSwitch , %spb2%
	Gui, 3:ListView, PrefListView1
	LV_Delete()
	Gui, 3:ListView, PrefListView2
	LV_Delete()
	f_FillPrefListViews(sCodesMode)
	GuiControl , Enable , b_PrefAddCode
	GuiControl , Enable , b_PrefDeleteCode
	}
return 1
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that add new custom code
;;  Params: code, class, num, skill1, skill2, skill3, skill4, skill5, skill6, auto1, auto2 - all data required for new entry

;; Edited by Kitt for creating custom autocast - added auto1/2
f_PrefAddCode(code,class,num,skill1,skill2,skill3,skill4,skill5,skill6,auto1,auto2)
{
global
if ( strlen(code) != 4 )
	{
	msgbox , 16 , Error , Length of code must be exactly 4 characters!
	return 0
	}
iniwrite , %num% , data\customcodes.ini , %code% , num
iniwrite , %skill1% , data\customcodes.ini , %code% , skill1
iniwrite , %skill2% , data\customcodes.ini , %code% , skill2
iniwrite , %skill3% , data\customcodes.ini , %code% , skill3
iniwrite , %skill4% , data\customcodes.ini , %code% , skill4
iniwrite , %auto1% , data\customcodes.ini , %code% , auto1   ;; Added by Kitt for creating custom autocast
iniwrite , %auto2% , data\customcodes.ini , %code% , auto2   ;; Added by Kitt for creating custom autocast


iniwrite , %class% , data\customcodes.ini , %code% , class
if ( num = 5 )
	iniwrite , %skill5% , data\customcodes.ini , %code% , skill5
if ( num = 6 )
	{
	iniwrite , %skill5% , data\customcodes.ini , %code% , skill5
	iniwrite , %skill6% , data\customcodes.ini , %code% , skill6
	}
Gui, 3:Default
Gui, 3:ListView, PrefListView1
;LV_Delete()
;f_FillPrefListViews(sCodesMode)
LV_Add("Focus, Select",code)
return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Function that Delete/edit Custom code
;;  ( Following code is based on IniSectionGet(File,Array) by "InvalidUser" )

f_PrefDeleteCode(old,line)
{
global
fDelete := 0
FileAppend ,, data\_customcodes.ini
Loop, Read, data\customcodes.ini
	{
	StringLeft, L, A_LoopReadLine, 1
	;Possible Section name, so check right side
	If L = [
		{
		StringRight, R, A_LoopReadLine, 1
		;If its a right bracket Section found
		If R = ]
			{
			ECont = %A_LoopReadLine%
			StringTrimLeft, ECont, ECont, 1
			StringTrimRight, ECont, ECont, 1
			if ( ECont = old )
				{
				fDelete := 1
				}
			else
				{
				fDelete := 0
				}
			}
		}
	if ( fDelete = 0 )
		{
		FileAppend , %A_LoopReadLine%`n , data\_customcodes.ini
		}
	}
	FileMove , data\_customcodes.ini, data\customcodes.ini , 1
	Gui, 3:Default
	Gui, 3:ListView, PrefListView1
	LV_Delete(line)
	if ( line != 1 )
		LV_Modify(line,"Focus, Select")
return 1
}

f_PrefEditCodeHeader(new,old,line)
{
global
if ( strlen(new) != 4 )
	{
	msgbox , 16 , Error , Length of code must be exactly 4 characters!
	return 0
	}
Loop, Read, data\customcodes.ini
	{
	StringLeft, L, A_LoopReadLine, 1
	;Possible Section name, so check right side
	If L = [
		{
		StringRight, R, A_LoopReadLine, 1
		;If its a right bracket Section found
		If R = ]
			{
			ECont = %A_LoopReadLine%
			StringTrimLeft, ECont, ECont, 1
			StringTrimRight, ECont, ECont, 1
			if ( Econt = old )
				{
				FileAppend , [%new%]`n , data\_customcodes.ini
				}
			else
				{
				FileAppend , %A_LoopReadLine%`n , data\_customcodes.ini
				}
			}
		else
			{
			FileAppend , %A_LoopReadLine%`n , data\_customcodes.ini
			}
		}
	else
		{
		FileAppend , %A_LoopReadLine%`n , data\_customcodes.ini
		}
	}
	FileMove , data\_customcodes.ini, data\customcodes.ini , 1
	Gui, 3:Default
	Gui, 3:ListView, PrefListView1
	LV_Modify(line,"",new)
	sCode := new
return 1
}
