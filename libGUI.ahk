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
;; File with functions which CREATE, not handle GUIs.


;###########################################################################################
;# Main Window ( known as Control Panel )                                                  #
;###########################################################################################

f_GUICreateControlPanel(showcp = 1)
{
global
local iXpos, iXpos2
Gui , add , groupbox , x12 y5 w115 h170 cblack,
Gui , add , button , xp+7 yp+14 w100 h30 gl_MenuDKEditor, %sb1%
Gui , add , button , xp y+10 w100 h30 gl_MenuMacroEditor, %sb2%
Gui , add , button , xp y+10 w100 h30 vb_MainToggle gl_ToggleDKState, %sb3%
Gui , add , button , xp y+10 w100 h30 vb_MainExit gl_MenuExit, %sb5%

Gui , add , groupbox , x132 y5 w115 h170 cblack,
Gui , add , button , xp+7 yp+14 w100 h30 gl_MainCommandsSetup , %sb6%
Gui , add , button , xp y+10 w100 h30 gl_MainCustomCodesSetup , %sb7%

gui , add , picture , xp+14 y+10 gl_MenuDonate , %A_WorkingDir%\temp\paypal_donate.gif

iXpos := 12
iXpos2 := iXpos + 98
Gui , add , groupbox , x%iXpos% y180 w505 h155 cblack, %sBox1%  ;h155
gui , add , text , xp+7 yp+30 , %kKey25%
gui , add , text , xp yp+30 , %kKey26%
gui , add , text , xp yp+30 , %kKey27%
gui , add , text , xp yp+30 , %kKey28%

gui , add , edit , x%iXpos2% yp-94 w395 vMainQMsg1 gl_MainQMsg1, %sQmsg1%
gui , add , edit , x%iXpos2% yp+30 w395 vMainQMsg2 gl_MainQMsg2, %sQmsg2%
gui , add , edit , x%iXpos2% yp+30 w395 vMainQMsg3 gl_MainQMsg3, %sQmsg3%
gui , add , edit , x%iXpos2% yp+30 w395 vMainQMsg4 gl_MainQMsg4, %sQmsg4%
/*
if ( fConnected = 1 )
	{
	browser1 := IE_Add( hWnd, 260, 13, 255, 161)
	IE_LoadURL(browser1, "http://www.dasnet.cz")

	;;Gui , add , groupbox , x%iXpos% y340 w505 h155 cblack, %sBox1%  ;h155
	browser2 := IE_Add( hWnd, 12, 340, 505, 155)
	IE_LoadURL(browser2, "file://localhost/D:/_ahk/WarPath/dotakeys1.4/reklama.html")

	;;IE_LoadURL(browser1, "http://fuller.gjgt.sk/dotakeys/site/reklama.html")
	}
*/

;gui , add , groupbox , x125 y5 w392 h170 cblack, News
;gui , add , text , xp+7 yp+16 w380 h148 , Hello.`nThis is experimental build of DK ( v1.4 ). All functions there might not work as expected. If you find some bug please write us an email ( [email=dota.keys@gmail.com] ) or visit our Dotakeys v1.4 [url=http://dotakeys.forumer.com]forum[/url] topic


bCPisOn := 1
iMiscWindow := 0
Menu , Tray , Rename , %sh4% , %sh5%
if ( showcp = 1 )
	{
	;if ( fConnected = 1 )
	;	{
	;	Gui , show , w528 h510 center , DotaKeys v%sVersion%    ;; autosize
	;	}
	;else
	;	{
		Gui , show , autosize center , DotaKeys v%sVersion%    ;; autosize
	;	}
	}
return 1
}


f_GUIDestroyControlPanel()
{
gui , destroy
return 1
}


;###########################################################################################
;# Main Menu                                                                               #
;###########################################################################################

f_GUICreateMainMenu()
{
global
Menu , FileMenu, Add, %ss11% , l_MenuReboot
Menu , FileMenu, Add,,
Menu , FileMenu, Add, %ss12% , l_MenuExit
Menu , OptionsMenu, Add, %ss21%, l_MenuDKEditor
Menu , OptionsMenu, Add, %ss22%, l_MenuMacroEditor
Menu , OptionsMenu, Add,,
Menu , OptionsMenu, Add, %ss23%, l_MenuPreferences
Menu , HelpMenu, Add, %ss31%, l_MenuHelp
Menu , HelpMenu, Add, %ss32%, l_MenuHomepage
Menu , HelpMenu, Add,,
Menu , HelpMenu, Add, %ss35%, l_MenuDonate
Menu , HelpMenu, Add,,
Menu , HelpMenu, Add, %ss33%, l_MenuUpdate
Menu , HelpMenu, Add,,
Menu , HelpMenu, Add, %ss34%, l_MenuAbout
Menu , MainMenu, Add, %sh1% , :FileMenu
Menu , MainMenu, Add, %sh2% , :OptionsMenu
Menu , MainMenu, Add, %sh3% , :HelpMenu
Gui , Menu , MainMenu
return 1
}

f_GUICreateTrayMenu()
{
global
Menu , TrayOptions, Add, %ss21%, l_MenuDKEditor
Menu , TrayOptions, Add, %ss22%, l_MenuMacroEditor
Menu , TrayOptions, Add,,
Menu , TrayOptions, Add, %ss23%, l_MenuPreferences
Menu , Tray, Add, %sh4%, l_MenuShowHideCP
Menu , Tray, Add,,
Menu , Tray, Add, %sb3%, l_MenuToggleDKState
Menu , Tray, Add,,
Menu , Tray, Add, %sh2%, :TrayOptions
Menu , Tray, Add, %ss11% , l_MenuReboot
Menu , Tray, Add, %ss12% , l_MenuExit

Menu , Tray, Click, 1
Menu , Tray, Default, %sh4%
Menu , Tray, NoStandard

return 1
}


;###########################################################################################
;# Editor Window                                                                           #
;###########################################################################################

f_GUICreateEditor()
{
global
Gui , 1:+Disabled
Gui , 2:-MinimizeBox +owner1
Gui , 2:Default
Gui , 2:Add, ListView, R27 w300 -LV0x10 Grid NoSort NoSortHdr gl_EditorLVEvent vEditorListView AltSubmit -multi, %set1%|%set2%|%set3%   ;-LV0x20
LV_ModifyCol(1, 76)
LV_ModifyCol(2, 128)
LV_ModifyCol(3, 71)
Gui , 2:Add, GroupBox, x328 y87 w120 h126 cblack,
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorOpen, %seb1%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorSave, %seb2%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorSaveAs, %seb3%
Gui , 2:Add, GroupBox, x328 y+5 w120 h126 cblack,
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorClear, %seb4%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorClearAll, %seb5%
Gui , 2:Add, Button, xp y+15 w105 h25 gl_EditorDefault, %seb6%
Gui , 2:Add, GroupBox, x328 y+5 w120 h46 cblack,
Gui , 2:Add, Button, xp+7 yp+14 w105 h25 gl_EditorExit, %sb5%
Gui , 2:Add, Button, Hidden default gl_EditorDefaultSubmit, ok
Gui , 2:show, autosize center, DotaKeys Editor - %sProfile%
if ( f_EditorCreateList() = 0 )
	msgbox Can't create hotkeys list!
if ( f_EditorUpdateKeysList() = 0 )
	msgbox Can't update hotkeys list!
iMiscWindow := 2
return 1
}

f_GUIDestroyEditor()
{
global
Gui , 1:-Disabled
Gui , 2:Destroy
iMiscWindow := 0
return 1
}

f_GUICreateKeyWnd(key)
{
global
Gui , 2:+Disabled
Gui , 21:-Minimizebox +owner2
Gui , 21:Add, Hotkey, x10 y10 Limit190 vEditorHotkeyEdit, %key%
Gui , 21:Add, Radio, xp y+10 vEditorRadioGroup1, MouseWheel UP
Gui , 21:Add, Radio, xp y+10 , MouseWheel Down
Gui , 21:Add, Radio, xp y+10 , MouseButton 3
Gui , 21:Add, Radio, xp y+10 , MouseButton 4
Gui , 21:Add, Radio, xp y+10 , MouseButton 5
Gui , 21:Add, Radio, xp y+10 , Space
Gui , 21:Add, Button, xp y+10 w80 h25 gl_KeyWndSubmit default, OK
Gui , 21:Show, autosize center, Press any key...
return 1
}

f_GUIDestroyKeyWnd()
{
global
Gui , 2:-Disabled
Gui , 2:Default
Gui , 21:Destroy
return 1
}


;###########################################################################################
;# Preferences Window                                                                      #
;###########################################################################################

f_GUICreatePreferences(mode = 1)
{
global
Gui , 1:+Disabled
Gui , 3:-MinimizeBox +owner1
Gui , 3:Default
Gui , 3:Add, Tab, w450 h350 Choose%mode%, %sptab1%|%sptab2%|%sptab3%
Gui , 3:Tab, 1
Gui , 3:Add, CheckBox, vcbAutoUpdate gl_CBGenStatusChange, %spcb1%
Gui , 3:Add, CheckBox, vcbCP gl_CBGenStatusChange, %spcb2%
Gui , 3:Add, CheckBox, vcbToolTip gl_CBGenStatusChange, %spcb3%
Gui , 3:Add, CheckBox, vcbSilentMode gl_CBGenStatusChange, %spcb4%
Gui , 3:Add, CheckBox, vcbLED gl_CBGenStatusChange, %spcb5%
Gui , 3:Add, CheckBox, vcbKeysBoundToW3 gl_CBGenStatusChange, %spcb6%
Gui , 3:Add, CheckBox, vcbEditReplaceHotKeys gl_CBGenStatusChange, %spcb7%
Gui , 3:Add, CheckBox, vcbCreepSkill5 gl_CBGenStatusChange, %spcb8%
Gui , 3:Add, Text, y+20 , %sptext1%
Gui , 3:Add, Edit, x+10 yp-3 w80 vpLanguage readonly , %sLanguage%
Gui , 3:Add, Button, x+10 yp-2 w70 h25 vbBrowse gl_BBrowseLang, %spb1%

sCodesMode := "custom"
Gui , 3:Tab, 2
Gui , 3:Add, ListView, R20 w80 -LV0x10 Grid NoSort NoSortHdr gl_PrefListView1 vPrefListView1 AltSubmit -multi, Code   ;-LV0x20
Gui , 3:Add, ListView, x+10 yp R20 w230 -LV0x10 Grid NoSort NoSortHdr gl_PrefListView2 vPrefListView2 AltSubmit -multi, Data|Value   ;-LV0x20
LV_ModifyCol(1, 48)
LV_ModifyCol(2, 178)
Gui , 3:Add, Button, x+10 yp w100 vb_PrefCustomHeroSwitch gl_PrefCustomHeroSwitch, %spb2%
Gui , 3:Add, Button, xp y+10 w100 vb_PrefAddCode gl_PrefAddCode, %spb4%
Gui , 3:Add, Button, xp y+10 w100 vb_PrefDeleteCode gl_PrefDeleteCode, %spb5%


Gui , 3:Tab, 3
Gui , 3:Add, Text,, %sptext2%
Gui , 3:Add, Text,, %sptext5%
Gui , 3:Add, Text,, %sptext6%
Gui , 3:Add, Text,, %sptext7%
Gui , 3:Add, Text,, %sptext8%
Gui , 3:Add, Text,, %sptext9%
Gui , 3:Add, Text,, %sptext17%
Gui , 3:Add, DropDownList, x130 y57 vDDLCommand1 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, DropDownList, vDDLCommand2 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, DropDownList, vDDLCommand3 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, DropDownList, vDDLCommand4 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, DropDownList, vDDLCommand5 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, DropDownList, vDDLCommand6 gl_DDLCommandChange, a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 3:Add, Text, x22 w420 yp+30 , %sptext3%

Gui , 3:Tab
Gui , 3:Add, Button, x370 y365 w90 h25 gl_PreferencesExit, OK

if ( f_InitPreferences() = 0 )
	msgbox Can't initialize controls!

if ( f_FillPrefListViews(sCodesMode) = 0 )
	msgbox Can't Load Custom Codes!

Gui , 3:Show, autosize center , %ss23%

iMiscWindow := 3
return 1
}

/*
[flags]
bAutoUpdate=0
bCP=1
bToolTip=0
bSilentMode=0
bLED=1
bKeysBoundToW3=0
*/

f_GUIDestroyPreferences()
{
global
Gui , 3:Submit, nohide
if ( f_PreferencesUpdate() = 0 )
	msgbox Can't update preferences!
Gui , 1:-Disabled
Gui , 3:Destroy
iMiscWindow := 0
return
}

f_GUICreateCodeWnd(mode,value)
{
global
Gui , 3:+Disabled
Gui , 31:-Minimizebox +owner3
Gui , 31:Default
if mode contains skill
	{
	Gui , 31:Add, DropDownList, vDDLCode , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|
	GuiControl , 31:ChooseString, DDLCode, %value%
	}
else if mode contains class
	{
	Gui , 31:Add, Edit , w180 vEditCode , %value%
	}
else if mode contains num
	{
	Gui , 31:Add, Edit , w180 ,
	Gui , 31:Add , UpDown , vEditNum Range4-6, %value%
	}
;; ############### Kitt ############
else if mode contains auto
        {
        Gui , 31:Add, DropDownList, vDDLCode , none|1|2|3|4|5|6|7|8|9|10|11|12|
        GuiControl , 31:ChooseString, DDLCode, %value%
        }
;; #################################

Gui , 31:Add, Button, xp y+10 w80 h25 gl_CodeWndSubmit default, OK
Gui , 31:Show, autosize center, %spwtitle1%
return 1
}

f_GUIDestroyCodeWnd()
{
global
Gui , 3:-Disabled
Gui , 3:Default
Gui , 31:Destroy
return 1
}

f_GUICreateNewCodeWnd()
{
global
Gui , 3:+Disabled
Gui , 32:-Minimizebox +owner3
Gui , 32:Default
Gui , 32:Add , Edit , w200 Limit4 vEditNewCode , Code...
Gui , 32:Add , Edit , w200 vEditNewClass , Class...
Gui , 32:Add , Text , y+10, %sptext10%
Gui , 32:Add , Edit , x+13 yp-3 w110
Gui , 32:Add , UpDown , vEditNewNum gl_EditNewNum Range4-6, 4
Gui , 32:Add , Text , x10 y+11, %sptext11%
Gui , 32:Add , Text , xp y+18, %sptext12%
Gui , 32:Add , Text , xp y+18, %sptext13%
Gui , 32:Add , Text , xp y+18, %sptext14%
Gui , 32:Add , Text , xp y+18 vTextNewSkill5, %sptext15%
Gui , 32:Add , Text , xp y+18 vTextNewSkill6, %sptext16%
Gui , 32:Add , Text , xp y+18, Autocast 1           ;; Added by Kitt for creating custom autocast
Gui , 32:Add , Text , xp y+18, Autocast 2           ;; Added by Kitt for creating custom autocast


Gui , 32:Add , DropDownList, x+10 y90 vDDLNewSkill1 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill2 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill3 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill4 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill5 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill6 , a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill7 , none||1|2|3|4|5|6|7|8|9|10|11|12            ;; Added by Kitt for creating custom autocast
Gui , 32:Add , DropDownList, xp y+10 vDDLNewSkill8 , none||1|2|3|4|5|6|7|8|9|10|11|12            ;; Added by Kitt for creating custom autocast

GuiControl , 32:Hide , DDLNewSkill5
GuiControl , 32:Hide , DDLNewSkill6
GuiControl , 32:Hide , TextNewSkill5
GuiControl , 32:Hide , TextNewSkill6
Gui , 32:Add , Button, xp y+10 w80 h25 gl_NewCodeWndSubmit default, OK
Gui , 32:Show , autosize center, %spwtitle2%
return 1
}

f_GUIDestroyNewCodeWnd()
{
global
Gui , 3:-Disabled
Gui , 3:Default
Gui , 32:Destroy
return 1
}


f_GUICreateNewCodeHeaderWnd(sec)
{
global
Gui , 3:+Disabled
Gui , 33:-Minimizebox +owner3
Gui , 33:Default
Gui , 33:Add , Edit , w180 Limit4 vEditNewHeader, %sec%
Gui , 33:Add , Button, xp y+10 w80 h25 gl_NewHeaderWndSubmit default, OK
Gui , 33:Show , autosize center, %spwtitle3%
return 1
}

f_GUIDestroyNewCodeHeaderWnd()
{
global
Gui , 3:-Disabled
Gui , 3:Default
Gui , 33:Destroy
return 1
}




;###########################################################################################
;# About Window                                                                            #
;###########################################################################################

f_GUICreateAbout()
{
global
Gui , 1:+Disabled
Gui , 4:-MinimizeBox +owner1
Gui , 4:Default

Gui , 4:Add, Picture, x5 y20, %A_WorkingDir%\temp\about.gif
Gui , 4:Add, picture, x80 y95 w260 , %A_WorkingDir%\temp\ciara.bmp
Gui , 4:Add, picture, x80 y190 w260 , %A_WorkingDir%\temp\ciara.bmp
Gui , 4:Add, Text, x80 y20, Version: %sVersion%
Gui , 4:Add, Text, x80 yp+15, Copyright (c) 2005-2009 Matus Goljer
Gui , 4:Add, Text, x80 y60, This product is completely free under the terms of`nthe
Gui , 4:Font, underline
Gui , 4:Add, Text, x99 y73 cBlue gl_License, GNU General Public License
Gui , 4:Font, norm
Gui , 4:Add, Text, x80 y110, ICQ: 320-082-612
Gui , 4:Add, Text, x80 yp+15, Jabber: dota.keys@gmail.com
Gui , 4:Font, underline
Gui , 4:Add, Text, x80 yp+15 gl_email cBlue, E-mail: dota.keys@gmail.com
Gui , 4:Add, Text, x80 yp+15 gl_MenuHomepage cBlue, Homepage: http://dotakeys.forumer.com
Gui , 4:Font, norm
Gui , 4:Add, Text, x80 yp+15 , IRC: #dotakeys@irc.quakenet.org
Gui , 4:Add, Text, x80 y200, Current members of the DotaKeys team:
Gui , 4:Add, Text, x80 yp+15, Matus Goljer ( Project leader and programmer )
Gui , 4:Add, Text, x80 yp+15, Kitt ( programmer )
Gui , 4:Add, Button, x265 y260 w75 h25 gl_AboutExit, OK
Gui , 4:Show, w350 h295 center , About DotaKeys
iMiscWindow := 4
return 1
}

