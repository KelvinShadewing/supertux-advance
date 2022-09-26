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
				if(frame == 0.0) popSound(sndSpring, 0)
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
				if(frame == 0.0) popSound(sndSpring, 0)
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
				local ins = actor[l[i]]
				ins.x = x + r * cos((2 * pi / c) + a[i])
				ins.y = y + r * sin((2 * pi / c) + a[i])

				if(ins.rawin("vspeed")) ins.vspeed = 0
				if(ins.rawin("hspeed")) ins.hspeed = 0

				local canrotate = true
				if(ins.rawin("frozen")) if(actor[l[i]].frozen > 0) canrotate = false
				if(canrotate) a[i] += s / 60.0
			}
			else cl--
		}
		if(cl == 0) deleteActor(id)
	}
}

//Moving platform
::MoPlat <- class extends PathCrawler {
	shape = 0
	w = 1
	sprite = sprPlatformWood

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		w = max(1, _arr[2].tointeger())
		if(_arr.len() > 3 && getroottable().rawin(_arr[3])) sprite = getroottable()[_arr[3]]
		if(_arr.len() > 3 && (_arr[3] == 0 || _arr[3] == "0")) sprite = 0
		shape = Rec(x, y, w * 8, 4, 0)
		//mapNewSolid(shape)
	}

	function run() {
		base.run()
		shape.setPos(x, y)

		if(w == 1) drawSprite(sprite, 0, x - camx, y - camy)
		else for(local i = 0; i < w; i++) {
			if(i == 0) drawSpriteZ(6, sprite, 1, x - (w * 8) + (i * 16) - camx + 8, y - camy)
			else if(i == w - 1) drawSpriteZ(6, sprite, 3, x - (w * 8) + (i * 16) - camx + 8, y - camy)
			else drawSpriteZ(6, sprite, 2, x - (w * 8) + (i * 16) - camx + 8, y - camy)
		}

		if(debug) {
			setDrawColor(0x008080ff)
			shape.draw()
		}
	}

	function destructor() {
		//mapDeleteSolid(shape)
	}

	function _typeof() { return "MoPlat" }
}

::Portal <- class extends Actor {
	shapeA = 0
	shapeB = 0
	canWarp = true
	sprite = sprPortalGray
	angleA = 0
	angleB = 0
	color = 0x808080ff

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)

		shapeA = Cir(x, y, 12)
		shapeB = Cir(x, y, 12)

		if(_arr[0].len() > 0) {
			shapeA.setPos(_arr[0][0][0], _arr[0][0][1])
			shapeB.setPos(_arr[0][_arr[0].len() - 1][0], _arr[0][_arr[0].len() - 1][1])
		}

		switch(_arr[1]) {
			case "blue":
				sprite = sprPortalBlue
				color = 0x0000f8ff
				break
			case "red":
				sprite = sprPortalRed
				color = 0xf80000ff
				break
			case "green":
				sprite = sprPortalGreen
				color = 0x008000ff
				break
			case "yellow":
				sprite = sprPortalYellow
				color = 0xf8f800ff
				break
			case "punkle":
				sprite = sprPortalPunkle
				color = 0xf800f8ff
				break
		}

		angleA = _arr[2].tofloat()
		angleB = _arr[3].tofloat()
	}

	function run() {
		drawSpriteEx(sprite, getFrames() / 4, shapeA.x - camx, shapeA.y - camy, angleA, 0, 1, 1, 1)
		drawSpriteEx(sprite, getFrames() / 4, shapeB.x - camx, shapeB.y - camy, angleB, 0, 1, 1, 1)
		if(debug) {
			setDrawColor(color)
			drawLine(shapeA.x - camx, shapeA.y - camy, shapeB.x - camx, shapeB.y - camy)
		}

		if(gvPlayer) {
			if(canWarp) {
				if(hitTest(shapeA, gvPlayer.shape)) {
					local theta = pointAngle(0, 0, gvPlayer.hspeed, gvPlayer.vspeed)
					local mag = distance2(0, 0, gvPlayer.hspeed, gvPlayer.vspeed)
					theta += (angleB - angleA) + 180
					gvPlayer.hspeed = lendirX(mag, theta) * 1.5
					gvPlayer.vspeed = lendirY(mag, theta) * 1.5
					playerTeleport(shapeB.x + lendirX(gvPlayer.shape.w, angleB), shapeB.y + lendirY(gvPlayer.shape.h, angleB) - gvPlayer.shape.oy)
					canWarp = false
				}

				if(hitTest(shapeB, gvPlayer.shape)) {
					local theta = pointAngle(0, 0, gvPlayer.hspeed, gvPlayer.vspeed)
					local mag = distance2(0, 0, gvPlayer.hspeed, gvPlayer.vspeed)
					theta += (angleA - angleB) + 180
					gvPlayer.hspeed = lendirX(mag, theta) * 1.5
					gvPlayer.vspeed = lendirY(mag, theta) * 1.5
					playerTeleport(shapeA.x + lendirX(gvPlayer.shape.w, angleA), shapeA.y + lendirY(gvPlayer.shape.h, angleA) - gvPlayer.shape.oy)
					canWarp = false
				}
			}
			//If the player has left the portal, allow reentry
			else if(!hitTest(shapeA, gvPlayer.shape) && !hitTest(shapeB, gvPlayer.shape)) canWarp = true
		}
	}
}