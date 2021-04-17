::drawBG <- 0

::dbgCave <- function() {
	for(local i = 0; i < 5; i++) {
		for(local j = 0; j < 5; j++) {
			drawSprite(bgIridia, 0, ((-camx / 1.25) % 100) + (i * 100), ((-camy / 1.25) % 100) + (j * 56))
		}
	}
}