f_GUIDestroyAbout()
{
global
Gui , 1:-Disabled
Gui , 4:Destroy
iMiscWindow := 0
return
}


;###########################################################################################
;# Macro Window                                                                            #
;###########################################################################################

f_GUICreateMacro()
{
global
Gui , 1:+Disabled
Gui , 5:-MinimizeBox +owner1
Gui , 5:Default
return 1
}

f_GUIDestroyMacro()
{
global
Gui , 1:-Disabled
Gui , 5:Destroy
iMiscWindow := 0
return
}

;###########################################################################################
;# Update Window #1 Checking for Update                                                    #
;###########################################################################################

f_GUICreateUpdate1()
{
global
Gui , 1:+Disabled
Gui , 6:-MinimizeBox +owner1 +AlwaysOnTop
Gui , 6:Default

Gui , 6:Font, , Tahoma
Gui , 6:Add, Picture, x0 y0 w397 h38, %A_WorkingDir%\temp\update_checking.gif
Gui , 6:Add, Picture, x-1 y230 w397 h2, %A_WorkingDir%\temp\line.gif
Gui , 6:Add, Text, x56 y50 w200 h20,DotaKeys is now checking for updates...
Gui , 6:Font,  s10 w700,
Gui , 6:Font,  norm s8,
Gui , 6:Font,  underline,
Gui , 6:Font,  norm,
Gui , 6:Font,  w700,
Gui , 6:Add, Button, x325 y243 w65 h25, Cancel
Gui , 6:Font,  norm,
Gui , 6:Add, Progress, x56 y70 w300 h20 -smooth range0-100 vupgP_check, 0
Gui , 6:Show, center h282 w397, DotaKeys Update
iMiscWindow := 6
return 1
}

