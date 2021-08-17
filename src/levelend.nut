::levelEndRunner <- 0

::LevelEnder <- class extends Actor {
	timer = 600

}

::endGoal <- function() {
	gvPlayer.canMove = false
	gvPlayer.endmode = true
	gvPlayer = 0
}