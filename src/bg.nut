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
	for(local i = 0; i < 2; i++) drawSprite(bgWoodedMountain, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	for(local i = 0; i < 4; i++) drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), gvMap.h - camy - 180)
	for(local i = 0; i < 4; i++) drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), gvMap.h - camy - 180)
}

::dbgAurora <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAurora, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgRiverCity <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgRiverCity, 0, ((-camx / 8) % 380) + (i * 380), (screenH() / 2) - 120)
	}
}