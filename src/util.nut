///////////////////////
// UTILITY FUNCTIONS //
///////////////////////

//These functions may end up being added to the runtime core file.
//They will be marked as such if this happens.

::mergeTable <- function(a, b) {
	if(typeof a == null && typeof b == null) return null
	if(typeof a == null) return b
	if(typeof b == null) return a
	if(a == null) return b
	if(b == null) return a

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
	startPlay("res/map/test.json", true, true)
}

::canint <- function(str) {
	switch(typeof str) {
		case "float":
		case "integer":
			return true
			break
		case "string":
			if(str.len() == 0) return false
			else {
				for(local i = 0; i < 10; i++) {
					if(str[0].tochar() == i.tostring()) return true
				}
				if(str[0] == "-") return true
			}
			return false
			break
		default:
			return false
			break
	}
}

::minNum <- function(a, b) { return (a * (a < b)) + (b * (b <= a)) }

::maxNum <- function(a, b) { return (a * (a > b)) + (b * (b >= a)) }

::popSound <- function(sound, repeat = 0) {
	stopSound(sound)
	playSound(sound, repeat)
}

::addTimeAttackWorld <- function(
	displayName, //Name to show in the menu
	folder, //The contrib/ folder of your world
	level //The first level of the world
	) {
	local tempBack = meTimeAttack.pop() //To move back to the end
	local newSlot = {
		name = function() { return displayName }
		func = function() {
			gvTAFullGame = false
			game.path = "contrib/" + folder + "/"
			gvTAStart = level
			menu = meDifficulty

			local searchDirExists = false
			for(local i = 0; i < tileSearchDir.len(); i++) {
				if(tileSearchDir[i] == "contrib/" + folder + "/gfx") searchDirExists = true
			}
			if(!searchDirExists) tileSearchDir.push("contrib/" + folder + "/gfx")

			if(fileExists("contrib/" + folder + "/script.nut") && !contribDidRun.rawin(folder)) {
				donut("contrib/" + folder + "/script.nut")
				contribDidRun[folder] <- true
			}
		}
	}

	meTimeAttack.push(newSlot)
	meTimeAttack.push(tempBack)
}