global playerX as integer
global playerY as integer
global playerNewX as integer
global playerNewY as integer
global playerHealth as integer
global playerWhips as integer
global playerWhipStrength as integer
global playerScore as integer
global playerKeys as integer
global playerLevelFinished as integer
global playerCompletedGame as integer
global playerShowOverlay as integer

global inputDelayTimer as float
global enemyTimer as float
global generateTimer as float

#constant potionType_Blind 3
#constant potionType_Poison 1
#constant potionType_Invisible 2
#constant potionType_EnemyWeaken 4
#constant potionType_EnemyStrengthen 5
#constant potionType_EnemyFaster 6
#constant potionType_EnemySlower 7
#constant potionType_PlayerWeaken 8
#constant potionType_PlayerStrengthen 9
#constant potionType_PlayerFaster 10
#constant potionType_PlayerSlower 11

global dim playerStatusEffects[12] as float

function UpdateGameplay(pPointerX as integer, pPointerY as integer, pFrameTime as float)
    tEnemyTimeLimit as float
    tEnemyTimeLimit = 1

    if gameState = GAMESTATE_GAME
        if playerHealth > 0
            if mapStart = 0
                SetSpriteVisible(152, 0)
                SetGameplayMessageVisible(1)
                SetGameplayMessageText(mapName)
                RenderGameplayMessage()
                SetGameplayMessageVisible(0)
                mapStart = 1
            endif

            UpdateGameplayGUI()
            checkPlayerMenu(pPointerX, pPointerY)

            if playerLevelFinished = 0
                UpdatePlayerStatusEffects(pFrameTime)
                CheckPlayerMovementInput(pPointerX, pPointerY, pFrameTime)

                if mapGeneratorSpeed > 0
                    generateTimer = generateTimer + pFrameTime
                    if generateTimer > mapGeneratorSpeed
                        generateTimer = generateTimer - mapGeneratorSpeed
                        UpdateGeneratorTiles()
                    endif
                endif

                enemyTimer = enemyTimer + pFrameTime
                tEnemyTimeLimit = 1 + playerStatusEffects[potionType_EnemyFaster] + playerStatusEffects[potionType_EnemySlower]

                if tEnemyTimeLimit < .5
                    tEnemyTimeLimit = .5
                endif

                if tEnemyTimeLimit > 1.5
                    tEnemyTimeLimit = 1.5
                endif

                if enemyTimer > tEnemyTimeLimit
                    enemyTimer = enemyTimer - tEnemyTimeLimit
                    UpdateEnemyMovement()
                endif
            else

                if playerLevelFinished <= 2
                    if playerLevelFinished = 1
                         levelSelected = levelSelected + 1
                        RenderLinesFromTextLibrary(0)
                    elseif playerLevelFinished = 2
                        RenderLinesFromTextLibrary(51)
                        levelSelected = levelSelected + mapTiles[playerX, playerY].tag
                    endif

                    SaveStateLevel.whips = playerWhips
                    SaveStateLevel.keys = playerKeys
                    SaveStateLevel.life = playerHealth
                    SaveStateLevel.whipStrength = playerWhipStrength
                    SaveStateLevel.score = playerScore
                    SaveStateLevel.levelID = levelSelected

                LoadMap()

                else playerLevelFinished = 3
                    x as integer
                    y as integer
                    tWait as float
                    tLevel as integer
                    tLevel = levelSelected
                    playsoundsync(16)
                    for y = 0 to mapHeight - 1
                        if y > 10
                            exit
                        endif

                        for x = 0 to mapWidth - 1
                            if (mapTiles[x, y].definitionID > mapTile_GameOver or mapTiles[x, y].definitionID < mapTile_GameOver) and (mapTiles[x, y].definitionID > mapTile_GemFinal or mapTiles[x, y].definitionID < mapTile_GemFinal) and (mapTiles[x, y].definitionID > mapTile_Player or mapTiles[x, y].definitionID < mapTile_Player)
                                SwitchTileToNew(x, y, mapTile_Blank)
                                `playsoundsync(12)
                                while tWait < .01
                                    tWait = tWait + GetModifiedFrameTime()
                                    SyncOverride()
                                endwhile
                                tWait = 0
                            endif
                        next
                    next

                    levelSelected = 0
                    PlayerCompletedGame = 1
                    SaveStateLevel.whips = playerWhips
                    SaveStateLevel.keys = playerKeys
                    SaveStateLevel.life = playerHealth
                    SaveStateLevel.whipStrength = playerWhipStrength
                    SaveStateLevel.score = playerScore
                    SaveStateLevel.levelID = levelSelected
                    playsound(14)

                    if FullVersion = 1
                        if tLevel = 54
                            RenderLinesFromTextLibrary(336)
                        endif

                        if tLevel = 53
                            RenderLinesFromTextLibrary(171)
                        endif
                    else
                        RenderLinesFromTextLibrary(232)
                    endif
                    RenderSaveGameGUI(1)
                    SetSpriteVisible(399, 1)
                    gameState = GAMESTATE_MAINMENU
                endif
            endif
        else
            playsoundsync(17)
            SwitchTileToNew(playerX, playerY, mapTile_PlayerDead)
            playsound(14)
            RenderLinesFromTextLibrary(170)
            SetMainMenuGUIVisible(1)
            GameState = GameState_MainMenu
        endif
    endif
endfunction

function UpdateGeneratorTiles()
    x as integer
    y as integer

    randX as integer
    randY as integer
    tTag as integer

    targetX as integer
    targetY as integer

    stepX as integer
    stepY as integer

    testX as integer
    testY as integer

    genTile as integer
    targetTile as integer

    tFinished as integer
    tFailed as integer

    for x = 0 to mapWidth - 1
        for y = 0 to mapHeight - 1
            targetTile = GetTilePropertyFromPosition(x, y, tileProp_GenerateTile)


            if targetTile > mapTile_Blank
                genTile = mapTiles[x,y].definitionID
                tTag = mapTiles[x,y].tag

                randX = random(0, tTag)
                randY = random(0, tTag)

                targetX = x + randX - floor((tTag * .5))
                targetY = y + randY - floor((tTag * .5))

                if CheckValidTargetLocation(targetX, targetY) = 1
                    if (targetX - x) > 0
                        stepX = 1
                    elseif (targetX - x) < 0
                        stepX = -1
                    else
                        stepX = 0
                    endif

                    if (targetY - y) > 0
                        stepY = 1
                    elseif (targetY - y) < 0
                        stepY = -1
                    else
                        stepY = 0
                    endif

                    tFinished = 0
                    tFailed = 0

                    testX = x `targetX
                    testY = y `targetY

             `f tTag > 0
              `  print(str(stepX) + "," + str(stepY))
            `endif
                    while tFinished = 0 and tFailed = 0
                        if testX > targetX or testX < targetX
                            testX = testX + stepX
                        endif

                        if testY > targetY or testY < targetY
                            testY = testY + stepY
                        endif

                        if mapTiles[testX, testY].definitionID = mapTile_Blank or mapTiles[testX, testY].definitionID = targetTile or mapTiles[testX, testY].definitionID = genTile

                        else
                            tFailed = 1
                        endif

                        if testX = targetX and testY = targetY
                            tFinished = 1
                        endif

                    endwhile

                    if tFailed = 0 and mapTiles[testX, testY].definitionID = mapTile_Blank and tFinished = 1
                        SwitchTileToNew(testX, testY, targetTile)
                    endif
                endif
            endif
        next
    next
