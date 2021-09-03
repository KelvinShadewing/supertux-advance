///////////////
// OVERWORLD //
///////////////

//Player coordinates
::gvOverX <- 0
::gvOverY <- 0

::OverPlayer <- class extends PhysAct {
	dir = 0
	//0 = right
	//1 = up
	//2 = left
	//3 = down

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

		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		base.run()

		if(x % 16 == 0 && y % 16 == 0) {
			shape.setPos(x, y)
			hspeed = 0
			vspeed = 0
			local level = ""
			if(actor.rawin("StageIcon")) {//Find what level was landed on
				foreach(i in actor["StageIcon"]) {
					if(hitTest(shape, i.shape)) {
						level = i.level
						break
					}
				}
			}

			if(hspeed == 0 && vspeed == 0) {
				
			}

		}
	}

	function _typeof() { return "OverPlayer" }
}

::StageIcon <- class extends PhysAct {
	level = ""

	constructor(_x, _y) {
		base.constructor(_x, y)

		shape = Rec(x, y, 8, 8, 0)
	}

	function _typeof() { return "StageIcon" }
}