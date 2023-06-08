::gvPauseMode <- false //Is the player on the overworld instead of normal play

::gmPause <- function() {
	setDrawTarget(gvScreen)
	drawImage(bgPause, 0, 0)
	setDrawColor(0x00000080)
	drawRec(0, 0, screenW(), screenH(), true)
	drawText(font2, (screenW() / 2) - 20, screenH() / 2 - 64, gvLangObj["pause-menu"]["pause"])
	textMenu()
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
}

::togglePause <- function() {
	cursor = 0
	if(gvGameMode == gmPlay) {
		if(actor.rawin("DeadPlayer") && actor["DeadPlayer"].len() > 0 && !gvPlayer && !gvPlayer2) {
			startPlay(gvMap.file, true, true)
			if(game.check == false) {
				gvIGT = 0
				game.ps.weapon = "normal"
			}
		}
		else {
			gvGameMode = gmPause
			setDrawTarget(bgPause)
			drawImage(gvScreen, 0, 0)
			gvPauseMode = false
			if(gvTimeAttack) menu = mePauseTimeAttack
			else menu = mePausePlay
			autocon = clone(defAutocon)
		}
	}
	else if(gvGameMode == gmOverworld){
		if(gvPlayer) if(gvPlayer.hspeed != 0 || gvPlayer.vspeed != 0) return
		gvGameMode = gmPause
		setDrawTarget(bgPause)
		drawImage(gvScreen, 0, 0)
		gvPauseMode = true
		menu = mePauseOver
		autocon = clone(defAutocon)
	}
	else if(gvGameMode == gmPause) {
		if(gvPauseMode == false) gvGameMode = gmPlay
		else if(gvPauseMode == true) gvGameMode = gmOverworld
	}
}