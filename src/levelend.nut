::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

}

::endGoal <- function() {
	gvPlayer.canMove = false
	gvPlayer.hspeed = 4
	gvPlayer.vspeed = 1
	gvPlayer = 0
}