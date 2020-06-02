﻿#NoEnv
SendMode Input
#SingleInstance Force
#MaxThreadsPerHotkey 2
#IfWinActive VALORANT
SetWorkingDir, %A_ScriptDir%


;----  SOUNDS
;
FileInstall, enable.wav, enable.wav
FileInstall, disable.wav, disable.wav


;----  DEFAULT FILES
;
defaultlist = Breach	:0`nCypher	:0`nJett	:0`nPhoenix	:0`nSage	:0`nSova	:0`nViper	:0`nBrimstone	:0`nOmen	:0`nRaze	:0`nReyna	:0`n
ifnotexist,Agent List.txt
    {
    FileAppend, %defaultlist%, %A_ScriptDir%\Agent List.txt
    }
	
ifnotexist,Config.ini
    {
    IniWrite, 0, Config.ini, Agents Icons, yPosition
    IniWrite, 0, Config.ini, Continue Button, xPosition
    IniWrite, 0, Config.ini, Continue Button, yPosition
    }


;----  READ POS
;
agents:=Object()
names:=Object()

Loop, Read, Agent List.txt
{
    StringSplit, line, A_LoopReadLine, :, %A_Space%%A_Tab%
    agents[line1] := line2
}

for i, element in agents
    names .= i . "|"

IniRead, y, Config.ini, Agents Icons, yPosition , 687

IniRead, xContinue, Config.ini, Continue Button, xPosition , 680
IniRead, yContinue, Config.ini, Continue Button, yPosition , 600


;----  GUI
;
Gui, Font, s10
Gui, Add, Text,, Selecione um agente
Gui, Add, DropDownList,w85 vElement gAction, %names%
Gui, Add, Text,,Press F4 to enable/disable.`nThe agent will be picked up `nas the agent selection appears.`n`n(C) PINTOSO 2020
Gui, Show, w230 h145, Agent Picker

;----  LAST WINDOW POS
;

ifnotexist,ignore.ini
    {
    IniWrite, first, ignore.ini, lastwinpos, xpos
    IniWrite, first, ignore.ini, lastwinpos, ypos
    }

IniRead, xpos, ignore.ini, lastwinpos, xpos
IniRead, ypos, ignore.ini, lastwinpos, ypos
if (xpos="first")
  Gui, show, w230 h145
else
  Gui, show, w230 h145 x%xpos% y%ypos%
return


GuiClose:
  WinGetPos, xpos, ypos
  IniWrite, %xpos%, ignore.ini, lastwinpos, xpos
  IniWrite, %ypos%, ignore.ini, lastwinpos, ypos
  ExitApp


;----  GUI AGENT SELECTION
;
x =
y =
name =

Action:
Gui, Submit, nohide
x = % agents[Element]
name = % Element
return


;----  TOGGLE SCRIPT
;
toggle=false
F4::
toggle := !toggle
if !toggle
	{
        SoundPlay, disable.wav
        return
    }

SoundPlay, enable.wav
Loop
{    
    if !toggle
        break 
    
        Sleep, 51
        MouseClick, left, x, y
        Sleep, 51
        MouseClick, left, xContinue, yContinue
}
return


;----  TRAY
;
TrayTip, Agent Picker, #PINTOSO#
Menu, tray, NoStandard
Menu, tray, add
Menu, tray, add, @PINTOSO, link
Menu, tray, add
Menu, tray, add, EXIT, Exit

link:
run, https://steamcommunity.com/id/Dennil/
return
exit:
ExitApp
return
