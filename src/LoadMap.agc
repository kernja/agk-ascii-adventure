#constant mapTileWidth 32
#constant mapTileHeight 64

#constant mapTile_Player 17
#constant mapTile_PlayerDead 39
#constant mapTile_GameOver 62
#constant mapTile_Key 16
#constant mapTile_Lock 15
#constant mapTile_Whip 9
#constant mapTile_Chest 11
#constant mapTile_Boulder 26
#constant mapTile_EnemyA 23
#constant mapTile_EnemyB 24
#constant mapTile_EnemyC 25
#constant mapTile_Lava 8
#constant mapTile_LavaGenerate 61
#constant mapTile_Blank 0
#constant mapTile_PlayerPoisoned 40
#constant mapTile_Potion 14
#constant mapTile_GemA 19
#constant mapTile_GemB 20
#constant mapTile_GemC 21
#constant mapTile_GemFinal 22
#constant mapTile_Trans 12
#constant mapTile_Switch 13
#constant mapTile_Goal 18
#constant mapTile_GoalToWarp 75
#constant mapTile_HiddenSwitch 41
#constant mapTile_Message 48
#constant mapTile_Warp 47
#constant mapTile_WhipPowerup 10

#constant tileProp_Movable 3
#constant tileProp_Alt 16
#constant tileProp_SolidPlayer 0
#constant tileProp_SolidEnemy 1
#constant tileProp_SolidBlock 2
#constant tileProp_ChangeHealth 4
#constant tileProp_ChangeWhips 5
#constant tileProp_ChangeScore 6
#constant tileProp_DestroyEnemy 10
#constant tileProp_DestroyBoulder 11
#constant tileProp_ToggleSwitch 18
#constant tileProp_GenerateTile 15

type Type_MapTileDefinition
    id as integer
    hasGravity as integer
    spriteID as integer
endtype

type Type_MapTile
    definitionID as integer
    spriteID as integer
    tag as integer
    arrowTag as integer
    alt as integer
    X as integer
    Y as integer
    enemyTag as integer
endtype

global dim mapTileDefinitions[1] as Type_MapTileDefinition
global dim mapTileProperties[1,19] as integer
global dim mapTiles[1,1] as Type_MapTile

global mapName as string
global mapWidth as integer
global mapHeight as integer
global mapStart as integer
global mapTileDefinitionCount as integer = 1
global mapGravity as integer
global mapSpriteIndex as integer
global mapGeneratorSpeed as float

function LoadMap()
    myFile as string

    SetSpriteVisible(152, 1)
    SyncOverride()

    myFile = getLevelPathFromID(levelSelected)
    SaveState(1)
    LoadMapFromCSV(myFile)
    SetViewOffset(-608 + (playerX * mapTileWidth),  -256 + (playerY * mapTileHeight))

endfunction

