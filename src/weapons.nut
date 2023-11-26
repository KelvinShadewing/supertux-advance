/////////////////
// NEW WEAPONS //
/////////////////

//All weapons will use the same return type
//Different weapons will have different stats for enemies to react to

::fireWeapon <- function(weapon, x, y, alignment, owner) {
	local c = actor[newActor(weapon, x, y, [alignment, owner])]
	c.alignment = alignment
	c.owner = owner
	return c
}

::WeaponEffect <- class extends PhysAct {
	power = 1
	element = "normal"
	cut = false
	blast = false
	piercing = 0
	owner = 0
	alignment = 0 //0 is neutral, 1 is player, 2 is enemy
	box = false //If the attack comes from a box
	didHit = false

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)
		if(typeof _arr == "array") {
			if(canint(_arr[0])) alignment = _arr[0].tointeger()
			if(canint(_arr[1])) owner = _arr[1].tointeger()
		}
	}

	function _typeof() { return "WeaponEffect" }
}

////////////////////
// NORMAL ATTACKS //
////////////////////

::MeleeHit <- class extends WeaponEffect {
	element = "normal"
	timer = 4

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}
}

::BoxHit <- class extends WeaponEffect {
	element = "normal"
	timer = 4
	box = true
	piercing = -1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}

	function draw() { if(debug) drawSprite(sprPoof, 0, x - camx, y - camy - 8) }
}

::StompPoof <- class extends WeaponEffect{
	power = 1
	piercing = -1
	frame = 0.0
	shape = 0
	blast = true
	altShape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 8, 8, 0)
		altShape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		frame += 0.2
		if(frame >= 2) power = 0
		if(frame >= 4) deleteActor(id)
	}

	function draw() { drawSpriteEx(sprPoof, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1) }
}

::ExplodeN <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeN, 0)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeN, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightGradient, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeN2 <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeN, 0)

		shape = Cir(x, y, 24.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 96) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 96) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeN2, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightGradient, 0, x - camx, y - camy, 0, 0, 1.0 - (frame / 10.0), 1.0 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeN3 <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeN, 0)

		shape = Cir(x, y, 36.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 96) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 96) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeN3, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightGradient, 0, x - camx, y - camy, 0, 0, 1.0 - (frame / 10.0), 1.0 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::RollingSlash <- class extends WeaponEffect{
	power = 2
	frame = 0.0
	shape = 0
	cut = true
	piercing = -1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCyraSwordSwing, 0)

		shape = Cir(x, y, 32.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)
		if(checkActor(owner)) {
			x = actor[owner].x + actor[owner].hspeed
			y = actor[owner].y + actor[owner].vspeed
			shape.setPos(x, y)
		}
	}

	function draw() {
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::InstaShield <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	sprite = 0
	angle = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndThrow, 0)

		shape = Cir(x, y, 16.0)

		sprite = sprShieldInsta
	}

	function run() {
		frame += 0.5

		if(frame >= 4) deleteActor(id)
		if(checkActor(owner)) {
			x = actor[owner].x
			y = actor[owner].y
			shape.setPos(x, y)
		}

		if(didHit && checkActor(owner) && "didAirSpecial" in actor[owner]) {
			actor[owner].didAirSpecial = false
			actor[owner].vspeed = min(-fabs(actor[owner].vspeed), -4.0)
			actor[owner].antigrav = 0
			actor[owner].homingTarget = 0
		}
	}

	function draw() {
		drawSpriteZ(4, sprite, frame, x - camx, y - camy, angle)
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

//////////////////
// FIRE ATTACKS //
//////////////////

::Fireball <- class extends WeaponEffect {
	element = "fire"
	timer = 90
	piercing = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
	}

	function physics() {
		//Shrink hitbox
		timer--
		if(timer == 0) deleteActor(id)
		if(!placeFree(x, y))
			deleteActor(id)

		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
		}
		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.99
			vspeed *= 0.99
		}

		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x, y - 2)) {
			x += hspeed
			y += -2
			vspeed = -1
		}
		if(!placeFree(x, y)) deleteActor(id)

		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h || piercing < 0) deleteActor(id)

		shape.setPos(x, y)
	}

	function draw()  {
		drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, int(hspeed > 0), 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function animation() {
		if(getFrames() % 3 == 0) {
			local c = actor[newActor(FlameTiny, x, y)]
			c.frame = 4
		}
	}

	function destructor() {
		fireWeapon(AfterFlame, x + hspeed, y + vspeed, alignment, owner)
	}
}

