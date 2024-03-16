TYPE Type_SaveStateProperty
    name as string
    value as integer
EndType

Type Type_SaveStateLevel
    levelID as integer
    whips as integer
    whipStrength as integer
    keys as integer
    life as integer
    score as integer
endtype

tYPE Type_Level
    levelID as integer
    levelPath as string
endtype

Type Type_LevelSlot
    levelID as integer
    completed as integer
EndType

global dim LevelList[1] as Type_Level
global dim LevelSlot[5] as Type_LevelSlot

global levelListCount as integer
global levelSelected as integer

global dim SaveStateProperties[1] as Type_SaveStateProperty
global SaveStateLevel as Type_SaveStateLevel

global SaveStatePropertyCount as integer
global SelectedSaveStateIndex as integer

function LoadState(pBackup as integer)

    i as integer
    tFileID as integer
    tString as string
    tStringSplitCount as integer
    tStringSplit as string
    tPath as string

    if pBackup = 0
        if FullVersion = 1
            tPath = "state"  + str(SelectedSaveStateIndex) + ".csv"
        else
             tPath = "l_state"  + str(SelectedSaveStateIndex) + ".csv"
        endif
    else
        if FullVersion = 1
            tPath = "backup.csv"
        else
            tPath = "l_backup.csv"
        endif
    endif

    ClearSaveStateProperties()

    if getfileexists(tPath) = 1
        tFileID = opentoread(tPath)
            rem write down the version of the app
            rem in the first line
            tString = readline(tFileID)

            if tString = "V1"

                rem this is special
                rem write saveslot that the game was using
                if pBackup = 1
                    SelectedSaveStateIndex = val(readline(tFileID))
                endif

                rem read in whether or not player completed game
                tString = readline(tFileID)
                playerCompletedGame = val(tString)

                rem read in whether or not overlay was used

                rem write whether help was displaed
                playerShowOverlay = val(readline(tFileID))

                tString = readline(tFileID)
                tStringSplitCount = SplitStringCount(tString, ",")

                `dim SaveStateProperties[tStringSplitCount]
                `SaveStatePropertyCount = tStringSplitCount

                if tString = ""

                else
                    for i = 0 to tStringSplitCount - 1
                        tName as string
                        tProperty as integer

                        tStringSplit = SplitString(tString, ",", i)
                        tName = SplitString(tStringSplit, ":", 0)
                        tProperty = val(SplitString(tStringSplit, ":", 1))
                     `
                    `    SaveStateProperties[i].name = SplitString(tStringSplit, ":", 0)
                     `   SaveStateProperties[i].value = val(SplitString(tStringSplit, ":", 1))
                        SetSaveStateProperty(tName,tProperty )
                    next i
                endif



                tString = readline(tFileID)
                 `for i = 0 to levelListCount - 1
                 `   tString = ""
                `tString = str(SaveStateLevel.levelID) + "," +  str(SaveStateLevel.whips) + "," + str(SaveStateLevel.whipStrength) + "," +  str(SaveStateLevel.keys) + "," + str(SaveStateLevel.life) + "," +  str(SaveStateLevel.score)
                SaveStateLevel.levelID = val(SplitString(tString, ",", 0))
                SaveStateLevel.whips  = val(SplitString(tString, ",", 1))
                SaveStateLevel.whipStrength  = val(SplitString(tString, ",", 2))
                SaveStateLevel.keys  = val(SplitString(tString, ",", 3))
                SaveStateLevel.life  = val(SplitString(tString, ",", 4))
                SaveStateLevel.score  = val(SplitString(tString, ",", 5))

                `next i
                closefile(tFileID)
            endif
    else
        playerCompletedGame = 0
        playerShowOverlay = 0
        SaveStateLevel.levelID = 0
        SaveStateLevel.whips  = 0
        SaveStateLevel.whipStrength  = 2
        SaveStateLevel.keys  = 0
        SaveStateLevel.life  = 10
        SaveStateLevel.score  = 0
    endif

    playerWhips = SaveStateLevel.whips
    playerKeys = SaveStateLevel.keys
    playerHealth = SaveStateLevel.life
    playerWhipStrength = SaveStateLevel.whipStrength
    playerScore = SaveStateLevel.score
    levelSelected = SaveStateLevel.levelID
    `playerShowOverlay = 1

    SetSpriteVisible(3005, playerShowOverlay)

endfunction

