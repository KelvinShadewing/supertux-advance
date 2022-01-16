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
	if(keyPress(k_5)) game.weapon = 4
	if(keyPress(k_equals)) game.lives++

	//Teleport
	if(gvPlayer && mouseDown(0)) {
		gvPlayer.x = mouseX() + camx
		gvPlayer.y = mouseY() + camy

		if(gvGameMode == gmOverworld) {
			gvPlayer.x = (gvPlayer.x - (gvPlayer.x % 16)) + 8
			gvPlayer.y = (gvPlayer.y - (gvPlayer.y % 16)) + 8
		}
	}

	local message = ""

	if(gvPlayer) {
		message += "X: " + gvPlayer.x + "\n"
		message += "Y: " + gvPlayer.y + "\n"
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

	message += "HSPD: "
	if(gvPlayer) message += gvPlayer.hspeed.tostring()
	message += "\nVSPD: "
	if(gvPlayer) message += gvPlayer.vspeed.tostring()
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

::PolyTest <- class extends Actor {
	path = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		path = _arr[0]
	}

	function run() {
		setDrawColor(0xff0000ff)
		for(local i = 0; i < path.len() - 1; i++) drawLine(path[i][0] - camx, path[i][1] - camy, path[i + 1][0] - camx, path[i + 1][1] - camy)
	}
}