startMain <- function() {
	stopMusic()
	songPlay(musTheme)
	game = createNewGameObject()
	drawBG = dbgOceanMoving
	gvGameMode = gmMain
	actor = {}
	menu = meMain
	autocon = deepClone(defAutocon)
	gvLight = 0xffffffff
	gvLightTarget = 0xffffffff
	levelEndRunner = 0
}

gmMain <- function()
{
	drawBG = dbgOceanMoving
	setDrawTarget(gvScreen)
	drawBG()
	runActors()
	drawSprite(sprTitle, 0, screenW() / 2, 16)
	drawDebug()

	drawText(font, 0, screenH() - 8, "~tBrux GDK " + bruxVersion() + " - STA " + gvVersion + " - " + getOS())
	textMenu()
}
