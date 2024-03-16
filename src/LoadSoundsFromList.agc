
Type Type_SoundDefinition
    id as integer
    duration as float
EndType

Global Dim SoundList[1] as Type_SoundDefinition
Global SoundListCount as integer

REM PFILENAME IS PATH TO FILE, POVERWRITEEXISTING IS A NONVALUE NUMBER TO DELETE EXISTING IMAGE AND LOAD IN A NEW ONE

function LoadSoundsFromCSV(pFileName as string)
    REM MYRETURN VALUE
    REM TO STORE WHETHER OR NOT EVERYTHING COMPLETED SUCCESSFULLY
    REM 0 MEANS NO, 1 MEANS YES
    REM SET IT TO 1 INITIALLY, IF SOME ERROR OCCURS SET IT TO 0
    REM IF IT MAKES IT THROUGH THE ENTIRE FUNCTION NORMALLY, IT HAS COMPLETED SUCCESSFULLY!
    myReturn as integer
    myReturn = 1
	REM FILE ID THAT WE WORK WITH WHEN MANIPULATING THE FILE
	tFileID as integer

	REM TEMP VARIABLES USED FOR HOLDING DATA FROM THE CSV
	tID as integer
	tPath as string
	tDuration as float

	REM VARIABLE TOREDIM ARRAY
    tCount as integer

	REM VARIABLE TO HOLD DATA BEING READ FROM THE CSV
	tString as string

    REM MAKE SURE FILE PASSED IN EXISTS
	if GetFileExists(pFileName) = 1

	REM GET FILE NAME AND FILE ID
	tFileID = opentoread(pFileName)

		REM READ FIRST LINE OF FILE
		REM AS IT CONTAINS HEADER INFO
		tString = readline(tFileID)

		REM LOOP UNTIL AT END OF FILE
        while fileEOF(tFileID) = 0

		REM READ IN LINE FROM FILE
		tString = readline(tFileID)

		   REM MAKE SURE THAT LINE IS NOT EMPTY
         	   if tString <> ""
                    tCount = tCount + 1
                    SoundListCount = tCount
                    dim SoundList[tCount]

                    REM GET FILE ID, PATH, MAG AND MIN FILTERS
                    tID = val(SplitString(tString, ",", 0))
                	tPath = SplitString(tString, ",", 1)
                	tDuration = val(SplitString(tString, ",", 2)) * .001

                    REM BEFORE WE DO ANY MANIPULATING WITH THE CURRENT DATA
                    REM MAKE SURE THE FILE EXISTS
                    if GetFileExists(tPath)
                        REM DELETE ANY EXISTING IMAGE IF OVERWRITE IS ENABLED
                        REM AND IT ALREADY EXISTS
                            deletesound(tID)
                            loadsound(tID, tPath)
                            SoundList[tCount - 1].id = tID
                            SoundList[tCount - 1].duration = tDuration
                    else
                        REM IMAGE NOT FOUND.  RETURN 0
                        myReturn = 0
                    endif
 	           endif
        	endwhile

		REM CLOSE FILE
        closefile(tFileID)
    else
        REM CSV NOT FOUND. RETURN 0
        myReturn = 0
	endif

endfunction myReturn

function GetSoundDuration(pID as integer)
    myReturn as float
    i as integer

    for i = 0 to SoundListCount - 1
        if SoundList[i].id = pID
            myReturn = SoundList[i].duration
            exitfunction myReturn
        endif
    next

endfunction myReturn
