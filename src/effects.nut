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
	}

	function draw() { drawSpriteZ(4, sprSpark, floor(frame), x - camx, y - camy, 45 * randInt(8), 0, 1, 1, 1) }
}

::BigSpark <- class extends Actor {
	frame = 0.0
	flip = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null && _arr != "") flip = _arr.tointeger()
	}

	function run() {
		frame += 0.25
		if(frame >= 6) deleteActor(id)
	}

	function draw() { drawSpriteZ(4, sprBigSpark, floor(frame), x - camx, y - camy, 0, flip, 1, 1, 1) }
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
	}

	function draw() { drawSpriteZ(4, sprGlimmer, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1) }
}

::Poof <- class extends Actor {
	frame = 0.0
	angle = 0
	depth = 7
	hspeed = 0
	vspeed = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
		if(typeof _arr == "integer") depth = _arr
	}

	function run() {
		frame += 0.125
		if(frame >= 4) deleteActor(id)
		x += hspeed
		y += vspeed
	}

	function draw() { drawSpriteZ(depth, sprPoof, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::PoofTiny <- class extends Actor {
	frame = 0.0
	angle = 0
	depth = 7
	hspeed = 0
	vspeed = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}

	function run() {
		frame += 0.25
		if(frame >= 4) deleteActor(id)
		x += hspeed
		y += vspeed
	}

	function draw() { drawSpriteZ(depth, sprPoof, floor(frame), x - camx, y - camy, 0, 0, 0.5, 0.5, 1) }
}

::Flame <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}
	function run() {
		frame += 0.25
		if(frame >= 8) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(7, sprFlame, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
	}

	function _typeof() { return "Flame" }
}

::Splash <- class extends Actor {
	frame = 0.0
	angle = 0
	sprite = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
		popSound(sndSplash)
		switch(_arr) {
			case "lava":
				sprite = sprLavaSplash
				break
			case "acid":
				sprite = sprAcidSplash
				break
			default:
				sprite = sprSplash
				break
		}
	}

	function run() {
		frame += 0.25
		if(frame >= 4) deleteActor(id)
	}

	function draw() { drawSpriteZ(7, sprite, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 0.8) }
}

::FlameTiny <- class extends Actor {
	frame = 0.0
	angle = 0
	hspeed = 0.0
	vspeed = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		x += hspeed
		y += vspeed
		frame += 0.25
		if(frame >= 6) deleteActor(id)
	}

	function draw() {
		drawSpriteEx(sprFlameTiny, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy + 2, 0, 0, (1.0 / 6.0) - (frame / 32.0), (1.0 / 6.0) - (frame / 32.0))
	}
}

::Bubble <- class extends Actor {
	frame = 0.0
	angle = 0
	hspeed = 0.0
	vspeed = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		x += hspeed
		y += vspeed
		frame += 0.25
		if(frame >= 6) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(6, sprBubble, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
	}
}

::AcidBubble <- class extends Actor {
	frame = 0.0
	angle = 0
	hspeed = 0.0
	vspeed = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		x += hspeed
		y += vspeed
		frame += 0.25
		if(frame >= 6) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(6, sprBubble, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1, 0xa0c838ff)
	}
}

::CoinEffect <- class extends Actor {
	vspeed = -6.0
	value = 1

	constructor(_x, _y, _arr = null) {
		if(_arr == 5) value = 5
		else if(_arr == 10) value = 10
		game.levelCoins += value
		base.constructor(_x, _y)
		popSound(sndCoin, 0)
	}

	function run() {
		vspeed += 0.5
		y += vspeed

		if(vspeed >= 3) {
			deleteActor(id)
			newActor(Spark, x, y)
		}
	}

	function draw() {
		if(value == 10) drawSpriteZ(4, sprCoin10, getFrames() / 2, x - camx, y - camy)
		else if(value == 5) drawSpriteZ(4, sprCoin5, getFrames() / 2, x - camx, y - camy)
		else drawSpriteZ(4, sprCoin, getFrames() / 2, x - camx, y - camy)
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
		popSound(sndIceBreak, 0)
	}

	function run() {
		vspeed += 0.2
		v += vspeed
		h += 1
		a += 4

		timer--
		if(timer == 0) deleteActor(id)
	}

	function draw() {
		drawSpriteEx(sprIceChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteEx(sprIceChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)
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
	}

	function draw() { drawSpriteZ(4, sprHeal, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::HealMana <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		if(frame < 1) frame += 0.02
		frame += 0.05
		y -= 0.5
		if(frame >= 3) deleteActor(id)
	}

	function draw() { drawSpriteZ(4, sprHealMana, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::HealStamina <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		if(frame < 1) frame += 0.02
		frame += 0.05
		y -= 0.5
		if(frame >= 3) deleteActor(id)
	}

	function draw() { drawSpriteZ(4, sprHealStamina, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::GoldCharge <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		frame += 0.25
		y -= 1
		if(frame >= 4) deleteActor(id)
	}

	function draw() { drawSpriteZ(4, sprGoldCharge, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::AfterImage <- class extends Actor {
	sprite = 0
	frame = 0
	alpha = 1.0
	depth = 0
	flip = 0
	angle = 0
	xscale = 0
	yscale = 0
	mod = 0

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)
		sprite = _arr[0]
		frame = _arr[1]
		depth = _arr[2]
		flip = _arr[3]
		angle = _arr[4]
		xscale = _arr[5]
		yscale = _arr[6]
		if(_arr.len() > 7)
			alpha = _arr[7]
		mod = getFrames() % 2
	}

	function run() {
		alpha -= 0.2
		if(alpha <= 0) deleteActor(id)
	}

	function draw() { drawSpriteZ(depth, sprite, frame, x - camx, y - camy, angle, flip, xscale, yscale, alpha) }
}

::RockChunks <- class extends Actor {
	h = 0.0
	v = 0.0
	vspeed = -3.0
	timer = 30
	a = 0

	function run() {
		vspeed += 0.25
		v += vspeed
		h += 0.5
		a += 4

		timer--
		if(timer == 0) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(2, sprRock, 1, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprRock, 2, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteZ(2, sprRock, 3, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprRock, 4, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)
	}
}