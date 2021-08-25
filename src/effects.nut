::Spark <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}
	function run() {
		frame += 0.25
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprSpark, floor(frame), x - camx, y - camy, (360 / 8) * randInt(8), 0, 1, 1, 1)
	}
}

::Poof <- class extends Actor {
	frame = 0.0
	angle = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		angle = (360 / 8) * randInt(8)
	}
	function run() {
		frame += 0.125
		if(frame >= 4) deleteActor(id)
		else drawSpriteEx(sprPoof, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}

::CoinEffect <- class extends Actor {
	vspeed = -4.0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		playSound(sndCoin, 0)
		game.coins++
	}

	function run() {
		vspeed += 0.3
		y += vspeed
		drawSprite(sprCoin, getFrames(), x - camx, y - camy)
		if(vspeed >= 2) {
			deleteActor(id)
			newActor(Spark, x, y)
		}
	}
}