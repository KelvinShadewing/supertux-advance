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
