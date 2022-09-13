/*=============*\
| PHYSICS ACTOR |
\*=============*/

::PhysAct <- class extends Actor{
	hspeed = 0.0
	vspeed = 0.0
	box = [0, 0, 0, 0]
	xstart = 0.0
	ystart = 0.0
	xprev = 0.0
	yprev = 0.0
	shape = Rec(0, 0, 0, 0, 0)
	anim = null
	frame = 0.0
	sprite = 0
	z = 0
	phantom = false
	routine = null
	gravity = 0.0
	friction = 0.1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		xstart = _x
		ystart = _y
	}

	function run() {
		physics()
		animation()
		if(routine != null) routine()
	}

	function physics() {
		if(placeFree(x, y + (0 <=> gravity)) && !phantom) vspeed += gravity
		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 4; i++) if(!placeFree(x, y + 4) && placeFree(x + hspeed, y + 1) && !inWater() && vspeed >= 0 && !placeFree(x + hspeed, y + 4)) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= min(8, abs(hspeed)); i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						if(i > 2) {
							if(hspeed > 0) hspeed -= 0.2
							if(hspeed < 0) hspeed += 0.2
						}
						didstep = true
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		//Friction
		if(fabs(hspeed) > friction) {
			if(hspeed > 0) hspeed -= friction
			if(hspeed < 0) hspeed += friction
		} else hspeed = 0

		shape.setPos(x, y)
		xprev = x
		yprev = y
	}

	function setAnim(_anim) {
		anim = _anim
		frame = 0.0
	}

	function animation() {}

	function routine() {}

	function draw() {
		drawSpriteExZ(z, sprite, anim[frame % anim.len()], x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function escapeMoPlat(useDown = false, useUp = false, useLeft = false, useRight = false) {
		if(!actor.rawin("MoPlat")) return 0
		local result = 0

		foreach(i in actor["MoPlat"]) {
			if(hitTest(shape, i.shape)) {
				//Get angle between actors
				local angle = pointAngle(x - hspeed, y - vspeed, i.x, i.y)
				local slopeA = fabs(lendirY(1.0, angle))

				//Get slope across platform
				local slopeB = 8.0 / (i.w * 8.0)

				//Get pushed by platform
				if(placeFree(x + i.hspeed, y + i.vspeed)) {
					x += i.hspeed
					y += i.vspeed
				}

				//Move out of platform box
				if(x - hspeed + shape.w > i.x - (i.w * 8.0) && x - hspeed + shape.w < i.x + (i.w * 8.0)
				|| x - hspeed - shape.w > i.x - (i.w * 8.0) && x - hspeed - shape.w < i.x + (i.w * 8.0)
				|| x - hspeed > i.x - (i.w * 8.0) && x - hspeed < i.x + (i.w * 8.0)
				|| slopeA >= slopeB) {
					if(y < i.y) {
						if(placeFree(x, i.y - shape.h - shape.oy - 4)) y = i.y - shape.h - shape.oy - 4
						result = -1
						if(useDown && placeFree(x + i.hspeed, y + i.vspeed)) y += i.vspeed
					}
					else {
						if(placeFree(x, i.y + shape.h - shape.oy + 4)) y = i.y + shape.h - shape.oy + 4
						result = 1
						if(useUp && placeFree(x + i.hspeed, y + i.vspeed)) y += i.vspeed
					}
				}
				else {
					if(x < i.x) {
						if(placeFree(i.x - (i.w * 8) - shape.w - shape.ox, y)) x = i.x - (i.w * 8) - shape.w - shape.ox
						result = -2
						if(useLeft && placeFree(x + i.hspeed, y + i.vspeed)) x += i.hspeed
					}
					else {
						if(placeFree(i.x + (i.w * 8) + shape.w - shape.ox, y)) x = i.x + (i.w * 8) + shape.w - shape.ox
						result = 2
						if(useRight && placeFree(x + i.hspeed, y + i.vspeed)) x += i.hspeed
					}

				}
			}
		}

		return result
	}

	function placeFree(_x, _y) {
		//Save current location and move
		local ns
		if(typeof shape == "Rec") ns = Rec(_x + shape.ox, _y + shape.oy, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(_x + shape.ox, _y + shape.oy, shape.r)
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
						case 39:
						case 40:
						case 42:
						case 43:
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
						case 52:
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
						case 58:
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 6: //1/2 TL B
						case 59:
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 7: //1/2 TR B
						case 55:
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 1
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 8: //1/2 TR A
						case 56:
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 12)
							gvMap.shape.kind = 1
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(hitTest(ns, gvMap.shape)) return false
							break
						case 9: //45 TL
						case 54:
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
						case 53:
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
						case 38: //One Way
						case 50:
						case 51:
							local nps
							if(typeof shape == "Rec") nps = Rec(shape.x + shape.ox, ns.y, ns.w, ns.h, shape.kind)
							if(typeof shape == "Cir") nps = Cir(shape.x + shape.ox, ns.y, ns.r)
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 4)
							gvMap.shape.kind = 0
							gvMap.shape.w = 8.0
							gvMap.shape.h = 4.0
							if(nps.y >= shape.y + shape.oy || vspeed > 0) if(hitTest(nps, gvMap.shape) && !hitTest(shape, gvMap.shape) && hitTest(ns, gvMap.shape)) return false
							break
						case 44: //One Way Top Left
							local nps
							if(typeof shape == "Rec") nps = Rec(shape.x + shape.ox, ns.y, ns.w, ns.h, shape.kind)
							if(typeof shape == "Cir") nps = Cir(shape.x + shape.ox, ns.y, ns.r)
							gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
							gvMap.shape.kind = 2
							gvMap.shape.w = 8.0
							gvMap.shape.h = 8.0
							if(nps.y > shape.y + shape.oy || vspeed >= 0) if(hitTest(nps, gvMap.shape) && !hitTest(shape, gvMap.shape) && hitTest(ns, gvMap.shape)) return false
					}
					if(debug) {
						gvMap.shape.draw()
					}
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

	function placeMeeting(_class, _x, _y) {
		if(!_class.rawin("shape")) return false
	}

	function inWater(_x = 0, _y = 0) {
		local ns
		if(typeof shape == "Rec") ns = Rec(_x + shape.ox, _y + shape.oy, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(_x + shape.ox, _y + shape.oy, shape.r)

		if(actor.rawin("Water")) {
			foreach(i in actor["Water"]) {
				if(hitTest(ns, i.shape)) return true
			}
		}

		return false
	}

	function onHazard(_x, _y) {
		//Save current location and move
		local ns
		if(typeof shape == "Rec") ns = Rec(_x + shape.ox, _y + shape.oy, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(_x + shape.ox, _y + shape.oy, shape.r)
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
					if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 37) {
						gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
						gvMap.shape.kind = 0
						gvMap.shape.w = 6.0
						gvMap.shape.h = 6.0
						if(hitTest(ns, gvMap.shape)) return true
					}
					if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 40) {
						gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
						gvMap.shape.kind = 0
						gvMap.shape.w = 9.0
						gvMap.shape.h = 6.0
						if(hitTest(ns, gvMap.shape)) return true
						gvMap.shape.w = 6.0
						gvMap.shape.h = 9.0
						if(hitTest(ns, gvMap.shape)) return true
					}
					if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 42) {
						gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
						gvMap.shape.kind = 0
						gvMap.shape.w = 9.0
						gvMap.shape.h = 6.0
						if(hitTest(ns, gvMap.shape)) return true
					}
					if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 43) {
						gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
						gvMap.shape.kind = 0
						gvMap.shape.w = 6.0
						gvMap.shape.h = 9.0
						if(hitTest(ns, gvMap.shape)) return true
					}
					if(debug) gvMap.shape.draw()
				}
			}
		}

		return false
	}

	function onDeath(_x, _y) {
		//Save current location and move
		local ns
		if(typeof shape == "Rec") ns = Rec(_x + shape.ox, _y + shape.oy, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(_x + shape.ox, _y + shape.oy, shape.r)
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
					if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 41) {
						gvMap.shape.setPos(((cx + i) * 16) + 8, ((cy + j) * 16) + 8)
						gvMap.shape.kind = 0
						gvMap.shape.w = 6.0
						gvMap.shape.h = 6.0
						if(hitTest(ns, gvMap.shape)) return true
					}
					if(debug) gvMap.shape.draw()
				}
			}
		}

		return false
	}

	function onPlatform() {
		//Save current location and move
		local ns
		if(typeof shape == "Rec") ns = Rec(x + shape.ox, y + shape.oy + 2, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(x + shape.ox, y + shape.oy + 2, shape.r)
		local cx = floor(x / 16)
		local cy = floor(y / 16) + 1

		//Check that the solid layer exists
		local wl = gvMap.solidLayer

		//Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) switch(wl.data[tile] - gvMap.solidfid) {
				case 38:
				case 50:
				case 51:
					gvMap.shape.setPos(x, y + 4)
					gvMap.shape.kind = 0
					gvMap.shape.w = 8.0
					gvMap.shape.h = 4.0
					if(hitTest(ns, gvMap.shape)) return true
					break
				case 44: //L diag
					gvMap.shape.setPos(x, y + 4)
					gvMap.shape.kind = 2
					gvMap.shape.w = 8.0
					gvMap.shape.h = 4.0
					if(hitTest(ns, gvMap.shape)) return true
					break
				case 45: //L 2/2
					break
				case 46: //L 1/2
					break
				case 47: //R 1/2
					break
				case 48: //R 2/2
					break
				case 49: //R diag
					break
			}
		}

		//Handle moving platforms
		if(actor.rawin("MoPlat")) foreach(i in actor["MoPlat"]) {
			if(hitTest(ns, i.shape)) return true
		}

		return false
	}

	function onIce(_x = -1, _y = -1) {
		//Save current location and move
		local ns
		if(typeof shape == "Rec") ns = Rec(x + shape.ox, y + shape.oy + 2, shape.w, shape.h, shape.kind)
		if(typeof shape == "Cir") ns = Cir(x + shape.ox, y + shape.oy + 2, shape.r)
		local cx = floor(x / 16)
		local cy = floor(y / 16) + 1
		if(_x != -1) cx = floor(_x / 16)
		if(_y != -1) cy = floor(_y / 16) + 1
		if(_x != -1 && _y != -1) ns.setPos(_x, _y + 2)

		//Check that the solid layer exists
		local wl = gvMap.solidLayer

		//Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) switch(wl.data[tile] - gvMap.solidfid) {
				case 39:
				case 51:
				case 52:
				case 53:
				case 54:
				case 55:
				case 56:
				case 57:
				case 58:
				case 59:
					if(typeof shape == "Rec") ns = Rec(x, y, shape.w, shape.h, shape.kind)
					if(typeof shape == "Cir") ns = Cir(x, y, shape.r)
					gvMap.shape.setPos((cx * 16) + 8, (cy * 16))
					gvMap.shape.kind = 0
					gvMap.shape.w = 10.0
					gvMap.shape.h = 4.0
					if(hitTest(ns, gvMap.shape)) return true
					if(debug) gvMap.shape.draw()
					break
			}
		}

		return false
	}
}

