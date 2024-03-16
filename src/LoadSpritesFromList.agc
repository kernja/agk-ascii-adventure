REM LOAD IMAGES FROM A PROPERLY FORMATTED CSV FILE
REM EXAMPLE:
REM IMAGEID, IMAGEPATH, MAGFILTER, MINFILTER

REM PFILENAME IS PATH TO FILE, POVERWRITEEXISTING IS A NONVALUE NUMBER TO DELETE EXISTING IMAGE AND LOAD IN A NEW ONE

function LoadSpritesFromCSV(pFileName as string, pOverwriteExisting as integer)
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
	tAsAnimated as integer
	tSpriteID as integer
	tImageID as integer
	tFixSprite as integer
    tDepth as integer
	tFrameWidth as integer
	tFrameHeight as integer
	tFrameCount as integer
	tFPS as integer

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

                    REM GET FILE ID, PATH, MAG AND MIN FILTERS
                    tAsAnimated = val(SplitString(tString, ",", 0))
                	tSpriteID = val(SplitString(tString, ",", 1))
                	tImageID = val(SplitString(tString, ",", 2))
                    tFixSprite = val(SplitString(tString, ",", 4))
                    tDepth = val(SplitString(tString, ",", 5))
                	tFrameWidth = val(SplitString(tString, ",", 6))
                	tFrameHeight = val(SplitString(tString, ",", 7))
                    tFrameCount = val(SplitString(tString, ",", 8))
                    tFPS = val(SplitString(tString, ",", 9))

                    REM BEFORE WE DO ANY MANIPULATING WITH THE CURRENT DATA
                    REM MAKE SURE THE FILE EXISTS
                    if GetImageExists(tImageID) = 1
                        REM DELETE ANY EXISTING IMAGE IF OVERWRITE IS ENABLED
                        REM AND IT ALREADY EXISTS
                        if pOverwriteExisting <> 0
                            DeleteSprite(tSpriteID)
                        endif

                        REM SET UP A NON ANIMATED SPRITE AND HIDE IT
                        if tAsAnimated = 0
                            CreateSprite(tSpriteID, tImageID)
                            FixSpriteToScreen(tSpriteID, tFixSprite)
                            SetSpriteVisible(tSpriteID, 0)
                            SetSpriteDepth(tSpriteID, tDepth)
                        else
                        REM ANIMATED SPRITE
                            CreateSprite(tSpriteID, tImageID)
                            FixSpriteToScreen(tSpriteID, tFixSprite)
                            SetSpriteAnimation(tSpriteID, tFrameWidth, tFrameHeight, tFrameCount)
                            playsprite(tSpriteID)
                            SetSpriteSpeed(tSpriteID, tFPS)
                            SetSpriteVisible(tSpriteID, 0)
                            SetSpriteDepth(tSpriteID, tDepth)
                        endif
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
