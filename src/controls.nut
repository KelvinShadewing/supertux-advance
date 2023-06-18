::gvPadTypes <- ["XBox", "DInput", "Generic"]

::autocon <- { //Has nothing to do with Transformers
	a = {
		up = false
		down = false
		left = false
		right = false
		jump = false
		shoot = false
		spec1 = false
		spec2 = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasSpec1 = false
		wasSpec2 = false
		wasSwapItem = false
	}

	b = {
		up = false
		down = false
		left = false
		right = false
		jump = false
		shoot = false
		spec1 = false
		spec2 = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasSpec1 = false
		wasSpec2 = false
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
		spec1 = false
		spec2 = false
		swapItem = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasSpec1 = false
		wasSpec2 = false
		wasSwapItem = false
}

::getcon <- function(control, state, useauto = false, player = 0) {
	local keyfunc = 0
	local joyfunc = 0
	local hatfunc = 0
	local joy = null
	local autonum = null

	local deadzone = 0
	if(config.stickspeed) deadzone = js_max / 9
	else deadzone = int(js_max * 0.9)

	if(player == 1 || player == 0) {
		joy = clone(config.joy)
		if(gvNumPlayers == 1 || gvGameMode != gmPlay) joy.index = config.joy2.index
		autonum = autocon.a
	}
	if(player == 2) {
		joy = clone(config.joy2)
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
				if(hatfunc(joy.index, js_up) || (state == "hold" && joyY(joy.index) < -deadzone && config.stickactive)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == -1 && config.stickactive) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == -1 && config.stickactive) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.up)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_up) || (state == "hold" && joyY(i) < -deadzone && config.stickactive)) return true
					if(state == "press" && joyAxisPress(i, 1, deadzone) == -1 && config.stickactive) return true
					if(state == "release" && joyAxisRelease(i, 1, deadzone) == -1 && config.stickactive) return true
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
				if(hatfunc(joy.index, js_down) || (state == "hold" && joyY(joy.index) > deadzone)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == 1) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == 1) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.down)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_down) || (state == "hold" && joyY(i) > deadzone)) return true
					if(state == "press" && joyAxisPress(i, 1, deadzone) == 1) return true
					if(state == "release" && joyAxisRelease(i, 1, deadzone) == 1) return true
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
				if(hatfunc(joy.index, js_left) || (state == "hold" && joyX(joy.index) < -deadzone) && config.stickactive) return true
				if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == -1 && config.stickactive) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == -1 && config.stickactive) return true
			}
			if(player == 0) {
				if(keyfunc(config.key.left)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_left) || (state == "hold" && joyX(i) < -deadzone && config.stickactive)) return true
					if(state == "press" && joyAxisPress(i, 1, deadzone) == -1 && config.stickactive) return true
					if(state == "release" && joyAxisRelease(i, 1, deadzone) == -1 && config.stickactive) return true
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
				try{
				if(hatfunc(joy.index, js_right) || (state == "hold" && joyX(joy.index) > deadzone && config.stickactive)) return true
				if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == 1 && config.stickactive) return true
				if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == 1 && config.stickactive) return true
				}
				catch(exception) {
					print(exception)
					print(typeof joy)
				}
			}
			if(player == 0) {
				if(keyfunc(config.key.right)) return true
				for(local i = 0; i < joyCount(); i++) {
					if(hatfunc(i, js_right) || (state == "hold" && joyX(i) > deadzone && config.stickactive)) return true
					if(state == "press" && joyAxisPress(i, 1, deadzone) == 1 && config.stickactive) return true
					if(state == "release" && joyAxisRelease(i, 1, deadzone) == 1 && config.stickactive) return true
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
		case "spec1":
			if(keyfunc(config.key.spec1) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.spec1)) return true
			break
		case "spec2":
			if(keyfunc(config.key.spec2) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.spec2)) return true
			break
		case "pause":
			if(keyfunc(config.key.pause) && (player == 1 || player == 0)) return true
			if(joyfunc(joy.index, joy.pause)) return true
			if(player == 0) {
				if(joyfunc(config.joy.index, config.joy.pause)) return true
				if(joyfunc(config.joy2.index, config.joy2.pause)) return true
			}
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

		local keyname = ""
		switch(newkey) {
			case 0:
				keyname = gvLangObj["controls-menu"]["up-selection"]
				if(keyPressAny() != -1) {
					config.key.up = keyPressAny()
					done = true
				}
				break
			case 1:
				keyname = gvLangObj["controls-menu"]["down-selection"]
				if(keyPressAny() != -1) {
					config.key.down = keyPressAny()
					done = true
				}
				break
			case 2:
				keyname = gvLangObj["controls-menu"]["left-selection"]
				if(keyPressAny() != -1) {
					config.key.left = keyPressAny()
					done = true
				}
				break
			case 3:
				keyname = gvLangObj["controls-menu"]["right-selection"]
				if(keyPressAny() != -1) {
					config.key.right = keyPressAny()
					done = true
				}
				break
			case 4:
				keyname = gvLangObj["controls-menu"]["jump-selection"]
				if(keyPressAny() != -1) {
					config.key.jump = keyPressAny()
					done = true
				}
				break
			case 5:
				keyname = gvLangObj["controls-menu"]["shoot-selection"]
				if(keyPressAny() != -1) {
					config.key.shoot = keyPressAny()
					done = true
				}
				break
			case 6:
				keyname = gvLangObj["controls-menu"]["spec1-selection"]
				if(keyPressAny() != -1) {
					config.key.spec1 = keyPressAny()
					done = true
				}
				break
			case 7:
				keyname = gvLangObj["controls-menu"]["spec2-selection"]
				if(keyPressAny() != -1) {
					config.key.spec2 = keyPressAny()
					done = true
				}
				break
			case 8:
				keyname = gvLangObj["controls-menu"]["pause-selection"]
				if(keyPressAny() != -1) {
					config.key.pause = keyPressAny()
					done = true
				}
				break
			case 9:
				keyname = gvLangObj["controls-menu"]["item-swap-selection"]
				if(keyPressAny() != -1) {
					config.key.swap = keyPressAny()
					done = true
				}
				break
			case 10:
				keyname = gvLangObj["controls-menu"]["menu-accept-selection"]
				if(keyPressAny() != -1) {
					config.key.accept = keyPressAny()
					done = true
				}
				break
			case 11:
				keyname = gvLangObj["controls-menu"]["cam-left-peek-selection"]
				if(keyPressAny() != -1) {
					config.key.leftPeek = keyPressAny()
					done = true
				}
				break
			case 12:
				keyname = gvLangObj["controls-menu"]["cam-right-peek-selection"]
				if(keyPressAny() != -1) {
					config.key.rightPeek = keyPressAny()
					done = true
				}
				break
			case 13:
				keyname = gvLangObj["controls-menu"]["cam-down-peek-selection"]
				if(keyPressAny() != -1) {
					config.key.downPeek = keyPressAny()
					done = true
				}
				break
			case 14:
				keyname = gvLangObj["controls-menu"]["cam-up-peek-selection"]
				if(keyPressAny() != -1) {
					config.key.upPeek = keyPressAny()
					done = true
				}
				break
			default:
				done = true
				break
		}
		local message = format(gvLangObj["controls-menu"]["press-key-for"], keyname)

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

	local deadzone = 0
	if(config.stickspeed) deadzone = js_max / 9
	else deadzone = int(js_max * 0.9)

	while(!done) {
		dbgOceanMoving()

		if(keyPress(k_escape)) done = true
		local keyname = ""
		switch(joystep) {
			case 4:
				keyname = gvLangObj["controls-menu"]["jump-selection"]
				if(keyPress(k_backspace)) {
					joy.jump = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.jump = joyPressAny(0)
					done = true
				}
				break
			case 5:
				keyname = gvLangObj["controls-menu"]["shoot-selection"]
				if(keyPress(k_backspace)) {
					joy.shoot = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.shoot = joyPressAny(0)
					done = true
				}
				break
			case 6:
				keyname = gvLangObj["controls-menu"]["spec1-selection"]
				if(keyPress(k_backspace)) {
					joy.spec1 = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.spec1 = joyPressAny(0)
					done = true
				}
				break
			case 7:
				keyname = gvLangObj["controls-menu"]["spec2-selection"]
				if(keyPress(k_backspace)) {
					joy.spec2 = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.spec2 = joyPressAny(0)
					done = true
				}
				break
			case 8:
				keyname = gvLangObj["controls-menu"]["pause-selection"]
				if(keyPress(k_backspace)) {
					joy.pause = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.pause = joyPressAny(0)
					done = true
				}
				break
			case 9:
				keyname = gvLangObj["controls-menu"]["item-swap-selection"]
				if(keyPress(k_backspace)) {
					joy.swap = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.swap = joyPressAny(0)
					done = true
				}
				break
			case 10:
				keyname = gvLangObj["controls-menu"]["menu-accept-selection"]
				if(keyPress(k_backspace)) {
					joy.accept = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.accept = joyPressAny(0)
					done = true
				}
				break
			case 11:
				keyname = gvLangObj["controls-menu"]["cam-left-peek-selection"]
				if(keyPress(k_backspace)) {
					joy.leftPeek = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.leftPeek = joyPressAny(0)
					done = true
				}
				break
			case 12:
				keyname = gvLangObj["controls-menu"]["cam-right-peek-selection"]
				if(keyPress(k_backspace)) {
					joy.rightPeek = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.rightPeek = joyPressAny(0)
					done = true
				}
				break
			case 13:
				keyname = gvLangObj["controls-menu"]["cam-down-peek-selection"]
				if(keyPress(k_backspace)) {
					joy.downPeek = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.downPeek = joyPressAny(0)
					done = true
				}
				break
			case 14:
				keyname = gvLangObj["controls-menu"]["cam-up-peek-selection"]
				if(keyPress(k_backspace)) {
					joy.upPeek = -1
					done = true
				}
				if(joyPressAny(0) != -1) {
					joy.upPeek = joyPressAny(0)
					done = true
				}
				break
			default:
				done = true
				break
		}
		local message = format(gvLangObj["controls-menu"]["press-button-for"], keyname)
		message += "\n" + gvLangObj["controls-menu"]["clear"]

		setDrawColor(0x00000080)
		drawRec(0, 0, screenW(), 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}

::rebindJoyPeek <- function(axis, player = 0) {
	resetDrawTarget()

	local joy = config.joy
	if(player != 0) joy = config.joy2

	local deadzone = 0
	if(config.stickspeed) deadzone = js_max / 9
	else deadzone = int(js_max * 0.9)

	local message = format(gvLangObj["controls-menu"]["peek-axis"], gvLangObj["controls-menu"][axis == 0 ? "peek-horizontal" : "peek-vertical"])
	local done = false

	update()

	while(!done) {
		if(keyPress(k_escape)) done = true

		for(local i = 0; i < 10; i++) {
			if(abs(joyAxis(joy.index, i)) >= 1000 && abs(joyAxis(joy.index, i)) <= 10000) {
				if(axis == 0) joy.xPeek = i
				else joy.yPeek = i
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

::getConName <- function(control, getkey = true, getjoy = true) {
	local output = ""

	switch(control) {
		case "up":
			if(getkey)
				output += gvLangObj["key"][config.key.up.tostring()]
			if(getjoy)
				output += "(" + chint(30) + ")"
			break
		case "down":
			if(getkey)
				output += gvLangObj["key"][config.key.down.tostring()]
			if(getjoy)
				output += "(" + chint(31) + ")"
			break
		case "left":
			if(getkey)
				output += gvLangObj["key"][config.key.left.tostring()]
			if(getjoy)
				output += "(" + chint(17) + ")"
			break
		case "right":
			if(getkey)
				output += gvLangObj["key"][config.key.right.tostring()]
			if(getjoy)
				output += "(" + chint(16) + ")"
			break
		case "jump":
			if(getkey)
				output += gvLangObj["key"][config.key.jump.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.jump.tostring()]
			break
		case "shoot":
			if(getkey)
				output += gvLangObj["key"][config.key.shoot.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.shoot.tostring()]
			break
		case "spec1":
			if(getkey)
				output += gvLangObj["key"][config.key.spec1.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.spec1.tostring()]
			break
		case "spec2":
			if(getkey)
				output += gvLangObj["key"][config.key.spec2.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.spec2.tostring()]
			break
		case "swap":
			if(getkey)
				output += gvLangObj["key"][config.key.swap.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.swap.tostring()]
			break
		case "pause":
			if(getkey)
				output += gvLangObj["key"][config.key.pause.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.pause.tostring()]
			break
		case "accept":
			if(getkey)
				output += gvLangObj["key"][config.key.accept.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.accept.tostring()]
			break
		case "leftPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.leftPeek.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.leftPeek.tostring()]
			break
		case "rightPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.rightPeek.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.rightPeek.tostring()]
			break
		case "downPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.downPeek.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.downPeek.tostring()]
			break
		case "upPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.upPeek.tostring()]
			if(getjoy)
				output += gvLangObj["joy"][config["joymode"].tolower()][config.joy.upPeek.tostring()]
			break
	}

	return output
}