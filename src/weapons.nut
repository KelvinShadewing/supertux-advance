/////////////////
// NEW WEAPONS //
/////////////////

//All weapons will use the same return type
//Different weapons will have different stats for enemies to react to

::fireWeapon <- function(weapon, x, y, alignment, owner) {
	local c = actor[newActor(weapon, x, y)]
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

	function _typeof() { return "WeaponEffect" }
}

::Fireball <- class extends WeaponEffect {
	element = "fire"
	timer = 90

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 3, 3, 0)
		newActor(AfterFlame, x, y)
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

		base.physics()
	}

	function animation() {
		if(hspeed > 0) drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 0, 1, 1, 1)
		else drawSpriteEx(sprFireball, getFrames() / 2, x - camx, y - camy, 0, 1, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)

		if(getFrames() % 3 == 0) {
			local c = actor[newActor(FlameTiny, x, y)]
			c.frame = 4
		}
	}
}

::AfterFlame <- class extends WeaponEffect {
	element = "fire"
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