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
	for(local i = 0; i < layers; i++) {
		if(!gvZList.rawin(i)) continue //If nothing was drawn to that layer, skip it

		local n = gvZList[i].len() //Number of sprites per layer
		if(n == 0) continue //Just in case

		for(local j = 0; j < n; j++) {
			local s = gvZList[i][j] //Sprite argument array
			drawSpriteEx(s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8])
		}
	}

	gvZList.clear() //Empty table for next render
}