endfunction

function WeakenMonsters()
    SetGameplayMessageTextFromLibrary(55)
    playerStatusEffects[potionType_EnemyWeaken] = playerStatusEffects[potionType_EnemyWeaken] - 1
endfunction

function StrengthenMonsters()
    SetGameplayMessageTextFromLibrary(56)
    playerStatusEffects[potionType_EnemyStrengthen] = playerStatusEffects[potionType_EnemyStrengthen] + 1
endfunction

function SpeedUpMonsters()
    SetGameplayMessageTextFromLibrary(53)
    playerStatusEffects[potionType_EnemyFaster] = playerStatusEffects[potionType_EnemyFaster] - .1
endfunction

function SlowDownMonsters()
    SetGameplayMessageTextFromLibrary(54)
    playerStatusEffects[potionType_EnemySlower] = playerStatusEffects[potionType_EnemySlower] + .1
endfunction

function WeakenPlayer()
    SetGameplayMessageTextFromLibrary(60)
    playerStatusEffects[potionType_PlayerWeaken] = playerStatusEffects[potionType_PlayerWeaken] - 1
endfunction

function StrengthenPlayer()
    SetGameplayMessageTextFromLibrary(59)
    playerStatusEffects[potionType_PlayerStrengthen] = playerStatusEffects[potionType_PlayerStrengthen] + 1
endfunction

function SpeedUpPlayer()
    SetGameplayMessageTextFromLibrary(57)
    playerStatusEffects[potionType_PlayerFaster] = playerStatusEffects[potionType_PlayerFaster] - .05
endfunction

function SlowDownPlayer()
    SetGameplayMessageTextFromLibrary(58)
    playerStatusEffects[potionType_PlayerSlower] = playerStatusEffects[potionType_PlayerSlower] + .05
endfunction

function UpdatePlayerStatusEffects(pFrameTime as float)
    i as integer

    for i = 0 to 3
        if playerStatusEffects[i] > 0
        playerStatusEffects[i] = playerStatusEffects[i] - pFrameTime
            if playerStatusEffects[i] < 0
                playerStatusEffects[i] = 0

                rem blinded
                if i = 0
                    SetSpriteVisible(3004, 0)
                    RenderLinesFromTextLibrary(1)
                endif

                rem invisible
                if i = 1
                    if playerSTatusEffects[2] > 0
                        SwitchPlayerSprite(mapTile_PlayerPoisoned)
                    else
                        SwitchPlayerSprite(mapTile_Player)
                    endif

                        RenderLinesFromTextLibrary(2)
                endif

                rem poisoned
                if i = 2
                    if playerStatusEffects[1] > 0
                        SwitchPlayerSprite(mapTile_Blank)
                    else
                        SwitchPlayerSprite(mapTile_Player)
                    endif

                        RenderLinesFromTextLibrary(3)
                endif
            endif
        endif

    next
endfunction

function ClearPlayerStatusEffects()
    for i = 0 to 12
         playerStatusEffects[i] = 0
    next i

    if getspriteexists(3004) = 1
        SetSpriteVisible(3004, 0)
    endif
endfunction

function IsPlayerInvisible()
    myReturn as integer
    myReturn = 0

    if playerStatusEffects[1] > 0
        myReturn = 1
    endif

endfunction myReturn

function SetPlayerInvisible()
    playerStatusEffects[1] = playerStatusEffects[1] + random(15,35)
    SwitchPlayerSprite(mapTile_Blank)
endfunction

function IsPlayerPoisoned()
    myReturn as integer
    myReturn = 0

    if playerSTatusEffects[2] > 0
        myReturn = 1
    endif
endfunction myReturn

function SetPlayerPoisoned()
    playerSTatusEffects[2] = playerSTatusEffects[2] + random(15,35)
    if isPlayerInvisible() = 0
        SwitchPlayerSprite(mapTile_PlayerPoisoned)
    endif
endfunction

function SetPlayerBlinded()
    playerStatusEffects[0] = playerStatusEffects[0] + random(15,35)
    DeleteSprite(3004)
    CloneSprite(3004, 146)
    SetSpriteVisible(3004, 1)
endfunction

