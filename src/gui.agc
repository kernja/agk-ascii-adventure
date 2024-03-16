

function CreateRestoreBackupGUI()
    tLen as integer

    rem create background sprite
    CloneSprite(300, 129)
    SetSpriteDepth(300,20)
    FixSpriteToScreen(300, 1)
    SetSpriteSize(300, 960, 640)
    SetSpritePosition(300, 0,0)
    SetSpriteVisible(300, 0)
    SetSpriteDepth(300, 10)

    rem create text
    CreateText(300, GetTextLibraryString(150))

    if FullVersion = 0
        SetTextString(300, GetTextLibraryString(233))
    endif

    SetTextVisible(300, 0)
    SetTextSize(300, 58)
    SetTextPosition(300,-8,0)
    SetTextSpacing(300, -14)
    FixTextToScreen(300,1)
    changeTextToCGAColor(300, 15)

    CreateText(301, GetTextLibraryString(151))
    SetTextVisible(301, 0)
    SetTextSize(301, 58)
    SetTextPosition(301,-8,128)
    SetTextSpacing(301, -14)
    FixTextToScreen(301,1)
    changeTextToCGAColor(301, 7)

    CreateText(302, GetTextLibraryString(152))
    SetTextVisible(302, 0)
    SetTextSize(302, 58)
    SetTextPosition(302,-8,192)
    SEtTextSpacing(302, -14)
    FixTextToScreen(302,1)
    changeTextToCGAColor(302, 7)

    CreateText(303, GetTextLibraryString(153))
    SetTextVisible(303, 0)
    SetTextSize(303, 58)
    SetTextPosition(303,-8,576)
    SEtTextSpacing(303, -14)
    FixTextToScreen(303,1)
    changeTextToCGAColor(303, 15)

    tLen = len(GetTextLibraryString(154))
    CreateText(304, GetTextLibraryString(154))
    SetTextVisible(304, 0)
    SetTextSize(304, 58)
    SetTextPosition(304,952 - (tLen * 32), 576)
    SEtTextSpacing(304, -14)
    FixTextToScreen(304,1)
    changeTextToCGAColor(304, 15)

    SetRestoreBackupGUIVisible(0)
endfunction

function SetRestoreBackupGUIVisible(pValue as integer)
    i as integer
    SetSpriteVisible(300, pValue)

    for i = 300 to 304
        SetTextVisible(i, pValue)
    next i
endfunction

function RenderBackupGUI()
    SetRestoreBackupGUIVisible(1)

    myReturn as integer
    selection as integer
    released as integer
    pPointerX as integer
    pPointerY as integer

    i as integer

    selection = 0
    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()


        released = getpointerreleased()
        changeTextToRandomCGAColor(300)
        for i = 303 to 304
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 16, 16) = 1
                changeTextToRandomCGAColor(i)

                if released = 1
                    selection = i
                endif
            else
                  changeTextToCGAColor(i, 15)
            endif
        next i
        SyncOverride()
    endwhile


    if selection = 304
        myReturn = 1
    endif
    playsound(14)
    SetRestoreBackupGUIVisible(0)
endfunction myReturn

