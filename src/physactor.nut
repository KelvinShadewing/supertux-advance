/*=============*\
| PHYSICS ACTOR |
\*=============*/

::PhysAct <- class extends Actor{
	hspeed = 0.0
	vspeed = 0.0
	box = [0, 0, 0, 0]
	xstart = 0.0
	ystart = 0.0
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		xstart = _x
		ystart = _y
	}

	function placeFree(_x, _y) {
		//Save current location and move
		local ns = Rec(_x, _y, shape.w, shape.h, shape.kind)
		local np = Rec(_x, _y, 0, 0, 0)

		//Find a region
		for(local i = 0; i < gvMap.geo.len(); i++) {
			if(hitTest(ns, gvMap.geo[i][0])) {
				//Find a zone
				for(local j = 0; j < gvMap.geo[i][1].len(); j++) {
					if(hitTest(ns, gvMap.geo[i][1][j][0])) {
						//Check the boxes
						for(local k = 0; k < gvMap.geo[i][1][j][1].len(); k++) {
							if(hitTest(ns, gvMap.geo[i][1][j][1][k][0])) return false	
						}
					}
				}
			}
		}

		return true
	}

	function inWater(_x, _y) {
		local ns = Rec(_x, _y, shape.w, shape.h, shape.kind)
		local np = Rec(_x, _y, 0, 0, 0)

		if(actor.rawin("Water")) {
			foreach(i in actor["Water"]) {
				if(hitTest(ns, i.shape)) return true
			}
		}

		return false
	}
}
