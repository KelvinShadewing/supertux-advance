::drawBG <- 0

::dbgCave <- function() {
	for(local i = 0; i < 5; i++) {
		for(local j = 0; j < 5; j++) {
			drawSprite(bgIridia, 0, ((-camx / 2) % 100) + (i * 100), ((-camy / 2) % 56) + (j * 56))
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 2; j++) {
			drawSprite(bgCaveHoles, 0, (-camx % 400) + (i * 400), (-camy % 392) + (j * 392))
		}
	}
}