function UpdateEnemyMovement()
    x as integer
    y as integer
    tDist as float
    tTile as integer
    tMoveCount as integer
    tMoveCount = 0

    tX as integer
    tY as integer
    for x = mapWidth - 1 to 0 step -1
        for y = mapHeight - 1 to 0 step -1
            tTile = GetTileTypeFromPosition(x, y)
            if tTile >=  mapTile_EnemyA and tTile <=  mapTile_EnemyC
                if  mapTiles[x, y].enemyTag < 1
                    rem figure out distance between enemy and tile
                    tDist = sqrt(((x - playerX) ^ 2) + ((y - playerY) ^ 2) )

                    if tDist < 10

                        if playerX > x
                            tX = 1
                        elseif playerX < x
                            tX = -1
                        endif

                        if playerY > y
                            tY = 1
                        elseif playerY < y
                            tY = -1
                        endif

                        if CheckEnemyCanMoveSpot(x + tX, y + tY) = 1
                            EnemyLeaveTile(x, y)
                            EnemyEnterTile(x + tX, y + tY, tTile)
                                    tMoveCount = 1
                        elseif CheckEnemyCanMoveSpot(x + tX, y) = 1
                            if tX > 0 or tX < 0
                                    EnemyLeaveTile(x, y)
                                    EnemyEnterTile(x + tX, y, tTile)
                                        tMoveCount = 1
                            endif
                        elseif CheckEnemyCanMoveSpot(x, y + tY) = 1
                            if tY > 0 or tY < 0
                                    EnemyLeaveTile(x, y)
                                    EnemyEnterTile(x, y + tY, tTile)
                                    tMoveCount = 1
                            endif
                        endif
                    endif
                else
                    mapTiles[x, y].enemyTag = 0
                endif
            endif
        next
    next

    if tMoveCount = 1
        playsound(6)
    endif
endfunction

function CheckPlayerMovementInput(pPointerX as integer, pPointerY as integer, pFrameTime as float)
    rem current menu bar width is 256
    playerNewX = 0
    playerNewY = 0

    `playerNewX = round(GetJoystickX())
    `playerNewY = round(GetJoystickY())

    rem up arrow, num lock 8 (up), W, Q, E, home, pageup
    if GetRawKeyState(38) = 1 or GetRawKeyState(104) = 1 or GetRawKeyState(87) = 1 or GetRawKeyState(81) = 1 or GetRawKeyState(69) = 1 or GetRawKeyState(36) = 1 or GetRawKeyState(33) = 1
        playerNewY = -1
    endif

    rem down arrow, num lock 2 (down), X, Z, C, end, pgdown
    if GetRawKeyState(40) = 1 or GetRawKeyState(98) = 1 or GetRawKeyState(88) = 1 or GetRawKeyState(90) = 1 or GetRawKeyState(67) = 1 or GetRawKeyState(35) = 1 or GetRawKeyState(34) = 1
        playerNewY = 1
    endif

    rem left arrow, num lock 4 (left), A, Q, Z, home, end
    if GetRawKeyState(37) = 1 or GetRawKeyState(100) = 1 or GetRawKeyState(65) = 1 or GetRawKeyState(81) = 1 or GetRawKeyState(90) = 1 or GetRawKeyState(36) = 1  or GetRawKeyState(35) = 1
        playerNewX = -1
    endif

    rem right arrow, num lock 6 (right), D, E, C, pageup, pgdown
    if GetRawKeyState(39) = 1 or GetRawKeyState(102) = 1 or GetRawKeyState(68) = 1 or GetRawKeyState(69) = 1 or GetRawKeyState(67) = 1 or GetRawKeyState(33) = 1 or GetRawKeyState(34) = 1
        playerNewX = 1
    endif

    `if getpointerstate() = 1
        `if pPointerX >= 256

            rem move player to the left one
            `if pPointerX <= 384
            `    playerNewX = -1
            `elseif pPointerX >= 832
            `    playerNewX = 1
            `endif

            rem move player to the left one
            `if pPointerY <= 128
            `    playerNewY = -1
            `elseif pPointerY >= 512
            `    playerNewY = 1
           ` endif

            if IsPlayerPoisoned() = 1
                playerNewX = playerNewX * -1
                playerNewY = playerNewY * -1
            endif

            `if pPointerX >= 560 and pPointerX <= 688
                `if pPointerY >= 240 and pPointerY <= 320
                if GetButtonPressed(1) = 1
                    if playerWhips > 0
                     `CreatePlayerLimitedVisibility()
                        HandlePlayerWhip()
                    endif
                endif
                `endif
            `endif
        `else
            `PlaySoundSync(4)
    `    endif
    `endif


   ` if getpointerreleased() = 1
    `    sync()
    `    if pPointerX < 256
    `        RenderSaveGameGUI(1)
    `    endif
    `endif
    tTimerTime as float
    tTimerTime = .25 + playerStatusEffects[potionType_playerFaster] + playerStatusEffects[potionType_playerSlower]

    if tTimerTime < .05
        tTimerTime = .05
    endif

    if playerNewX = 0 and playerNewY = 0
        inputDelayTimer = tTimerTime - .001
    else
        inputDelayTimer = inputDelayTimer + pFrameTime
    endif

    if inputDelayTimer >= tTimerTime
        inputDelayTimer = inputDelayTimer - tTimerTime

        rem move the player
        rem make sure the new location is valid however
        oldX as integer
        oldY as integer
        oldX = playerX
        oldY = playerY

        if CheckPlayerCanMoveSpot(playerX + playerNewX, playerY + playerNewY, playerNewX, playerNewY) = 1
            playerX = playerX + playerNewX
            playerY = playerY + playerNewY

            PlayerLeaveTile(oldX, oldY)
            PlayerEnterTile(playerX, playerY)
            PlaySound(2)
        elseif CheckPlayerCanMoveSpot(playerX + playerNewX, playerY, playerNewX, playerNewY) = 1
            if playerNewX > 0 or playerNewX < 0
                playerX = playerX + playerNewX

                    PlayerLeaveTile(oldX, oldY)
                    PlayerEnterTile(playerX, playerY)
                    PlaySound(2)
            endif
        elseif CheckPlayerCanMoveSpot(playerX, playerY + playerNewY, playerNewX, playerNewY) = 1
            if playerNewY > 0 or playerNewY < 0
                playerY = playerY + playerNewY
                    PlayerLeaveTile(oldX, oldY)
                    PlayerEnterTile(playerX, playerY)
                    PlaySound(2)
            endif
        endif
    endif

    if oldX not playerX and oldY not playerY
         `PlaySound(2)
    elseif oldX = playerX and oldY = playerY
        if playerNewX > 0 or playerNewX < 0 or playerNewY > 0 or playerNewY < 0
            if getsoundsplaying(13) = 0
                playsound(13)
            endif
        endif
    endif

    remstart
    if getpointerstate() = 1
        if pPointerX >= 256

            rem move player to the left one
            if pPointerX <= 384
                playerNewX = -1
            elseif pPointerX >= 832
                playerNewX = 1
            endif

            rem move player to the left one
            if pPointerY <= 128
                playerNewY = -1
            elseif pPointerY >= 512
                playerNewY = 1
            endif

            if IsPlayerPoisoned() = 1
                playerNewX = playerNewX * -1
                playerNewY = playerNewY * -1
            endif

            if pPointerX >= 560 and pPointerX <= 688
                if pPointerY >= 240 and pPointerY <= 320
                    if playerWhips > 0
                    `CreatePlayerLimitedVisibility()
                        HandlePlayerWhip()
                    endif
                endif
            endif
        `else
            `PlaySoundSync(4)
        endif
    endif


   ` if getpointerreleased() = 1
    `    sync()
    `    if pPointerX < 256
    `        RenderSaveGameGUI(1)
    `    endif
    `endif
    tTimerTime as float
    tTimerTime = .25 + playerStatusEffects[potionType_playerFaster] + playerStatusEffects[potionType_playerSlower]

    if tTimerTime < .05
        tTimerTime = .05
    endif

    if playerNewX = 0 and playerNewY = 0
        inputDelayTimer = tTimerTime - .001
    else
        inputDelayTimer = inputDelayTimer + pFrameTime
    endif

    if inputDelayTimer >= tTimerTime
        inputDelayTimer = inputDelayTimer - tTimerTime

        rem move the player
        rem make sure the new location is valid however
        oldX as integer
        oldY as integer
        oldX = playerX
        oldY = playerY

        if CheckPlayerCanMoveSpot(playerX + playerNewX, playerY + playerNewY, playerNewX, playerNewY) = 1
            playerX = playerX + playerNewX
            playerY = playerY + playerNewY

            PlayerLeaveTile(oldX, oldY)
            PlayerEnterTile(playerX, playerY)
            PlaySound(2)
        elseif CheckPlayerCanMoveSpot(playerX + playerNewX, playerY, playerNewX, playerNewY) = 1
            if playerNewX > 0 or playerNewX < 0
                playerX = playerX + playerNewX

                    PlayerLeaveTile(oldX, oldY)
                    PlayerEnterTile(playerX, playerY)
                    PlaySound(2)
            endif
        elseif CheckPlayerCanMoveSpot(playerX, playerY + playerNewY, playerNewX, playerNewY) = 1
            if playerNewY > 0 or playerNewY < 0
                playerY = playerY + playerNewY
                    PlayerLeaveTile(oldX, oldY)
                    PlayerEnterTile(playerX, playerY)
                    PlaySound(2)
            endif
        endif
    endif

    if oldX not playerX and oldY not playerY
         `PlaySound(2)
    elseif oldX = playerX and oldY = playerY
        if playerNewX > 0 or playerNewX < 0 or playerNewY > 0 or playerNewY < 0
            if getsoundsplaying(13) = 0
                playsound(13)
            endif
        endif
    endif
    remend
