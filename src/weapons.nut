::Fireball <- class extends PhysAct {
	gravity = 0.1

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
	}

	function run() {
		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
			else deleteActor(id)
		}
		vspeed += gravity

		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x + hspeed, y - 2)) {
			x += hspeed
			y += -2
			vspeed = -1
		} else deleteActor(id)

		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h || inWater(x, y)) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		if(hspeed > 0) drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 0, 1, 1, 1)
		else drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 1, 1, 1, 1)

		shape.setPos(x, y)
	}

	function _typeof () {return "Fireball"}
}

::Iceball <- class extends PhysAct {
	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
	}

	function run() {
		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
			else deleteActor(id)
		}
		vspeed += 0.1

		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x + hspeed, y - 2)) {
			x += hspeed
			y += -2
			vspeed = -1
		} else deleteActor(id)

		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h || inWater(x, y)) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		drawSprite(sprIceball, getFrames() / 2, x - camx, y - camy)

		if(getFrames() % 5 == 0) newActor(Glimmer, x - 4 + randInt(8), y - 4 + randInt(8))

		shape.setPos(x, y)
	}

	function _typeof () {return "Iceball"}
}