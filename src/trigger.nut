::pipeFunnel <- function() {
	if(gvPlayer.x < x && gvPlayer.hspeed < 1 && getcon("down", "hold")) gvPlayer.hspeed += 0.25
	if(gvPlayer.x > x && gvPlayer.hspeed > -1 && getcon("down", "hold")) gvPlayer.hspeed -= 0.25
}

::Trigger <- class extends Actor {
	code = ""
	shape = 0
	w = 0.0
	h = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) dostr("x <- " + x + "; y <- " + y + "; id <- " + id + "; myTarget <- gvPlayer; " + code)
		if(gvPlayer2) if(hitTest(shape, gvPlayer2.shape)) dostr("x <- " + x + "; y <- " + y + "; id <- " + id + "; myTarget <- gvPlayer2; " + code)
	}

	function _typeof() { return "Trigger" }
}