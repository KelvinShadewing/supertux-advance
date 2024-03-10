//You guys don't mind me making someone with a portal gun, do you? 👉👈
::ShellPortal <- class extends Portal {
	function draw() {
		drawSpriteEx(sprPortalBlue, getFrames() / 4, shapeA.x - camx, shapeA.y - camy, angleA, 0, 1, 1, 1)
		drawSpriteEx(sprPortalOrange, getFrames() / 4, shapeB.x - camx, shapeB.y - camy, angleB, 0, 1, 1, 1)
		if(debug) {
			setDrawColor(color)
			drawLine(shapeA.x - camx, shapeA.y - camy, shapeB.x - camx, shapeB.y - camy)
		}
	}
	function _typeof() { return "ShellPortal" }
}