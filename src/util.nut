///////////////////////
// UTILITY FUNCTIONS //
///////////////////////

//These functions may end up being added to the runtime core file.
//They will be marked as such if this happens.

::mergeTable <- function(a, b) {
	//Create new table
	local nt = clone(a)

	//Merge B table slots into A table
	foreach(slot, i in b) {
		if(!nt.rawin(slot)) nt[slot] <- i
		else if(typeof nt[slot] == "table" && typeof b[slot] == "table") nt[slot] = mergeTable(nt[slot], b[slot])
		else nt[slot] <- i
	}

	return nt
}

::gotoTest <- function() {
	game.check = false
	startPlay("res/map/test.json")
}