::AfterFlame <- class extends WeaponEffect {
	element = "fire"
	timer = 2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}
}

::FlameBreath <- class extends WeaponEffect {
	element = "fire"
	frame = 0.0
	angle = 0
	power = 1.0
	piercing = 0

	constructor(_x, _y, _arr = null) {
		shape = Rec(x, y, 4, 4, 0)
		base.constructor(_x, _y, _arr)
		vspeed = 0.5 - randFloat(1.0)
		fireWeapon(AfterFlame, x, y, alignment, owner)
	}

	function run() {
		angle = pointAngle(0, 0, hspeed, vspeed) - 90
		frame += 0.2
		x += hspeed
		y += vspeed
		if(checkActor(owner)) {
			x += actor[owner].hspeed
			y += actor[owner].vspeed / 2
		}
		shape.setPos(x, y)
		if(!placeFree(x, y)) deleteActor(id)
		if(frame >= 6) deleteActor(id)
	}

	function draw() {
		drawSpriteEx(sprFlameTiny, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}
}

::FireballK <- class extends WeaponEffect {
	timer = 90
	angle = 0
	element = "fire"
	power = 1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 2)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(inWater(x, y)) {
			vspeed *= 0.99
			hspeed *= 0.99
		}
		else
			vspeed += 0.1

		x += hspeed
		y += vspeed
		if(!placeFree(x, y))
			deleteActor(id)

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed) - 90

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteEx(sprFlame, (getFrames() / 4) % 4, x - camx, y - camy, angle, 1, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 4.0, 1.0 / 4.0)
	}

	function destructor() {
		local c = fireWeapon(ExplodeF, x, y, alignment, owner)
		c.power = power
	}
}

::ExplodeF <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "fire"
	power = 2
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		stopSound(sndExplodeF)
		playSound(sndExplodeF, 0)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeF, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, getFrames() / 4, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeF2 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "fire"
	power = 2
	blast = true
	altShape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeF2)

		shape = Cir(x, y, 8.0)
		altShape = Cir(x, y, 2.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)
		if(altShape.r < 16) altShape.r++
		if(shape.r < 24) shape.r++

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeF2, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, getFrames() / 4, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeF3 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "fire"
	power = 2
	blast = true
	altShape = null
	didbloom = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeF2)

		shape = Cir(x, y, 8.0)
		altShape = Cir(x, y, 2.0)
		for(local i = 0; i < 16; i++) {
			local d = actor[newActor(FlameTiny, x + lendirX(randInt(8) + 16, i * 22.5), y + lendirY(randInt(8) + 16, i * 22.5))]
			d.hspeed = 1.0 - randFloat(2.0)
			d.vspeed = 1.0 - randFloat(2.0)
			d.frame = -2.0 - randFloat(4.0)
		}
	}

	function run() {
		frame += 0.2

		if(frame >= 1 && !didbloom) {
			didbloom = true
			local c = null
			c = fireWeapon(FireballK, x - 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = -2.0
			c = fireWeapon(FireballK, x + 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = -2.0
			c = fireWeapon(FireballK, x - 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = 2.0
			c = fireWeapon(FireballK, x + 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = 2.0
		}

		if(frame >= 5) deleteActor(id)
		if(altShape.r < 16) altShape.r++
		if(shape.r < 24) shape.r++

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeF2, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, getFrames() / 4, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeHiddenF <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "fire"
	power = 2
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeN, 0)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::FuseSpark <- class extends WeaponEffect {
	element = "fire"
	power = 0
	piercing = -1

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)
		shape = Cir(x, y, 2)
	}

	function run() {
		shape.setPos(x, y)
		if(getFrames() % 4 == 0) newActor(FlameTiny, x - 1 + randInt(3), y - 1 + randInt(3))
	}

	function draw() { drawSprite(sprFireball, getFrames(), x - camx, y - camy) }
}

::FuseLine <- class extends PathCrawler {
	speed = 0
	obj = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Cir(x, y, 8)
	}

	function run() {
		base.run()

		if(speed == 0 && "WeaponEffect" in actor && actor["WeaponEffect"].len() > 0) foreach(i in actor["WeaponEffect"]) {
			if(hitTest(shape, i.shape) && i.element == "fire") {
				speed = 2
				obj = fireWeapon(FuseSpark, x, y, 0, id)
				i.piercing--
			}
		}

		if(obj != 0) {
			obj.x = x
			obj.y = y
		}
	}

	function draw() { if(speed == 0) drawSprite(sprSteelBall, 0, x - camx, y - camy) }

	function pathEnd() {
		deleteActor(obj.id)
		deleteActor(id)
	}
}

::DashFlame <- class extends WeaponEffect {
	flip = 0
	element = "fire"
	power = 1
	piercing = 0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 14, 4, 0)
		flip = -1
	}

	function run() {
		if(checkActor(owner)) {
			x = actor[owner].x + (actor[owner].hspeed * 2.0)
			y += (actor[owner].vspeed) / 2.0
			if(flip == -1)
				flip = int(actor[owner].hspeed < 0)
		}
		else
			flip = 0

		shape.setPos(x, y)
		frame += 0.25
		if(frame > 1)
			deleteActor(id)
	}

	function draw() {
		drawSpriteZ(3, sprShieldFire, -floor(frame + 1.0), x - camx, y - camy, 90, flip * 2, 0.8, 0.8)
	}
}

