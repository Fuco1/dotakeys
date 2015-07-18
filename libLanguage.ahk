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
;# Function for loading strings ( based on current language )                              #
;###########################################################################################

f_LoadStrings()
{
global
local file, file2
file = langs\%sLanguage%.ini
file2 = langs\english.ini

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main

;; BUTTONS
iniread , sb , %file% , main , sb
if ( sb = "ERROR" )
	return 0

loop , %sb%
	{
	iniread , sb%A_Index% , %file% , main , sb%A_Index%
	if ( sb%A_Index% = "ERROR" )
		iniread , sb%A_Index% , %file2% , main , sb%A_Index%
	}

;; BOXES
iniread , sbox1 , %file% , main , sbox1
if ( sbox1 = "ERROR" )
	iniread , sbox1 , %file2% , main , sbox1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Menu

iniread , sh , %file% , menu , sh
if ( sh = "ERROR" )
	return 0

loop , %sh%
	{
	iniread , sh%A_Index% , %file% , menu , sh%A_Index%
	if ( sh%A_Index% = "ERROR" )
		iniread , sh%A_Index% , %file2% , menu , sh%A_Index%
	}

iniread , ss11 , %file% , menu , ss11
if ( ss11 = "ERROR" )
	iniread , ss11 , %file2% , menu , ss11

iniread , ss12 , %file% , menu , ss12
if ( ss12 = "ERROR" )
	iniread , ss12 , %file2% , menu , ss12

iniread , ss21 , %file% , menu , ss21
if ( ss21 = "ERROR" )
	iniread , ss21 , %file2% , menu , ss21

iniread , ss22 , %file% , menu , ss22
if ( ss22 = "ERROR" )
	iniread , ss22 , %fil2e% , menu , ss22

iniread , ss23 , %file% , menu , ss23
if ( ss23 = "ERROR" )
	iniread , ss23 , %file2% , menu , ss23

iniread , ss31 , %file% , menu , ss31
if ( ss31 = "ERROR" )
	iniread , ss31 , %file2% , menu , ss31

iniread , ss32 , %file% , menu , ss32
if ( ss32 = "ERROR" )
	iniread , ss32 , %file2% , menu , ss32

iniread , ss33 , %file% , menu , ss33
if ( ss33 = "ERROR" )
	iniread , ss33 , %file2% , menu , ss33

iniread , ss34 , %file% , menu , ss34
if ( ss34 = "ERROR" )
	iniread , ss34 , %file2% , menu , ss34

iniread , ss35 , %file% , menu , ss35
if ( ss35 = "ERROR" )
	iniread , ss35 , %file2% , menu , ss35

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Editor

;; Tabs
iniread , set , %file% , editor , set
if ( set = "ERROR" )
	return 0

loop , %set%
	{
	iniread , set%A_Index% , %file% , editor , set%A_Index%
	if ( set%A_Index% = "ERROR" )
		iniread , set%A_Index% , %file2% , editor , set%A_Index%
	}

iniread , seb , %file% , editor , seb
if ( seb = "ERROR" )
	return 0

loop , %seb%
	{
 	iniread , seb%A_Index% , %file% , editor , seb%A_Index%
	if ( seb%A_Index% = "ERROR" )
		iniread , seb%A_Index% , %file2% , editor , seb%A_Index%
	}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Preferences

iniread , sptitle , %file% , preferences , sptitle
if ( sptitle = "ERROR" )
	return 0

iniread , sptab , %file% , preferences , sptab
if ( sptab = "ERROR" )
	return 0

loop , %sptab%
	{
	iniread , sptab%A_Index% , %file% , preferences , sptab%A_Index%
	if ( sptab%A_Index% = "ERROR" )
		iniread , sptab%A_Index% , %file2% , preferences , sptab%A_Index%
	}

iniread , spcb , %file% , preferences , spcb
if ( spcb = "ERROR" )
	return 0

loop , %spcb%
	{
	iniread , spcb%A_Index% , %file% , preferences , spcb%A_Index%
	if ( spcb%A_Index% = "ERROR" )
		iniread , spcb%A_Index% , %file2% , preferences , spcb%A_Index%
	}

iniread , spb , %file% , preferences , spb
if ( spb = "ERROR" )
	return 0

loop , %spb%
	{
	iniread , spb%A_Index% , %file% , preferences , spb%A_Index%
	if ( spb%A_Index% = "ERROR" )
		iniread , spb%A_Index% , %file2% , preferences , spb%A_Index%
	}

iniread , sptext , %file% , preferences , sptext
if ( sptext = "ERROR" )
	return 0

loop , %sptext%
	{
	iniread , sptext%A_Index% , %file% , preferences , sptext%A_Index%
	if ( sptext%A_Index% = "ERROR" )
		iniread , sptext%A_Index% , %file2% , preferences , sptext%A_Index%
	}


iniread , spwtitle , %file% , preferences , spwtitle
if ( spwtitle = "ERROR" )
	return 0

loop , %spwtitle%
	{
	iniread , spwtitle%A_Index% , %file% , preferences , spwtitle%A_Index%
	if ( spwtitle%A_Index% = "ERROR" )
		iniread , spwtitle%A_Index% , %file2% , preferences , spwtitle%A_Index%
	}

return 1
}

f_LoadPreStrings()
{
global
local file, file2
file = langs\%sLanguage%.ini
file2 = langs\english.ini

iniread , loading , %file% , loading , loading
if ( loading = "ERROR" )
	iniread , loading , %file2% , loading , loading

iniread , stage , %file% , loading , stage
if ( stage = "ERROR" )
	return 0

loop , %stage%
	{
 	iniread , stage%A_Index% , %file% , loading , stage%A_Index%
	if ( stage%A_Index% = "ERROR" )
		iniread , stage%A_Index% , %file2% , loading , stage%A_Index%
	}
return 1
}


/*
[preferences]
sptitle=Preferences
sptab1=General
sptab2=Settings
sptab3=Custom Codes
sptab4=Commands (Orders)
*/
