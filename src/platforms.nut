::PlatformV <- class extends Actor {
	shape = 0
	r = 0 //Travel range
	ystart = 0
	mode = 0
	timer = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)

		ystart = _y
	}

	function init(w, _r) {
		shape = Rec(x, y, w, 8)
		r = _r
	}

	function run() {
		base.run()

		if(mode == 0) {
			if(y > ystart - r) y--
			else mode = 1
		}
		else if(mode == 1) {
			if(timer < 60) timer++
			else {
				timer = 0
				mode = 2
			}
		}
		else if(mode == 2) {
			if(y < ystart + x) y++
			else mode = 3
		}
		else {
			if(timer < 60) timer++
			else {
				timer = 0
				mode = 0
			}
		}
	}
}

::Ladder <- class extends Actor {
	shape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
	}

	function _typeof() {return "Ladder" }
}

::Spring <- class extends Actor {
	shape = 0
	dir = 0
	frame = 0.0
	fspeed = 0.0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		shape = Rec(x + 8, y + 8, 4, 4, 0)
	}

	function run() {
		base.run()

		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)) {
				fspeed = 0.2
				switch(dir) {
					case 0: //Up
						gvPlayer.vspeed = -5
						break

					case 1: //Down
						gvPlayer.vspeed = 4
						break

					case 2: //Right
						gvPlayer.hspeed = 4
						break

					case 3: //Left
						gvPlayer.hspeed = -4
						break
				}
			}
		}

		frame += fspeed
		if(floor(frame) > 3) {
			frame = 0.0
			fspeed = 0.0
		}

		switch(dir) { //Draw sprite based on direction
			case 0: //Up
				drawSprite(sprSpring, round(frame), x - camx, y - camy)
				break

			case 1: //Down
				drawSpriteEx(sprSpring, round(frame), x + 16 - camx, y + 14 - camy, 180, 0, 1, 1, 1)
				break

			case 2: //Right
				drawSpriteEx(sprSpring, round(frame), x + 14 - camx, y - camy, 90, 0, 1, 1, 1)
				break

			case 3: //Left
				drawSpriteEx(sprSpring, round(frame), x - camx + 2, y + 16 - camy, 270, 0, 1, 1, 1)
				break
		}

		if(debug) shape.draw()
	}
}