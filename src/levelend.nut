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
			levelEndRunner = 0
			if(gvNextLevel != "" && gvTimeAttack) {
				game.check = false
				if(gvNextLevel == "timeattack-win") startPlay("res/map/" + gvNextLevel + ".json", true, true)
				else startPlay(game.path + gvNextLevel + ".json", true, true)
				gvIGT = 0
			}
			else startOverworld(game.world)
		}
	}

	function _typeof() { return "LevelEnder" }
}

::endGoal <- function(next = "", unblock = "") {
	local clearedLevel
	clearedLevel = gvMap.name
	gvNextLevel = next
	if(levelEndRunner == 0){
		gvPlayer.canMove = false
		gvPlayer.endMode = true
		if(gvPlayer.hspeed > 2) gvPlayer.hspeed = 2.0
		gvPlayer.invincible = 999

		if(unblock != "" && !game.unblocked.rawin(unblock)) game.unblocked[unblock] <- true
		if(!game.completed.rawin(clearedLevel)) game.completed[clearedLevel] <- true
		if(game.levelCoins >= game.maxCoins && !game.allCoins.rawin(clearedLevel)) game.allCoins[clearedLevel] <- true
		if(game.secrets >= game.maxSecrets && !game.allSecrets.rawin(clearedLevel)) game.allSecrets[clearedLevel] <- true
		if(game.enemies >= game.maxEnemies && !game.allEnemies.rawin(clearedLevel)) game.allEnemies[clearedLevel] <- true
		if(!game.bestTime.rawin(clearedLevel)) game.bestTime[clearedLevel] <- gvIGT
		else if(game.bestTime[clearedLevel] > gvIGT) game.bestTime[clearedLevel] = gvIGT

		//Best stats
		if(!game.bestTime.rawin(clearedLevel + "-" + game.playerChar)) game.bestTime[clearedLevel + "-" + game.playerChar] <- gvIGT
		else if(game.bestTime[clearedLevel + "-" + game.playerChar] > gvIGT) game.bestTime[clearedLevel + "-" + game.playerChar] <- gvIGT
		if(!game.bestCoins.rawin(clearedLevel)) game.bestCoins[clearedLevel] <- game.levelCoins
		else if(game.bestCoins[clearedLevel] < game.levelCoins) game.bestCoins[clearedLevel] <- game.levelCoins
		if(!game.bestSecrets.rawin(clearedLevel)) game.bestSecrets[clearedLevel] <- game.secrets
		else if(game.bestSecrets[clearedLevel] < game.secrets) game.bestSecrets[clearedLevel] <- game.secrets
		if(!game.bestEnemies.rawin(clearedLevel)) game.bestEnemies[clearedLevel] <- game.enemies
		else if(game.bestEnemies[clearedLevel] < game.enemies) game.bestEnemies[clearedLevel] <- game.enemies

		game.coins += game.levelCoins

		playSound(sndWin, 0)
		stopMusic()

		levelEndRunner = newActor(LevelEnder, 0, 0)



		saveGame()
	}
}