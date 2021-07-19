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

::dbgForest <- function() {
	local offset = -camx //Constantly scrolling for now for testing purposes

	for(local i = 0; i < 3; i++) drawSprite(bgForest0, 0, ((offset / 4) % 272) + (i * 272), 0)
	for(local i = 0; i < 3; i++) drawSprite(bgForest1, 0, ((offset / 3) % 272) + (i * 272), 0)
	for(local i = 0; i < 3; i++) drawSprite(bgForest2, 0, ((offset / 2) % 272) + (i * 272), 0)
	for(local i = 0; i < 3; i++) drawSprite(bgForest3, 0, (offset % 272) + (i * 272), 0)
}

::dbgAurora <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAurora, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}