::gmMain <- function()
{
	//TODO: Put main menu here
	drawBG = dbgUnderwater
	drawBG()
	drawSprite(sprTitle, 0, 160, 16)

	textMenu()
	if(keyPress(k_escape)) gvQuit = true
}