::ExplodeTiny <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "fire"
	power = 0
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeTiny)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.8
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.8
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 1.5
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeTiny, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

/////////////////
// ICE ATTACKS //
/////////////////

::Iceball <- class extends WeaponEffect {
	element = "ice"
	timer = 90

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
	}

	function physics() {
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

		shape.setPos(x, y)
	}

	function animation() {
		if(getFrames() % 5 == 0) newActor(Glimmer, x - 4 + randInt(8), y - 4 + randInt(8))
	}

	function draw() {
		drawSpriteEx(sprIceball, getFrames() / 2, x - camx, y - camy, 0, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		fireWeapon(AfterIce, x, y, alignment, owner)
	}
}

::AfterIce <- class extends WeaponEffect {
	element = "ice"
	timer = 2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}
}

::ExplodeI <- class extends WeaponEffect{
	power = 2
	frame = 0.0
	shape = 0
	piercing = -1
	element = "ice"
	blast = true
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeI, 0)

		shape = Cir(x, y, 8.0)
		angle = randInt(360)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeI, frame, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeI2 <- class extends WeaponEffect{
	power = 2
	frame = 0.0
	shape = 0
	piercing = -1
	element = "ice"
	blast = true
	angle = 0
	r = 8
	timeLimit = 16

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeI)
		popSound(sndBlizzardBomb)

		shape = Cir(x, y, 8.0)
		angle = randInt(360)
	}

	function run() {
		frame += 0.2

		if(frame >= timeLimit) deleteActor(id)
		angle += frame
		r++
		shape.r = r

		newActor(Glimmer, x + lendirX(r, randInt(360)), y + lendirY(r, randInt(360)))

		if(alignment == 1) {
			if(gvPlayer) {
				if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
					if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
					if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
					if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
				}
			}

			if(gvPlayer2) {
				if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
					if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
					if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
					if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
				}
			}
		}
	}

	function draw() {
		for(local i = 0; i < 8; i++) {
			drawSprite(sprExplodeI, wrap((getFrames() / 4) + i, 1, 4), x + lendirX(r, angle + (i * 45) + 22.5) - camx, y + lendirY(r, angle + (i * 45) + 22.5) - camy, angle + (i * 45) + 22.5, 0, min(1, float(timeLimit - frame) / 10.0), min(1, float(timeLimit - frame) / 10.0))
			drawLight(sprLightIce, 0, x + lendirX(r, angle + (i * 45) + 22.5) - camx, y + lendirY(r, angle + (i * 45) + 22.5) - camy, 0, 0, min(1, float(timeLimit - frame) / 10.0), min(1, float(timeLimit - frame) / 10.0))
		}
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::IceBreath <- class extends WeaponEffect {
	element = "ice"
	frame = 0.0
	angle = 0
	power = 1.0
	piercing = 0

	constructor(_x, _y, _arr = null) {
		shape = Rec(x, y, 4, 4, 0)
		base.constructor(_x, _y, _arr)
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
	}

	function draw() {
		drawSpriteEx(sprGlimmer, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}
}

///////////////////
// SHOCK ATTACKS //
///////////////////

::ExplodeT <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "shock"
	power = 2
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeT, 0)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeT, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeT2 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "shock"
	power = 2
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCyraElectricSwing, 0)

		shape = Cir(x, y, 24.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8
			}
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteEx(sprExplodeT2, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeT3 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "shock"
	power = 2
	blast = true
	didbloom = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCyraElectricSwing, 0)

		shape = Cir(x, y, 24.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 1 && !didbloom) {
			didbloom = true
			local c = fireWeapon(Shockball, x + 6, y + 6, alignment, owner)
					c.power = 2
					c.hspeed = 1.5
					c.vspeed = 1.5
					c.piercing = 4
					c = fireWeapon(Shockball, x - 6, y + 6, alignment, owner)
					c.power = 2
					c.hspeed = -1.5
					c.vspeed = 1.5
					c.piercing = 4
					c = fireWeapon(Shockball, x + 6, y - 6, alignment, owner)
					c.power = 2
					c.hspeed = 1.5
					c.vspeed = -1.5
					c.piercing = 4
					c = fireWeapon(Shockball, x - 6, y - 6, alignment, owner)
					c.power = 2
					c.hspeed = -1.5
					c.vspeed = -1.5
					c.piercing = 4
					c = fireWeapon(Shockball, x, y + 8, alignment, owner)
					c.power = 2
					c.vspeed = 2
					c.piercing = 4
					c = fireWeapon(Shockball, x, y - 8, alignment, owner)
					c.power = 2
					c.vspeed = -2
					c.piercing = 4
					c = fireWeapon(Shockball, x + 8, y, alignment, owner)
					c.power = 2
					c.hspeed = 2
					c.piercing = 4
					c = fireWeapon(Shockball, x - 8, y, alignment, owner)
					c.power = 2
					c.hspeed = -2
					c.piercing = 4
		}

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8
			}
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteEx(sprExplodeT2, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::Shockball <- class extends WeaponEffect {
	element = "shock"
	timer = 120
	piercing = 0
	power = 1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
	}

	function physics() {
		//Shrink hitbox
		timer--
		if(timer == 0) deleteActor(id)
		if(!placeFree(x, y))
			deleteActor(id)

		hspeed *= 0.98
		vspeed *= 0.98

		x += hspeed
		y += vspeed

		shape.setPos(x, y)

		local target = null
		local tdist = 128.0

		//Find target
		foreach(i in actor) {
			if(i instanceof Enemy && distance2(x, y, i.x, i.y) <= tdist && i.health > 0 && !("squish" in i && i.squish) && !hitTest(shape, i.shape) && !i.notarget) {
				tdist = distance2(x, y, i.x, i.y)
				target = i
			}
		}

		if(target != null) {
			hspeed *= 0.98
			vspeed *= 0.98
			hspeed += lendirX(0.2, pointAngle(x, y, target.x, target.y))
			vspeed += lendirY(0.2, pointAngle(x, y, target.x, target.y))
		}
	}

	function draw()  {
		drawSpriteEx(sprShockball, getFrames() / 2, x - camx, y - camy, 0, int(hspeed > 0), 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function animation() {}

	function destructor() {
		newActor(Spark, x, y)
	}
}

///////////////////
// EARTH ATTACKS //
///////////////////

::EarthballK <- class extends WeaponEffect {
	timer = 90
	angle = 0
	element = "earth"
	power = 1
	blast = true
	piercing = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 4)
	}

	function physics() {}

	function run() {
		base.run()
		timer--
		if(timer == 0) deleteActor(id)

		vspeed += 0.1

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed) - 90

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteEx(sprRock, 0, x - camx, y - camy, angle, 1, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		fireWeapon(AfterEarth, x + hspeed / 2, y + vspeed / 2, alignment, owner)
		newActor(RockChunks, x, y)
		popSound(sndCrumble)
	}
}

