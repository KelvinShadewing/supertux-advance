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
	// 5 liquid

	constructor(_x, _y, _w, _h, _kind) {
		x = _x.tofloat()
		y = _y.tofloat()
		w = _w.tofloat()
		h = _h.tofloat()
		kind = _kind

		//Prevent zero dimensions
		//It's important, trust me
		if(w <= 0) w = 0.1
		if(h <= 0) h = 0.1
	}

	function _typeof() { return "Rec" }

	function setPos(_x, _y) {
		x = _x.tofloat()
		y = _y.tofloat()
	}

	function draw() {
		drawRect(x - w - camx, y - h - camy, (w * 2) + 1, (h * 2) + 1, false)
	}
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
										//Get slope angle
										local a0 = b.h / b.w
										local a1 = ((a.y + a.h) - (b.y + b.h)) / ((a.x - a.w) - (b.x + b.w))
										if(a1 > a0) return false
										break
									case 2:
										//Get slope angle
										local a0 = b.h / -b.w
										local a1 = ((a.y + a.h) - (b.y + b.h)) / ((a.x + a.w) - (b.x - b.w))
										if(a1 < a0) return false
										break
									case 3:
										//Get slope angle
										local a0 = -b.h / b.w
										local a1 = ((a.y - a.h) - (b.y - b.h)) / ((a.x - a.w) - (b.x + b.w))
										if(a1 < a0) return false
										break
									case 4:
										//Get slope angle
										local a0 = -b.h / -b.w
										local a1 = ((a.y - a.h) - (b.y - b.h)) / ((a.x + a.w) - (b.x - b.w))
										if(a1 > a0) return false
										break
									case 5:
										if(abs(a.x - b.x) > abs(a.w + b.w)) return false
										if(abs(a.y - b.y) > abs(a.h / 4 + b.h)) return false
										break
								}
								break

							case 1: //Top right
								switch(b.kind) {
									case 0:
									case 1:
									case 2:
									case 3:
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