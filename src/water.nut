::Water <- class extends Actor {
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
	}

	function draw() {
		setDrawColor(0x2020a040)
		drawRect(x - shape.w - camx, y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)
		setDrawColor(0x20f0f040)
		drawLine(x - shape.w - camx, y - shape.h - camy - 1, x + shape.w - camx - 1, y - shape.h - camy - 1)
		setDrawColor(0x20f0f080)
		drawLine(x - shape.w - camx, y - shape.h - camy - 2, x + shape.w - camx - 1, y - shape.h - camy - 2)
	}

	function _typeof() { return "Water" }
}