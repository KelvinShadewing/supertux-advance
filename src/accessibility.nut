//Functions having to do with accessibility features go here

::drawFloatingStats <- function(x, y, red, green, blue) {
	if(red < 1.0) {
		drawSprite(sprNearRedBack, (red <= 0.25 ? getFrames() / 16 : 0), floor(x) - 24, floor(y) - 16)
		drawImagePart(imgNearRedFill, floor(x) - 23, floor(y) - 15 + (30 - (30 * red)), 0, 30 - (30 * red), 6, 30 * red)
	}

	if(blue < 1.0) {
		drawSprite(sprNearBlueBack, (blue <= 0.25 ? getFrames() / 16 : 0), floor(x) + 17, floor(y) - 16)
		drawImagePart(imgNearBlueFill, floor(x) + 18, floor(y) - 15 + (30 - (30 * blue)), 0, 30 - (30 * blue), 6, 30 * blue)
	}

	if(green < 1.0) {
		drawSprite(sprNearGreenBack, (green <= 0.25 ? getFrames() / 16 : 0), floor(x) - 16, floor(y) + 16)
		drawImagePart(imgNearGreenFill, floor(x) - floor(16 * green), floor(y) + 17, 15 - (16 * green), 0, (32 * green), 6)
	}
}