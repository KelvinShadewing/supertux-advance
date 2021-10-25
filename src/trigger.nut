::pipeFunnel <- function() {
	if(gvPlayer.x < x && gvPlayer.hspeed < 0.5 && getcon("down", "hold")) gvPlayer.hspeed += 0.2
	if(gvPlayer.x > x && gvPlayer.hspeed > -0.5 && getcon("down", "hold")) gvPlayer.hspeed -= 0.2
}

::Trigger <- class extends Actor {
	code = ""
	shape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) dostr("x <- " + x + "; y <- " + y + "; " + code)
	}

	function _typeof() { return "Trigger" }
}