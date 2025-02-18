gvBattleMode <- false
gvBattleHealth <- 0

P2Start <- class extends Actor {
	function run() {
		if(gvPlayer2) {
			gvPlayer2.x = x
			gvPlayer2.y = y
			deleteActor(id)
		}
	}
}

manageBattle <- function() {
	if(!gvPlayer || !gvPlayer2) endGoal()
}

addBattleStage <- function(
	displayName, //Name to show in the menu
	level, //level file
	folder, //The folder of your world
	sprite
	) {
	if(displayName in gvLangObj["level"])
		displayName = gvLangObj["level"][displayName]
	local tempBack = meBattleWorld.pop() //To move back to the end
	local newSlot = {
		name = function() { 
			drawBattlePreview(sprite)
			return displayName
		}
		func = function() {
			game.path = folder
			gvTACourse = level

			local searchDirExists = false
			for(local i = 0; i < tileSearchDir.len(); i++) {
				if(tileSearchDir[i] == folder + "/gfx") searchDirExists = true
			}
			if(!searchDirExists) tileSearchDir.push(folder + "/gfx")

			if(fileExists(folder + "/script.nut") && !contribDidRun.rawin(folder)) {
				donut(folder + "/script.nut")
				contribDidRun[folder] <- true
			}

			startBattle(game.path + "/" + level + ".json")
		}
	}

	meBattleWorld.push(newSlot)
	meBattleWorld.push(tempBack)
}

drawBattlePreview <- function(sprite) {
	drawSprite(sprite, 0, screenW() - 16 - spriteW(sprite) / 2, screenH() - 96)
}

startBattle <- function(level) {
	gvBattleMode = true
	game.maxHealth = 16 + gvBattleHealth
	startPlay(level, true, true)
}