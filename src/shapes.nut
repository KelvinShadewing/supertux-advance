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

	constructor(_x, _y, _w, _h, _kind = 0, _ox = 0.0, _oy = 0.0) {
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

	function hitLine(x1, y1, x2, y2) {
		// Vector AB
		local ABx = x2 - x1
		local ABy = y2 - y1
		
		// Vector AC
		local ACx = x - x1
		local ACy = y - y1
		
		// Compute the dot product AB ⋅ AC
		local dotProduct = ABx * ACx + ABy * ACy
		
		// Compute the squared length of AB
		local lenABsq = ABx * ABx + ABy * ABy
		
		// Parameter along AB where closest to C
		local parameter = dotProduct / lenABsq
		
		// Clamp parameter to lie between 0 and 1
		parameter = math.min(math.max(parameter, 0), 1)
		
		// Closest point on the line segment to the circle center
		local closestX = x1 + parameter * ABx
		local closestY = y1 + parameter * ABy
		
		// Calculate distance squared between closest point and circle center
		local distanceSq = (x - closestX) * (x - closestX) + (y - closestY) * (y - closestY)
		
		// Check if the distance squared is less than or equal to the circle's radius squared
		return distanceSq <= r * r
	}

	function _typeof() { return "Cir" }
}

::Poly <- class {
	x = 0
	y = 0
	vertices = null
	
	// Constructor
	constructor(_x, _y, _vertices) {
		x = _x
		y = _y
		vertices = _vertices
	}
	
	function pointIn(px, py) {
		local intersections = 0
		print(typeof vertices)
		local numVertices = vertices.len()

		if(numVertices == 0)
			return false

		if(numVertices == 1)
			return (vertices[0][0] + x == px && vertices [0][1] + y == py)
		
		// Iterate through each edge of the polygon
		for (local i = 0; i < numVertices; i++) {
			local x1 = vertices[i][0] + x
			local y1 = vertices[i][1] + y
			local x2 = vertices[(i + 1) % numVertices][0] + x
			local y2 = vertices[(i + 1) % numVertices][1] + y
			
			// Check if the point is exactly on an edge
			if ((py == y1 && py == y2) &&
				(px > min(x1, x2) && px < max(x1, x2))) {
				return true
			}
			
			// Check for intersection with horizontal ray from point
			if ((py > min(y1, y2)) && (py <= max(y1, y2)) &&
				(px <= max(x1, x2)) &&
				(y1 != y2)) {
				
				local xIntersect = (py - y1) * (x2 - x1) / (y2 - y1) + x1
				if (x1 == x2 || px <= xIntersect) {
					intersections++
				}
			}
		}
		
		// If intersections are odd, point is inside the polygon
		return (intersections % 2) != 0
	}

	function _typeof() { return "Poly" }
}

::hitTest <- function(a, b) {
	switch(typeof a) {
		case "Rec":
			switch(typeof b) {
				case "Rec":
					//Make sure that rectangle bounding boxes are touching
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
					return hitTest(b, a)
					break

					//Still need to check for collisions with slopes and liquid

				case "Poly":
					// Check if any vertex of the polygon is inside the circle
					for (local i = 0; i < b.vertices.len(); i++) {
						local vertex = b.vertices[i]
						if (a.pointIn(vertex[0], vertex[1])) {
							return true
						}
					}
					
					// Check if the circle's center is inside the polygon
					if (b.pointIn(a.x, a.y)) {
						return true
					}
					
					// Check for edge intersections
					
					return false
					break

				case "Cir":
					return inDistance2(a.x, a.y, b.x, b.y, a.r + b.r)

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