::PlatformV <- class extends Actor {
	shape = 0
	r = 0 //Travel range
	w = 0 //Platform width
	ystart = 0
	mode = 0
	timer = 0
	mapshape = 0
	mapshapeid = 0
	init = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		ystart = _y
	}

	function run() {
		base.run()

		if(init == 1) { //If ready to initiate
			init = 0
			shape = Rec(x, y, w, 8, 0)
			mapshape = Rec(x, y, w, 8, 0)
			mapshapeid = mapNewSolid(mapshape)
		}

		//Draw shape
		if(w / 8 <= 1) drawSprite(tsWoodPlat, 0, x - 8 - camx, y - 8 - camy)
		else for(local i = 1; i <= w / 8; i++) {
			if(i == 1) drawSprite(tsWoodPlat, 1, (x - w) + ((i - 1) * 16) - camx, y - 8 - camy)
			else if(i == w / 8) drawSprite(tsWoodPlat, 3, (x - w) + ((i - 1) * 16) - camx, y - 8 - camy)
			else drawSprite(tsWoodPlat, 2, (x - w) + ((i - 1) * 16) - camx, y - 8 - camy)
		}

		//Movement
		mapshape.setPos(x, y)

		if(mode == 0) {
			shape.setPos(x, y - 1)
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.y--
			mapshape.setPos(x, y)

			if(y > ystart) y--
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
			if(y < ystart + r) y++
			else mode = 3
			mapshape.setPos(x, y)

			shape.setPos(x, y - 1)
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.y++

			shape.setPos(x, y)
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.y--

			shape.setPos(x, y + 2)
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.y += 2
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

::Spring <- class extends Actor {
	shape = 0
	dir = 0
	frame = 0.0
	fspeed = 0.0
	power = 10.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
		dir = _arr
	}

	function run() {
		base.run()

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) {
				fspeed = 0.2
				switch(dir) {
					case 0: //Up
						gvPlayer.vspeed = -power
						break

					case 1: //Down
						gvPlayer.vspeed = power
						break

					case 2: //Right
						gvPlayer.hspeed = (gvPlayer.hspeed > 4) ? gvPlayer.hspeed : power
						break

					case 3: //Left
						gvPlayer.hspeed = (gvPlayer.hspeed < -4) ? gvPlayer.hspeed : -power
						break
				}
				if(frame == 0.0) playSound(sndSpring, 0)
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
				drawSpriteEx(sprSpring, round(frame), x - camx, y - camy, 180, 0, 1, 1, 1)
				break

			case 2: //Right
				drawSpriteEx(sprSpring, round(frame), x - camx, y - camy, 90, 0, 1, 1, 1)
				break

			case 3: //Left
				drawSpriteEx(sprSpring, round(frame), x - camx, y - camy, 270, 0, 1, 1, 1)
				break
		}

		if(debug) shape.draw()
	}

	function _typeof() { return "Spring" }
}

::SpringD <- class extends Actor {
	shape = 0
	dir = 0
	frame = 0.0
	fspeed = 0.0
	power = 10.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
		dir = _arr
	}

	function run() {
		base.run()

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) {
				fspeed = 0.2
				switch(dir) {
					case 0: //Up Right
						gvPlayer.vspeed = -power * 0.8
						gvPlayer.hspeed = power * 0.6
						break

					case 1: //Down Right
						gvPlayer.vspeed = power * 0.7
						gvPlayer.hspeed = power * 0.7
						break

					case 2: //Down Left
						gvPlayer.hspeed = -power * 0.7
						gvPlayer.vspeed = power * 0.7
						break

					case 3: //Up Left
						gvPlayer.hspeed = -power * 0.6
						gvPlayer.vspeed = -power * 0.8
						break
				}
				if(frame == 0.0) playSound(sndSpring, 0)
			}
		}

		frame += fspeed
		if(floor(frame) > 3) {
			frame = 0.0
			fspeed = 0.0
		}

		switch(dir) { //Draw sprite based on direction
			case 0: //Up
				drawSprite(sprSpringD, round(frame), x - camx, y - camy)
				break

			case 1: //Down
				drawSpriteEx(sprSpringD, round(frame), x - camx, y - camy, 90, 0, 1, 1, 1)
				break

			case 2: //Right
				drawSpriteEx(sprSpringD, round(frame), x - camx, y - camy, 180, 0, 1, 1, 1)
				break

			case 3: //Left
				drawSpriteEx(sprSpringD, round(frame), x - camx, y - camy, 270, 0, 1, 1, 1)
				break
		}

		if(debug) shape.draw()
	}

	function _typeof() { return "Spring" }
}

