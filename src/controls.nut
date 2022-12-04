::autocon <- { //Has nothing to do with Transformers
	a = {
		up = false
		down = false
		left = false
		right = false
		jump = false
		shoot = false
		run = false
		sneak = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasRun = false
		wasSneak = false
		wasSwapItem = false
	}

	b = {
		up = false
		down = false
		left = false
		right = false
		jump = false
		shoot = false
		run = false
		sneak = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasRun = false
		wasSneak = false
		wasSwapItem = false
	}
}

::defAutocon <- clone(autocon)

::netconState <- {
		up = false
		down = false
		left = false
		right = false
		jump = false
		shoot = false
		run = false
		sneak = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasRun = false
		wasSneak = false
		wasSwapItem = false
}

::getcon <- function(control, state, useauto = false, player = 0) {
	local keyfunc = 0
	local joyfunc = 0
	local hatfunc = 0
	local joy = null
	local autonum = null

	if(player == 1 || player == 0) {
		joy = config.joy
		autonum = autocon.a
	}
	if(player == 2) {
		joy = config.joy2
		autonum = autocon.b
	}

	switch(state) {
		case "press":
			keyfunc = keyPress
			joyfunc = joyButtonPress
			hatfunc = joyHatPress
			break
		case "release":
			keyfunc = keyRelease
			joyfunc = joyButtonRelease
			hatfunc = joyHatRelease
			break
		case "hold":
			keyfunc = keyDown
			joyfunc = joyButtonDown
			hatfunc = joyHatDown
			break
		default:
			return false
			break
	}

	switch(control) {
		case "up":
			if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.up)) return true
			if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
				if(hatfunc(joy.index, js_up) || (state == "hold" && joyY(joy.index) < -js_max / 10)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, js_max / 20) == -1) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, js_max / 20) == -1) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.up)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_up) || (state == "hold" && joyY(i) < -js_max / 10)) return true
					if(state == "press" && joyAxisPress(i, 1, js_max / 20) == -1) return true
					if(state == "release" && joyAxisRelease(i, 1, js_max / 20) == -1) return true
				}
			}

			if(state == "hold" && useauto) return autonum.up
			if(state == "press" && useauto) return autonum.up && !autonum.wasUp
			if(state == "release" && useauto) return !autonum.up && autonum.wasUp

			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.up) return true
				if(state == "press" && netconState.up && !netconState.wasUp) return true
				if(state == "release" && !netconState.up && netconState.wasUp) return true
			}
			break
		case "down":
			if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.down)) return true
			if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
				if(hatfunc(joy.index, js_down) || (state == "hold" && joyY(joy.index) > js_max / 10)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, js_max / 20) == 1) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, js_max / 20) == 1) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.down)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_down) || (state == "hold" && joyY(i) > js_max / 10)) return true
					if(state == "press" && joyAxisPress(i, 1, js_max / 20) == 1) return true
					if(state == "release" && joyAxisRelease(i, 1, js_max / 20) == 1) return true
				}
			}

			if(state == "hold" && useauto) return autonum.down
			if(state == "press" && useauto) return autonum.down && !autonum.wasDown
			if(state == "release" && useauto) return !autonum.down && autonum.wasDown

			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.down) return true
				if(state == "press" && netconState.down && !netconState.wasDown) return true
				if(state == "release" && !netconState.down && netconState.wasDown) return true
			}
			break
		case "left":
			if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.left)) return true
			if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
				if(hatfunc(joy.index, js_left) || (state == "hold" && joyX(joy.index) < -js_max / 10)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, js_max / 20) == -1) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, js_max / 20) == -1) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.left)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_left) || (state == "hold" && joyX(i) < -js_max / 10)) return true
					if(state == "press" && joyAxisPress(i, 1, js_max / 20) == -1) return true
					if(state == "release" && joyAxisRelease(i, 1, js_max / 20) == -1) return true
				}
			}

			if(state == "hold" && useauto) return autonum.left
			if(state == "press" && useauto) return autonum.left && !autonum.wasUp
			if(state == "release" && useauto) return !autonum.left && autonum.wasUp

			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.left) return true
				if(state == "press" && netconState.left && !netconState.wasUp) return true
				if(state == "release" && !netconState.left && netconState.wasUp) return true
			}
			break
		case "right":
			if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.right)) return true
			if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
				if(hatfunc(joy.index, js_right) || (state == "hold" && joyX(joy.index) > js_max / 10)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, js_max / 20) == 1) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, js_max / 20) == 1) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.right)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_right) || (state == "hold" && joyX(i) > js_max / 10)) return true
					if(state == "press" && joyAxisPress(i, 1, js_max / 20) == 1) return true
					if(state == "release" && joyAxisRelease(i, 1, js_max / 20) == 1) return true
				}
			}

			if(state == "hold" && useauto) return autonum.right
			if(state == "press" && useauto) return autonum.right && !autonum.wasUp
			if(state == "release" && useauto) return !autonum.right && autonum.wasUp

			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.right) return true
				if(state == "press" && netconState.right && !netconState.wasUp) return true
				if(state == "release" && !netconState.right && netconState.wasUp) return true
			}
			break
		case "jump":
			if(keyfunc(config.key.jump) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.jump)) return true
			break
		case "shoot":
			if(keyfunc(config.key.shoot) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.shoot)) return true
			break
		case "run":
			if(config.autorun) {
				if(!keyfunc(config.key.run) && (player == 1 || player == 0)) return true
				if(!joyfunc(joy.index, joy.run)) return true
			}
			else {
				if(keyfunc(config.key.run) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.run)) return true
			}
			break
		case "sneak":
			if(keyfunc(config.key.sneak) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.sneak)) return true
			break
		case "pause":
			if(keyfunc(config.key.pause) && (player == 1 || player == 0)) return true
			if( joyfunc(joy.index, joy.pause)) return true
			break
		case "swap":
			if(keyfunc(config.key.swap) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.swap)) return true
			break
		case "accept":
			if(keyfunc(config.key.accept) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.accept)) return true
			break
		case "leftPeek":
			if(keyfunc(config.key.leftPeek) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.leftPeek)) return true
			break
		case "rightPeek":
			if(keyfunc(config.key.rightPeek) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.rightPeek)) return true
			break
		case "downPeek":
			if(keyfunc(config.key.downPeek) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.downPeek)) return true
			break
		case "upPeek":
			if(keyfunc(config.key.upPeek) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.upPeek)) return true
			break
	}

	return false
}