f_GUIDestroyUpdate1()
{
global
Gui , 1:-Disabled
Gui , 6:Destroy
iMiscWindow := 0
return
}

;###########################################################################################
;# Update Window #2 Available                                                              #
;###########################################################################################


f_GUICreateUpdate2()
{
global
Gui , 1:+Disabled
Gui , 7:-MinimizeBox +owner1 +AlwaysOnTop
Gui , 7:Default

Gui , 7:Font,, Tahoma
Gui , 7:Add, Picture, x0 y0 w397 h38, %A_WorkingDir%\temp\update_available.gif
Gui , 7:Add, Picture, x-1 y230 w397 h2, %A_WorkingDir%\temp\line.gif
Gui , 7:Add, Text, x56 y50 w200 h20, A new version of DotaKeys is available:
Gui , 7:Font, s10 w700
Gui , 7:Add, Text, x56 y72 w140 h30, DotaKeys %nVersion%
Gui , 7:Font, norm s8
Gui , 7:Add, Text, x56 y97 w300 h30, It is strongly recommended that you upgrade DotaKeys as soon as possible.
Gui , 7:Font, underline
Gui , 7:Add, Text, x56 y150 w300 h40 cblue gl_UpdateShowChangelog, View more information about this update
Gui , 7:Font, norm
Gui , 7:Add, Button, x6 y243 w70 h25 gl_UpdateLater ,Later
Gui , 7:Font, w700
Gui , 7:Add, Button, x196 y243 w190 h25 default gl_UpdateUpdate ,Download && Install Now >>
Gui , 7:Font, norm
Gui , 7:Show, center h280 w397, DotaKeys Update
iMiscWindow := 7
return 1
}

