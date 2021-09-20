::Water <- class extends Actor {
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
	}

	function draw() {
		setDrawColor(0x2020a040)
		drawRect(x - shape.w - camx, y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)
		for(local i = 0; i < shape.w / 8; i++) {
			drawSpriteEx(sprWaterSurface, (getFrames() / 16) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy, 0, 0, 1, 1, 0.5)
		}
	}

	function _typeof() { return "Water" }
}