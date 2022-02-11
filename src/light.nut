::gvLightScreen <- 0
::gvLight <- 0xffffffff

::drawLight <- function(sprite, frame, x, y) {
	setDrawTarget(gvLightScreen)
	drawSprite(sprite, frame, x, y)
	setDrawTarget(gvScreen)
}