function SaveState(pBackup as integer)
    i as integer
    tFileID as integer
    tString as string
    tFile as string

    if pBackup = 0
        if FullVersion = 1
            tFile = "state"  + str(SelectedSaveStateIndex) + ".csv"
        else
             tFile = "l_state"  + str(SelectedSaveStateIndex) + ".csv"
        endif
    else
        if FullVersion = 1
            tFile = "backup.csv"
        else
            tFile = "l_backup.csv"
        endif
    endif

    deletefile(tFile)

    tFileID = opentowrite(tFile, 0)
        rem write down the version of the app
        rem in the first line
        writeline(tFileID, GameVersion)
        tString = ""

        rem this is special
        rem write saveslot that the game was using
        if pBackup = 1
            writeline(tFileID, str(SelectedSaveStateIndex))
        endif

        writeline(tFileID, str(PlayerCompletedGame))



        rem write whether help was displaed
        writeline(tFileID, str(playerShowOverlay))

        for i = 0 to SaveStatePropertyCount - 1
            tString = tString + SaveStateProperties[i].name + ":" + str(SaveStateProperties[i].value)

            if i < SaveStatePropertyCount - 1
                tString = tString + ","
            endif
        next i


        rem write properties
        writeline(tFileID, tString)

         `for i = 0 to levelListCount - 1
         `   tString = ""
            tString = str(SaveStateLevel.levelID) + "," +  str(SaveStateLevel.whips) + "," + str(SaveStateLevel.whipStrength) + "," +  str(SaveStateLevel.keys) + "," + str(SaveStateLevel.life) + "," +  str(SaveStateLevel.score)

            writeline(tFileID, tString)
        `next i

    closefile(tFileID)
endfunction

function LoadLevelList()
    i as integer
    tFileID as integer
    tString as string
    rem do this so we can correctly dim the level list array later
    levelListCount = 0
    rem set first level to be selected
    levelSelected = 0

    if FullVersion = 0
        tFileID = opentoread("levelListLite.csv")
    else
        tFileID = opentoread("levelList.csv")
    endif

        rem skip first line
        rem header file
        readline(tFileID)
        rem read til out of info in file
        while fileEOF(tFileID) = 0
            rem read in line
            tString = readline(tFileID)

            rem skip last line if it is empty space
            if tString <> ""
                rem increment variable and redim array
                levelListCount = levelListCount + 1
                dim levelList[levelListCount - 1] as Type_Level

                levelList[levelListCount - 1].levelID = val(SplitString(tString, ",", 0))
                levelList[levelListCount - 1].levelPath = SplitString(tString, ",", 1)
            endif
        endwhile

    closefile(tFileID)
endfunction

function getLevelPathFromID(pID as integer)
    i as integer
    myReturn as string

    for i = 0 to levelListCount - 1
        if levelList[i].levelID = pID
            myReturn = levelList[i].levelPath
            exitfunction myReturn
        endif
    next i

endfunction myReturn

function ClearSaveStateProperties()
    i as integer

    for i = 0 to SaveStatePropertyCount - 1
        SaveStateProperties[i].value = 0
    next i
endfunction

function SetSaveStateProperty(pName as string, pValue as integer)
    i as integer
    pFound as integer

    for i = 0 to SaveStatePropertyCount - 1
        if SaveStateProperties[i].name = pName
            SaveStateProperties[i].value = pValue
            pFound = 1
        endif
    next

    if pFound = 0
        SaveStatePropertyCount = SaveStatePropertyCount + 1
        dim SaveStateProperties[SaveStatePropertyCount]
        SaveStateProperties[SaveStatePropertyCount - 1].name = pName
        SaveStateProperties[SaveStatePropertyCount - 1].value = pValue
    endif
endfunction

function GetSaveStateProperty(pName as string)
    i as integer
    myReturn as integer
    myReturn = 0

    for i = 0 to SaveStatePropertyCount - 1
        if SaveStateProperties[i].name = pName
            myReturn = SaveStateProperties[i].value
        endif
    next

endfunction myReturn

function RefreshLevelSlots()
    i as integer
    tPath as string
    tFileID as integer
    tString as string
    tStringSplitCount as integer
    tStringSplit as string

    dim LevelSlot[5] as Type_LevelSlot

    for i = 0 to 4
        if FullVersion = 1
            tPath = "state"  + str(i) + ".csv"
        else
             tPath = "l_state"  + str(i) + ".csv"
        endif

        if getfileexists(tPath) = 1
                tFileID = opentoread(tPath)
                rem write down the version of the app
                rem in the first line
                tString = readline(tFileID)

                if tString = "V1"
                    rem read in whether or not player completed game
                    tString = readline(tFileID)
                    LevelSlot[i].completed = val(tString)
                    tString = readline(tFileID)
                    tString = readline(tFileID)
                    tString = readline(tFileID)
                    LevelSlot[i].levelID = val(SplitString(tString, ",", 0))


                    closefile(tFileID)
                endif
        else
            LevelSlot[i].levelID = -1
            levelslot[i].completed = 0
        endif

    next
endfunction
