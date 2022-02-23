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

::endGoal <- function() {
	if(levelEndRunner == 0){
		gvPlayer.canMove = false
		gvPlayer.endMode = true
		if(gvPlayer.hspeed > 2) gvPlayer.hspeed = 2.0
		gvPlayer.invincible = 999
		if(game.levelCoins >= game.maxCoins && !game.allCoins.rawin(gvMap.name)) game.allCoins[gvMap.name] <- true
		if(game.secrets <= 0 && !game.allSecrets.rawin(gvMap.name)) game.allSecrets[gvMap.name] <- true
		if(game.enemies <= 0 && !game.allEnemies.rawin(gvMap.name)) game.allEnemies[gvMap.name] <- true
		game.coins += game.levelCoins

		playSound(sndWin, 0)
		stopMusic()
		if(!game.completed.rawin(gvMap.name)) game.completed[gvMap.name] <- true
		levelEndRunner = newActor(LevelEnder, 0, 0)

		if(!game.bestTime.rawin(gvMap.name)) game.bestTime[gvMap.name] <- gvIGT
		else if(game.bestTime[gvMap.name] > gvIGT) game.bestTime[gvMap.name] = gvIGT

		saveGame()
	}
}