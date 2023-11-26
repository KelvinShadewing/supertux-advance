::gvLightScreen <- 0
::gvLightScreen1 <- 0
::gvLightScreen2 <- 0
::gvLight <- 0xffffffff
::gvLightTarget <- 0xffffffff
::gvLight2 <- 0xffffffff
::gvLightTarget2 <- 0xffffffff

::drawLight <- function(sprite, frame, x, y, a = 0, f = 0, w = 1.0, h = 1.0, p = 1.0) {
	if(!config.light) return
	if(gvLightScreen == 0) return
	if(gvLightScreen == gvLightScreen1 && gvLight == 0xffffffff
	|| gvLightScreen == gvLightScreen2 && gvLight2 == 0xffffffff) return

	local prevTarget = getDrawTarget()

	setDrawTarget(gvLightScreen)
	drawSprite(sprite, frame, x, y, a, f, w, h, p)
	setDrawTarget(prevTarget)
}

::runAmbientLight <- function(light2 = false) {
	local prevTarget = getDrawTarget()

	if(config.light) {
		if(!light2) {
			if((gvLightTarget & 0xFF) < 255) {
				local newlight = gvLightTarget >> 8
				gvLightTarget = (newlight << 8) + 255
			}
			if((gvLight & 0xFF) < 255) {
				local newlight = gvLight >> 8
				gvLight = (newlight << 8) + 255
			}
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
				if(lr != tr) lr += (tr <=> lr) * 2
				if(abs(lr - tr) < 2) lr = tr
				if(lg != tg) lg += (tg <=> lg) * 2
				if(abs(lg - tg) < 2) lg = tg
				if(lb != tb) lb += (tb <=> lb) * 2
				if(abs(lb - tb) < 2) lb = tb

				gvLight = (ceil(lr) << 24) | (ceil(lg) << 16) | (ceil(lb) << 8) | 0xFF // Last 0xFF is alpha
			}
		}

		if(light2) {
			if((gvLightTarget2 & 0xFF) < 255) {
				local newlight = gvLightTarget2 >> 8
				gvLightTarget2 = (newlight << 8) + 255
			}
			if((gvLight2 & 0xFF) < 255) {
				local newlight = gvLight2 >> 8
				gvLight2 = (newlight << 8) + 255
			}
			if(gvLight2 != gvLightTarget2) {
				//Prevent floats
				gvLight2 = gvLight2.tointeger()
				gvLightTarget2 = gvLightTarget2.tointeger()

				local lr = (gvLight2 >> 24) & 0xFF
				local lg = (gvLight2 >> 16) & 0xFF
				local lb = (gvLight2 >> 8) & 0xFF

				local tr = (gvLightTarget2 >> 24) & 0xFF
				local tg = (gvLightTarget2 >> 16) & 0xFF
				local tb = (gvLightTarget2 >> 8) & 0xFF

				//Fade to color
				if(lr != tr) lr += (tr <=> lr) * 2
				if(abs(lr - tr) < 2) lr = tr
				if(lg != tg) lg += (tg <=> lg) * 2
				if(abs(lg - tg) < 2) lg = tg
				if(lb != tb) lb += (tb <=> lb) * 2
				if(abs(lb - tb) < 2) lb = tb

				gvLight2 = (ceil(lr) << 24) | (ceil(lg) << 16) | (ceil(lb) << 8) | 0xFF // Last 0xFF is alpha
			}
		}
	}

	setDrawTarget(gvLightScreen1)
	setDrawColor(gvLight)
	drawRec(0, 0, gvScreenW, gvScreenH, true)

	setDrawTarget(gvLightScreen2)
	setDrawColor(gvLight2)
	drawRec(0, 0, gvScreenW, gvScreenH, true)

	setDrawTarget(prevTarget)
}

::drawAmbientLight <- function(light2 = false) {
	if(!config.light)
		return
	if(light2)
		drawImage(gvLightScreen2, 0, 0)
	else
		drawImage(gvLightScreen, 0, 0)
}

::setLight <- function(color) {
	gvLightTarget = color
	gvLight = color
	gvLightTarget2 = color
	gvLight2 = color
}

::setLight1 <- function(color) {
	gvLightTarget = color
	gvLight = color
}

::setLight2 <- function(color) {
	gvLightTarget2 = color
	gvLight2 = color
}