::AfterEarth <- class extends WeaponEffect {
	element = "earth"
	timer = 2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)
	}
}

::ExplodeE <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true
	element = "earth"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCrumble)
		newActor(RockChunks, x, y)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.1

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeE, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeE2 <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true
	element = "earth"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCrumble)
		newActor(RockChunks, x, y)

		shape = Cir(x, y, 16.0)
	}

	function run() {
		frame += 0.1

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeE, frame, x - camx, y - camy, randInt(360), 0, 2, 2, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeE3 <- class extends WeaponEffect{
	power = 1
	frame = 0.0
	shape = 0
	piercing = -1
	blast = true
	element = "earth"
	didbloom = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndCrumble)
		newActor(RockChunks, x, y)

		shape = Cir(x, y, 16.0)
	}

	function run() {
		frame += 0.1

		if(frame >= 0.5 && !didbloom) {
			didbloom = true
			local c = fireWeapon(CrystalBullet, x - 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = -2.0
			c = fireWeapon(CrystalBullet, x + 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = -2.0
			c = fireWeapon(CrystalBullet, x - 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = 2.0
			c = fireWeapon(CrystalBullet, x + 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = 2.0
		}

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteEx(sprExplodeE, frame, x - camx, y - camy, randInt(360), 0, 2, 2, 1)
		drawLight(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::CrystalBullet <- class extends WeaponEffect {
	element = "earth"
	timer = 240
	piercing = -1
	angle = 0
	power = 2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
		timer += randInt(60)
	}

	function physics() {
		//Shrink hitbox
		timer--
		if(timer == 0) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		if(!placeFree(x, y + 1)) vspeed = -1.2
		if(!placeFree(x, y - 1)) vspeed = 1
		if(!placeFree(x + 1, y) || !placeFree(x - 1, y)) {
			if(placeFree(x + 1, y) || placeFree(x - 1, y)) vspeed = -1
		}
		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.99
			vspeed *= 0.99
		}

		xprev = x
		yprev = y
		if(placeFree(x, y)) {
			x += hspeed
			y += vspeed
		}
		else deleteActor(id)

		if(x != xprev && y != yprev)
			angle = pointAngle(x, y, xprev, yprev)

		if(y > gvMap.h || piercing == 0) deleteActor(id)

		shape.setPos(x, y)
	}

	function draw()  {
		drawSpriteEx(sprCrystalBullet, 0, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		fireWeapon(AfterFlame, x + hspeed, y + vspeed, alignment, owner)
	}
}

////////////////////
// MIDI'S WEAPONS //
////////////////////

::NutBomb <- class extends WeaponEffect {
	timer = 90
	element = "normal"
	power = 0
	blast = false
	piercing = 0
	exPower = 1
	sprite = null
	sprite2 = null
	sprite3 = null
	exElement = "normal"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 3)
		sprite = sprNutBomb
		sprite2 = sprNutBomb2
		sprite3 = sprNutBomb3
	}

	function run() {
		if(exPower == 2) sprite = sprite2
		if(exPower == 3) sprite = sprite3
		
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.95
			vspeed *= 0.95
		}

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSprite(sprite, (getFrames() / 4) % 4, x - camx, y - camy)
		drawLight(sprLightFire, 0, x - camx, y - camy - 4, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		local c
		local t = ExplodeN
		switch(exElement) {
			case "normal":
				t = ExplodeN
				break
			case "fire":
				t = ExplodeF
				break
			case "ice":
				t = ExplodeI
				break
			case "shock":
				t = ExplodeT
				break
			case "air":
				t = ExplodeA
				break
			case "earth":
				t = ExplodeE
				break
			case "water":
				t = ExplodeW
				break
		}
		if(exPower == 2) {
			switch(exElement) {
				case "normal":
					c = fireWeapon(ExplodeN2, x, y, alignment, owner)
					c.power = 2
					break
				case "fire":
					c = fireWeapon(ExplodeF2, x, y, alignment, owner)
					c.power = 2
					break
				case "water":
					c = fireWeapon(ExplodeW2, x, y, alignment, owner)
					c.power = 2
					break
				case "shock":
					c = fireWeapon(ExplodeT2, x, y, alignment, owner)
					c.power = 2
					break
				case "air":
					c = fireWeapon(ExplodeA2, x, y, alignment, owner)
					c.power = 2
					break
				default:
					c = fireWeapon(t, x - (6 * exPower), y, alignment, owner)
					c.power = 2
					c = fireWeapon(t, x + (6 * exPower), y, alignment, owner)
					c.power = 2
					c = fireWeapon(t, x, y - (6 * exPower), alignment, owner)
					c.power = 2
					c = fireWeapon(t, x, y + (6 * exPower), alignment, owner)
					c.power = 2
					break
			}
		}
		else if(exPower >= 3){
			switch(exElement) {
				case "normal":
					c = fireWeapon(ExplodeN3, x, y, alignment, owner)
					c.power = 4
					break
				case "shock":
					c = fireWeapon(ExplodeT3, x, y, alignment, owner)
					c.power = 4
					break
				case "earth":
					c = fireWeapon(ExplodeE3, x, y, alignment, owner)
					c.power = 4
					break
				case "air":
					c = fireWeapon(ExplodeA3, x, y, alignment, owner)
					c.power = 4
					stopSound(sndExplodeA2)
					break
				case "fire":
					c = fireWeapon(ExplodeF3, x, y, alignment, owner)
					c.power = 4
					break
				case "ice":
					c = fireWeapon(ExplodeI2, x, y, alignment, owner)
					c.power = 4
					break
				case "water":
					c = fireWeapon(ExplodeW2, x, y, alignment, owner)
					c.power = 4
					break
				
				default:
					c = fireWeapon(t, x - (6 * exPower), y, alignment, owner)
					c.power = 4
					c = fireWeapon(t, x + (6 * exPower), y, alignment, owner)
					c.power = 4
					c = fireWeapon(t, x, y - (6 * exPower), alignment, owner)
					c.power = 4
					c = fireWeapon(t, x, y + (6 * exPower), alignment, owner)
					c.power = 4
					break
			}
		}
		else {
			c = fireWeapon(t, x, y, alignment, owner)
			c.power = exPower
		}
	}
}

::TopNut <- class extends NutBomb {
	timer = 90
	element = "normal"
	power = 0
	blast = false
	piercing = 0
	exPower = 1
	exElement = "normal"
	sprite = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
		sprite = sprTopNut
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1
		else vspeed *= 0.99
		hspeed *= 0.99

		x += hspeed
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 4.0

		if(!placeFree(x, y)) {
			local mustboom = true

			for(local i = 0; i < 8; i++) {
				if(placeFree(x, y - i)) {
					y -= i
					mustboom = false
					break
				}
			}

			if(mustboom) deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSprite(sprite, (getFrames() / 4) % 4, x - camx, y - camy)
		drawLight(sprLightFire, 0, x - camx, y - camy - 4, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}
}

::WingNut <- class extends NutBomb {
	timer = 16
	element = "normal"
	power = 0
	blast = false
	piercing = 0
	bounceShape = null
	exPower = 1
	exElement = "normal"
	sprite = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 3)
		bounceShape = Rec(x, y, 10, 16, 0)
		sprite = sprWingNut
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteZ(3, sprite, (getFrames() / 4) % 4, x - camx, y - camy)
		drawLight(sprLightFire, 0, x - camx, y - camy - 4, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		base.destructor()
		if(checkActor(owner) && hitTest(bounceShape, actor[owner].shape) && actor[owner].anim == "ball") actor[owner].vspeed = -5
	}
}

::NutMine <- class extends NutBomb {
	element = "normal"
	power = 0
	blast = false
	piercing = 0
	bounceShape = null
	exPower = 1
	exElement = "normal"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y + 4, 3)
		bounceShape = Cir(x, y, 8)
	}

	function run() {
		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		if(placeFree(x, y + 2) && !onPlatform()) deleteActor(id)

		shape.setPos(x, y)

		if(checkActor(owner) && getcon("jump", "press", false, actor[owner].playerNum) && hitTest(bounceShape, actor[owner].shape)) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(2, sprite, (getFrames() / 4) % 4, x - camx, y - camy)
		drawLight(sprLightFire, 0, x - camx, y - camy - 4, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		base.destructor()
		if(checkActor(owner) && hitTest(bounceShape, actor[owner].shape)) actor[owner].vspeed = -10
	}
}

/////////////////
// AIR ATTACKS //
/////////////////

::ExplodeA <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "air"
	power = 2
	blast = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeA, 0)

		shape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 6) deleteActor(id)

		if(gvPlayer) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprTinyWind, getFrames() / 2, x - camx, y - camy - 8, 0, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprTinyWind, getFrames() / 2, x - camx + 8, y - camy, 90, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprTinyWind, getFrames() / 2, x - camx, y - camy + 8, 180, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprTinyWind, getFrames() / 2, x - camx - 8, y - camy, 270, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawLight(sprLightBasic, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeA2 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "air"
	power = 2
	blast = true
	altShape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeA2, 0)

		shape = Cir(x, y, 32.0)
		altShape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 6) deleteActor(id)

		if(gvPlayer) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx, y - camy - 8, 0, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx + 8, y - camy, 90, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx, y - camy + 8, 180, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx - 8, y - camy, 270, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawLight(sprLightBasic, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeA3 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "air"
	power = 2
	blast = true
	altShape = null
	didbloom = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		popSound(sndExplodeA2, 0)

		shape = Cir(x, y, 32.0)
		altShape = Cir(x, y, 8.0)
	}

	function run() {
		frame += 0.2

		if(frame >= 1.0 && !didbloom) {
			didbloom = true
			local c = fireWeapon(StormTornado, x + 8, y - 4, alignment, owner)
			c.direction = 22.5
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x + 4, y - 8, alignment, owner)
			c.direction = 22.5 - 45
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x - 4, y - 8, alignment, owner)
			c.direction = 22.5 - (45 * 2)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x - 8, y - 4, alignment, owner)
			c.direction = 22.5 - (45 * 3)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x - 8, y + 4, alignment, owner)
			c.direction = 22.5 - (45 * 4)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x - 4, y + 8, alignment, owner)
			c.direction = 22.5 - (45 * 5)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x + 4, y + 8, alignment, owner)
			c.direction = 22.5 - (45 * 6)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
			c = fireWeapon(StormTornado, x + 8, y + 4, alignment, owner)
			c.direction = 22.5 - (45 * 7)
			c.power = 2
			c.speed = 0.25
			c.maxTime = 60
		}

		if(frame >= 6) deleteActor(id)

		if(gvPlayer) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64 + (32 * (power / 2.0))) {
				if(x > gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.2 * (power / 2.0)
				if(x < gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.2 * (power / 2.0)
				if(gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx, y - camy - 8, 0, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx + 8, y - camy, 90, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx, y - camy + 8, 180, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawSpriteZ(6, sprExplodeA, getFrames() / 2, x - camx - 8, y - camy, 270, 0, sin(max(4, frame) / 2), sin(max(4, frame) / 2), 1)
		drawLight(sprLightBasic, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::DragBubble <- class extends WeaponEffect {
	frame = 0
	power = 0
	piercing = -1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 4)
		frame = randInt(4)
		popSound(sndBlurp)
	}

	function run() {
		if(checkActor(owner)) {
			hspeed += lendirX(0.1, pointAngle(x, y, actor[owner].x, actor[owner].y))
			vspeed += lendirY(0.1, pointAngle(x, y, actor[owner].x, actor[owner].y))

			if(inDistance2(x, y, actor[owner].x, actor[owner].y, 16))
				deleteActor(id)

			if(gvPlayer && hitTest(shape, gvPlayer.shape)) {
				gvPlayer.hspeed += lendirX(0.1, pointAngle(x, y, actor[owner].x, actor[owner].y))
				gvPlayer.vspeed += lendirY(0.1, pointAngle(x, y, actor[owner].x, actor[owner].y))
			}
		}
		else
			deleteActor(id)

		x += hspeed
		y += vspeed
		shape.setPos(x, y)
	}

	function draw() {
		drawSprite(sprBubble, frame, x - camx, y - camy)
	}
}

::StormTornado <- class extends WeaponEffect {
	piercing = -1
	power = 1
	timer = 0
	speed = 0.0
	direction = 0
	element = "air"
	solidshape = null
	hitshape = null
	maxTime = 300

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		hitshape = Cir(x, y, 8)
		solidshape = Rec(x, y, 1, 1, 0)
		shape = hitshape
		popSound(sndExplodeA3)
	}

	function run() {
		base.run()

		shape = solidshape
		if(!placeFree(x, y) || timer >= maxTime)
			deleteActor(id)
		shape = hitshape

		if(timer >= 30)
			speed = 4.0

		timer++

		x += lendirX(speed, direction)
		y += lendirY(speed, direction)
		shape.setPos(x, y)
	}

	function draw() {
		drawSprite(sprTinyWind, getFrames() / 2, x - camx, y - camy, direction + 90)
	}
}

///////////////////
// WATER ATTACKS //
///////////////////

::Waterball <- class extends WeaponEffect {
	element = "water"
	timer = 90
	piercing = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
	}

	function physics() {
		//Shrink hitbox
		timer--
		if(timer == 0) deleteActor(id)
		if(!placeFree(x, y))
			deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1
		else {
			hspeed *= 0.99
			vspeed *= 0.99
		}

		x += hspeed
		y += vspeed

		if(!placeFree(x, y)) deleteActor(id)

		if(y > gvMap.h || piercing < 0) deleteActor(id)

		shape.setPos(x, y)
	}

	function draw()  {
		drawSpriteEx(sprWaterball, getFrames() / 2, x - camx, y - camy, 0, int(hspeed > 0), 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function animation() {}
}

::ExplodeW <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "water"
	power = 2
	blast = true
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		stopSound(sndSplash)
		playSound(sndSplash, 0)

		shape = Cir(x, y, 8.0)
		angle = randInt(360)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprExplodeW, frame, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeW2 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "water"
	power = 2
	blast = true
	altShape = null
	angle = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		stopSound(sndSplashBig)
		playSound(sndSplashBig, 0)

		shape = Cir(x, y, 8.0)
		altShape = Cir(x, y, 2.0)

		angle = randInt(360)
	}

	function run() {
		frame += 0.2

		if(frame >= 5) deleteActor(id)
		if(altShape.r < 16) altShape.r++
		if(shape.r < 24) shape.r++

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprExplodeW2, frame, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::ExplodeW3 <- class extends WeaponEffect{
	frame = 0.0
	shape = 0
	piercing = -1
	element = "water"
	power = 2
	blast = true
	altShape = null
	angle = 0
	didbloom = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		stopSound(sndSplashBig)
		playSound(sndSplashBig, 0)

		shape = Cir(x, y, 8.0)
		altShape = Cir(x, y, 2.0)

		angle = randInt(360)
	}

	function run() {
		frame += 0.2

		if(!didbloom && frame >= 1.0) {
			didbloom = true
			local c = fireWeapon(WaterBomb, x - 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = -2.0
			c = fireWeapon(WaterBomb, x + 6, y - 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = -2.0
			c = fireWeapon(WaterBomb, x - 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = -2.0
			c.vspeed = 2.0
			c = fireWeapon(WaterBomb, x + 6, y + 6, alignment, owner)
			c.power = 4
			c.hspeed = 2.0
			c.vspeed = 2.0
		}

		if(frame >= 5) deleteActor(id)
		if(altShape.r < 16) altShape.r++
		if(shape.r < 24) shape.r++

		if(gvPlayer) {
			if(owner != gvPlayer.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x && gvPlayer.hspeed < 8) gvPlayer.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer.x && gvPlayer.hspeed > -8) gvPlayer.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer.y && gvPlayer.vspeed > -8) gvPlayer.vspeed -= 0.8 * (power / 2.0)
			}
		}

		if(gvPlayer2) {
			if(owner != gvPlayer2.id) if(floor(frame) <= 1 && distance2(x, y, gvPlayer2.x, gvPlayer2.y) < 64) {
				if(x < gvPlayer2.x && gvPlayer2.hspeed < 8) gvPlayer2.hspeed += 0.5 * (power / 2.0)
				if(x > gvPlayer2.x && gvPlayer2.hspeed > -8) gvPlayer2.hspeed -= 0.5 * (power / 2.0)
				if(y >= gvPlayer2.y && gvPlayer2.vspeed > -8) gvPlayer2.vspeed -= 0.8 * (power / 2.0)
			}
		}
	}

	function draw() {
		drawSpriteZ(6, sprExplodeW2, frame, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.5 - (frame / 10.0), 1.5 - (frame / 10.0))
		if(debug) {
			setDrawColor(0xff0000ff)
			drawCircle(x - camx, y - camy, shape.r, false)
		}
	}
}

::WaterBomb <- class extends WeaponEffect {
	timer = 90
	angle = 0
	element = "water"
	power = 1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 2)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(inWater(x, y)) {
			vspeed *= 0.99
			hspeed *= 0.99
		}
		else
			vspeed += 0.1

		x += hspeed
		y += vspeed
		if(!placeFree(x, y))
			deleteActor(id)

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed) - 90

		shape.setPos(x, y)
	}

	function draw() {
		drawSpriteEx(sprWaterBomb, (getFrames() / 4) % 4, x - camx, y - camy, 0, 1, 1, 1, 1)
		drawLight(sprLightIce, 0, x - camx, y - camy, 0, 0, 1.0 / 4.0, 1.0 / 4.0)
	}

	function destructor() {
		local c = fireWeapon(ExplodeW, x, y, alignment, owner)
		c.power = power
	}
}