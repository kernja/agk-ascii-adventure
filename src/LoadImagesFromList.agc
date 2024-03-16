REM LOAD IMAGES FROM A PROPERLY FORMATTED CSV FILE
REM EXAMPLE:
REM IMAGEID, IMAGEPATH, MAGFILTER, MINFILTER

REM PFILENAME IS PATH TO FILE, POVERWRITEEXISTING IS A NONVALUE NUMBER TO DELETE EXISTING IMAGE AND LOAD IN A NEW ONE

function LoadImagesFromCSV(pFileName as string, pOverwriteExisting as integer)
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
	tSubImage as integer
	tSourceImage as integer
	tImageID as integer
	tImagePath as string
	tMagFilter as integer
	tMinFilter as integer

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
                    tSubImage = val(SplitString(tString, ",", 0))
                	tImageID = val(SplitString(tString, ",", 1))
                	tImagePath = SplitString(tString, ",", 2)
                	tMagFilter = val(SplitString(tString, ",", 3))
                	tMinFilter = val(SplitString(tString, ",", 4))
                    tSourceImage = val(SplitString(tString, ",", 5))

                    REM BEFORE WE DO ANY MANIPULATING WITH THE CURRENT DATA
                    REM MAKE SURE THE FILE EXISTS
                    if (GetFileExists(tImagePath) and tSubImage=0) or tSubImage > 0
                        REM DELETE ANY EXISTING IMAGE IF OVERWRITE IS ENABLED
                        REM AND IT ALREADY EXISTS
                        if pOverwriteExisting <> 0 and GetImageExists(tImageID) = 1
                            DeleteImage(tImageID)
                        endif

                        REM LOAD IMAGE =)
                        REM DO THIS IF IT IS A NORMAL IMAGE
                        if tSubImage = 0
                            if GetImageExists(tImageID) = 0
                                loadImage(tImageID, tImagePath)
                                SetImageMagFilter(tImageID, tMagFilter)
                                SetImageMinFilter(tImageID, tMinFilter)
                            endif
                        else
                            if GetImageExists(tImageID) = 0
                                LoadSubImage(tImageID, tSourceImage, tImagePath)
                            endif
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