function CreateMainMenuGUI()
    rem create background sprite
    CloneSprite(399, 129)
    SetSpriteDepth(399, 20)
    FixSpriteToScreen(399, 1)
    SetSpriteSize(399, 960, 640)
    SetSpritePosition(399, 0,0)
    SetSpriteVisible(399, 0)
    SetSpriteDepth(399, 11)

    rem create background sprite
    CloneSprite(310, 129)
    SetSpriteDepth(310,20)
    FixSpriteToScreen(310, 1)
    SetSpriteSize(310, 960, 640)
    SetSpritePosition(310, 0,0)
    SetSpriteVisible(310, 0)
    SetSpriteDepth(310, 10)

    rem create text
    CreateText(310, GetTextLibraryString(150))

    if FullVersion = 0
        SetTextString(310, GetTextLibraryString(233))
    endif

    SetTextVisible(310, 0)
    SetTextSize(310, 58)
    SetTextPosition(310,-8,0)
    SetTextSpacing(310, -14)
    FixTextToScreen(310,1)
    changeTextToCGAColor(310, 15)

    CreateText(311, GetTextLibraryString(155))
    SetTextVisible(311, 0)
    SetTextSize(311, 58)
    SetTextPosition(311,-8,128)
    SetTextSpacing(311, -14)
    FixTextToScreen(311,1)
    changeTextToCGAColor(311, 7)

    CreateText(312, GetTextLibraryString(156))
    SetTextVisible(312, 0)
    SetTextSize(312, 58)
    SetTextPosition(312,-8,192)
    SEtTextSpacing(312, -14)
    FixTextToScreen(312,1)
    changeTextToCGAColor(312, 8)

    CreateText(313, GetTextLibraryString(157))
    SetTextVisible(313, 0)
    SetTextSize(313, 58)
    SetTextPosition(313,-8,256)
    SEtTextSpacing(313, -14)
    FixTextToScreen(313,1)
    changeTextToCGAColor(313, 7)

    CreateText(314, GetTextLibraryString(158))
    SetTextVisible(314, 0)
    SetTextSize(314, 58)
    SetTextPosition(314,-8,320)
    SEtTextSpacing(314, -14)
    FixTextToScreen(314,1)
    changeTextToCGAColor(314, 7)

    setMainMenuGUIVisible(0)
endfunction

