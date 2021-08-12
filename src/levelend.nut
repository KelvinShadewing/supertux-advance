::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

}

::endGoal <- function() {
	gvPlayer.canMove = false
	if(gvPlayer.hspeed < 3) gvPlayer.hspeed = 3
	gvPlayer.vspeed = 1
	gvPlayer = 0
}