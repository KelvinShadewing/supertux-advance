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
	message += "RFPS: " + getFPS() + "\n\n\n\n";

	//Debug keys
	drawSprite(sprDebug, keyDown(config.key.left).tointeger(), 4, 36);
	drawSprite(sprDebug, keyDown(config.key.up).tointeger() + 4, 12, 32);
	drawSprite(sprDebug, keyDown(config.key.down).tointeger() + 6, 12, 40);
	drawSprite(sprDebug, keyDown(config.key.right).tointeger() + 2, 20, 36);

	drawSprite(sprDebug, keyDown(config.key.jump).tointeger() + 8, 4, 48);
	drawSprite(sprDebug, keyDown(config.key.shoot).tointeger() + 10, 12, 48);
	drawSprite(sprDebug, keyDown(config.key.run).tointeger() + 12, 20, 48);

	message += "SPD:"
	if(gvPlayer != 0) for(local i = 0; i < abs(round(gvPlayer.hspeed)); i++) message += chint(16);
	message += "\n\n";
	message += "Map W: " + gvMap.w + "\n";
	message += "Map H: " + gvMap.h + "\n";

	drawText(font, 0, 0, message);
}