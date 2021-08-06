
::gmPause <- function() {
	drawText(font, 16, 16, "Pause is incomplete, so this screen is black.")
}

::togglePause <- function() {
	if(gvGameMode == gmPlay) {
		gvGameMode = gmPause
		//TODO Add taking screenshot to use as pause background
	}
	else if(gvGameMode == gmPause) gvGameMode = gmPlay
}