::rebindKeys <- function(newkey) {
	resetDrawTarget()
	local done = false

	update()

	while(!done) {
		dbgOceanMoving()

		local message = gvLangObj["controls-menu"]["press-key-for"] + " "
		switch(newkey) {
			case 0:
				message += gvLangObj["controls-menu"]["up"]
				if(anyKeyPress() != -1) {
					config.key.up = anyKeyPress()
					done = true
				}
				break
			case 1:
				message += gvLangObj["controls-menu"]["down"]
				if(anyKeyPress() != -1) {
					config.key.down = anyKeyPress()
					done = true
				}
				break
			case 2:
				message += gvLangObj["controls-menu"]["left"]
				if(anyKeyPress() != -1) {
					config.key.left = anyKeyPress()
					done = true
				}
				break
			case 3:
				message += gvLangObj["controls-menu"]["right"]
				if(anyKeyPress() != -1) {
					config.key.right = anyKeyPress()
					done = true
				}
				break
			case 4:
				message += gvLangObj["controls-menu"]["jump"]
				if(anyKeyPress() != -1) {
					config.key.jump = anyKeyPress()
					done = true
				}
				break
			case 5:
				message += gvLangObj["controls-menu"]["shoot"]
				if(anyKeyPress() != -1) {
					config.key.shoot = anyKeyPress()
					done = true
				}
				break
			case 6:
				message += gvLangObj["controls-menu"]["run"]
				if(anyKeyPress() != -1) {
					config.key.run = anyKeyPress()
					done = true
				}
				break
			case 7:
				message += gvLangObj["controls-menu"]["sneak"]
				if(anyKeyPress() != -1) {
					config.key.sneak = anyKeyPress()
					done = true
				}
				break
			case 8:
				message += gvLangObj["controls-menu"]["pause"]
				if(anyKeyPress() != -1) {
					config.key.pause = anyKeyPress()
					done = true
				}
				break
			case 9:
				message += gvLangObj["controls-menu"]["item-swap"]
				if(anyKeyPress() != -1) {
					config.key.swap = anyKeyPress()
					done = true
				}
				break
			case 10:
				message += gvLangObj["controls-menu"]["menu-accept"]
				if(anyKeyPress() != -1) {
					config.key.accept = anyKeyPress()
					done = true
				}
				break
			case 11:
				message += gvLangObj["controls-menu"]["cam-left-peek"]
				if(anyKeyPress() != -1) {
					config.key.leftPeek = anyKeyPress()
					done = true
				}
				break
			case 12:
				message += gvLangObj["controls-menu"]["cam-right-peek"]
				if(anyKeyPress() != -1) {
					config.key.rightPeek = anyKeyPress()
					done = true
				}
				break
			case 13:
				message += gvLangObj["controls-menu"]["cam-down-peek"]
				if(anyKeyPress() != -1) {
					config.key.downPeek = anyKeyPress()
					done = true
				}
				break
			case 14:
				message += gvLangObj["controls-menu"]["cam-up-peek"]
				if(anyKeyPress() != -1) {
					config.key.upPeek = anyKeyPress()
					done = true
				}
				break
			default:
				done = true
				break
		}
		message += "..."

		setDrawColor(0x00000080)
		drawRec(0, 0, screenW(), 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}

::rebindGamepad <- function(joystep, joypad = 0) {
	resetDrawTarget()
	local done = false

	update()

	local joy = null
	if(joypad == 0) joy = config.joy
	if(joypad == 1) joy = config.joy2
	if(joy == null) return

	while(!done) {
		dbgOceanMoving()

		if(keyPress(k_escape)) done = true
		local message = gvLangObj["controls-menu"]["press-button-for"] + " "
		switch(joystep) {
			case 4:
				message += gvLangObj["controls-menu"]["jump"]
				if(keyPress(k_backspace)) {
					joy.jump = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.jump = anyJoyPress(0)
					done = true
				}
				break
			case 5:
				message += gvLangObj["controls-menu"]["shoot"]
				if(keyPress(k_backspace)) {
					joy.shoot = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.shoot = anyJoyPress(0)
					done = true
				}
				break
			case 6:
				message += gvLangObj["controls-menu"]["run"]
				if(keyPress(k_backspace)) {
					joy.run = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.run = anyJoyPress(0)
					done = true
				}
				break
			case 7:
				message += gvLangObj["controls-menu"]["sneak"]
				if(keyPress(k_backspace)) {
					joy.sneak = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.sneak = anyJoyPress(0)
					done = true
				}
				break
			case 8:
				message += gvLangObj["controls-menu"]["pause"]
				if(keyPress(k_backspace)) {
					joy.pause = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.pause = anyJoyPress(0)
					done = true
				}
				break
			case 9:
				message += gvLangObj["controls-menu"]["item-swap"]
				if(keyPress(k_backspace)) {
					joy.swap = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.swap = anyJoyPress(0)
					done = true
				}
				break
			case 10:
				message += gvLangObj["controls-menu"]["menu-accept"]
				if(keyPress(k_backspace)) {
					joy.accept = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.accept = anyJoyPress(0)
					done = true
				}
				break
			case 11:
				message += gvLangObj["controls-menu"]["cam-left-peek"]
				if(keyPress(k_backspace)) {
					joy.leftPeek = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.leftPeek = anyJoyPress(0)
					done = true
				}
				break
			case 12:
				message += gvLangObj["controls-menu"]["cam-right-peek"]
				if(keyPress(k_backspace)) {
					joy.rightPeek = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.rightPeek = anyJoyPress(0)
					done = true
				}
				break
			case 13:
				message += gvLangObj["controls-menu"]["cam-down-peek"]
				if(keyPress(k_backspace)) {
					joy.downPeek = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.downPeek = anyJoyPress(0)
					done = true
				}
				break
			case 14:
				message += gvLangObj["controls-menu"]["cam-up-peek"]
				if(keyPress(k_backspace)) {
					joy.upPeek = -1
					done = true
				}
				if(anyJoyPress(0) != -1) {
					joy.upPeek = anyJoyPress(0)
					done = true
				}
				break
			default:
				done = true
				break
		}
		message += "...\n" + gvLangObj["controls-menu"]["clear"]

		setDrawColor(0x00000080)
		drawRec(0, 0, screenW(), 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}

::rebindJoyPeek <- function(axis) {
	resetDrawTarget()

	local message = gvLangObj["controls-menu"]["peek-axis"]
	if(axis == 0) message += gvLangObj["controls-menu"]["peek-horizontal"]
	else message += gvLangObj["controls-menu"]["peek-vertical"]
	local done = false

	update()

	while(!done) {
		if(keyPress(k_escape)) done = true

		for(local i = 0; i < 10; i++) {
			if(abs(joyAxis(0, i)) >= 1000 && abs(joyAxis(0, i)) <= 10000) {
				if(axis == 0) config.joy.xPeek = i
				else config.joy.yPeek = i
				done = true
				break
			}
		}

		dbgOceanMoving()
		setDrawColor(0x00000080)
		drawRec(0, 0, screenW(), 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}