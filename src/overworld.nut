///////////////
// OVERWORLD //
///////////////

//Player coordinates
::gvOverX <- 0
::gvOverY <- 0

OverPlayer <- class extends PhysAct {
	constructor(_x, _y) {
		base.constructor(_x, _y)

		if(gvOverX == 0 && gvOverY == 0) {
			x = _x
			y = _y
		}
		else {
			x = gvOverX
			y = gvOverY
		}
	}
}