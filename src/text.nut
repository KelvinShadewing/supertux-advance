::textLineLen <- function(_s, _l) {
	_s = strip(_s)
	if(_s.len() == 0) return

	local newstr = "" //New string being made
	local curline = ""
	local words = split(_s, " ")

	foreach(i in words) {
		if(i.len() >= _l) {
			newstr += i
			newstr += "\n"
			curline = ""
		}
		else {
			if(curline.len() + i.len() + 1 >= _l) {
				newstr += curline
				curline = ""
				newstr += "\n"
			}
			if(curline.len() + i.len() + 1 <= _l) {
				curline += i
				curline += " "
			}
		}
	}

	newstr += curline

	return newstr
}

::drawTextLen <- function(_f, _x, _y, _s, _l) {
	_s = strip(_s)
	if(_s.len() == 0) return

	local newstr = "" //New string being made
	local curline = ""
	local words = split(_s, " ")

	foreach(i in words) {
		if(i.len() >= _l) {
			newstr += i
			newstr += "\n"
			curline = ""
		}
		else {
			if(curline.len() + i.len() + 1 < _l) {
				curline += i
				curline += " "
			}
			if(curline.len() + i.len() + 1 >= _l) {
				newstr += curline
				curline = ""
				newstr += "\n"
			}
		}
	}

	drawText(_f, _x, _y, newstr)
}