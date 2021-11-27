::debug <- false
::debugTickIndex <- 0
::debugTickSum <- 0
::debugTickList <- array(64, 0)
::devcom <- false

::drawDebug <- function() {
	if(keyPress(k_f12)) {
		debug = !debug
		//if(debug) foreach(i in actor) print(typeof i)
	}
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

	//Set weapon
	if(keyPress(k_1)) game.weapon = 0
	if(keyPress(k_2)) game.weapon = 1
	if(keyPress(k_3)) game.weapon = 2
	if(keyPress(k_4)) game.weapon = 3
	if(keyPress(k_equals)) game.lives++

	//Teleport
	if(gvPlayer != 0 && mouseDown(0)) {
		gvPlayer.x = mouseX() + camx
		gvPlayer.y = mouseY() + camy

		if(gvGameMode == gmOverworld) {
			gvPlayer.x = (gvPlayer.x - (gvPlayer.x % 16)) + 8
			gvPlayer.y = (gvPlayer.y - (gvPlayer.y % 16)) + 8
		}
	}

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
	drawSprite(sprDebug, getcon("left", "hold").tointeger(), 4, 60)
	drawSprite(sprDebug, getcon("up", "hold").tointeger() + 4, 12, 56)
	drawSprite(sprDebug, getcon("down", "hold").tointeger() + 6, 12, 64)
	drawSprite(sprDebug, getcon("right", "hold").tointeger() + 2, 20, 60)

	drawSprite(sprDebug, getcon("jump", "hold").tointeger() + 8, 4, 72)
	drawSprite(sprDebug, getcon("shoot", "hold").tointeger() + 10, 12, 72)
	drawSprite(sprDebug, getcon("run", "hold").tointeger() + 12, 20, 72)

	message += "HSPD:"
	if(gvPlayer != 0) for(local i = 0; i < abs(round(gvPlayer.hspeed * 2)); i++) message += chint(16)
	message += "\nVSPD:"
	if(gvPlayer != 0) {
		if(gvPlayer.vspeed < 0) for(local i = 0; i < abs(round(gvPlayer.vspeed * 2)); i++) message += chint(30)
		else for(local i = 0; i < abs(round(gvPlayer.vspeed * 2)); i++) message += chint(31)
	}
	message += "\n\n"
	if(gvMap != 0) message += "Map W: " + gvMap.w + "\n"
	if(gvMap != 0) message += "Map H: " + gvMap.h + "\n"
	message += "SRT: " + floor(getTicks() / 1000) + "\n"
	message += "Enemies: " + game.enemies + "\n"
	message += "Secrets: " + game.secrets + "\n"

	drawText(font, 0, 32, message)

	setDrawColor(0xff0000ff)
	drawLine(mouseX() - 8, mouseY(), mouseX() + 8, mouseY())
	drawLine(mouseX(), mouseY() - 8, mouseX(), mouseY() + 8)
}

::debugConsole <- function() {
	setDrawTarget(bgPause)
	drawImage(gvScreen, 0, 0)
	resetDrawTarget()
	update()

	local output = ""
	local history = []
	local input = ""

	while(!keyPress(k_tick) && !keyPress(k_escape)) {
		if(keyPress(k_backspace) && input.len() > 0) input = input.slice(0, -1)
		if(keyPress(k_enter)) {
			dostr(input)
			history.push(input)
			if(history.len() > 15) history.remove(0)
			input = ""
		}
		local newchar = keyString()
		if(newchar != "`") input += newchar

		drawImage(bgPause, 0, 0)
		setDrawColor(0x00000080)
		drawRec(0, 0, screenW(), 8 * 16, true)

		output = ""
		for(local i = 0; i < history.len(); i++) {
			output += history[i]
			output += "\n"
		}
		if(input.len() < 52) output += input
		else output += input.slice(-52)
		if(floor(getFrames() / 32) % 2 == 0) output += "|"
		drawText(font, 0, 0, output)

		update()
	}
}