::gvPauseMode <- false //Is the player on the overworld instead of normal play

::gmPause <- function() {
	setDrawTarget(gvScreen)
	drawImage(bgPause, 0, 0)
	drawText(font2, (screenW() / 2) - 20, screenH() / 2 - 64, gvLangObj["pause-menu"]["pause"])
	textMenu()
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
}

::togglePause <- function() {
	cursor = 0
	if(gvGameMode == gmPlay) {
		if(actor.rawin("DeadPlayer")) {
			startPlay(gvMap.file)
			if(game.check == false) {
				gvIGT = 0
				game.weapon = 0
			}
		}
		else {
			gvGameMode = gmPause
			setDrawTarget(bgPause)
			drawImage(gvScreen, 0, 0)
			gvPauseMode = false
			menu = mePausePlay
			autocon = {
				up = false
				down = false
				left = false
				right = false
			}
		}
	}
	else if(gvGameMode == gmOverworld){
		if(gvPlayer) if(gvPlayer.hspeed != 0 || gvPlayer.vspeed != 0) return
		gvGameMode = gmPause
		setDrawTarget(bgPause)
		drawImage(gvScreen, 0, 0)
		gvPauseMode = true
		menu = mePauseOver
		autocon = {
			up = false
			down = false
			left = false
			right = false
		}
	}
	else if(gvGameMode == gmPause) {
		if(gvPauseMode == false) gvGameMode = gmPlay
		else if(gvPauseMode == true) gvGameMode = gmOverworld
	}
}