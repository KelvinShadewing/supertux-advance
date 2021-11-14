::startMain <- function() {
	stopMusic()
	songPlay(musTheme)
	game = clone(gameDefault)
	drawBG = dbgUnderwater
	gvGameMode = gmMain
	actor = {}
}

::gmMain <- function()
{
	setDrawTarget(gvScreen)
	drawBG()
	drawSprite(sprTitle, 0, screenW() / 2, 16)
	drawDebug()

	textMenu()
	if(keyPress(k_escape)) gvQuit = true

	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
}
