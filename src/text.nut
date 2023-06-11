::textLineLen <-  function(_s, _l) {
	_s = strip(_s)
	if (_s.len() == 0) return

	local newstr = "" //New string being made
	local curline = ""
	local words = split(_s, " ")

	foreach(i in words) {
		if (i.len() >= _l) {
			newstr += i
			newstr += "\n"
			curline = ""
		} else {
			if (curline.len() + i.len() + 1 >= _l) {
				newstr += curline
				curline = ""
				newstr += "\n"
			}
			if (curline.len() + i.len() + 1 <= _l) {
				curline += i
				curline += " "
			}
		}
	}

	newstr += curline

	return newstr
}

::drawTextLen <-  function(_f, _x, _y, _s, _l) {
	_s = strip(_s)
	if (_s.len() == 0) return

	local newstr = "" //New string being made
	local curline = ""
	local words = split(_s, " ")

	foreach(i in words) {
		if (i.len() >= _l) {
			newstr += i
			newstr += "\n"
			curline = ""
		} else {
			if (curline.len() + i.len() + 1 < _l) {
				curline += i
				curline += " "
			}
			if (curline.len() + i.len() + 1 >= _l) {
				newstr += curline
				curline = ""
				newstr += "\n"
			}
		}
	}

	drawText(_f, _x, _y, newstr)
}

::formatTime <-  function(time) {
	local seconds = (time % 3600).tofloat() / 60.0
	local minutes = floor(time / 3600)

	local seconds_p1 = ceil(seconds)
	local seconds_p2 = (seconds - floor(seconds)) * 1000
	return format("%02d:%02d.%03d", minutes, seconds_p1, seconds_p2);
}

::formatInfo <- function(info) {
	if(typeof info == "string")
		return info

	local newcall = [0]

	for(local i = 0; i < info.len(); i++) {
		if(i == 0)
			newcall.push(info[i])
		else newcall.push(eval(info[i]))
	}

	return format.acall(newcall)
}