endfunction

function HandlePlayerWhip()
    i as integer
    tX as integer
    tY as integer

    for i = 0 to 7
        if i = 0
            tX = playerX
            tY = playerY - 1
        elseif i = 1
            tX = playerX + 1
            tY = playerY - 1
        elseif i = 2
            tX = playerX + 1
            tY = playerY
        elseif i = 3
            tX = playerX + 1
            tY = playerY + 1
        elseif i = 4
            tX = playerX
            tY = playerY + 1
        elseif i = 5
            tX = playerX - 1
            tY = playerY + 1
        elseif i = 6
            tX = playerX - 1
            tY = playerY
        else
            tX = playerX - 1
            tY = playerY - 1
        endif

        deletesprite(3000)
        clonesprite(3000, 135 + i)
        `fixspritetoscreen(3000, 1)

        setspriteposition(3000, (playerX - 1)* mapTileWidth, (playerY - 1) * mapTileHeight)
        setspritevisible(3000, 1)

        if tX >= 0 and tX <= mapWidth and tY >=0 and tY <= mapHeight
            if PlayerCheckDestroyTileWithWhip(tX, tY) = 0
                PlaySoundSync(3)
            else
                PlaySoundSync(4)
                playerScore = playerScore + abs(GetTilePropertyFromPosition(tX, tY, tileProp_ChangeScore))
                SwitchTileToAlt(tX, tY)
            endif
        else
            PlaySoundSync(3)
        endif
    next i

    setspritevisible(3000, 0)
    playerWhips = playerWhips - 1
endfunction

function PlayerCheckDestroyTileWithWhip(pX as integer, pY as integer)
    myReturn as integer
    myObjectStrength as integer
    tempPlayerStrength as integer

    myReturn = 0
    myObjectStrength = GetTilePropertyFromPosition(pX, pY, 9)

    tempPlayerStrength = playerWhipStrength + playerStatusEffects[potionType_PlayerWeaken] + playerStatusEffects[potionType_PlayerStrengthen]
    if tempPlayerStrength < 0
        tempPlayerStrength = 0
    endif

    if mapTiles[pX, pY].definitionID >=  mapTile_EnemyA and mapTiles[pX, pY].definitionID <= mapTile_EnemyC
        myObjectStrength  = myObjectStrength + playerStatusEffects[potionType_EnemyWeaken] + playerStatusEffects[potionType_EnemyStrengthen]
    endif

    if myObjectStrength = 0
        myReturn = 0
    elseif myObjectStrength <= tempPlayerStrength
        myReturn = 1
    else
        myRandom as integer
        myRandom = Random(0, myObjectStrength)

        if myRandom < tempPlayerStrength
            myReturn = 1
        endif
    endif

endfunction myReturn

function CheckValidTargetLocation(pX as integer, pY as integer)
    myReturn as integer
    myReturn = 1

    if pX < 0 or pY < 0
        myReturn = 0
    endif

    if pX >= mapWidth or pY >= mapHeight
        myReturn = 0
    endif
endfunction myReturn

function CheckPlayerCanMoveSpot(pX as integer, pY as integer, pOffsetX as integer, pOffsetY as integer)
    myReturn as integer
    myReturn = CheckValidTargetLocation(pX, pY)

    if myReturn = 1
        if IsTileSolidPlayer(pX, pY) < 0
            if GetTileTypeFromPosition(pX, pY) = mapTile_Lock and playerKeys > 0
                    if GetSaveStateProperty("keyLock") = 0
                        SetSaveStateProperty("keyLock", 1)
                        playsound(14)
                        RenderLinesFromTextLibrary(4)
                    endif
                myReturn = 1
                playerKeys = playerKeys - 1

            elseif GetTilePropertyFromPosition(pX, pY, tileProp_Movable) < 0
                tType as integer
                tType = GetTileTypeFromPosition(pX, pY)
                    if CheckBoulderCanMoveSpot(pX + pOffsetX, pY + pOffsetY) = 1
                        BoulderLeaveTile(pX, pY)
                        BoulderEnterTile(pX + pOffsetX, pY + pOffsetY, tType)
                    elseif CheckBoulderCanMoveSpot(pX + pOffsetX, pY) = 1
                        BoulderLeaveTile(pX, pY)
                        BoulderEnterTile(pX + pOffsetX, pY, tType)

                    elseif CheckBoulderCanMoveSpot(pX, pY + pOffsetY) = 1
                        BoulderLeaveTile(pX, pY)
                        BoulderEnterTile(pX, pY + pOffsetY, tType)
                    else
                        myReturn = 0
                    endif
            else
                myReturn = 0
            endif
        endif
    endif
endfunction myReturn

function CheckEnemyCanMoveSpot(pX as integer, pY as integer)
    myReturn as integer
    myReturn = CheckValidTargetLocation(pX, pY)

    if myReturn = 1
        if IsTileSolidEnemy(pX, pY) < 0
            myReturn = 0
        endif
    endif

endfunction myReturn

function CheckBoulderCanMoveSpot(pX as integer, pY as integer)
    myReturn as integer
    myReturn = CheckValidTargetLocation(pX, pY)

    if myReturn = 1
        if IsTileSolidBoulder(pX, pY) < 0
            myReturn = 0
        endif
    endif

endfunction myReturn

function SwitchTileToAlt(pX as integer, pY as integer)
    mapTiles[pX, pY].definitionID = mapTiles[pX, pY].alt
    mapTiles[pX, pY].alt = GetAltTileFromBlockID(mapTiles[pX, pY].definitionID)

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function SwitchTileToNew(pX as integer, pY as integer, pID as integer)
    mapTiles[pX, pY].definitionID = pID
    mapTiles[pX, pY].alt = GetAltTileFromBlockID(mapTiles[pX, pY].definitionID)

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function PlayerLeaveTile(pX as integer, pY as integer)
    mapTiles[pX, pY].definitionID = mapTiles[pX, pY].alt
    mapTiles[pX, pY].alt = GetAltTileFromBlockID(mapTiles[pX, pY].definitionID)

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function PlayerEnterTile(pX as integer, pY as integer)
    tID as integer
    tImageID as integer
    tID = mapTiles[pX, pY].definitionID

    if GetTilePropertyFromPosition(pX, pY, tileProp_ToggleSwitch) < 0
        mapTiles[pX, pY].alt = mapTiles[pX, pY].definitionID
    endif

    mapTiles[pX, pY].definitionID =  mapTile_Player

    if IsPlayerInvisible() = 0
        if IsPlayerPoisoned() = 0
            tImageID =  mapTile_Player
        else
            tImageID = mapTile_PlayerPoisoned
        endif
    elseif IsPlayerInvisible() = 1
        tImageID = mapTile_Blank
    endif

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(tImageID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)

    `if tID not mapTile_chest
    `    PlayerAddEffectsFromTile(tID, 0)
    `else
        PlayerAddEffectsFromTile(tID, 1)
    `endif
endfunction
rem mapTile_Boulder

function BoulderLeaveTile(pX as integer, pY as integer)
    playsoundsync(9)
    mapTiles[pX, pY].definitionID = mapTiles[pX, pY].alt
    mapTiles[pX, pY].alt = GetAltTileFromBlockID(mapTiles[pX, pY].definitionID)

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function BoulderEnterTile(pX as integer, pY as integer, pID as integer)
    tDestroyed as integer
    tDestroyed = 0
    tID as integer
    tID = mapTiles[pX, pY].definitionID

    if GetTilePropertyFromPosition(pX, pY, tileProp_DestroyBoulder) < 0
        tDestroyed = 1
    endif

    if tDestroyed = 0
        if GetTilePropertyFromPosition(pX, pY, tileProp_ToggleSwitch) < 0
            mapTiles[pX, pY].alt = tID
        else
            mapTiles[pX, pY].alt = GetAltTileFromBlockID(pID)
        endif

        mapTiles[pX, pY].definitionID =  pID
        mapTiles[pX, pY].tag = 1
    else
        mapTiles[pX, pY].definitionID = mapTile_Blank
        mapTiles[pX, pY].alt = 0
    endif

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)


    if GetSaveStateProperty("keyBoulder") = 0
        SetSaveStateProperty("keyBoulder", 1)
        RenderLinesFromTextLibrary(5)
    endif

endfunction

function EnemyLeaveTile(pX as integer, pY as integer)
    mapTiles[pX, pY].definitionID = mapTiles[pX, pY].alt
    mapTiles[pX, pY].alt = GetAltTileFromBlockID(mapTiles[pX, pY].definitionID)

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)
    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function EnemyEnterTile(pX as integer, pY as integer, pID as integer)
    tDestroyed as integer
    tRandom as integer
    tRandom = random(1,2)
    tID as integer
    tID =  mapTiles[pX, pY].definitionID
    tDestroyed = 0

    if GetTilePropertyFromPosition(pX, pY, tileProp_DestroyEnemy) < 0
        tDestroyed = 1
    endif

    if mapTiles[pX, pY].definitionID = mapTile_Player
        PlayerAddEffectsFromTile(pID, 0)
        exitfunction
    endif

    if tDestroyed = 0
        if GetTilePropertyFromPosition(pX, pY, tileProp_ToggleSwitch) < 0
            mapTiles[pX, pY].alt = tID
        else
            mapTiles[pX, pY].alt = GetAltTileFromBlockID(pID)
        endif
        mapTiles[pX, pY].definitionID =  pID
        mapTiles[pX, pY].enemyTag = 1
    else
        mapTiles[pX, pY].definitionID = mapTile_Blank
        mapTiles[pX, pY].alt = 0
    endif

    deleteSprite(mapTiles[pX, pY].spriteID)
    clonesprite(mapTiles[pX, pY].spriteID, GetBaseSpriteFromBlockID(mapTiles[pX, pY].definitionID))
    SetSpritePosition(mapTiles[pX, pY].spriteID, mapTiles[pX, pY].X,mapTiles[pX, pY].Y)

    if tDestroyed = 0
        SetSpriteFrame(mapTiles[pX, pY].spriteID, tRandom)
    endif

    setspritevisible(mapTiles[pX, pY].spriteID, 1)
endfunction

function PlayerAddEffectsFromTile(pID as integer, pShowMessage as integer)
    i as integer
    j as integer

    if pID = mapTile_Key
        playerKeys = playerKeys + 1
        if GetSaveStateProperty("keyHelp") = 0 and pShowMessage = 1
            playsound(14)
            SetSaveStateProperty("keyHelp", 1)
            RenderLinesFromTextLibrary(6)
        endif
    elseif pID = mapTile_Chest
        HandlePlayerChest(mapTiles[playerX, playerY].tag)
        SetGameplayMessageVisible(0)
    elseif pID = mapTile_Lava or pID = mapTile_LavaGenerate
        PlaySoundSync(7)
        if GetSaveStateProperty("keyLava") = 0 and pShowMessage = 1
            RenderLinesFromTextLibrary(7)
        endif
    elseif pID = mapTile_Potion
        HandlePlayerPotion(mapTiles[playerX, playerY].tag)
                SetGameplayMessageVisible(0)
    elseif pID = mapTile_Trans
        HandlePlayerTrans()
    elseif pID = mapTile_Goal or pID = mapTile_GoalToWarp
        playsound(14)
        playerLevelFinished = 1
    elseif pID = mapTile_WhipPowerup
        playsoundsync(16)
        RenderLinesFromTextLibrary(52)
        playerWhipStrength = playerWhipStrength + 1
    elseif pID = mapTile_Warp
        playsoundsync(15)
        playerLevelFinished = 2
        `levelSelected = levelSelected + mapTiles[playerX, playerY].tag
    elseif pID = mapTile_GameOver
        playerLevelFinished = 3
    elseif pID = mapTile_Switch or pID = mapTile_HiddenSwitch
        playsoundsync(11)
        HandleSwitch()


        if pID = mapTile_Switch
            if GetSaveStateProperty("keySwitch") = 0  and pShowMessage = 1
                SetSaveStateProperty("keySwitch", 1)

                RenderLinesFromTextLibrary(8)
            endif
        else
            if GetSaveStateProperty("keyHiddenSwitch") = 0  and pShowMessage = 1
                SetSaveStateProperty("keyHiddenSwitch", 1)

                RenderLinesFromTextLibrary(9)
            endif
        endif
    elseif pID = mapTile_Whip
        if GetSaveStateProperty("keyWhip") = 0  and pShowMessage = 1
            SetSaveStateProperty("keyWhip", 1)
            playsound(14)
                RenderLinesFromTextLibrary(10)

        endif
    elseif pID = mapTile_Message
        playsound(14)
        RenderLinesFromTextLibrary(mapTiles[playerX, playerY].tag)
    elseif pID = mapTile_GemA
        if GetSaveStateProperty("keyGemA") = 0  and pShowMessage = 1
            SetSaveStateProperty("keyGemA", 1)
            playsound(14)
            RenderLinesFromTextLibrary(48)
        endif
    elseif pID = mapTile_GemB
        if GetSaveStateProperty("keyGemB") = 0  and pShowMessage = 1
            SetSaveStateProperty("keyGemB", 1)
            playsound(14)
            RenderLinesFromTextLibrary(49)
        endif
    elseif pID = mapTile_GemC
        if GetSaveStateProperty("keyGemC") = 0  and pShowMessage = 1
            SetSaveStateProperty("keyGemC", 1)
            playsound(14)
            RenderLinesFromTextLibrary(50)
        endif
    endif

    playerWhips = playerWhips + GetTilePropertyFromIndex(pID, tileProp_ChangeWhips)
    playerHealth = playerHealth + GetTilePropertyFromIndex(pID, tileProp_ChangeHealth)
    playerScore = playerScore + GetTilePropertyFromIndex(pID, tileProp_ChangeScore)

    if playerWhips < 0
        playerWhips = 0
    elseif playerWhips > 9999
        playerWhips = 9999
    endif

    if playerHealth < 0
        playerHealth = 0
    elseif playerHealth > 9999
        playerHealth = 9999
    endif

    if playerScore < 0
        playerScore = 0
    elseif playerScore > 999999
        playerScore = 999999
    endif

    if playerKeys < 0
        playerKeys = 0
    elseif playerKeys > 9999
        playerKeys = 9999
    endif

