::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

	function run() {
		timer--
		if(timer == 0) startOverworld(game.world)
	}
}

::endGoal <- function() {
	if(gvPlayer != 0){
		gvPlayer.canMove = false
		gvPlayer.endmode = true
		gvPlayer.hspeed = 0.5
		gvPlayer.invincible = 999
		game.coins += game.levelcoins
		if(game.levelcoins >= game.maxcoins && !game.allcoins.rawin(gvMap.name)) game.allcoins[gvMap.name] <- true
		if(game.secrets <= 0 && !game.allsecrets.rawin(gvMap.name)) game.allsecrets[gvMap.name] <- true
		if(game.enemies <= 0 && !game.allenemies.rawin(gvMap.name)) game.allenemies[gvMap.name] <- true
		playSound(sndWin, 0)
		stopMusic()
		if(!game.completed.rawin(gvMap.name)) game.completed[gvMap.name] <- true
		newActor(LevelEnder, 0, 0)
	}
	gvPlayer = 0
}