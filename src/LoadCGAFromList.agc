REM LOAD IMAGES FROM A PROPERLY FORMATTED CSV FILE
REM EXAMPLE:
REM IMAGEID, IMAGEPATH, MAGFILTER, MINFILTER

REM PFILENAME IS PATH TO FILE, POVERWRITEEXISTING IS A NONVALUE NUMBER TO DELETE EXISTING IMAGE AND LOAD IN A NEW ONE
TYPE TYPE_COLOR
    R as integer
    G as integer
    B as integer
    A as integer
endtype
global dim CGAColors[16] as TYPE_COLOR
global cgaColorIndex as float

function LoadCGAFromCSV(pFileName as string)
    dim CGAColors[16] as TYPE_COLOR
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

        for i = 0 to 15

		REM READ IN LINE FROM FILE
		tString = readline(tFileID)

		   REM MAKE SURE THAT LINE IS NOT EMPTY
         	   if tString <> ""
                    CGAColors[i].R = val(SplitString(tString, ",", 1))
                    CGAColors[i].G = val(SplitString(tString, ",", 2))
                    CGAColors[i].B = val(SplitString(tString, ",", 3))
                    CGAColors[i].A = val(SplitString(tString, ",", 4))
                endif
        	next

		REM CLOSE FILE
        closefile(tFileID)
    else
        REM CSV NOT FOUND. RETURN 0
        myReturn = 0
	endif

endfunction myReturn

function renderCGAColors(pTimeElapsed as float)
    cgaColorIndex = cgaColorIndex + (16 * pTimeElapsed)

    if floor(cgaColorIndex) >= 16
        cgaColorIndex = cgaColorIndex - 16
    endif
endfunction

function changeTextToRandomCGAColor(pID as integer)
    myColor as integer
    myColor = floor(cgaColorIndex)

    SetTextColor(pID, CGAColors[myColor].R,CGAColors[myColor].G,CGAColors[myColor].B,CGAColors[myColor].A )
endfunction

function changeTextToCGAColor(pID as integer, pColor as integer)
    SetTextColor(pID, CGAColors[pColor].R,CGAColors[pColor].G,CGAColors[pColor].B,CGAColors[pColor].A)
endfunction
