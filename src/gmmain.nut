::gmMain <- function()
{
	//TODO: Put main menu here
	drawBG()
	textMenu()
	if(keyPress(k_escape)) gvQuit = true
}
