::startRacer <- function(level) {
	if(!fileExists(level)) return

	//Clear actors and start creating new ones
	setFPS(60)
	gvPlayer = false
	gvBoss = false
	actor.clear()
	actlast = 0
}