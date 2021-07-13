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
		x = _x
		y = _y
		w = _w
		h = _h
		kind = _kind

		//Prevent zero dimensions
		//It's important, trust me
		if(w <= 0) w = 0.1
		if(h <= 0) h = 0.1
	}

	function _typeof() { return "Rec" }

	function setPos(_x, _y, _a) {
		x = _x
		y = _y
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
							case 0:
								switch(b.kind) {
									case 0:
										break
									case 1:
										//Get slope angle
										local a0 = abs(a.h / a.w)
										local a1 = abs(((a.y - a.h) - (b.y - b.h)) / ((a.x - a.w) - (b.x - b.w)))
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
							case 1:
								switch(b.kind) {
									case 0:
										break
									case 1:
										//Get slope angle
										local a0 = abs(a.h / a.w)
										local a1 = abs(((a.y - a.h) - (b.y - b.h)) / ((a.x - a.w) - (b.x - b.w)))
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

							case 2:
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

							case 3:
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

							case 4:
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

							case 5:
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