f_GUIDestroyUpdate2()
{
global
Gui , 1:-Disabled
Gui , 7:Destroy
iMiscWindow := 0
return
}


;###########################################################################################
;# Update Window #3 Not Found                                                              #
;###########################################################################################


f_GUICreateUpdate3()
{
global
Gui , 1:+Disabled
Gui , 8:-MinimizeBox +owner1 +AlwaysOnTop
Gui , 8:Default

Gui , 8:Font, , Tahoma
Gui , 8:Add, Picture, x0 y0 w397 h38, %A_WorkingDir%\temp\update_notfound.gif
Gui , 8:Add, Picture, x-1 y230 w397 h2, %A_WorkingDir%\temp\line.gif
Gui , 8:Add, Text, x56 y50 w200 h20,There are no new updates available.
Gui , 8:Font,  s10 w700,
Gui , 8:Font,  norm s8,
Gui , 8:Font,  underline,
Gui , 8:Font,  norm,
Gui , 8:Font,  w700,
Gui , 8:Add, Button, x325 y243 w65 h25 default gl_UpdateNoUpdate, Finish
Gui , 8:Font,  norm,
Gui , 8:Show, center h282 w397, DotaKeys Update
iMiscWindow := 8
return 1
}

f_GUIDestroyUpdate3()
{
global
Gui , 1:-Disabled
Gui , 8:Destroy
iMiscWindow := 0
return
}


