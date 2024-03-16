rem this gets the amount of 'segments' that a string can be split into
rem this is based off of 1, not 0.  so, if the string and delimiter you pass in
rem returns a counted valueof 3, you can get segments 0-2 from it.
function SplitStringCount(pString as string, pDelimiter as string)
    delimitCount as integer
    i as integer

    rem get length of string
    pStringLength as integer
    pStringLength = len(pString)

    rem parse through the string and count how many delimited chars there are
    for i = 0 to pStringLength - 1
        if mid(pString, i + 1, 1) = pDelimiter
            delimitCount = delimitCount + 1
        endif
    next i

    delimitCount = delimitCount + 1
endfunction delimitCount

rem this splits a string by its delimiter and will return one segment of it.
rem to see how many segments there are, use SplitStringCount.
rem NOTE: SplitString is 0-based, whereas SplitStringCount is 1-based.
rem       This is so that SplitStringCount will return a total value of segments (e.g., 3)
rem       and to access them in SplitString, you'll use values 0-2.

REM NOTE, if this function 'errors' out - e.g., invalid segment (negative number or too a high a number)
REM this function will return the ENTIRE string back to you.
REM if the function was successful, it will only send back a segment as the return value.
function SplitString(pString as string, pDelimiter as string, pSegment)
    delimitCount as integer
    myReturn as string
        myReturn = ""
    charCount as integer
    segmentCount as integer
    exitSearch as integer
    i as integer

    rem get the length of the original source string
    pStringLength as integer
    pStringLength = len(pString)

    rem count how many delimiters there are in the string
    for i = 0 to pStringLength - 1
        if mid(pString, i + 1, 1) = pDelimiter
            delimitCount = delimitCount + 1
        endif
    next i

    rem if there are no delimiters found in the original source string
    rem or there was an invalid segment number passed in (negative, too high a number)
    rem return the original source string
    if delimitCount = 0 or pSegment < 0 or pSegment > delimitCount
        exitfunction pString
    endif

    rem this is only applicable to the non-first segment.
    rem this finds the first character after a selected delimiter.
    rem if we wanted to split up 'foo,bar' and get the second segment, this would return the position of 'b'
    rem since the first letter of the first segment starts at 0, we can ignore it
    if pSegment > 0
        for i = 0 to pStringLength - 1
            charCount = charCount + 1

            if mid(pString, i + 1, 1) = pDelimiter
                segmentCount = segmentCount + 1

                if segmentCount = pSegment
                    exit
                endif
            endif
        next i
    endif

    rem return an empty string
    rem if the last character in the original source string was a delimiter:  foo,bar,
    if charCount >= pStringLength
        myReturn = ""
        exitfunction myReturn
    endif

    rem now we search through and add characters that we need to our return variable.
    rem keep adding eltters until we hit a delimiter or the string ends
    while exitSearch = 0 and charCount < pStringLength
        if mid(pString, charCount + 1, 1) = pDelimiter
            exitSearch = 1
        else
            myReturn = myReturn + mid(pString, charCount + 1, 1)
            charCount = charCount + 1
        endif
    endwhile

    rem return value
endfunction myReturn