function RenderMainMenuGUI()
    SetMainMenuGUIVisible(1)

    selection as integer
    released as integer
    pPointerX as integer
    pPointerY as integer

    i as integer

    selection = 0
    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(310)
        for i = 311 to 314
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(i)

                if released = 1
                    if i = 312
                            playsound(14)
                        SetMainMenuGUIVisible(0)
                        tValue as integer
                        tValue = RenderLoadGameGUI(0)
                   ` RenderLoadGameGUI

                        if tValue > 0
                            gameState = gameState_GAME
                            selection = 312
                        else
                            SetMainMenuGUIVisible(1)
                        endif
                    elseif i = 311
                        selection = 311
                        gameState = GAMESTATE_GAME
                        SelectedSaveStateIndex = -1
                        loadstate(0)
                        loadmap()
                    elseif i = 313
                        SetMainMenuGUIVisible(0)
                        playsound(14)
                        RenderHowToGUI()
                        SetMainMenuGUIVisible(1)
                    elseif i = 314
                        SetMainMenuGUIVisible(0)
                        playsound(14)
                        RenderAboutGUI()
                        SetMainMenuGUIVisible(1)
                    else
                        selection = i
                    endif
                endif
            else
                  changeTextToCGAColor(i, 15)
            endif
        next
        SyncOverride()
    endwhile

    playsound(14)
    SetMainMenuGUIVisible(0)
endfunction

function SetMainMenuGUIVisible(pValue as integer)
    i as integer
    SetSpriteVisible(310, pValue)

    for i = 310 to 314
        SetTextVisible(i, pValue)
    next i
endfunction

function CreateSaveSlotGUI()
tLen as integer
    i as integer

    rem create background sprite
    CloneSprite(320, 129)
    SetSpriteDepth(320,20)
    FixSpriteToScreen(320, 1)
    SetSpriteSize(320, 960, 640)
    SetSpritePosition(320, 0,0)
    SetSpriteVisible(320, 0)
    SetSpriteDepth(320, 10)

    rem create text
    CreateText(320, GetTextLibraryString(150))

    if FullVersion = 0
        SetTextString(320, GetTextLibraryString(233))
    endif

    SetTextVisible(320, 0)
    SetTextSize(320, 58)
    SetTextPosition(320,-8,0)
    SetTextSpacing(320, -14)
    FixTextToScreen(320,1)
    changeTextToCGAColor(320, 15)

    CreateText(321, GetTextLibraryString(159))
    SetTextVisible(321, 0)
    SetTextSize(321, 58)
    SetTextPosition(321,-8,128)
    SetTextSpacing(321, -14)
    FixTextToScreen(321,1)
    changeTextToCGAColor(321, 7)

    for i = 0 to 4
        CreateText(322 + i, GetTextLibraryString(160))
        SetTextVisible(322 + i, 0)
        SetTextSize(322 + i, 58)
        SetTextPosition(322+ i,-8,192 + (i * 64))
        SEtTextSpacing(322 + i, -14)
        FixTextToScreen(322+ i,1)
        changeTextToCGAColor(322 + i, 15)
    next i

    CreateText(327, GetTextLibraryString(153))
    SetTextVisible(327, 0)
    SetTextSize(327, 58)
    SetTextPosition(327,-8,576)
    SEtTextSpacing(327, -14)
    FixTextToScreen(327,1)
    changeTextToCGAColor(327, 15)

    tLen = len(GetTextLibraryString(154))
    CreateText(328, GetTextLibraryString(154))
    SetTextVisible(328, 0)
    SetTextSize(328, 58)
    SetTextPosition(328,952 - (tLen * 32), 576)
    SEtTextSpacing(328, -14)
    FixTextToScreen(328,1)
    changeTextToCGAColor(328, 8)

    SetSaveSlotGUIVisible(0)
endfunction

function SetSaveSlotGUIVisible(pValue as integer)
    i as integer
    SetSpriteVisible(320, pValue)

    for i = 320 to 328
        SetTextVisible(i, pValue)
    next

    if pValue = 0
        changeTextToCGAColor(328, 8)
    endif

endfunction

function RenderLoadGameGUI(pAsNew as integer)
rem update contents of save slots
    RefreshLevelSlots()
    i as integer

    SetTextString(321, GetTextLibraryString(162))

    for i = 0 to 4
        if LevelSlot[i].levelID = -1
            SetTextString(322 + i, GetTextLibraryString(160))
        elseif LevelSlot[i].completed = 0
            SetTextString(322 + i, GetTextLibraryString(161) + str(LevelSlot[i].levelID + 1))
        else
            SetTextString(322 + i, GetTextLibraryString(169) + str(LevelSlot[i].levelID + 1))
        endif
    next i

    SetSaveSlotGUIVisible(1)

    selection as integer
    selectedIndex as integer

    released as integer
    pPointerX as integer
    pPointerY as integer

    selection = 0
    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(320)

        for i = 322 to 326
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(i)
                if getpointerpressed() = 1
                    if (pAsNew = 0 and LevelSlot[i - 322].levelID > -1) or pAsNew = 1
                        selectedIndex = i
                        changeTextToCGAColor(328, 15)
                            playsound(14)
                    else
                        playsound(13)
                    endif
                endif
            else
                if  i = selectedIndex
                    changeTextToCGAColor(selectedIndex, 14)
                elseif pAsNew = 1 or LevelSlot[i - 322].levelID > -1
                    changeTextToCGAColor(i, 15)
                else
                    changeTextToCGAColor(i, 8)
                endif
            endif
        next

        for i = 327 to 328
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(i)

                if (i = 328 and selectedIndex > 0) or i = 327
                    if released = 1
                        selection = i
                    endif
                elseif i=328
                    if released = 1
                        playsound(13)
                    endif
                endif
            else
                if i = 327
                    changeTextToCGAColor(i, 15)
                else
                    if selectedIndex = 0
                        changeTextToCGAColor(i, 8)
                    else
                        changeTextToCGAColor(i, 15)
                    endif
                endif
            endif
        next
        SyncOverride()
    endwhile

    selection = selection - 327

    if selection > 0
        SelectedSaveStateIndex = selectedIndex - 322
        LoadState(0)
`                message(str(SelectedSaveStateIndex))
        `gameState = GAMESTATE_GAME
        LoadMap()
    endif

    playsound(14)
    SetSaveSlotGUIVisible(0)
endfunction selection


function RenderSaveGameGUI(pAsNew as integer)
rem update contents of save slots
    RefreshLevelSlots()
    i as integer
    for i = 0 to 4
        if LevelSlot[i].levelID = -1
            SetTextString(322 + i, GetTextLibraryString(160))
        elseif LevelSlot[i].completed = 0
            SetTextString(322 + i, GetTextLibraryString(161) + str(LevelSlot[i].levelID + 1))
        else
            SetTextString(322 + i, GetTextLibraryString(169) + str(LevelSlot[i].levelID + 1))
        endif
    next i

    SetTextString(321, GetTextLibraryString(159))
    SetSaveSlotGUIVisible(1)

    selection as integer
    selectedIndex as integer

    released as integer
    pPointerX as integer
    pPointerY as integer

    selection = 0
    selectedIndex = SelectedSaveStateIndex + 322

    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(320)

        for i = 322 to 326
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(i)
                  if getpointerpressed() = 1
                    if (pAsNew = 0 and LevelSlot[i - 322].levelID > -1) or pAsNew = 1
                        selectedIndex = i
                        changeTextToCGAColor(328, 15)
                            playsound(14)
                    else
                        playsound(13)
                    endif
                endif
            else
                if  i = selectedIndex
                    changeTextToCGAColor(selectedIndex, 14)
                elseif pAsNew = 1 or LevelSlot[i - 322].levelID > -1
                    changeTextToCGAColor(i, 15)
                else
                    changeTextToCGAColor(i, 8)
                endif
            endif
        next

        for i = 327 to 328
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1

            changeTextToRandomCGAColor(i)

                if (i = 328 and selectedIndex > 321) or i = 327

                    if released = 1
                        selection = i
                    endif
                elseif i = 328
                  if released = 1
                        playsound(13)
                    endif
                endif
            else
                if i = 327
                    changeTextToCGAColor(i, 15)
                else
                    if selectedIndex <= 321
                        changeTextToCGAColor(i, 8)
                    else
                        changeTextToCGAColor(i, 15)
                    endif
                endif
            endif
        next
        SyncOverride()
    endwhile

    selection = selection - 327

    if selection > 0
        SelectedSaveStateIndex = selectedIndex - 322
        SaveState(0)
    endif

    playsound(14)
    SetSaveSlotGUIVisible(0)
endfunction selection

function CheckButtonPointerHover(pID as integer, pPointerX as integer, pPointerY as integer, pOffsetX as integer, pOffsetY as integer)
    tX as integer
    tY as integer
    tWidth as integer
    tHeight as integer
    myReturn as integer

    REM comment out these lines to get the app working again
    tX = GetTextX(pID) - pOffsetX
    tY = GetTextY(pID) - pOffsetY
    tWidth = tX + GetTextTotalWidth(pID) + (pOffsetX * 2)
    tHeight = tY + GetTextTotalHeight(pID) + (pOffsetY * 2)

        if tX <= pPointerX and pPointerX <= tWidth and tY <= pPointerY and pPointerY <= tHeight
            if GetPointerState() = 1 or GetPointerReleased() = 1
                myReturn = 1
            endif
        endif
    REM comment out til here

endfunction myReturn


function CreatePauseGUI()
    rem create background sprite
    CloneSprite(330, 129)
    SetSpriteDepth(330,20)
    FixSpriteToScreen(330, 1)
    SetSpriteSize(330, 960, 640)
    SetSpritePosition(330, 0,0)
    SetSpriteVisible(330, 0)
    SetSpriteDepth(330, 10)

    rem create text
    CreateText(330, GetTextLibraryString(150))

    if FullVersion = 0
        SetTextString(330, GetTextLibraryString(233))
    endif

    SetTextVisible(330, 0)
    SetTextSize(330, 58)
    SetTextPosition(330,-8,0)
    SetTextSpacing(330, -14)
    FixTextToScreen(330,1)
    changeTextToCGAColor(330, 15)

    CreateText(331, GetTextLibraryString(163))
    SetTextVisible(331, 0)
    SetTextSize(331, 58)
    SetTextPosition(331,-8,128)
    SetTextSpacing(331, -14)
    FixTextToScreen(331,1)
    changeTextToCGAColor(331, 15)

    CreateText(332, GetTextLibraryString(164))
    SetTextVisible(332, 0)
    SetTextSize(332, 58)
    SetTextPosition(332,-8,192)
    SEtTextSpacing(332, -14)
    FixTextToScreen(332,1)
    changeTextToCGAColor(332, 15)

    CreateText(333, GetTextLibraryString(165))
    SetTextVisible(333, 0)
    SetTextSize(333, 58)
    SetTextPosition(333,-8,384)
    SEtTextSpacing(333, -14)
    FixTextToScreen(333,1)
    changeTextToCGAColor(333, 15)

    CreateText(334, GetTextLibraryString(166))
    SetTextVisible(334, 0)
    SetTextSize(334, 58)
    SetTextPosition(334,-8,256)
    SEtTextSpacing(334, -14)
    FixTextToScreen(334,1)
    changeTextToCGAColor(334, 15)

    CreateText(335, GetTextLibraryString(167))
    SetTextVisible(335, 0)
    SetTextSize(335, 58)
    SetTextPosition(335,-8,512)
    SEtTextSpacing(335, -14)
    FixTextToScreen(335,1)
    changeTextToCGAColor(335, 15)

    setPauseGUIVisible(0)
endfunction

function RenderPauseGUI()
    SetTextString(335, GetTextLibraryString(167 + playerShowOverlay))
    SetPauseGUIVisible(1)

    selection as integer
    released as integer
    pPointerX as integer
    pPointerY as integer

    i as integer

    selection = 0

    while getrawkeypressed(77) = 1
        sync()
    endwhile

    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(330)
        for i = 331 to 335
            if CheckButtonPointerHover(i, pPointerX, pPointerY, 2, 2) = 1  or GetRawkeypressed(82) = 1
                changeTextToRandomCGAColor(i)

                if released = 1 or GetRawkeypressed(82) = 1
                    if i = 335
                    `    if playerShowOverlay = 1
                    `        playerShowOverlay = 0
                    `    else
                    `        playerShowOverlay = 1
                    `    endif
                    `    playsound(14)
                    `    SetSpriteVisible(3005, playerShowOverlay)
                    `    SetTextString(335, GetTextLibraryString(167 + playerShowOverlay))
                    elseif i = 331 and GetRawkeypressed(82) = 0
                        SetPauseGUIVisible(0)
                        playsound(14)
                        tSaved as integer
                        tSaved = RenderSaveGameGUI(1)

                        gameState = GAMESTATE_GAME

                        if tSaved = 1
                            selection = 1
                        else
                            selection = 0
                            SetPauseGUIVisible(1)
                        endif
                    elseif i = 332 and GetRawkeypressed(82) = 0
                        playsound(14)
                        SetPauseGUIVisible(0)
                        tValue as integer
                        tValue = RenderLoadGameGUI(0)

                        if tValue > 0
                            gameState = gameState_GAME
                            selection = 332
                        else
                            SetPauseGUIVisible(1)
                            selection = 0
                        endif

                        gameState = GAMESTATE_GAME
                    elseif i = 333 or GetRawkeypressed(82) = 1
                        playsound(14)
                        gameState = GAMESTATE_GAME
                        selection = i
                    elseif i = 334 and GetRawkeypressed(82) = 0
                        playsound(14)
                        selection = i
                        gamestate = GAMESTATE_MAINMENU
                        SetSpriteVisible(399, 1)
                    else
                        selection = i
                    endif

                endif
            else
                  changeTextToCGAColor(i, 15)
            endif
        next
        SyncOverride()
    endwhile

    rem new game
    `if selection = 331
    `    gameState = GAMESTATE_GAME
    `    loadstate(0)
    `    loadmap()
   ` elseif selection = 332
   `     gameState = GAMESTATE_LOAD
   ` endif

    playsound(14)
    SetPauseGUIVisible(0)
