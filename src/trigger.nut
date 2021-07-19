::Trigger <- class extends Actor {
	code = ""
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
	}

	function run() {
		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) dostr(code)
	}

	function _typeof() { return "Trigger" }
}