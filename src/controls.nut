::gvPadTypes <- ["XBox", "DInput", "Generic"]
::gvAutoCon <- false

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
		swap = false
		accept = false
		peekLeft = false
		peekRight = false
		peekUp = false
		downPeek = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasSpec1 = false
		wasSpec2 = false
		wasSwap = false
		wasAccept = false
		wasPeekLeft = false
		wasPeekRight = false
		wasPeekUp = false
		wasDownPeek = false

		pressUp = false
		pressDown = false
		pressLeft = false
		pressRight = false
		pressJump = false
		pressShoot = false
		pressSpec1 = false
		pressSpec2 = false
		pressSwap = false
		pressAccept = false
		pressPeekLeft = false
		pressPeekRight = false
		pressPeekUp = false
		pressDownPeek = false

		releaseUp = false
		releaseDown = false
		releaseLeft = false
		releaseRight = false
		releaseJump = false
		releaseShoot = false
		releaseSpec1 = false
		releaseSpec2 = false
		releaseSwap = false
		releaseAccept = false
		releasePeekLeft = false
		releasePeekRight = false
		releasePeekUp = false
		releaseDownPeek = false
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
		swap = false
		accept = false
		peekLeft = false
		peekRight = false
		peekUp = false
		downPeek = false

		wasUp = false
		wasDown = false
		wasLeft = false
		wasRight = false
		wasJump = false
		wasShoot = false
		wasSpec1 = false
		wasSpec2 = false
		wasSwap = false
		wasAccept = false
		wasPeekLeft = false
		wasPeekRight = false
		wasPeekUp = false
		wasDownPeek = false

		pressUp = false
		pressDown = false
		pressLeft = false
		pressRight = false
		pressJump = false
		pressShoot = false
		pressSpec1 = false
		pressSpec2 = false
		pressSwap = false
		pressAccept = false
		pressPeekLeft = false
		pressPeekRight = false
		pressPeekUp = false
		pressDownPeek = false

		releaseUp = false
		releaseDown = false
		releaseLeft = false
		releaseRight = false
		releaseJump = false
		releaseShoot = false
		releaseSpec1 = false
		releaseSpec2 = false
		releaseSwap = false
		releaseAccept = false
		releasePeekLeft = false
		releasePeekRight = false
		releasePeekUp = false
		releaseDownPeek = false
	}
}

