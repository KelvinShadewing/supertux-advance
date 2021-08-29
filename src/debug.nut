::debug <- false
::debugTickIndex <- 0
::debugTickSum <- 0
::debugTickList <- array(64, 0)
::devcom <- false

::drawDebug <- function() {
	if(keyPress(k_f12)) debug = !debug
	if(keyPress(k_f1)) devcom = !devcom

	local fps = getFPS()
	debugTickSum -= debugTickList[debugTickIndex]
	debugTickSum += fps
	debugTickList[debugTickIndex] = fps
	debugTickIndex++
	if(debugTickIndex == 64) debugTickIndex = 0
	fps = debugTickSum / 64

	//If drawing is disabled, exit
	if(!debug) return

	local message = ""

	if(gvPlayer != 0) {
		message += "X: " + floor(gvPlayer.x) + "\n"
		message += "Y: " + floor(gvPlayer.y) + "\n"
	}
	else {
		message += "X: YOU'RE\nY:  DEAD\n"
	}

	message += "FPS: " + round(fps) + " (" + getFPS() + ")\n\n\n\n"

	//Debug keys
	drawSprite(sprDebug, keyDown(config.key.left).tointeger(), 4, 60)
	drawSprite(sprDebug, keyDown(config.key.up).tointeger() + 4, 12, 56)
	drawSprite(sprDebug, keyDown(config.key.down).tointeger() + 6, 12, 64)
	drawSprite(sprDebug, keyDown(config.key.right).tointeger() + 2, 20, 60)

	drawSprite(sprDebug, keyDown(config.key.jump).tointeger() + 8, 4, 72)
	drawSprite(sprDebug, keyDown(config.key.shoot).tointeger() + 10, 12, 72)
	drawSprite(sprDebug, keyDown(config.key.run).tointeger() + 12, 20, 72)

	message += "HSPD:"
	if(gvPlayer != 0) for(local i = 0; i < abs(round(gvPlayer.hspeed * 2)); i++) message += chint(16)
	message += "\nVSPD:"
	if(gvPlayer != 0) {
		if(gvPlayer.vspeed < 0) for(local i = 0; i < abs(round(gvPlayer.vspeed * 2)); i++) message += chint(30)
		else for(local i = 0; i < abs(round(gvPlayer.vspeed * 2)); i++) message += chint(31)
	}
	message += "\n\n"
	message += "Map W: " + gvMap.w + "\n"
	message += "Map H: " + gvMap.h + "\n"
	message += "SRT: " + floor(getTicks() / 1000) + "\n"
	message += "Map: " + gvMap.name + "\n"



	drawText(font, 0, 32, message)
}
