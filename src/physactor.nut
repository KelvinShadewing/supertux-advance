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
		local ns = Rec(_x + shape.ox, _y + shape.oy, shape.w, shape.h, shape.kind)
		local cx = floor(_x / 16)
		local cy = floor(_y / 16)
		local cw = ceil(shape.w / 16)
		local ch = ceil(shape.h / 16)

		//Check that the solid layer exists
		local wl = null //Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		//Check against places in solid layer
		if(wl != null) {
			for(local i = -cw; i <= cw; i++) {
				for(local j = -ch; j <= ch; j++) {
					local tile = (cx + i) + ((cy + j) * wl.width)
					if(tile >= 0 && tile < wl.data.len()) switch(wl.data[tile] - gvMap.solidfid) {
						case 0: //Full solid
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 1: //Half Down
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 2: //Half Up
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 3: //Half Left
							gvMap.shape.setPos(((cx + i) * 16) + 4, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 0
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 4: //Half Right
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 0
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 5: //1/2 TL A
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 6: //1/2 TL B
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 7: //1/2 TR B
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 1
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 8: //1/2 TR A
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 1
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 9: //45 TL
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 10: //1/2 BL A
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 4
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 11: //1/2 BL B
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 4
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 12: //1/2 BR B
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 3
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 13: //1/2 BR A
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 3
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 14: //45 TR
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 1
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 15: //2/1 TL A
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 2
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 16: //2/1 TR A
							gvMap.shape.setPos(((cx + i) * 16) + 4, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 1
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 17: //2/1 BL B
							gvMap.shape.setPos(((cx + i) * 16) + 4, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 4
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 18: //2/1 BR B
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 3
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 19: //45 BL
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 4
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 20: //2/1 TL B
							gvMap.shape.setPos(((cx + i) * 16) + 4, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 2
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 21: //2/1 TR B
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 1
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 22: //2/1 BL A
							gvMap.shape.setPos(((cx + i) * 16) + 12, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 4
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 23: //2/1 BR A
							gvMap.shape.setPos(((cx + i) * 16) + 4, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 3
							gvMap.shape.w = 4.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 24: //45 BR
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 3
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 25: //Thin Down
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 15)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 1.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 26: //Thin Up
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 1)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 1.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 27: //Thin Left
							gvMap.shape.setPos(((cx + i) * 16) + 1, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 0
							gvMap.shape.w = 1.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 28: //Thin Right
							gvMap.shape.setPos(((cx + i) * 16) + 15, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 0
							gvMap.shape.w = 1.0
							gvMap.shape.h = 8.0
							if(hitTest(ns, gvMap.shape)) return false
							break
					}
					if(debug) gvMap.shape.draw()
				}
			}
		}

		gvMap.shape.setPos(-256, -256)

		//Go through map geo
		for(local i = 0; i < gvMap.geo.len(); i++) {
			if(gvMap.geo[i] != null) if(hitTest(ns, gvMap.geo[i])) return false
		}

		return true
	}

	function inWater(_x, _y) {
		local ns = Rec(_x, _y, shape.w, shape.h, shape.kind)

		if(actor.rawin("Water")) {
			foreach(i in actor["Water"]) {
				if(hitTest(ns, i.shape)) return true
			}
		}

		return false
	}
}
