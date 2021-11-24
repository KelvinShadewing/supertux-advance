::gvPauseMode <- false //Is the player on the overworld instead of normal play

::gmPause <- function() {
	setDrawTarget(gvScreen)
	drawText(font2, (screenW() / 2) - 20, screenH() / 2, "PAUSE")
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
	textMenu()
}

::togglePause <- function() {
	if(gvGameMode == gmPlay) {
		gvGameMode = gmPause
		setDrawTarget(bgPause)
		drawImage(gvScreen, 0, 0)
		gvPauseMode = false
		menu = mePausePlay
	}
	else if(gvGameMode == gmOverworld){
		gvGameMode = gmPause
		setDrawTarget(bgPause)
		drawImage(gvScreen, 0, 0)
		gvPauseMode = true
		menu = mePauseOver
	}
	else if(gvGameMode == gmPause) {
		if(gvPauseMode == false) gvGameMode = gmPlay
		else if(gvPauseMode == true) gvGameMode = gmOverworld
	}
}