endfunction

function SetPauseGUIVisible(pValue as integer)
    i as integer
    SetSpriteVisible(330, pValue)

    for i = 330 to 335
        SetTextVisible(i, pValue)
    next i

    SetTextVisible(335, 0)
endfunction

function CreateAboutGUI()
    tLen as integer
    i as integer
    rem create background sprite
    CloneSprite(340, 129)
    SetSpriteDepth(340,20)
    FixSpriteToScreen(340, 1)
    SetSpriteSize(340, 960, 640)
    SetSpritePosition(340, 0,0)
    SetSpriteVisible(340, 0)
    SetSpriteDepth(340, 10)

    rem create text
    CreateText(340, GetTextLibraryString(150))

    if FullVersion = 0
        SetTextString(340, GetTextLibraryString(233))
    endif

    SetTextVisible(340, 0)
    SetTextSize(340, 58)
    SetTextPosition(340,-8,0)
    SetTextSpacing(340, -14)
    FixTextToScreen(340,1)
    changeTextToCGAColor(340, 15)

    for i = 0 to 5
        CreateText(341 + i, GetTextLibraryString(172 + i))
        SetTextVisible(341 + i, 0)
        SetTextSize(341 + i, 58)
        SetTextPosition(341 + i,-8,128 + (i * 64))
        SetTextSpacing(341 + i, -14)
        FixTextToScreen(341 + i,1)
        changeTextToCGAColor(341 + i, 7)
    next i

    tLen = len(GetTextLibraryString(154))
    CreateText(347, GetTextLibraryString(154))
    SetTextVisible(347, 0)
    SetTextSize(347, 58)
    SetTextPosition(347,952 - (tLen * 32), 576)
    SEtTextSpacing(347, -14)
    FixTextToScreen(347,1)
    changeTextToCGAColor(347, 15)

    SetAboutGUIVisible(0)
