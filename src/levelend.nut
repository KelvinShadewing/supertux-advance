::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

}

::endGoal <- function() {
	if(gvPlayer != 0){
		gvPlayer.canMove = false
		gvPlayer.endmode = true
		playSound(sndWin, 0)
	}
	gvPlayer = 0
}