function LoadMapFromCSV(pFileName as string)
    REM MYRETURN VALUE
    REM TO STORE WHETHER OR NOT EVERYTHING COMPLETED SUCCESSFULLY
    REM 0 MEANS NO, 1 MEANS YES
    REM SET IT TO 1 INITIALLY, IF SOME ERROR OCCURS SET IT TO 0
    REM IF IT MAKES IT THROUGH THE ENTIRE FUNCTION NORMALLY, IT HAS COMPLETED SUCCESSFULLY!
    myReturn as integer
    myReturn = 1
	REM FILE ID THAT WE WORK WITH WHEN MANIPULATING THE FILE
	tFileID as integer

    REM COUNTER VARIABLES
    i as integer
    j as integer

	REM TEMP VARIABLES USED FOR HOLDING DATA FROM THE CSV
	REM DEFINITION
	tTotalCount as integer
	tTileID as integer
	tTileGravity as integer
	tBaseSprite as integer
    REM MAP DATA
    tWidth as integer
    tHeight as integer
    tBase as integer
    tGravity as integer
    tName as string
    tTag as integer

	REM VARIABLE TO HOLD DATA BEING READ FROM THE CSV
	tString as string

    REM MAKE SURE FILE PASSED IN EXISTS
	if GetFileExists(pFileName) = 1

	REM GET FILE NAME AND FILE ID
	tFileID = opentoread(pFileName)

		REM READ FIRST LINE OF FILE
		REM AS IT CONTAINS GUID
		tString = readline(tFileID)

        REM READ IN HOW MANY OBJECTS WE HAVE TO COUNT
        tString = readline(tFileID)
        tTotalCount = val(tString)
        mapTileDefinitionCount = tTotalCount

        dim mapTileDefinitions[1]
        dim mapTileDefinitions[tTotalCount]
        dim mapTileProperties[1,19]
        dim mapTileProperties[tTotalCount, 19]

        for i = 0 to tTotalCount - 1
            tString = readline(tFileID)
            tTileID = val(SplitString(tString, ",", 0))
            tTileGravity = val(SplitString(tString, ",", 2))
            tBaseSprite = val(SplitString(tString, ",", 3))

            mapTileDefinitions[i].id = tTileID
            mapTileDefinitions[i].spriteID = tBaseSprite
            mapTileDefinitions[i].hasGravity = tTileGravity

            tString = readline(tFileID)

            for j = 0 to 18
                mapTileProperties[i, j] = val(SplitString(tString, ",", j))
            next
        next

        REM MAP DATA
        mapName = readline(tFileID)
        tString = readline(tFileID)
        tWidth = val(SplitString(tString, ",", 0))
        tHeight = val(SplitString(tString, ",", 1))

        mapWidth = tWidth
        mapHeight = tHeight

        dim mapTiles[1,1]
        dim mapTiles[tWidth, tHeight]

        tGravity = val(readLine(tFileID))
        mapGravity = tGravity

        mapGeneratorSpeed = val(readline(tFileID)) * .001

        REM DELETE ALL SPRITES SINCE WE'RE ASSIGNING NEW ONES
        DeleteMapSprites()

        for i = 0 to mapWidth - 1
            for j = 0 to mapHeight - 1
                tString = readLine(tFileID)
                tBase = val(SplitString(tString, ",", 0))
                tTag = val(SplitString(tString, ",", 1))

                mapTiles[i, j].definitionID = tBase
                mapTiles[i, j].tag = tTag
                mapTiles[i, j].alt = GetAltTileFromBlockID(tBase)
                mapTiles[i, j].spriteID = mapSpriteIndex
                mapTiles[i, j].X = i * mapTileWidth
                mapTiles[i, j].Y = j * mapTileHeight

                clonesprite(mapSpriteIndex, GetBaseSpriteFromBlockID(tBase))
                SetSpritePosition(mapSpriteIndex, mapTiles[i,j].X, mapTiles[i,j].Y)
                setspritevisible(mapSpriteIndex, 1)

                if tBase = mapTile_Player
                    playerX = i
                    playerY = j
                endif
                mapSpriteIndex = mapSpriteIndex + 1
            next
        next

        closefile(tFileID)

        dim playerStatusEffects[12] as float
        ClearPlayerStatusEffects()

        playerLevelFinished = 0

        mapStart = 0
        enemyTimer = 0
        generateTimer = 0

        tString = GetTextLibraryString(40) + PadStringLeft(str(levelSelected + 1), 3)
        SetTextString(1000, tString)

        rem delete backup csv
        deletefile("backup.csv")
        SaveState(1)
    else
        REM CSV NOT FOUND. RETURN 0
        myReturn = 0
	endif

endfunction myReturn

function DeleteMapSprites()
    i as integer
    for i = 1000 to 2999
        deletesprite(i)
    next

    mapSpriteIndex = 1000
endfunction

function GetBaseSpriteFromBlockID(pID as integer)
    i as integer
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = pID
            myReturn = mapTileDefinitions[i].spriteID
            exitfunction myReturn
        endif
    next
endfunction myReturn

function GetAltTileFromBlockID(pID as integer)
    i as integer
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = pID
            myReturn = mapTileProperties[i, tileProp_Alt]
            exitfunction myReturn
        endif
    next
endfunction myReturn

function IsTileSolidPlayer(pX as integer, pY as integer)
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = mapTiles[pX, pY].definitionID
            myReturn = mapTileProperties[i,tileProp_SolidPlayer]
            exitfunction myReturn
        endif
    next
endfunction myReturn

function IsTileSolidEnemy(pX as integer, pY as integer)
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = mapTiles[pX, pY].definitionID
            myReturn = mapTileProperties[i,tileProp_SolidEnemy]
            exitfunction myReturn
        endif
    next
endfunction myReturn

function IsTileSolidBoulder(pX as integer, pY as integer)
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = mapTiles[pX, pY].definitionID
            myReturn = mapTileProperties[i,2]
            exitfunction myReturn
        endif
    next
endfunction myReturn

function GetTileTypeFromPosition(pX as integer, pY as integer)
    myReturn as integer
    myReturn =  mapTiles[pX, pY].definitionID
endfunction myReturn

function GetTilePropertyFromPosition(pX as integer, pY as integer, pIndex as integer)
    myReturn as integer
    myType as integer
    myType = GetTileTypeFromPosition(pX, pY)
    myReturn = GetTilePropertyFromIndex(myType, pIndex)
endfunction myReturn

function GetTilePropertyFromIndex(pID as integer, pIndex as integer)
    myReturn as integer

    for i = 0 to mapTileDefinitionCount - 1
        if mapTileDefinitions[i].id = pID
            myReturn = mapTileProperties[i,pIndex]
            exitfunction myReturn
        endif
    next
endfunction myReturn
