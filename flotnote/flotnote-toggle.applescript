property stateFile : "/tmp/flotnote-prev-app"

on betweenQuotes(t)
	set AppleScript's text item delimiters to "\""
	set parts to text items of t
	set AppleScript's text item delimiters to ""
	if (count of parts) is greater than 1 then return item 2 of parts
	return ""
end betweenQuotes

on firstWord(t)
	set AppleScript's text item delimiters to " "
	set ws to text items of t
	set AppleScript's text item delimiters to ""
	if (count of ws) is 0 then return ""
	set w to item 1 of ws
	if (length of w) is greater than 1 and w starts with "\"" and w ends with "\"" then
		return text 2 thru -2 of w
	end if
	return w
end firstWord

on frontmostLine()
	set info to do shell script "lsappinfo info \"$(lsappinfo front | sed 's/:$//')\""
	set bid to ""
	set disp to ""
	set theLines to paragraphs of info
	if (count of theLines) is greater than 0 then set disp to my firstWord(item 1 of theLines)
	repeat with ln in theLines
		if ln contains "bundleID=" then
			set bid to my betweenQuotes(ln)
			exit repeat
		end if
	end repeat
	return bid & linefeed & disp
end frontmostLine

on captureContext()
	set theBid to ""
	set theDisp to ""
	set theWin to ""
	set theOk to "0"
	try
		set ctxLine to my frontmostLine()
		set theOk to "1"
		set parts to paragraphs of ctxLine
		if (count of parts) is greater than 0 then set theBid to item 1 of parts
		if (count of parts) is greater than 1 then set theDisp to item 2 of parts
		if theBid is not "" and theBid is not "com.flotnote.app" then
			tell application "System Events"
				set targetProc to first application process whose bundle identifier is theBid
				try
					set theWin to name of front window of targetProc
					if theWin is missing value then set theWin to ""
				on error
					set theWin to ""
				end try
			end tell
		end if
	on error
		set theOk to "0"
	end try
	return theBid & linefeed & theDisp & linefeed & theWin & linefeed & theOk
end captureContext

on writeState(s)
	try
		set fh to open for access (POSIX file stateFile) with write permission
		set eof of fh to 0
		write s to fh
		close access fh
	on error
		try
			close access fh
		end try
	end try
end writeState

on readState()
	try
		return read (POSIX file stateFile)
	on error
		return ""
	end try
end readState

on flotWc()
	tell application "System Events"
		if exists process "Flotnote" then return count of windows of process "Flotnote"
		return 0
	end tell
end flotWc

on openFlotnote()
	set ctx to my captureContext()
	set parts to paragraphs of ctx
	set rec to ""
	if (count of parts) is greater than 2 then
		set rec to item 1 of parts & linefeed & item 2 of parts & linefeed & item 3 of parts
	end if
	my writeState(rec)
	do shell script "open -a Flotnote"
end openFlotnote

on dismissFlotnote()
	set ctx to my captureContext()
	set parts to paragraphs of ctx
	set cb to ""
	set ok to "0"
	if (count of parts) is greater than 0 then set cb to item 1 of parts
	if (count of parts) is greater than 3 then set ok to item 4 of parts
	if ok is not "1" then
		tell application "Flotnote" to activate
	else if cb is "com.flotnote.app" then
		tell application "System Events" to key code 53
		delay 0.2
		set stxt to my readState()
		set sparts to paragraphs of stxt
		set prevBid to ""
		set prevDisp to ""
		set prevWin to ""
		if (count of sparts) is greater than 0 then set prevBid to item 1 of sparts
		if (count of sparts) is greater than 1 then set prevDisp to item 2 of sparts
		if (count of sparts) is greater than 2 then set prevWin to item 3 of sparts
		set usedBid to false
		if prevBid is not "" and prevBid is not "com.flotnote.app" then
			try
				tell application id prevBid to activate
				set usedBid to true
			end try
		end if
		if not usedBid and prevDisp is not "" and prevDisp is not "Flotnote" then
			try
				tell application prevDisp to activate
			end try
		end if
		if prevWin is not "" then
			delay 0.05
			try
				tell application "System Events"
					set targetProc to first application process whose bundle identifier is prevBid
					set targetWin to first window of targetProc whose name is prevWin
					perform action "AXRaise" of targetWin
				end tell
			end try
			if usedBid then
				try
					tell application id prevBid to activate
				end try
			end if
		end if
	else
		set rec to item 1 of parts & linefeed & item 2 of parts & linefeed & item 3 of parts
		my writeState(rec)
		tell application "Flotnote" to activate
	end if
end dismissFlotnote

if my flotWc() is 0 then
	my openFlotnote()
else
	my dismissFlotnote()
end if
