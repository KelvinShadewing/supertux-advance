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
		if(nt.rawin(slot)) nt[slot] = i
		else nt[slot] <- i
	}

	return nt
}