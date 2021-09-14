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
	drawSprite(sprTitle, 0, 160, 16)
	drawDebug()

	textMenu()
	if(keyPress(k_escape)) gvQuit = true
}
