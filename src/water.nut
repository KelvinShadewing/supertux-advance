::Water <- class extends Actor {
    shape = 0

    constructor(_x, _y) {
        base.constructor(_x, _y)
    }

	function draw() {
		setDrawColor(0x2020a040)
		drawRect(x - shape.w - camx, y - shape.h - camy - 2, (shape.w * 2) + 1, (shape.h * 2) + 1, true)
		setDrawColor(0x20f0f040)
		drawLine(x - shape.w - camx, y - shape.h - camy - 2, x + shape.w + 1 - camx, y - shape.h - camy - 2)
		setDrawColor(0x20f0f080)
		drawLine(x - shape.w - camx, y - shape.h - camy - 3, x + shape.w + 1 - camx, y - shape.h - camy - 3)
	}

    function _typeof() { return "Water" }
}