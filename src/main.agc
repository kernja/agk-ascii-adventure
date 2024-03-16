#include "SplitString.agc"
#include "LoadImagesFromList.agc"
#include "LoadSpritesFromList.agc"
#include "LoadMap.agc"
#include "Gameplay.agc"
#include "LoadSoundsFromList.agc"
#include "LoadCGAFromList.agc"
#include "LoadTreasureFromList.agc"
#include "SaveStateManager.agc"
#include "LoadTextFromString.agc"
#include "gui.agc"
#constant GameVersion "V1"
#constant FullVersion 1

#constant GAMESTATE_BACKUP 0
#constant GAMESTATE_MAINMENU 1
#constant GAMESTATE_NEW 2
#constant GAMESTATE_LOAD 3
#constant GAMESTATE_HOWTO 4
#constant GAMESTATE_ABOUT 5
#constant GAMESTATE_PAUSE 6
#constant GAMESTATE_GAME 10
global gameState as integer

rem Landscape App
SetDisplayAspect( 4.0/3.0 )
SetOrientationAllowed(0,0,1,1)
SetVirtualResolution(960, 640)

global myResult as integer

SelectedSaveStateIndex = -1
myResult = LoadImagesFromCSV("imageList.csv", 1)
LoadSpritesFromCSV("spriteList.csv", 1)
LoadSoundsFromCSV("soundList.csv")
LoadLevelList()
LoadCGAFromCSV("cga.csv")
LoadTreasureFromCSV("treasureList.csv")
LoadTextFromCSV("textList.csv")
InitGameplayGUI()
InitGameplayMessage()

SetTextDefaultFontImage(99)
SetTextDefaultMagFilter(0)
SetTextDefaultMinFilter(0)

rem create gui's
CreateMainMenuGUI()
CreateSaveSlotGUI()
CreatePauseGUI()
CreateAboutGUI()
tPointerX as integer
tPointerY as integer

tLoadFile as integer
tFileExists = getfileexists("backup.csv")

gameState = GAMESTATE_MAINMENU

    if tFileExists = 1
        CreateRestoreBackupGUI()
        tLoadFile = RenderBackupGUI()

        if tLoadFile = 1
            LoadState(1)
            LoadMap()
            gameState = GAMESTATE_GAME
        endif
    endif

do

    SetSpriteVisible(399, 1)

    if gameState = GAMESTATE_GAME
        SetSpriteVisible(399, 0)
        SetSpriteVisible(3001, 1)
        UpdateGameplay(GetPointerX(), GetPointerY(), GetModifiedFrameTime())
        SetViewOffset(-608 + (playerX * mapTileWidth),  -256 + (playerY * mapTileHeight))
    `elseif gameState = GAMESTATE_LOAD
    `    RenderLoadGameGUI(0, 0)
    elseif gameState = GAMESTATE_MAINMENU
        RenderMainMenuGUI()
    endif

    SyncOverride()
loop


function GetModifiedFrameTime()
    myReturn as float
    myReturn = GetFrameTime()

    if myReturn > .01667
        myReturn = .01667
    endif

endfunction  myReturn

function PadStringLeft(pString as string, pTotalSpaces as integer)
    myReturn as string
    myCount as integer
    myCount = len(pString)

    myReturn = pString

    if pTotalSpaces - myCount > 0
        myReturn = spaces(pTotalSpaces - myCount)
        myReturn = myReturn + pString
    endif

endfunction myReturn

function SyncOverride()
    renderCGAColors(GetModifiedFrameTime())

    If getrawkeypressed(27)
        end
    endif

    sync()
endfunction