::LevelSinker <- class extends Actor {
	rate = 0.01

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null) rate = _arr
	}

	function run() {
		if(gvMap.h > 240) gvMap.h -= rate
	}
}

::sinkLevel <- function(rate) { newActor(LevelSinker,0, 0, rate) }

::FireChain <- class extends Actor {
	r = 0
	a = 0.0
	s = 0.0
	hb = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		r = _arr[0].tointeger()
		a = _arr[1].tofloat()
		s = _arr[2].tofloat()
		hb = (Cir(x, y, 6))
	}

	function run() {
		//Rotate chain
		//s = sin(getFrames() / 5.0) * 4.0 //Save for flamethrower animation
		if(gvPlayer) if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, screenW() * 0.8)) return
		a += s

		if(r > 0) for(local i = 0; i < r; i++) {
			hb.setPos(x + (i * 8) * cos((2 * pi) + (a / 60.0 - i * s / 45.0)), y + (i * 8) * sin((2 * pi) + (a / 60.0 - i * s / 45.0)))
			drawSprite(sprFireball, getFrames() / 4, hb.x - camx, hb.y - camy)
			drawLightEx(sprLightFire, 0, hb.x - camx, hb.y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)

			if((i - 1) % 2 == 0) {
				if(gvPlayer) if(hitTest(hb, gvPlayer.shape)) {
					gvPlayer.hurt = 2
				}
			}

			if(randInt(60) == 0) {
				local c = actor[newActor(FlameTiny, hb.x, hb.y)]
				c.vspeed = -0.25
				c.hspeed = randFloat(0.5) - 0.25
			}
		}

		if(debug) drawText(font, x - camx, y - camy, wrap(a, 0, 360).tostring())
	}
}

::PathCarrier <- class extends PathCrawler {
	obj = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		local newarr = []
		if(_arr.len() > 3) for(local i = 3; i < _arr.len(); i++) newarr.push(_arr[i])
		if(getroottable().rawin(_arr[2])) obj = newActor(getroottable()[_arr[2]], x, y, newarr)
	}

	function run() {
		local dorun = true
		//Check for conditions that should hold the object in place
		if(actor[obj].rawin("frozen")) if(actor[obj].frozen > 0) dorun = false
		if(dorun) base.run()

		if(checkActor(obj)) {
			actor[obj].x = x
			actor[obj].y = y
		} else deleteActor(id)
	}
}

::RingCarrier <- class extends Actor {
	r = 0.0 //Radius
	c = 0.0 //Count
	s = 0.0 //Speed
	a = null //Angle
	l = null //List
	sa = 0.0 //Start angle

	constructor(_x, _y, _arr = null) {
		x = _x
		y = _y
		base.constructor(_x, _y)
		r = _arr[0].tofloat()
		c = _arr[1].tointeger()
		s = _arr[2].tofloat()
		sa = _arr[4].tofloat()

		local newarr = []
		a = []
		if(_arr.len() > 4) for(local i = 4; i < _arr.len(); i++) newarr.push(_arr[i])
		if(newarr.len() == 1) newarr = newarr[0]

		l = []
		if(c == 0) deleteActor(id)
		else for(local i = 0; i < c; i++) {
			l.push(newActor(getroottable()[_arr[3]], x, y, newarr))
			a.push((360.0 / c) * i / 180.0 * pi)
			a[i] += sa
		}
	}

	function run() {
		local cl = c //Coins left
		for(local i = 0; i < c; i++) {
			if(checkActor(l[i])) {
				actor[l[i]].x = x + r * cos((2 * pi / c) + a[i])
				actor[l[i]].y = y + r * sin((2 * pi / c) + a[i])

				local canrotate = true
				if(actor[l[i]].rawin("frozen")) if(actor[l[i]].frozen > 0) canrotate = false
				if(canrotate) a[i] += s / 60.0
			}
			else cl--
		}
		if(cl == 0) deleteActor(id)
	}
}