endfunction

function HandleSwitch()
    i as integer
    j as integer
    tTag as integer

    tTag = mapTiles[playerX, playerY].tag
    mapTiles[playerX, playerY].tag = -1

    for i = 0 to mapWidth - 1
        for j = 0 to mapHeight - 1
            if mapTiles[i, j].tag = tTag

            mapTiles[i, j].definitionID = mapTiles[i, j].alt
            mapTiles[i, j].alt = GetAltTileFromBlockID(mapTiles[i,j].definitionID)
            deleteSprite(mapTiles[i, j].spriteID)
            clonesprite(mapTiles[i, j].spriteID, GetBaseSpriteFromBlockID(mapTiles[i, j].definitionID))
            SetSpritePosition(mapTiles[i, j].spriteID, mapTiles[i, j].X,mapTiles[i, j].Y)
            SetSpriteVisible(mapTiles[i, j].spriteID, 1)
            SetViewOffset(-608 + (i * mapTileWidth),  -256 + (j * mapTileHeight))

            playsoundsync(12)
            endif
        next
    next

endfunction

function HandlePlayerTrans()
    tRandTurns as integer
    tRandTurns = random(10,25)

    tRandX as integer
    tRandY as integer

    tCount as integer

    while tCount < tRandTurns
        tRandX = random(0, mapWidth - 1)
        tRandY = random(0, mapHeight - 1)

        if mapTiles[tRandX, tRandY].definitionID = mapTile_Blank
            PlayerLeaveTile(playerX, playerY)
            PlayerEnterTile(tRandX, tRandY)
            playerX = tRandX
            playerY = tRandY
            SetViewOffset(-608 + (playerX * mapTileWidth),  -256 + (playerY * mapTileHeight))
            playsoundsync(10)
            tCount = tCount + 1

        endif

        SyncOverride()
    endwhile

    if GetSaveStateProperty("keyTrans") = 0
        SetSaveStateProperty("keyTrans", 1)

                RenderLinesFromTextLibrary(11)
    endif

