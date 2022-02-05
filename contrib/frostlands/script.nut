//asset stuffs
print("Loading Frostlands")

::bgAuroraALT <- newSprite("contrib/frostlands/gfx/aurora-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowPlainALT <- newSprite("contrib/frostlands/gfx/bgSnowPlain-alt.png", 720, 240, 0, 0, 0, 0)

//background shiz

::dbgAuroraF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraALT, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgSnowPlainF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlainALT, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

print("Loaded Frostlands")