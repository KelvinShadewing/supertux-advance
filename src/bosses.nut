::Boss <- class extends PhysAct {
	health = 100
	phasing = false //Allows the boss to phase through walls in their intro
	active = false
	routine = null
	hspeed = 0.0
	vspeed = 0.0
	flip = 0
	gravity = 0.0
	frame = 0.0
	anim = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
	}

	function run() {
		if(active) {
			if(routine != null) routine()
			animics()
		}
	}

	//Physics gets a separate function so that it can be inherited by other bosses
	function animics() {}
}

::BossManager <- class extends Actor {
	bossID = 0

}

::Yeti <- class extends Boss {
	//Animations
	anIdle = [0.0, 7.0, "idle"]
	anWalk = [8.0, 15.0, "walk"]
	anRun = [16.0, 23.0, "run"]
	anJump = [24.0, 27.0, "jump"]
	anFall = [28.0, 31.0, "fall"]
	anHurt = [32.0, 33.0, "hurt"]
	anDizzy = [34.0, 35.0, "dizzy"]
	anShake = [36.0, 39.0, "shake"]
	anThrow = [40.0, 43.0, "throw"]
	anCheer = [44.0, 47.0, "cheer"]

	//Boss specific variables
	eventTimer = 0

	constructor(_x, _y, _arr = null) {
		gravity = 0.5
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 12, 24, 0, 0, 8)
		routine = ruWalkIntoFrame
	}

	function _typeof() { return "Yeti" }

	function animics() {
		//Movement
		if(placeFree(x + hspeed, y) || phasing) x += hspeed
		else for(local i = 0; i < abs(hspeed * 1.5); i++) {
			if(placeFree(x + hspeed, y - i)) {
				x += hspeed
				y =- i
				break
			}
		}

		if(!phasing && vspeed < 4) vspeed += gravity
		if(placeFree(x, y + vspeed) || phasing) y += vspeed
		else vspeed = 0.0

		shape.setPos(x, y)

		//Animation
		switch(anim) {
			case anIdle:
			case anDizzy:
				frame += 0.1
				break
			case anWalk:
				frame += 0.2
				break
			case anRun:
			case anHurt:
			case anShake:
			case anThrow:
			case anCheer:
				frame += 0.3
				break
			case anJump:
			case anFall:
				if(frame < anim[1]) frame += 0.2
				break
		}
		if(anim != null) frame = wrap(frame, anim[0], anim[1])
	}

	function ruWalkIntoFrame() {
		phasing = true
		if(gvPlayer) gvPlayer.canMove = false
		anim = anWalk
		flip = 1
		hspeed = -1.0
		if(x < camx + screenW() - 96) {
			routine = ruIntroCheer
			hspeed = 0.0
		}
	}

	function ruIntroCheer() {}

}

::Nolok <- class extends Boss {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 20, 0)
	}

	function run() {
		base.run()
	}

	function _typeof() { return "Nolok" }
}