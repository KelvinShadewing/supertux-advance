::debug <- true
::debugTickIndex <- 0
::debugTickSum <- 0
::debugTickList <- array(64, 0)

::drawDebug <- function() {
	if(keyPress(k_f12)) debug = !debug

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

	message += "FPS: " + floor(fps) + " (" + getFPS() + ")\n\n\n\n"

	//Debug keys
	drawSprite(sprDebug, keyDown(config.key.left).tointeger(), 4, 28)
	drawSprite(sprDebug, keyDown(config.key.up).tointeger() + 4, 12, 24)
	drawSprite(sprDebug, keyDown(config.key.down).tointeger() + 6, 12, 32)
	drawSprite(sprDebug, keyDown(config.key.right).tointeger() + 2, 20, 28)

	drawSprite(sprDebug, keyDown(config.key.jump).tointeger() + 8, 4, 40)
	drawSprite(sprDebug, keyDown(config.key.shoot).tointeger() + 10, 12, 40)
	drawSprite(sprDebug, keyDown(config.key.run).tointeger() + 12, 20, 40)

	message += "SPD:"
	if(gvPlayer != 0) for(local i = 0; i < abs(round(gvPlayer.hspeed)); i++) message += chint(16)
	message += "\n\n"
	message += "Map W: " + gvMap.w + "\n"
	message += "Map H: " + gvMap.h + "\n"
	message += "SRT: " + floor(getTicks() / 1000) + "\n"



	drawText(font, 0, 0, message)
}
