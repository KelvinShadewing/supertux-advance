::pipeFunnel <- function(target) {
	if(target.x < x && target.hspeed < 1 && getcon("down", "hold", false, target.playerNum)) target.hspeed += 0.25
	if(target.x > x && target.hspeed > -1 && getcon("down", "hold", false, target.playerNum)) target.hspeed -= 0.25
}

::trigCurrent <- function(h = 0, v = 0, f = 0.5) {
	if(myTarget == null)
		return

	if(h > 0 && myTarget.hspeed < h)
		myTarget.hspeed += f

	if(h < 0 && myTarget.hspeed > h)
		myTarget.hspeed -= f

	if(v > 0 && myTarget.vspeed < v)
		myTarget.vspeed += f

	if(v < 0 && myTarget.vspeed > v)
		myTarget.vspeed -= f
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
		if(gvPlayer && hitTest(shape, gvPlayer.shape))
			dostr("x <- " + x + "; y <- " + y + "; w <- " + w + "; h <- " + h + "; id <- " + id + "; myTarget <- gvPlayer; " + code)
		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape))
			dostr("x <- " + x + "; y <- " + y + "; w <- " + w + "; h <- " + h + "; id <- " + id + "; myTarget <- gvPlayer2; " + code)
	}

	function _typeof() { return "Trigger" }
}

::joinPlayers <- function(target) {
	if(target == gvPlayer && gvPlayer2) {
		gvPlayer2.x = gvPlayer.x
		gvPlayer2.y = gvPlayer.y
	}

	if(target == gvPlayer2 && gvPlayer) {
		gvPlayer.x = gvPlayer2.x
		gvPlayer.y = gvPlayer2.y
	}
}