/*=======*\
| ENEMIES |
\*=======*/

::NMEloader <- class extends Actor {
	e = 0 //Enemy class to create
	m = 0 //Respawn mode
	a = 0 //Current actor ID

	function step() {

	}
}

::Enemy <- class extends PhysAct {
	r = 0
	health = 1
	hspeed = 0.0
	vspeed = 0.0

	function run() {
		//Collision with player
		if(gvPlayer != 0) {
			if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= r + 8) { //8 for player radius
				if((y > gvPlayer.y && vspeed < gvPlayer.vspeed) || gvPlayer.anim == gvPlayer.anSlide) gethurt()
				else hurtplayer()
			}
		}

		if(actor.rawin("Fireball")) foreach(i in actor[Fireball]) {
			if(distance2(x, y, i.x, i.y) <= r + 4) {
				hurtfire()
				deleteActor(i.id)
			}
		}
	}

	function gethurt() {} //Spiked enemies can just call hurtplayer() here
	function hurtplayer() {}
	function hurtfire() {} //If the object is hit by a fireball
	function _typeof() { return "Enemy" }
}

::Deathcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		r = 4
		shape = Rec(x, y, 4, 8, 0)
	}

	function run() {
		base.run()

		if(!squish) {
			if(placeFree(x, y + 1)) vspeed += 0.1
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2

			if(y > gvMap.h + 8) deleteActor(id)

			if(flip) {
				if(placeFree(x - 1, y)) x -= 1
				else if(placeFree(x - 1.0, y - 1.0)) {
					x -= 1.0
					y -= 1.0
				} else flip = false

				if(x <= 0) flip = false
			}
			else {
				if(placeFree(x + 1, y)) x += 1
				else if(placeFree(x + 1.0, y - 1.0)) {
					x += 1.0
					y -= 1.0
				} else flip = true

				if(x >= gvMap.w) flip = true
			}

			drawSpriteEx(sprDeathcap, wrap(getFrames() / 6, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		}
		else {

		}

		shape.setPos(x, y, 0)
	}

	function hurtplayer() {gvPlayer.vspeed -= 1}

	function _typeof() {return "Deathcap"}
}
