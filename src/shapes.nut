////////////
// SHAPES //
////////////

::Rec <- class {
	x = 0.0
	y = 0.0
	w = 0.0
	h = 0.0
	kind = 0
	// 0 normal
	// 1 top right
	// 2 top left
	// 3 bottom right
	// 4 bottom left
	// 5 liquid (requires other to be at least halfway inside, does not work well with other liquids)
	ox = 0.0
	oy = 0.0

	constructor(_x, _y, _w, _h, _kind, _ox = 0.0, _oy = 0.0) {
		x = _x.tofloat()
		y = _y.tofloat()
		w = _w.tofloat()
		h = _h.tofloat()
		kind = _kind

		//Prevent zero dimensions
		//It's important, trust me
		if(w <= 0) w = 0.1
		if(h <= 0) h = 0.1
		ox = _ox.tofloat()
		oy = _oy.tofloat()
	}

	function setPos(_x, _y) {
		x = _x.tofloat() + ox
		y = _y.tofloat() + oy
	}

	function draw() {
		drawRect(x - w - camx, y - h - camy, (w * 2) + 1, (h * 2) + 1, false)
	}

	function pointIn(_x, _y) {
		return (_x > x - w && _x < x + w && _y > y - h && _y < y + h)
	}

	function _typeof() { return "Rec" }
}

::Cir <- class{
	x = 0.0
	y = 0.0
	r = 0.0
	ox = 0.0
	oy = 0.0
	w = 0.0
	h = 0.0

	constructor(_x, _y, _r, _ox = 0.0, _oy = 0.0) {
		x = _x.tofloat()
		y = _y.tofloat()
		r = _r.tofloat()
		ox = _ox.tofloat()
		oy = _oy.tofloat()
		w = _r.tofloat()
		h = _r.tofloat()
	}

	function setPos(_x, _y) {
		x = _x.tofloat() + ox
		y = _y.tofloat() + oy
	}

	function draw() {
		drawCircle(x - camx, y - camy, r, false)
	}

	function pointIn(_x, _y) {
		return inDistance2(x, y, _x, _y, _r)
	}

	function _typeof() { return "Cir" }
}

::hitTest <- function(a, b) {
	switch(typeof a) {
		case "Rec":
			switch(typeof b) {
				case "Rec":
					if(abs(a.x - b.x) > abs(a.w + b.w)) return false
					if(abs(a.y - b.y) > abs(a.h + b.h)) return false

					//kinds
					if(a.kind != 0 || b.kind != 0) {
						switch(a.kind) {
							case 0: //Rectangle
								switch(b.kind) {
									case 0:
										//If rectangle/rectangle somehow gets in anyway
										return true
										break
									case 1:
										if (((a.x - a.w) - (b.x + b.w)) == 0)
											return false

										//Get slope angle
										local a0 = b.h / b.w
										local a1 = ((a.y + a.h) - (b.y + b.h)) / ((a.x - a.w) - (b.x + b.w))
										if(a1 > a0) return false
										break
									case 2:
										if (((a.x + a.w) - (b.x - b.w)) == 0)
											return false

										//Get slope angle
										local a0 = b.h / -b.w
										local a1 = ((a.y + a.h) - (b.y + b.h)) / ((a.x + a.w) - (b.x - b.w))
										if(a1 < a0) return false
										break
									case 3:
										if (((a.x - a.w) - (b.x + b.w)) == 0)
											return false

										//Get slope angle
										local a0 = -b.h / b.w
										local a1 = ((a.y - a.h) - (b.y - b.h)) / ((a.x - a.w) - (b.x + b.w))
										if(a1 < a0) return false
										break
									case 4:
										if (((a.x + a.w) - (b.x - b.w)) == 0)
											return false

										//Get slope angle
										local a0 = -b.h / -b.w
										local a1 = ((a.y - a.h) - (b.y - b.h)) / ((a.x + a.w) - (b.x - b.w))
										if(a1 > a0) return false
										break
									case 5:
										if(abs(a.x - b.x) > abs(b.w)) return false
										if(abs(a.y - b.y) > abs(b.h)) return false
										break
								}
								break

							case 1: //Top right
								switch(b.kind) {
									case 0:
									case 1:
									case 2:
									case 3:
										if (((a.x - a.w) - (b.x + b.w)) == 0)
											return false
										//Get slope angle
										local a0 = b.h / b.w
										local a1 = ((a.y + a.h) - (b.y + b.h)) / ((a.x - a.w) - (b.x + b.w))
										if(a1 > a0) return false
										break
									case 4:
										break
									case 5:
										break
								}
								break

							case 2: //Top left
								switch(b.kind) {
									case 0:
										break
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
									case 5:
										break
								}
								break

							case 3: //Bottom right
								switch(b.kind) {
									case 0:
										break
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
									case 5:
										break
								}
								break

							case 4: //Bottom left
								switch(b.kind) {
									case 0:
										break
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
									case 5:
										break
								}
								break

							case 5: //Liquid
								switch(b.kind) {
									case 0:
										break
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
									case 5:
										break
								}
								break
						}
					}

					return true
					break

				case "Cir": //Circle
					local hx = b.x
					local hy = b.y

					//Find closest point
					if(b.x < a.x - a.w) hx = a.x - a.w
					if(b.x > a.x + a.w) hx = a.x + a.w

					if(b.y < a.y - a.h) hy = a.y - a.h
					if(b.y > a.y + a.h) hy = a.y + a.h

					//Check distance
					if(inDistance2(hx, hy, b.x, b.y, b.r)) return true
					break
					//Still need to check for collisions with slopes and liquid

				default:
					return false
					break
			}
			break

		case "Cir": //Circle
			switch(typeof b) {
				case "Rec":
					local hx = a.x
					local hy = a.y

					//Find closest point
					if(a.x < b.x - b.w) hx = b.x - b.w
					if(a.x > b.x + b.w) hx = b.x + b.w

					if(a.y < b.y - b.h) hy = b.y - b.h
					if(a.y > b.y + b.h) hy = b.y + b.h

					//Check distance
					if(inDistance2(a.x, a.y, hx, hy, a.r)) return true
					break
					//Still need to check for collisions with slopes and liquid

				default:
					return false
					break
			}
			break

		default:
			return false
			break
	}
}