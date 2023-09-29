::drawWeather <- 0
::drawWeather2 <- 0

::dweRain <- function() {
	for(local i = 0; i < (screenW() / 256) + 4; i++) {
		for(local j = 0; j < (screenH() / 256) + 4; j++) {
			drawSprite(weRain, 0, -(getFrames() * 1 % 256) + (i * 256) - (camx % 256), ((getFrames() * 8) % 256) + (j * 256) - 256 - (camy % 256))
		}
	}
}

::dweSnow <- function() {
	setDrawColor(0x60606040)
	drawRec(0, 0, screenW(), screenH(), true)
	for(local i = 0; i < (screenW() / 64) + 4; i++) {
		for(local j = 0; j < (screenH() / 64) + 4; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 64.0) * 16.0) + (i * 64) - (camx % 64) - 64, ((getFrames() / 2) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
}

::dweBlizzard <- function() {
	setDrawColor(0x6060b0)
	drawRec(0, 0, screenW(), screenH(), true)
	for(local i = 0; i < (screenW() / 64) + 4; i++) {
		for(local j = 0; j < (screenH() / 64) + 4; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 32.0) * 128.0) % -64 + (i * 64) - (camx % 64) - 64, ((getFrames() * 2) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
	for(local i = 0; i < (screenW() / 64) + 4; i++) {
		for(local j = 0; j < (screenH() / 64) + 4; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 128.0) * 128.0) % -64 + (i * 64) - (camx % 64) - 64, ((getFrames() * 3) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
}

::dweBlizzardNight <- function() {
	setDrawColor(0x090924)
	drawRec(0, 0, screenW(), screenH(), true)
	for(local i = 0; i < (screenW() / 64) + 4; i++) {
		for(local j = 0; j < (screenH() / 64) + 4; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 32.0) * 128.0) % -64 + (i * 64) - (camx % 64) - 64, ((getFrames() * 2) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
	for(local i = 0; i < (screenW() / 64) + 4; i++) {
		for(local j = 0; j < (screenH() / 64) + 4; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 128.0) * 128.0) % -64 + (i * 64) - (camx % 64) - 64, ((getFrames() * 3) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
}