endfunction

function HandlePlayerChest(pID as integer)
    PlaySoundSync(5)

    tStringAll as string
    tStringSub as string

    tCountAll as integer
    tCountSub as integer

    tString as string

    tRandom as integer
    tRandomMin as integer
    tRandomMax as integer
    tTileID as integer
    tTagID as integer

    i as integer
    j as integer
    tStringAll = GetTreasureChestString(pID)
    tCountAll = SplitStringCount(tStringAll, "|")

    `SetGameplayMessageText(" ")


    for i = 0 to tCountAll - 1
        tStringSub = SplitString(tStringAll, "|", i)
        tCountSub = SplitStringCount(tStringSub, ":")

        if tCountSub = 3
            tRandomMin = val(SplitString(tStringSub, ":", 0))
            tRandomMax = val(SplitString(tStringSub, ":", 1))
            tTileID =  val(SplitString(tStringSub, ":", 2))

            if tRandomMin = tRandomMax
                tRandom = tRandomMin
            else
                tRandom = random(tRandomMin, tRandomMax)
            endif

            if tRandom > 0
                if tTileID = mapTile_Potion
                    HandlePlayerPotion(tRandom)
                else
                    if tTileID = mapTile_GemA
                         tString = GetTextLibraryString(12) + str(tRandom) + GetTextLibraryString(13)
                    elseif tTileID = mapTile_GemB
                         tString = GetTextLibraryString(12) + str(tRandom) + GetTextLibraryString(15)
                    elseif tTileID = mapTile_GemC
                        tString = GetTextLibraryString(12) + str(tRandom) + GetTextLibraryString(17)
                    elseif tTileID = mapTile_Whip
                        tString = GetTextLibraryString(12) + str(tRandom) + GetTextLibraryString(19)
                    elseif tTileID = mapTile_Key
                        tString = GetTextLibraryString(12) + str(tRandom) + GetTextLibraryString(61)
                    endif

                    SetGameplayMessageText(tString)
    SetGameplayMessageVisible(1)
                    RenderGameplayMessage()

                    for j = 1 to tRandom
                        PlayerAddEffectsFromTile(tTileID, 0)
                    next
                endif

            endif
        elseif tCountSub = 2
            tTileID =  val(SplitString(tStringSub, ":", 0))
            tTagID = val(SplitString(tStringSub, ":", 1))

            if tTileID = mapTile_Potion
                HandlePlayerPotion(tTagID)
            endif
        endif
    next

`SetGameplayMessageVisible(0)

