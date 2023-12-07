::gvZList <- {}
::gvHudList <- []

//Add a sprite instruction to Z list
::drawSpriteZ <- function(z, sprite, frame, x, y, angle = 0, flip = 0, xscale = 1.0, yscale = 1.0, alpha = 1.0, color = 0xffffffff) {
	//Make sure the depth slot exists
	if(!gvZList.rawin(z)) gvZList[z] <- array(0)

	//Insert the instruction
	gvZList[z].push([sprite, frame, x, y, angle, flip, xscale, yscale, alpha, color])
}

::drawSpriteHUD <- function(sprite, frame, x, y, angle = 0, flip = 0, xscale = 1.0, yscale = 1.0, alpha = 1.0, color = 0xffffffff) {
	//Insert the instruction
	gvHudList.push(["sprite", sprite, frame, x, y, angle, flip, xscale, yscale, alpha, color])
}

::drawTextHUD <- function(font, x, y, text) {
	gvHudList.push(["text", font, x, y, text])
}

::drawSpriteExZ <- function(z, sprite, frame, x, y, angle, flip, xscale, yscale, alpha, color) {
	//Make sure the depth slot exists
	if(!gvZList.rawin(z)) gvZList[z] <- array(0)

	//Insert the instruction
	gvZList[z].push([sprite, frame, x, y, angle, flip, xscale, yscale, alpha, color])
}

::drawZList <- function(layers) {
	//The argument defines how many layers from 0 to draw
	for(local i = 0; i <= layers; i++) {
		if(!gvZList.rawin(i)) continue //If nothing was drawn to that layer, skip it

		local n = gvZList[i].len() //Number of sprites per layer
		if(n == 0) continue //Just in case

		for(local j = 0; j < n; j++) {
			local s = gvZList[i][j] //Sprite argument array
			drawSprite(s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9])
		}
	}

	gvZList.clear() //Empty table for next render
}

::drawHudList <- function() {
	if(gvHudList.len() == 0)
		return

	for(local i = 0; i < gvHudList.len(); i++) {
		local s = gvHudList[i]
		switch(s[0]) {
			case "sprite":
				drawSprite(s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9], s[10])
				break

			case "text":
				drawText(s[1], s[2], s[3], s[4])
		}
	}

	gvHudList.clear()
}