endfunction

function SetAboutGUIVisible(pValue as integer)
    i as integer

    setspritevisible(340, pValue)

    for i = 340 to 347
        settextvisible(i, pValue)
    next i
endfunction

function RenderAboutGUI()
    selection as integer
    released as integer
    pPointerX as integer
    pPointerY as integer
    state as integer

    i as integer

    for i = 341 to 346
        settextstring(i, GetTextLibraryString(172 + (i - 341) + state))
    next i

    SetAboutGUIVisible(1)

    selection = 0
    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(340)
        `for i = 347 to 347
            if CheckButtonPointerHover(347, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(347)

                if released = 1
                    if state = 0
                        state = 6
                           for i = 341 to 346
                                settextstring(i, GetTextLibraryString(172 + (i - 341) + state))
                            next i
                        playsound(14)
                    else
                        selection = 1
                    endif
                endif
            else
                  changeTextToCGAColor(347, 15)
            endif
        `next
        SyncOverride()
    endwhile

    playsound(14)
    SetAboutGUIVisible(0)
endfunction

function RenderHowToGUI()
    selection as integer
    released as integer
    pPointerX as integer
    pPointerY as integer
    state as integer

    i as integer

    for i = 341 to 346
        settextstring(i, GetTextLibraryString(184 + (i - 341) + state))
    next i

    SetAboutGUIVisible(1)

    selection = 0
    while selection = 0
        pPointerX = GetPointerx()
        pPointerY = GetPointerY()

        released = getpointerreleased()

        changeTextToRandomCGAColor(340)
        `for i = 347 to 347
            if CheckButtonPointerHover(347, pPointerX, pPointerY, 2, 2) = 1
                changeTextToRandomCGAColor(347)

                if released = 1
                    if state < 42
                        state = state + 6
                           for i = 341 to 346
                                settextstring(i, GetTextLibraryString(184 + (i - 341) + state))
                            next i
                        playsound(14)
                    else
                        selection = 1
                    endif
                endif
            else
                  changeTextToCGAColor(347, 15)
            endif
        `next
        SyncOverride()
    endwhile

    playsound(14)
    SetAboutGUIVisible(0)
endfunction
