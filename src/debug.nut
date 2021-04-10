::debugMode <- true;
::drawDebug <- function() {
	if(keyPress(k_f12)) debugMode = !debugMode;

	gvFPS = (gvFPS + getFPS()) / 2;

	//If drawing is disabled, exit
	if(!debugMode) return;

	local message = "";

	if(gvPlayer != 0) {
		message += "X: " + gvPlayer.x + "\n";
		message += "Y: " + gvPlayer.y + "\n";
	}

	message += "AFPS: " + gvFPS + "\n";
	message += "RFPS: " + getFPS() + "\n";

	drawText(font, 0, 0, message);
}