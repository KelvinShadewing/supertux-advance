::getcon <- function(control, state) {
	local keyfunc = 0
	local joyfunc = 0
	local hatfunc = 0

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
			if(keyfunc(config.key.up) || hatfunc(0, js_up) || joyY(0) < -js_max / 10) return true
			break
		case "down":
			if(keyfunc(config.key.down) || hatfunc(0, js_down) || joyY(0) > js_max / 10) return true
			break
		case "left":
			if(keyfunc(config.key.left) || hatfunc(0, js_left) || joyX(0) < -js_max / 10) return true
			break
		case "right":
			if(keyfunc(config.key.right) || hatfunc(0, js_right) || joyX(0) > js_max / 10) return true
			break
		case "jump":
			if(keyfunc(config.key.jump) || joyfunc(0, config.joy.jump)) return true
			break
		case "shoot":
			if(keyfunc(config.key.shoot) || joyfunc(0, config.joy.shoot)) return true
			break
		case "run":
			if(keyfunc(config.key.run) || joyfunc(0, config.joy.run)) return true
			break
		case "sneak":
			if(keyfunc(config.key.sneak) || joyfunc(0, config.joy.sneak)) return true
			break
		case "pause":
			if(keyfunc(config.key.pause) || joyfunc(0, config.joy.pause)) return true
			break
	}

	return false
}