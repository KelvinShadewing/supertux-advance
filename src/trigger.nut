::Trigger <- class extends Actor {
	code = ""
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
	}

	function run() {
		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) dostr(code)
		setDrawColor(0xff4060ff)
		drawRec(shape.x - camx, shape.y - camy, shape.w * 2, shape.h * 2, true)
	}
}