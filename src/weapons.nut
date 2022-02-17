::Fireball <- class extends PhysAct {
	timer = 90

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
		newActor(AfterFlame, x, y)
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
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)

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
		newActor(AfterIce, x, y)
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
		newActor(AfterFlame, x, y)
	}
	function run() {
		angle = pointAngle(0, 0, hspeed, vspeed) - 90
		frame += 0.2
		x += hspeed
		y += vspeed
		if(gvPlayer) x += gvPlayer.hspeed
		shape.setPos(x, y)
		if(!placeFree(x, y)) deleteActor(id)
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprFlameTiny, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function _typeof() { return "Fireball" }
}

::IceBreath <- class extends PhysAct {
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
		if(gvPlayer) x += gvPlayer.hspeed
		shape.setPos(x, y)
		if(!placeFree(x, y)) deleteActor(id)
		if(frame >= 6) deleteActor(id)
		else drawSpriteEx(sprGlimmer, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
	}

	function _typeof() { return "Iceball" }
}

::ExplodeF <- class extends Actor{
	frame = 0.0
	shape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		stopSound(sndExplodeF)
		playSound(sndExplodeF, 0)

		shape = Cir(x, y, 16)
	}

	function run() {
		drawSpriteEx(sprExplodeF, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		frame += 0.2

		if(frame >= 1) {
			if(actor.rawin("TNT")) foreach(i in actor["TNT"]) {
				if(hitTest(shape, i.shape)) {
					newActor(BadExplode, i.x, i.y)
					tileSetSolid(i.x, i.y, 0)
					deleteActor(i.id)
				}
			}
		}
		if(frame >= 5) deleteActor(id)
	}

	function _typeof() { return "ExplodeF" }
}

::ExplodeN <- class extends Actor{
	frame = 0.0
	shape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		stopSound(sndBump)
		playSound(sndBump, 0)

		shape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		drawSpriteEx(sprExplodeN, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		frame += 0.2

		if(frame >= 5) deleteActor(id)
	}

	function _typeof() { return "ExplodeN" }
}

::StompPoof <- class extends Actor{
	frame = 0.0
	shape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		stopSound(sndBump)
		playSound(sndBump, 0)

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {
		drawSpriteEx(sprPoof, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		frame += 0.2

		if(frame >= 4) deleteActor(id)
	}

	function _typeof() { return "ExplodeN" }
}


::FireballK <- class extends PhysAct {
	timer = 90
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Cir(x, y, 4)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			newActor(ExplodeF, x, y)
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed) - 90

		if(hspeed > 0) drawSpriteEx(sprFlame, (getFrames() / 8) % 4, x - camx, y - camy, angle, 0, 1, 1, 1)
		else drawSpriteEx(sprFlame, (getFrames() / 8) % 4, x - camx, y - camy, angle, 1, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 4.0, 1.0 / 4.0)

		shape.setPos(x, y)
	}

	function _typeof() { return "FireballK" }
}

//When a fireball spawns in a wall, they die before blocks can respond. This is to mitigate that.
::AfterFlame <- class extends PhysAct {
	timer = 4

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}

	function _typeof() { return "Fireball" }
}

::AfterIce <- class extends PhysAct {
	timer = 4

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}

	function _typeof() { return "Iceball" }
}