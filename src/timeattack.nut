::gvNextLevel <- ""
::gvTimeAttack <- false
::gvTAStart <- "aurora-learn"
::gvTAStep <- 0
::gvTACourse <- 0

::addTimeAttackWorld <- function(
	displayName, //Name to show in the menu
	list, //List of levels in order they're to be played
	folder //The contrib/ folder of your world
	) {
	if(displayName in gvLangObj["level"])
		displayName = gvLangObj["level"][displayName]
	local tempBack = meTimeAttackWorld.pop() //To move back to the end
	local newSlot = {
		name = function() { return displayName }
		func = function() {
			game.path = "contrib/" + folder + "/"
			gvTACourse = list
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

	meTimeAttackWorld.push(newSlot)
	meTimeAttackWorld.push(tempBack)
}