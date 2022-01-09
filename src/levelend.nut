::levelEndRunner <- 0 //Stores a reference to the currently-active LevelEnder

::LevelEnder <- class extends Actor {
	timer = 180

	constructor(_x, _y, _arr = null) {
		base.constructor(0, 0)
	}

	function run() {
		timer--
		if(timer == 0 || getcon("pause", "press")) {
			stopSound(-1)
			startOverworld(game.world)
			levelEndRunner = 0
		}
	}

	function _typeof() { return "LevelEnder" }
}

::endGoal <- function() {
	if(levelEndRunner == 0){
		gvPlayer.canMove = false
		gvPlayer.endmode = true
		if(gvPlayer.hspeed > 2) gvPlayer.hspeed = 2.0
		gvPlayer.invincible = 999
		game.coins += game.levelcoins
		if(game.levelcoins >= game.maxcoins && !game.allcoins.rawin(gvMap.name)) game.allcoins[gvMap.name] <- true
		if(game.secrets <= 0 && !game.allsecrets.rawin(gvMap.name)) game.allsecrets[gvMap.name] <- true
		if(game.enemies <= 0 && !game.allenemies.rawin(gvMap.name)) game.allenemies[gvMap.name] <- true

		playSound(sndWin, 0)
		stopMusic()
		if(!game.completed.rawin(gvMap.name)) game.completed[gvMap.name] <- true
		levelEndRunner = newActor(LevelEnder, 0, 0)

		if(!game.besttime.rawin(gvMap.name)) game.besttime[gvMap.name] <- gvIGT
		else if(game.besttime[gvMap.name] > gvIGT) game.besttime[gvMap.name] = gvIGT

		saveGame()
	}
}