;###########################################################################################
;# Update Window #4 Downloading                                                            #
;###########################################################################################


f_GUICreateUpdate4()
{
global
Gui , 1:+Disabled
Gui , 9:-MinimizeBox +owner1 +AlwaysOnTop
Gui , 9:Default

Gui , 9:Font, , Tahoma
Gui , 9:Add, Picture, x0 y0 w397 h38, %A_WorkingDir%\temp\update_downloading.gif
Gui , 9:Add, Picture, x-1 y230 w397 h2, %A_WorkingDir%\temp\line.gif
Gui , 9:Font,  s10 w700,
Gui , 9:Font,  norm s8,
Gui , 9:Font,  underline,
Gui , 9:Font,  norm,
Gui , 9:Font,  w700,
Gui , 9:Add, Button, x325 y243 w65 h25 default disabled gl_UpdateFinish vbFinish, Finish
Gui , 9:Font,  norm,
Gui , 9:Add, Progress, x56 y70 w300 h20 -Smooth range0-100 vupgP_total , 0
Gui , 9:Add, Text, x56 y50 w300 h20 vupgT_updatetext , Updating DotaKeys %sVersion%
Gui , 9:Add, Text, x56 y150 w300 h70 vupgT_success, ;Update from version %sVersion% to version %nVersion% was successfuly comleted. Thanks for using DotaKeys.
Gui , 9:Show, center h282 w397, DotaKeys Updater
iMiscWindow := 9
return 1
}

f_GUIDestroyUpdate4()
{
global
Gui , 1:-Disabled
Gui , 9:Destroy
iMiscWindow := 0
return
}