::StaticLight <- class extends Actor {
	sprite = 0
	scale = 1.0

	constructor(_x, _y, _arr) {
		base.constructor(_x, _y)

		if(getroottable().rawin(_arr[0])) sprite = getroottable()[_arr[0]]
		else deleteActor(id)
		if(1 in _arr)
			scale = _arr[1].tofloat()
	}

	function draw() {
		if(sprite) drawLight(sprite, getFrames() / 4, x - camx, y - camy, 0, 0, scale, scale)
	}
}

::FlickerLight <- class extends Actor {
	sprite = 0
	scale = 1.0
	alpha = 1.0

	constructor(_x, _y, _arr) {
		base.constructor(_x, _y)

		if(getroottable().rawin(_arr[0])) sprite = getroottable()[_arr[0]]
		else deleteActor(id)
		if(1 in _arr)
			scale = _arr[1].tofloat()
	}

	function run() {
		local newAlpha = ((0.2 + (randFloat(5.0) / 10.0)) + alpha) / 2.0
		alpha = (newAlpha + alpha) / 2.0
		if(alpha < 0.2)
			alpha = 0.2
		if(alpha > 1.0)
			alpha = 1.0
	}

	function draw() {
		if(sprite) drawLight(sprite, getFrames() / 4, x - camx, y - camy, 0, 0, (scale * (sin(id + getFrames() / 16.0) / 16.0)) + scale, (scale * (cos(id + getFrames() / 16.0) / 16.0)) + scale, alpha)

		if(debug)
			drawText(font, x + 16 - camx, y - camy, alpha.tostring())
	}
}

::TransZone <- class extends Actor {
	w = 0.0
	h = 0.0
	color = "0xffffffff"
	bg = 0
	weather = 0

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)
		bg = _arr[0]
		weather = _arr[1]
		color = _arr[2]
	}

	function run() {
		if(!gvSplitScreen) {
			if(camx0 + (gvScreenW / 2) >= x - w
			&& camy0 + (gvScreenH / 2) >= y - h
			&& camx0 + (gvScreenW / 2) <= x + w
			&& camy0 + (gvScreenH / 2) <= y + h) {
				if(bg == "0") drawBG = 0
				else if(bg in getroottable()) drawBG = getroottable()[bg]
				if(weather == "0") drawWeather = 0
				else if(weather in getroottable()) drawWeather = getroottable()[weather]
				dostr("gvLightTarget = " + color)

				if(bg == "0") drawBG2 = 0
				else if(bg in getroottable()) drawBG2 = getroottable()[bg]
				if(weather == "0") drawWeather2 = 0
				else if(weather in getroottable()) drawWeather2 = getroottable()[weather]
				dostr("gvLightTarget2 = " + color)
			}
		}
		else {
			if((camx1 + (gvScreenW / 4) >= x - w
			&& camy1 + (gvScreenH / 2) >= y - h
			&& camx1 + (gvScreenW / 4) <= x + w
			&& camy1 + (gvScreenH / 2) <= y + h)
			|| (gvPlayer
			&& gvPlayer.x >= x - w
			&& gvPlayer.y >= y - h
			&& gvPlayer.x <= x + w
			&& gvPlayer.y <= y + h)) {
				if(bg == "0") drawBG = 0
				else if(bg in getroottable()) drawBG = getroottable()[bg]
				if(weather == "0") drawWeather = 0
				else if(weather in getroottable()) drawWeather = getroottable()[weather]
				dostr("gvLightTarget = " + color)
			}

			if((camx2 + (gvScreenW / 4) >= x - w
			&& camy2 + (gvScreenH / 2) >= y - h
			&& camx2 + (gvScreenW / 4) <= x + w
			&& camy2 + (gvScreenH / 2) <= y + h)
			|| (gvPlayer2
			&& gvPlayer2.x >= x - w
			&& gvPlayer2.y >= y - h
			&& gvPlayer2.x <= x + w
			&& gvPlayer2.y <= y + h)) {
				if(bg == "0") drawBG2 = 0
				else if(bg in getroottable()) drawBG2 = getroottable()[bg]
				if(weather == "0") drawWeather2 = 0
				else if(weather in getroottable()) drawWeather2 = getroottable()[weather]
				dostr("gvLightTarget2 = " + color)
			}
		}
	}

	function draw() {
		if(debug) {
			setDrawColor(0xffffffff)
			drawRec(x - camx - w, y - camy - h, w * 2, h * 2, false)
		}
	}

	function _typeof() { return "TransZone" }
}