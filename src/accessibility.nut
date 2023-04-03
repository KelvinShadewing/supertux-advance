//Functions having to do with accessibility features go here

::drawFloatingStats <- function(x, y, red, green, blue) {
	if(red < 1.0) {
		drawSprite(sprNearRedBack, (red <= 0.25 ? getFrames() / 16 : 0), x - 24, y - 16)
		drawImagePart(imgNearRedFill, x - 23, y - 15 + (30 - (30 * red)), 0, 30 - (30 * red), 6, 30 * red)
	}

	if(blue < 1.0) {
		drawSprite(sprNearBlueBack, (blue <= 0.25 ? getFrames() / 16 : 0), x + 17, y - 16)
		drawImagePart(imgNearBlueFill, x + 18, y - 15 + (30 - (30 * blue)), 0, 30 - (30 * blue), 6, 30 * blue)
	}
}