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
	gravity = 0.0
	constructor(_x, _y) {
		base.constructor(_x, _y)
		r = 8
		shape = Rec(x, y, 4, 8, 0)
	}

	function run() {
		base.run()

		
	}
}
