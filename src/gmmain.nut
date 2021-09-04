::gmMain <- function()
{
	//TODO: Put main menu here
	dbgOcean()
	camx++
	drawSprite(sprTitle, 0, 160, 16)

	textMenu()
	if(keyPress(k_escape)) gvQuit = true
}
