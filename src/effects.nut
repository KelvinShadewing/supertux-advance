::Spark <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = 45* randInt(8)
	}
	function run() {
		frame += 0.25
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprSpark, floor(frame), x - camx, y - camy, 45 * randInt(8), 0, 1, 1, 1)
	}
}

::Glimmer <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = 45 * randInt(8)
	}
	function run() {
		frame += 0.25
		if(frame >= 3) deleteActor(id)
		else drawSpriteEx(sprGlimmer, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
	}
}

::Poof <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}
	function run() {
		frame += 0.125
		if(frame >= 4) deleteActor(id)
		else drawSpriteEx(sprPoof, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}

::Flame <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}
	function run() {
		frame += 0.125
		if(frame >= 8) deleteActor(id)
		else drawSpriteEx(sprFlame, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}

::FlameTiny <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		frame += 0.2
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprFlameTiny, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
	}
}

::CoinEffect <- class extends Actor {
	vspeed = -4.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		playSound(sndCoin, 0)
		game.levelcoins++
	}

	function run() {
		vspeed += 0.3
		y += vspeed
		drawSprite(sprCoin, getFrames() / 2, x - camx, y - camy)
		if(vspeed >= 2) {
			deleteActor(id)
			newActor(Spark, x, y)
		}
	}
}

::IceChunks <- class extends Actor {
	h = 0.0
	v = 0.0
	vspeed = -3.0
	timer = 30
	a = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		playSound(sndIceBreak, 0)
	}

	function run() {
		vspeed += 0.2
		v += vspeed
		h += 1
		a += 4

		drawSpriteEx(sprIceChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)

		timer--
		if(timer == 0) deleteActor(id)
	}
}

::Heal <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		if(frame < 1) frame += 0.02
		frame += 0.05
		y -= 0.5
		if(frame >= 3) deleteActor(id)
		else drawSpriteEx(sprHeal, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}