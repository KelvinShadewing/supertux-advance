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
}

::Spring <- class extends Actor {
	shape = 0
	dir = 0
	frame = 0.0
	fspeed = 0.0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		shape = Rec(x + 8, y + 8, 8, 8)
	}

	function run() {
		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)) {
				fspeed = 0.2
				switch(dir) {
					case 0: //Up
						gvPlayer.vspeed = -4
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

		if(floor(frame) > 2) {
			frame = 0.0
			fspeed = 0.0
		}

		switch(dir) { //Draw sprite based on direction
			case 0: //Up
				drawSprite(sprSpring, frame, x, y)
				break

			case 1:
				drawSpriteEx(sprSpring, frame, x, y + 16, 0, 2, 1, 1, 1)
				break
		}
	}
}