::updateAutocon <- function() {
	autocon.a.pressLeft = autocon.a.left && !autocon.a.wasLeft
	autocon.a.releaseLeft = !autocon.a.left && autocon.a.wasLeft
	autocon.a.wasLeft = autocon.a.left
	autocon.a.pressRight = autocon.a.right && !autocon.a.wasRight
	autocon.a.releaseRight = !autocon.a.right && autocon.a.wasRight
	autocon.a.wasRight = autocon.a.right
	autocon.a.pressUp = autocon.a.up && !autocon.a.wasUp
	autocon.a.releaseUp = !autocon.a.up && autocon.a.wasUp
	autocon.a.wasUp = autocon.a.up
	autocon.a.pressDown = autocon.a.down && !autocon.a.wasDown
	autocon.a.releaseDown = !autocon.a.down && autocon.a.wasDown
	autocon.a.wasDown = autocon.a.down
	autocon.a.pressJump = autocon.a.jump && !autocon.a.wasJump
	autocon.a.releaseJump = !autocon.a.jump && autocon.a.wasJump
	autocon.a.wasJump = autocon.a.jump
	autocon.a.pressShoot = autocon.a.shoot && !autocon.a.wasShoot
	autocon.a.releaseShoot = !autocon.a.shoot && autocon.a.wasShoot
	autocon.a.wasShoot = autocon.a.shoot
	autocon.a.pressSpec1 = autocon.a.spec1 && !autocon.a.wasSpec1
	autocon.a.releaseSpec1 = !autocon.a.spec1 && autocon.a.wasSpec1
	autocon.a.wasSpec1 = autocon.a.spec1
	autocon.a.pressSpec2 = autocon.a.spec2 && !autocon.a.wasSpec2
	autocon.a.releaseSpec2 = !autocon.a.spec2 && autocon.a.wasSpec2
	autocon.a.wasSpec2 = autocon.a.spec2
	autocon.a.pressSwap = autocon.a.swap && !autocon.a.wasSwap
	autocon.a.releaseSwap = !autocon.a.swap && autocon.a.wasSwap
	autocon.a.wasSwap = autocon.a.swap
	autocon.a.pressAccept = autocon.a.accept && !autocon.a.wasAccept
	autocon.a.releaseAccept = !autocon.a.accept && autocon.a.wasAccept
	autocon.a.wasAccept = autocon.a.accept
	autocon.a.pressPeekLeft = autocon.a.peekLeft && !autocon.a.wasPeekLeft
	autocon.a.releasePeekLeft = !autocon.a.peekLeft && autocon.a.wasPeekLeft
	autocon.a.wasPeekLeft = autocon.a.peekLeft
	autocon.a.pressPeekRight = autocon.a.peekRight && !autocon.a.wasPeekRight
	autocon.a.releasePeekRight = !autocon.a.peekRight && autocon.a.wasPeekRight
	autocon.a.wasPeekRight = autocon.a.peekRight
	autocon.a.pressDownPeek = autocon.a.downPeek && !autocon.a.wasDownPeek
	autocon.a.releaseDownPeek = !autocon.a.downPeek && autocon.a.wasDownPeek
	autocon.a.wasDownPeek = autocon.a.downPeek
	autocon.a.pressPeekUp = autocon.a.peekUp && !autocon.a.wasPeekUp
	autocon.a.releasePeekUp = !autocon.a.peekUp && autocon.a.wasPeekUp
	autocon.a.wasPeekUp = autocon.a.peekUp

	autocon.b.pressLeft = autocon.b.left && !autocon.b.wasLeft
	autocon.b.releaseLeft = !autocon.b.left && autocon.b.wasLeft
	autocon.b.wasLeft = autocon.b.left
	autocon.b.pressRight = autocon.b.right && !autocon.b.wasRight
	autocon.b.releaseRight = !autocon.b.right && autocon.b.wasRight
	autocon.b.wasRight = autocon.b.right
	autocon.b.pressUp = autocon.b.up && !autocon.b.wasUp
	autocon.b.releaseUp = !autocon.b.up && autocon.b.wasUp
	autocon.b.wasUp = autocon.b.up
	autocon.b.pressDown = autocon.b.down && !autocon.b.wasDown
	autocon.b.releaseDown = !autocon.b.down && autocon.b.wasDown
	autocon.b.wasDown = autocon.b.down
	autocon.b.pressJump = autocon.b.jump && !autocon.b.wasJump
	autocon.b.releaseJump = !autocon.b.jump && autocon.b.wasJump
	autocon.b.wasJump = autocon.b.jump
	autocon.b.pressShoot = autocon.b.shoot && !autocon.b.wasShoot
	autocon.b.releaseShoot = !autocon.b.shoot && autocon.b.wasShoot
	autocon.b.wasShoot = autocon.b.shoot
	autocon.b.pressSpec1 = autocon.b.spec1 && !autocon.b.wasSpec1
	autocon.b.releaseSpec1 = !autocon.b.spec1 && autocon.b.wasSpec1
	autocon.b.wasSpec1 = autocon.b.spec1
	autocon.b.pressSpec2 = autocon.b.spec2 && !autocon.b.wasSpec2
	autocon.b.releaseSpec2 = !autocon.b.spec2 && autocon.b.wasSpec2
	autocon.b.wasSpec2 = autocon.b.spec2
	autocon.b.pressSwap = autocon.b.swap && !autocon.b.wasSwap
	autocon.b.releaseSwap = !autocon.b.swap && autocon.b.wasSwap
	autocon.b.wasSwap = autocon.b.swap
	autocon.b.pressAccept = autocon.b.accept && !autocon.b.wasAccept
	autocon.b.releaseAccept = !autocon.b.accept && autocon.b.wasAccept
	autocon.b.wasAccept = autocon.b.accept
	autocon.b.pressPeekLeft = autocon.b.peekLeft && !autocon.b.wasPeekLeft
	autocon.b.releasePeekLeft = !autocon.b.peekLeft && autocon.b.wasPeekLeft
	autocon.b.wasPeekLeft = autocon.b.peekLeft
	autocon.b.pressPeekRight = autocon.b.peekRight && !autocon.b.wasPeekRight
	autocon.b.releasePeekRight = !autocon.b.peekRight && autocon.b.wasPeekRight
	autocon.b.wasPeekRight = autocon.b.peekRight
	autocon.b.pressDownPeek = autocon.b.downPeek && !autocon.b.wasDownPeek
	autocon.b.releaseDownPeek = !autocon.b.downPeek && autocon.b.wasDownPeek
	autocon.b.wasDownPeek = autocon.b.downPeek
	autocon.b.pressPeekUp = autocon.b.peekUp && !autocon.b.wasPeekUp
	autocon.b.releasePeekUp = !autocon.b.peekUp && autocon.b.wasPeekUp
	autocon.b.wasPeekUp = autocon.b.peekUp
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
			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.up)
					return true
				if(state == "press" && netconState.up && !netconState.wasUp)
					return true
				if(state == "release" && !netconState.up && netconState.wasUp)
					return true
			}
			else if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.up
				if(state == "press")
					return autonum.pressUp
				if(state == "release")
					return !autonum.releaseUp
			}
			else {
				if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.up))
					return true

				if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
					if(hatfunc(joy.index, js_up) || (state == "hold" && joyY(joy.index) < -deadzone && config.stickactive))
						return true
					if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == -1 && config.stickactive)
						return true
					if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == -1 && config.stickactive)
						return true
				}

				if(player == 0) {
					if(keyfunc(config.key.up))
						return true
					for(local i = 0; i < joyCount(); i++) {
						if(hatfunc(i, js_up) || (state == "hold" && joyY(i) < -deadzone && config.stickactive))
							return true
						if(state == "press" && joyAxisPress(i, 1, deadzone) == -1 && config.stickactive)
							return true
						if(state == "release" && joyAxisRelease(i, 1, deadzone) == -1 && config.stickactive)
							return true
					}
				}
			}
			break

		case "down":
			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.down)
					return true
				if(state == "press" && netconState.down && !netconState.wasDown)
					return true
				if(state == "release" && !netconState.down && netconState.wasDown)
					return true
			}
			else if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.down
				if(state == "press")
					return autonum.pressDown
				if(state == "release")
					return !autonum.releaseDown
			}
			else {
				if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.down))
					return true

				if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
					if(hatfunc(joy.index, js_down) || (state == "hold" && joyY(joy.index) < -deadzone && config.stickactive))
						return true
					if(state == "press" && joyAxisPress(joy.index, 1, deadzone) == 1 && config.stickactive)
						return true
					if(state == "release" && joyAxisRelease(joy.index, 1, deadzone) == 1 && config.stickactive)
						return true
				}

				if(player == 0) {
					if(keyfunc(config.key.down))
						return true
					for(local i = 0; i < joyCount(); i++) {
						if(hatfunc(i, js_down) || (state == "hold" && joyY(i) < -deadzone && config.stickactive))
							return true
						if(state == "press" && joyAxisPress(i, 1, deadzone) == -1 && config.stickactive)
							return true
						if(state == "release" && joyAxisRelease(i, 1, deadzone) == -1 && config.stickactive)
							return true
					}
				}
			}
			break
		case "left":
			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.left)
					return true
				if(state == "press" && netconState.left && !netconState.wasLeft)
					return true
				if(state == "release" && !netconState.left && netconState.wasLeft)
					return true
			}
			else if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.left
				if(state == "press")
					return autonum.pressLeft
				if(state == "release")
					return !autonum.releaseLeft
			}
			else {
				if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.left))
					return true

				if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
					if(hatfunc(joy.index, js_left) || (state == "hold" && joyX(joy.index) < -deadzone && config.stickactive))
						return true
					if(state == "press" && joyAxisPress(joy.index, 0, deadzone) == -1 && config.stickactive)
						return true
					if(state == "release" && joyAxisRelease(joy.index, 0, deadzone) == -1 && config.stickactive)
						return true
				}

				if(player == 0) {
					if(keyfunc(config.key.left))
						return true
					for(local i = 0; i < joyCount(); i++) {
						if(hatfunc(i, js_left) || (state == "hold" && joyX(i) < -deadzone && config.stickactive))
							return true
						if(state == "press" && joyAxisPress(i, 0, deadzone) == -1 && config.stickactive)
							return true
						if(state == "release" && joyAxisRelease(i, 0, deadzone) == -1 && config.stickactive)
							return true
					}
				}
			}
			break
		case "right":
			if(player == 2 && gvNetPlay) {
				if(state == "hold" && netconState.right)
					return true
				if(state == "press" && netconState.right && !netconState.wasRight)
					return true
				if(state == "release" && !netconState.right && netconState.wasRight)
					return true
			}
			else if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.right
				if(state == "press")
					return autonum.pressRight
				if(state == "release")
					return !autonum.releaseRight
			}
			else {
				if(player == 1 || gvNumPlayers == 1) if(keyfunc(config.key.right))
					return true

				if(player == 2 || gvNumPlayers == 1 || joyCount() > 1) {
					if(hatfunc(joy.index, js_right) || (state == "hold" && joyX(joy.index) < -deadzone && config.stickactive))
						return true
					if(state == "press" && joyAxisPress(joy.index, 0, deadzone) == 1 && config.stickactive)
						return true
					if(state == "release" && joyAxisRelease(joy.index, 0, deadzone) == 1 && config.stickactive)
						return true
				}

				if(player == 0) {
					if(keyfunc(config.key.right))
						return true
					for(local i = 0; i < joyCount(); i++) {
						if(hatfunc(i, js_right) || (state == "hold" && joyX(i) < -deadzone && config.stickactive))
							return true
						if(state == "press" && joyAxisPress(i, 0, deadzone) == 1 && config.stickactive)
							return true
						if(state == "release" && joyAxisRelease(i, 0, deadzone) == 1 && config.stickactive)
							return true
					}
				}
			}
			break
		case "jump":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.jump
				if(state == "press")
					return autonum.pressJump
				if(state == "release")
					return !autonum.releaseJump
			}
			else {
				if(keyfunc(config.key.jump) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.jump)) return true
			}
			break
		case "shoot":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.shoot
				if(state == "press")
					return autonum.pressShoot
				if(state == "release")
					return !autonum.releaseShoot
			}
			else {
				if(keyfunc(config.key.shoot) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.shoot)) return true
			}
			break
		case "spec1":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.spec1
				if(state == "press")
					return autonum.spec1 && !autonum.wasSpec1
				if(state == "release")
					return !autonum.releaseSpec1
			}
			else {
				if(keyfunc(config.key.spec1) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.spec1)) return true
			}
			break
		case "spec2":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.spec2
				if(state == "press")
					return autonum.pressSpec2
				if(state == "release")
					return !autonum.releaseSpec2
			}
			else {
				if(keyfunc(config.key.spec2) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.spec2)) return true
			}
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
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.swap
				if(state == "press")
					return autonum.pressSwap
				if(state == "release")
					return !autonum.releaseSwap
			}
			else {
				if(keyfunc(config.key.swap) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.swap)) return true
			}
			break
		case "accept":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.accept
				if(state == "press")
					return autonum.pressAccept
				if(state == "release")
					return !autonum.releaseAccept
			}
			else {
				if(keyfunc(config.key.accept) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.accept)) return true
			}
			break
		case "leftPeek":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.leftPeek
				if(state == "press")
					return autonum.pressLeftPeek
				if(state == "release")
					return !autonum.releaseLeftPeek
			}
			else {
				if(keyfunc(config.key.leftPeek) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.leftPeek)) return true
			}
			break
		case "rightPeek":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.rightPeek
				if(state == "press")
					return autonum.pressRightPeek
				if(state == "release")
					return !autonum.releaseRightPeek
			}
			else {
				if(keyfunc(config.key.rightPeek) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.rightPeek)) return true
			}
			break
		case "downPeek":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.downPeek
				if(state == "press")
					return autonum.pressDownPeek
				if(state == "release")
					return !autonum.releaseDownPeek
			}
			else {
				if(keyfunc(config.key.downPeek) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.downPeek)) return true
			}
			break
		case "upPeek":
			if(gvAutoCon && useauto) {
				if(state == "hold")
					return autonum.upPeek
				if(state == "press")
					return autonum.pressUpPeek
				if(state == "release")
					return !autonum.releaseUpPeek
			}
			else {
				if(keyfunc(config.key.upPeek) && (player == 1 || player == 0)) return true
				if(joyfunc(joy.index, joy.upPeek)) return true
			}
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
			if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.jump.tostring() in map) {
					output += map[config.joy.jump.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "shoot":
			if(getkey)
				output += gvLangObj["key"][config.key.shoot.tostring()]
			if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.shoot.tostring() in map) {
					output += map[config.joy.shoot.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "spec1":
			if(getkey)
				output += gvLangObj["key"][config.key.spec1.tostring()]
			if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.spec1.tostring() in map) {
					output += map[config.joy.spec1.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "spec2":
			if(getkey)
				output += gvLangObj["key"][config.key.spec2.tostring()]
			if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.spec2.tostring() in map) {
					output += map[config.joy.spec2.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "swap":
			if(getkey)
				output += gvLangObj["key"][config.key.swap.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.swap.tostring() in map) {
					output += map[config.joy.swap.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "pause":
			if(getkey)
				output += gvLangObj["key"][config.key.pause.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.pause.tostring() in map) {
					output += map[config.joy.pause.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "accept":
			if(getkey)
				output += gvLangObj["key"][config.key.accept.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.accept.tostring() in map) {
					output += map[config.joy.accept.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "leftPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.leftPeek.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.leftPeek.tostring() in map) {
					output += map[config.joy.leftPeek.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "rightPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.rightPeek.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.rightPeek.tostring() in map) {
					output += map[config.joy.rightPeek.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "downPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.downPeek.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.downPeek.tostring() in map) {
					output += map[config.joy.downPeek.tostring()]
				} else {
					output += "???"
				}
			}
			break
		case "upPeek":
			if(getkey)
				output += gvLangObj["key"][config.key.upPeek.tostring()]
						if(getjoy) {
				local map = gvLangObj["joy"][config["joymode"].tolower()]
				if(config.joy.upPeek.tostring() in map) {
					output += map[config.joy.upPeek.tostring()]
				} else {
					output += "???"
				}
			}
			break
	}

	return output
}