endfunction


function HandlePlayerPotion(pID as integer)
    `potionID as integer
    `potionID = mapTiles[playerX, playerY].tag
    playsoundsync(8)
    SetGameplayMessageText("")
    SetGameplayMessageVisible(1)
    if pID = potionType_Blind
            SetPlayerBlinded()
            SetGameplayMessageTextFromLibrary(21)
    elseif pID = potionType_Poison
            SetPlayerPoisoned()
            SetGameplayMessageTextFromLibrary(22)
    elseif pID = potionType_Invisible
            SetPlayerInvisible()
            SetGameplayMessageTextFromLibrary(23)
    elseif pID = potionType_EnemyWeaken
            WeakenMonsters()
    elseif pID = potionType_EnemyStrengthen
            StrengthenMonsters()
    elseif pID = potionType_EnemyFaster
            SpeedUpMonsters()
    elseif pID = potionType_EnemySlower
            SlowDownMonsters()
    elseif pID = potionType_PlayerWeaken
            WeakenPlayer()
    elseif pID = potionType_PlayerStrengthen
            StrengthenPlayer()
    elseif pID = potionType_PlayerFaster
            SpeedUpPlayer()
    elseif pID = potionType_PlayerSlower
            SlowDownPlayer()
    endif

endfunction

function PlaySoundSync(pID as integer)
    i as integer
    myTime as float
    myDuration as float
    myDuration = GetSoundDuration(pID)

    for i = 1000 to 2999
        if getspriteexists(i) = 1
            stopsprite(i)
        else
            exit
        endif
    next

    playsound(pID)

    while myTime <= myDuration
        myTime = myTime + GetModifiedFrameTime()
        SyncOverride()
    endwhile

    for i = 1000 to 2999
        if getspriteexists(i) = 1
            resumesprite(i)
        else
            exit
        endif
    next
