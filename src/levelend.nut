::levelEndRunner <- 0 //Stores a reference to the currently-active LevelEnder

::LevelEnder <- class extends Actor {
	timer = 180

	constructor(_x, _y, _arr = null) {
		base.constructor(0, 0)
	}

	function run() {
		timer--
		if(timer == 0 || getcon("pause", "press")) {
			stopChannel(-1)
			startOverworld(game.world)
			levelEndRunner = 0
		}
	}

	function _typeof() { return "LevelEnder" }
}

::endGoal <- function(level = "") {
	local clearedLevel
	if(level == "") {
		clearedLevel = gvMap.name
	} else {
		clearedLevel = level
	}
	if(levelEndRunner == 0){
		gvPlayer.canMove = false
		gvPlayer.endMode = true
		if(gvPlayer.hspeed > 2) gvPlayer.hspeed = 2.0
		gvPlayer.invincible = 999

		if(!game.completed.rawin(clearedLevel)) game.completed[clearedLevel] <- true
		if(game.levelCoins >= game.maxCoins && !game.allCoins.rawin(clearedLevel)) game.allCoins[clearedLevel] <- true
		if(game.secrets <= 0 && !game.allSecrets.rawin(clearedLevel)) game.allSecrets[clearedLevel] <- true
		if(game.enemies <= 0 && !game.allEnemies.rawin(clearedLevel)) game.allEnemies[clearedLevel] <- true
		if(!game.bestTime.rawin(clearedLevel)) game.bestTime[clearedLevel] <- gvIGT
		else if(game.bestTime[clearedLevel] > gvIGT) game.bestTime[clearedLevel] = gvIGT

		game.coins += game.levelCoins

		playSound(sndWin, 0)
		stopMusic()

		levelEndRunner = newActor(LevelEnder, 0, 0)



		saveGame()
	}
}