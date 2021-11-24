::startMain <- function() {
	stopMusic()
	songPlay(musTheme)
	game = clone(gameDefault)
	drawBG = dbgUnderwater
	gvGameMode = gmMain
	actor = {}
	menu = meMain
}

::gmMain <- function()
{
	setDrawTarget(gvScreen)
	drawBG()
	drawSprite(sprTitle, 0, screenW() / 2, 16)
	drawDebug()

	textMenu()

	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
}
