
::gmPause <- function() {
	setDrawTarget(gvScreen)
	drawText(font2, (screenW() / 2) - 20, screenH() / 2, "PAUSE")
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
}

::togglePause <- function() {
	if(gvGameMode == gmPlay) {
		gvGameMode = gmPause
		setDrawTarget(bgPause)
		drawImage(gvScreen, 0, 0)
	}
	else if(gvGameMode == gmPause) gvGameMode = gmPlay
}