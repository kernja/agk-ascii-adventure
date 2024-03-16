REM LOAD IMAGES FROM A PROPERLY FORMATTED CSV FILE
REM EXAMPLE:
REM IMAGEID, IMAGEPATH, MAGFILTER, MINFILTER

REM PFILENAME IS PATH TO FILE, POVERWRITEEXISTING IS A NONVALUE NUMBER TO DELETE EXISTING IMAGE AND LOAD IN A NEW ONE
TYPE TYPE_TREASURE
    id as integer
    treasure as string
endtype
global dim TreasureList[1] as TYPE_TREASURE
global treasureCount as integer

function LoadTreasureFromCSV(pFileName as string)
    REM MYRETURN VALUE
    REM TO STORE WHETHER OR NOT EVERYTHING COMPLETED SUCCESSFULLY
    REM 0 MEANS NO, 1 MEANS YES
    REM SET IT TO 1 INITIALLY, IF SOME ERROR OCCURS SET IT TO 0
    REM IF IT MAKES IT THROUGH THE ENTIRE FUNCTION NORMALLY, IT HAS COMPLETED SUCCESSFULLY!
    myReturn as integer
    myReturn = 1
	REM FILE ID THAT WE WORK WITH WHEN MANIPULATING THE FILE
	tFileID as integer
	i as integer

	REM VARIABLE TO HOLD DATA BEING READ FROM THE CSV
	tString as string

    REM MAKE SURE FILE PASSED IN EXISTS
	if GetFileExists(pFileName) = 1

	REM GET FILE NAME AND FILE ID
	tFileID = opentoread(pFileName)

		REM READ FIRST LINE OF FILE
		REM AS IT CONTAINS HEADER INFO
		tString = readline(tFileID)
        treasureCount = 0

        while fileeof(tFileID) = 0

		REM READ IN LINE FROM FILE
		tString = readline(tFileID)

		   REM MAKE SURE THAT LINE IS NOT EMPTY
         	   if tString <> ""
                    treasureCount = treasureCount + 1
                    dim TreasureList[treasureCount] as TYPE_TREASURE
                    TreasureList[treasureCount - 1].id = val(SplitString(tString, ",", 0))
                    TreasureList[treasureCount - 1].treasure = SplitString(tString, ",", 1)
                endif
        endwhile

		REM CLOSE FILE
        closefile(tFileID)
    else
        REM CSV NOT FOUND. RETURN 0
        myReturn = 0
	endif

endfunction myReturn

function GetTreasureChestString(pID as integer)
    myReturn as string
    i as integer

    `if pID = -1
        myReturn = TreasureList[0].treasure
   `     exitfunction myReturn
   ` endif

    for i = 0 to treasureCount - 1
        if TreasureList[i].id = pID
            myReturn = TreasureList[i].treasure
            exitfunction myReturn
        endif
    next
endfunction myReturn