::PathCrawler <- class extends PhysAct {
	path = null
	speed = 0.0
	tx = 0
	ty = 0
	loop = false
	step = 0
	reverse = false
	dir = 0.0
	moving = true
	started = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		path = _arr[0]
		if(_arr.len() > 1) speed = _arr[1].tofloat()
		shape = Rec(x, y, 6, 6, 0)
		if(path[0][0] == path[path.len() - 1][0] && path[0][1] == path[path.len() - 1][1]) loop = true
		tx = path[0][0]
		ty = path[0][1]
	}

	function run() {
		//Follow path
		if(moving) {
			if(!started) {
				started = true
				pathStart()
			}
			if(!inDistance2(x, y, tx, ty, speed)) {
				dir = pointAngle(x, y, tx, ty)
				hspeed = lendirX(speed, dir)
				vspeed = lendirY(speed, dir)
				x += hspeed
				y += vspeed
			}
			else {
				hspeed = tx - x
				vspeed = ty - y
				x = tx
				y = ty
				//Update target
				if(reverse) {
					if(step - 1 < 0) {
						reverse = false
						step++
						pathZero()
					}
					else step--
					if(step < 0) step = 0
					tx = path[step][0]
					ty = path[step][1]
				}
				else {
					if(step + 1 < path.len()) step++
					else if(loop) step = 0
					else {
						step--
						reverse = true
						pathEnd()
					}
					if(step < 0) step = 0
					tx = path[step][0]
					ty = path[step][1]
				}
			}
		}
	}

	//Dummy functions
	function pathStart() {} //When it first starts moving
	function pathEnd() {} //When it reaches the last point moving forward
	function pathZero() {} //When it reaches the first point moving backwards
}