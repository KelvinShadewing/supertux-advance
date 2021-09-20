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
		playSound(sndWin, 0)
		stopMusic()
		if(!game.completed.rawin(gvMap.name)) game.completed[gvMap.name] <- true
		newActor(LevelEnder, 0, 0)
	}
	gvPlayer = 0
}