endfunction

function InitGameplayGUI()
    i as integer
    CloneSprite(3001, 100)

    rem help
    CloneSprite(3005, 151)
    SetSpriteVisible(3005, 1)

    rem background
    CloneSprite(3002, 129)
    SetSpriteDepth(3002, 20)
    FixSpriteToScreen(3002, 1)
    SetSpriteSize(3002, 256, 640)
    SetSpritePosition(3002, 0,0)
    SetSpriteVisible(3002, 1)

    CreateText(1000, "")
    SetTextVisible(1000, 1)
    SetTextSize(1000, 58)
    SetTextPosition(1000,-8,0)
    SEtTextSpacing(1000, -14)
    FixTextToScreen(1000,1)

    CreateText(1001, "Life  10")
    SetTextVisible(1001, 1)
    SetTextSize(1001, 58)
    SetTextPosition(1001,-8,128)
    SEtTextSpacing(1001, -14)
    FixTextToScreen(1001,1)

    CreateText(1002, "Key   0")
    SetTextVisible(1002, 1)
    SetTextSize(1002, 58)
    SetTextPosition(1002,-8,192)
    SEtTextSpacing(1002, -14)
    FixTextToScreen(1002,1)

    CreateText(1003, "Whip  10")
    SetTextVisible(1003, 1)
    SetTextSize(1003, 58)
    SetTextPosition(1003,-8,256)
    SEtTextSpacing(1003, -14)
    FixTextToScreen(1003,1)

    CreateText(1004, "Score")
    SetTextVisible(1004, 1)
    SetTextSize(1004, 58)
    SetTextPosition(1004,-8,384)
    SEtTextSpacing(1004, -14)
    FixTextToScreen(1004,1)

    CreateText(1005, "       0")
    SetTextVisible(1005, 1)
    SetTextSize(1005, 58)
    SetTextPosition(1005,-8,448)
    SEtTextSpacing(1005, -14)
    FixTextToScreen(1005,1)

    CreateText(1006, "~~Menu~~")
    SetTextVisible(1006, 1)
    SetTextSize(1006, 58)
    SetTextPosition(1006,-8,576)
    SEtTextSpacing(1006, -14)
    FixTextToScreen(1006,1)

    for i = 1000 to 1006
        settextcolor(i, 170, 170, 170, 255)
        settextdepth(i, 17)
    next
endfunction

function UpdateGameplayGUI()
    tString as string

    tString = GetTextLibraryString(41) + PadStringLeft(str(playerHealth), 4)
    SetTextString(1001, tString)

    tString = GetTextLibraryString(42) + PadStringLeft(str(playerKeys), 5)
    SetTextString(1002, tString)

    tString = GetTextLibraryString(43) + PadStringLeft(str(playerWhips), 4)
    SetTextString(1003, tString)

    tString = PadStringLeft(str(playerScore), 8)
    SetTextString(1005, tString)
endfunction

function checkPlayerMenu(pPointerX as integer, pPointerY as integer)
    getPause as integer
    getPause = GetResumed()
    SetTextString(1006, GetTextLibraryString(45))

    `if getPause = 1
    `    message("foo")
    `endif

    if CheckButtonPointerHover(1006, pPointerX, pPointerY, 2, 2) = 1 or getPause = 1 or getrawkeypressed(77) = 1
        if getrawkeypressed(77) = 0
            changeTextToRandomCGAColor(1006)
        endif

        if getpointerreleased() = 1 or getrawkeypressed(77) = 1
            playsound(14)
            RenderPauseGUI()

            `gameState = GAMESTATE_PAUSE
        endif
    else
        changeTextToCGAColor(1006   , 15)
    endif

endfunction


function InitGameplayMessage()
    CloneSprite(3003, 129)
    SetSpriteDepth(3003,15)
    FixSpriteToScreen(3003, 1)
    SetSpriteSize(3003, 960, 128)
    SetSpritePosition(3003, 0,512)
    SetSpriteVisible(3003, 0)
    SetSpritedepth(3003, 15)

    CreateText(1007, "")
    SetTextVisible(1007, 1)
    SetTextSize(1007, 58)
    SetTextPosition(1007,-8,512)
    SEtTextSpacing(1007, -14)
    FixTextToScreen(1007,1)

    CreateText(1008, GetTextLibraryString(46))
    SetTextVisible(1008, 1)
    SetTextSize(1008, 58)
    SetTextPosition(1008,-8,576)
    SEtTextSpacing(1008, -14)
    FixTextToScreen(1008,1)

    SetGameplayMessageVisible(0)
endfunction

function SetGameplayMessageText(pText as string)
    SetTextString(1007, pText)
endfunction

function SetGameplayMessageVisible(pVisible as integer)
    SetSpriteVisible(3003, pVisible)
    SetTextVisible(1007, pVisible)
    SetTextVisible(1008, pVisible)
endfunction

function SwitchPlayerSprite(pID as integer)
    deleteSprite(mapTiles[playerX, playerY].spriteID)
    clonesprite(mapTiles[playerX, playerY].spriteID, GetBaseSpriteFromBlockID(pID))
    SetSpritePosition(mapTiles[playerX, playerY].spriteID, mapTiles[playerX, playerY].X, mapTiles[playerX, playerY].Y)
    setspritevisible(mapTiles[playerX, playerY].spriteID, 1)
endfunction

function RenderGameplayMessage()

    while getrawkeystate(13) = 1
    ``while getpointerstate() = 1
        UpdateGameplayGUI()
        changeTextToRandomCGAColor(1008)
        SyncOverride()
    endwhile

    while getrawkeyreleased(13) = 1
    `while getpointerreleased() = 1
            UpdateGameplayGUI()
            changeTextToRandomCGAColor(1008)
        SyncOverride()
    endwhile

    while getrawkeyreleased(13) = 0
    `while GetPointerReleased() = 0
            UpdateGameplayGUI()
        changeTextToRandomCGAColor(1008)
        SyncOverride()
    endwhile

`    SetGameplayMessageVisible(0)
endfunction
