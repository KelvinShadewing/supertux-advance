::gvZList <- {}

//Add a sprite instruction to Z list
::drawSpriteZ <- function(z, sprite, frame, x, y) {
	//Make sure the depth slot exists
	if(!gvZList.rawin(z)) gvZList[z] <- array(0)

	//Insert the instruction
	gvZList[z].push([sprite, frame, x, y, 0, 0, 1, 1, 1])
}

::drawSpriteExZ <- function(z, sprite, frame, x, y, angle, flip, xscale, yscale, alpha) {
	//Make sure the depth slot exists
	if(!gvZList.rawin(z)) gvZList[z] <- array(0)

	//Insert the instruction
	gvZList[z].push([sprite, frame, x, y, angle, flip, xscale, yscale, alpha])
}

::drawZList <- function(layers) {
	//The argument defines how many layers from 0 to draw
}