::gvLightScreen <- 0
::gvLight <- 0xffffffff
::gvLightTarget <- 0xffffffff

::drawLight <- function(sprite, frame, x, y) {
	if(!config.light) return
	if(gvLightScreen == 0) return
	if(gvLight == 0xffffffff) return

	setDrawTarget(gvLightScreen)
	drawSprite(sprite, frame, x, y)
	setDrawTarget(gvPlayScreen)
}

::drawLightEx <- function(sprite, frame, x, y, a, f, w, h) {
	if(!config.light) return
	if(gvLightScreen == 0) return
	if(gvLight == 0xffffffff) return

	setDrawTarget(gvLightScreen)
	drawSpriteEx(sprite, frame, x, y, a, f, w, h, 1)
	setDrawTarget(gvPlayScreen)
}

::runAmbientLight <- function() {
	if(config.light) {
		if(gvLight != gvLightTarget) {
			//Prevent floats
			gvLight = gvLight.tointeger()
			gvLightTarget = gvLightTarget.tointeger()

			local lr = (gvLight >> 24) & 0xFF
			local lg = (gvLight >> 16) & 0xFF
			local lb = (gvLight >> 8) & 0xFF

			local tr = (gvLightTarget >> 24) & 0xFF
			local tg = (gvLightTarget >> 16) & 0xFF
			local tb = (gvLightTarget >> 8) & 0xFF

			//Fade to color
			if(lr != tr) lr += (tr - lr) / 30.0
			if(abs(lr - tr) < 1) lr = tr
			if(lg != tg) lg += (tg - lg) / 30.0
			if(abs(lg - tg) < 1) lg = tg
			if(lb != tb) lb += (tb - lb) / 30.0
			if(abs(lb - tb) < 1) lb = tb

			gvLight = (ceil(lr) << 24) | (ceil(lg) << 16) | (ceil(lb) << 8) | 0xFF // Last 0xFF is alpha
		}

		setDrawTarget(gvLightScreen)
		setDrawColor(gvLight)
		drawRec(0, 0, screenW(), screenH(), true)
	}
	setDrawTarget(gvScreen)
}

::drawAmbientLight <- function() {
	if(config.light) drawImage(gvLightScreen, 0, 0)
}

::setLight <- function(color) {
	gvLightTarget = color
	gvLight = color
}

::StaticLight <- class extends Actor {
	sprite = 0
	scale = 1.0

	constructor(_x, _y, _arr) {
		base.constructor(_x, _y)

		if(getroottable().rawin(_arr[0])) sprite = getroottable()[_arr[0]]
		else deleteActor(id)
		scale = _arr[1].tofloat()
	}

	function run() {
		if(sprite) drawLightEx(sprite, getFrames() / 4, x - camx, y - camy, 0, 0, scale, scale)
	}
}