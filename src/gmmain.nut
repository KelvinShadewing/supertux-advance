::startMain <- function() {
	stopMusic()
	game = clone(gameDefault)
	drawBG = dbgUnderwater
	gvGameMode = gmMain
	actor = {}
}

::gmMain <- function()
{
	drawBG()
	drawSprite(sprTitle, 0, screenW() / 2, 16)
	drawDebug()

	textMenu()
	if(keyPress(k_escape)) gvQuit = true
}
