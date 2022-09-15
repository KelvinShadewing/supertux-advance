::drawBG <- 0
::gvHorizon <- 0
::gvParallaxMap <- 0

::dbgNone <- function() {
	setDrawColor(0xff)
	drawRec(0, 0, screenW(), screenH(), true)
}

::dbgEcho <- function() {
	//drawImage(gvScreen, 0, 0)
	drawImage(gvPlayScreen, camxprev - camx, camyprev - camy)
	setDrawColor(0x20)
	drawRec(0, 0, screenW(), screenH(), true)
}

::dbgCave <- function() {
	for(local i = 0; i < 6; i++) {
		for(local j = 0; j < 6; j++) {
			drawSprite(bgIridia, 0, ((-camx / 8) % 100) + (i * 100), ((-camy / 8) % 56) + (j * 56))
		}
	}

	for(local i = 0; i < 4; i++) {
		for(local j = 0; j < 4; j++) {
			drawSprite(bgCaveHoles, 0, ((-camx / 4) % 400) + (i * 400), ((-camy / 4) % 392) + (j * 392))
		}
	}
}

::dbgForest <- function() {
	if(gvMap != 0) {
		for(local i = 0; i < 3; i++) drawSprite(bgWoodedMountain, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 5; i++) drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), gvHorizon - camy - 180)
		for(local i = 0; i < 5; i++) drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), gvHorizon - camy - 180)
	}
	else {
		for(local i = 0; i < 3; i++) drawSprite(bgWoodedMountain, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 5; i++) drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), screenH() - camy - 180)
		for(local i = 0; i < 5; i++) drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), screenH() - camy - 180)
	}
}

::dbgMountain <- function() {
	for(local i = 0; i < 3; i++) drawSprite(bgWoodedMountain, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
}

::dbgAurora <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAurora, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgAuroraNight <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraNight, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgIceForest <- function() {
	if(gvMap != 0) {
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest, 0, ((-camx / 16) % 640) + (i * 640), 0)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest2, 0, ((-camx / 8) % 480) + (i * 480), gvHorizon - camy - 192)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest1, 0, ((-camx / 4) % 640) + (i * 640), gvHorizon - camy - 256)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest0, 0, ((-camx / 2) % 800) + (i * 800), gvHorizon - camy - 320)
	}
	else {
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 4; i++) drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), screenH() - camy - 180)
		for(local i = 0; i < 4; i++) drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), screenH() - camy - 180)
	}
}

::dbgSnowNight <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowNight, 0, ((-camx / 8) % 800) + (i * 800), (screenH() / 2) - 120)
	}
}

::dbgSnowPlain <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlain, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgRiverCity <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgRiverCity, 0, ((-camx / 8) % 380) + (i * 380), (screenH() / 2) - 120)
	}
}

::dbgOcean <- function() {
	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOcean, j, ((-camx / 32) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOcean, j, (((-camx) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgOceanMoving <- function() {
	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOcean, j, (((-camx - getFrames()) / 16) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOcean, j, (((-camx - getFrames() * 4) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgStarSky <- function() {
	for(local i = 0; i < 3; i++) {
		drawSprite(bgStarSky, 0, ((-camx / 16) % 240) + (i * 240), (screenH() / 2) - 120)
	}
}

::dbgUnderwater <- function() {
	drawSprite(bgUnderwater, 0, 0, (screenH() / 2) - 120)
}

::dbgCastle <- function() {
	drawSprite(bgCastle, 0, 0, (screenH() / 2) - 120)
	drawSprite(bgCastle, 0, 320, (screenH() / 2) - 120)
}

::dbgFortMagma <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFortMagma, 0, ((-camx / 8) % 960) + (i * 960), (screenH() / 2) - 120)
	}
}

::dbgTheatre <- function() {
	drawSprite(bgCharSel, 0, screenW() / 2, 0)
}