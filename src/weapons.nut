::Fireball <- class extends PhysAct {
	timer = 90

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
			else deleteActor(id)
		}
		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.99
			vspeed *= 0.99
		}

		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x + hspeed, y - 4)) {
			x += hspeed
			y += -4
			vspeed = -1
		} else if(inWater(x, y)) hspeed = -hspeed
		else deleteActor(id)

		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		if(hspeed > 0) drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 0, 1, 1, 1)
		else drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 1, 1, 1, 1)

		if(getFrames() % 3 == 0) {
			local c = actor[newActor(FlameTiny, x, y)]
			c.frame = 4
		}

		shape.setPos(x, y)
	}

	function _typeof() {return "Fireball"}
}

::Iceball <- class extends PhysAct {
	timer = 90

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
			else deleteActor(id)
		}
		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.99
			vspeed *= 0.99
		}

		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x + hspeed, y - 2)) {
			x += hspeed
			y += -2
			vspeed = -1
		} else if(inWater(x, y)) hspeed = -hspeed
		else deleteActor(id)

		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		drawSprite(sprIceball, getFrames() / 2, x - camx, y - camy)

		if(getFrames() % 5 == 0) newActor(Glimmer, x - 4 + randInt(8), y - 4 + randInt(8))

		shape.setPos(x, y)
	}

	function _typeof() {return "Iceball"}
}

::FlameBreath <- class extends PhysAct {
	frame = 0.0
	angle = 0

	constructor(_x, _y, _arr = null) {
		shape = Rec(x, y, 4, 4, 0)
		base.constructor(_x, _y)
		vspeed = 0.5 - randFloat(1.0)
	}
	function run() {
		angle = pointAngle(0, 0, hspeed, vspeed) - 90
		frame += 0.2
		x += hspeed
		y += vspeed
		shape.setPos(x, y)
		if(!placeFree(x, y)) deleteActor(id)
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprFlameTiny, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
	}

	function _typeof() { return "FlameBreath" }
}