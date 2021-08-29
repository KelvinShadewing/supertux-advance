::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

}

::endGoal <- function() {
	if(gvPlayer != 0){
		gvPlayer.canMove = false
		gvPlayer.endmode = true
		gvPlayer.hspeed = 0.5
		gvPlayer.invincible = 999
		playSound(sndWin, 0)
		stopMusic()
	}
	gvPlayer = 0
}