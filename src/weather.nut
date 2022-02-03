::drawWeather <- 0

::dweRain <- function() {
	for(local i = 0; i < (screenW() / 64) + 2; i++) {
		for(local j = 0; j < (screenH() / 64) + 2; j++) {
			drawSprite(weRain, 0, -(getFrames() * 2 % 64) + (i * 64) - (camx % 64), ((getFrames() * 3) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
}

::dweSnow <- function() {
	for(local i = 0; i < (screenW() / 64) + 2; i++) {
		for(local j = 0; j < (screenH() / 64) + 2; j++) {
			drawSprite(weSnow, 0, -(sin(getFrames().tofloat() / 64.0) * 16.0) + (i * 64) - (camx % 64), ((getFrames() / 2) % 64) + (j * 64) - 64 - (camy % 64))
		}
	}
}