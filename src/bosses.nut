::Boss <- class extends PhysAct {
	health = 40
	phasing = false //Allows the boss to phase through walls in their intro
	active = false
	routine = null
	hspeed = 0.0
	vspeed = 0.0
	flip = 0
	gravity = 0.0
	frame = 0.0
	anim = null
	blinking = 0.0
	canBeStomped = false
	ready = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
	}

	function run() {
		if(active) {
			if(routine != null) routine()
			animics()

			//Collision with player
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape) && blinking <= 0) {
				if(gvPlayer.y < y && gvPlayer.vspeed >= 0 && gvPlayer.canStomp && canBeStomped) hurtStomp()
				else hitPlayer()
			}
			if(blinking > 0) blinking -= 0.1
			else {
				if(actor.rawin("Fireball")) foreach(i in actor["Fireball"]) {
					if(hitTest(shape, i.shape)) {
						hurtFire()
						deleteActor(i.id)
					}
				}

				if(actor.rawin("Iceball")) foreach(i in actor["Iceball"]) {
					if(hitTest(shape, i.shape)) {
						hurtIce()
						deleteActor(i.id)
					}
				}

				if(actor.rawin("ExplodeF")) foreach(i in actor["ExplodeF"]) {
					if(hitTest(shape, i.shape)) {
						hurtFire()
					}
				}

				if(actor.rawin("ExplodeT")) foreach(i in actor["ExplodeT"]) {
					if(hitTest(shape, i.shape)) {
						hurtShock()
					}
				}

				if(actor.rawin("ExplodeI")) foreach(i in actor["ExplodeI"]) {
					if(hitTest(shape, i.shape)) {
						hurtIce()
					}
				}

				if(actor.rawin("ExplodeN")) foreach(i in actor["ExplodeN"]) {
					if(hitTest(shape, i.shape)) {
						hurtBlast()
					}
				}
			}
		}
	}

	//Physics gets a separate function so that it can be inherited by other bosses
	function animics() {}
	function hitPlayer() {
		gvPlayer.hurt = 1
	}

	function hurtStomp() {}
	function hurtBlast() {}
	function hurtFire() {}
	function hurtIce() {}
	function hurtShock() {}
	function hurtEarth() {}

	function turnToPlayer() {
		if(gvPlayer) {
			if(gvPlayer.x > x) flip = 0
			else flip = 1
		}
	}

	function _typeof() { return "Boss" }
}

::BossManager <- class extends Actor {
	bossTotal = 0
	health = 0
	healthTotal = 0
	healthDrawn = 0
	doorID = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null && _arr != "") {
			doorID = _arr.tointeger()
		}

		if(!gvBoss) gvBoss = this
		foreach(i in actor["Boss"]) {
			bossTotal++
			healthTotal += 40
			health += i.health
		}
	}

	function run() {
		if(!actor.rawin("Boss")) deleteActor(id)

		//Recount health
		health = 0
		if(actor["Boss"].len() > 0) foreach(i in actor["Boss"]) {
			health += i.health
		}
		if(health <= 0) {
			health = 0
			fadeMusic(1)
			deleteActor(id)
			if(mapActor.rawin(doorID)) if(actor[mapActor[doorID]].rawin("opening")) actor[mapActor[doorID]].opening = true
		}

		game.bossHealth = 40 / healthTotal * health
	}

	function destructor() { gvBoss = false }
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
	health = 40
	eventTimer = 0
	eventStage = 0
	hasThrown = false

	constructor(_x, _y, _arr = null) {
		gravity = 0.1
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 14, 20, 0, 0, 4)
		routine = ruWalkIntoFrame

		for(local i = 0; i < 32; i++) {
			if(placeFree(x, y + 1)) y++
			else break
		}
		if(!placeFree(x, y)) y--
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

		if((!phasing || health <= 0) && vspeed < 4) vspeed += gravity
		if(placeFree(x, y + vspeed) || phasing) y += vspeed
		else vspeed /= 4.0

		if(health <= 0 && routine != ruDefeated) {
			phasing = true
			vspeed = -2.0
			routine = ruDefeated
			if(flip == 0) hspeed = -1.0
			else hspeed = 1.0
			setFPS(30)
			eventTimer = 120
			if(gvPlayer) gvPlayer.canMove = false
		}

		shape.setPos(x, y)

		//Animation
		switch(anim) {
			case anWalk:
				frame += 0.1
				break
			case anIdle:
			case anDizzy:
				frame += 0.15
				break
			case anRun:
				frame += 0.3
				break
			case anThrow:
				frame += 0.1
				if(frame < anim[0] + 2) frame += 0.1
				if(frame > anim[1] + 1) anim = anIdle
				break
			case anCheer:
			case anHurt:
			case anShake:
				frame += 0.2
				break
			case anJump:
				if(frame < anim[1] + 1) frame += 0.2
				if(frame >= anim[1] + 1) {
					if(vspeed < 0) frame -= 0.2
					else {
						anim = anFall
						frame = anim[0]
					}
				}
				break
			case anFall:
				if(frame < anim[1]) frame += 0.1
				else frame -= 0.5
				break
		}
		if(anim != null) frame = wrap(frame, anim[0], anim[1])

		if(anim != anHurt) {
			if(hspeed > 0) flip = 0
			if(hspeed < 0) flip = 1
		}

		//Draw
		if(blinking == 0) drawSpriteEx(sprYeti, frame, x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else drawSpriteEx(sprYeti, frame, x - camx, y - camy, 0, flip.tointeger(), 1, 1, max(wrap(blinking, 0, 1), (anim == anHurt).tointeger()))
		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()
			drawText(font2, x - camx, y - camy, vspeed.tostring())
		}
	}

	function ruWalkIntoFrame() {
		phasing = true
		if(gvPlayer) gvPlayer.canMove = false
		anim = anWalk
		flip = 1
		hspeed = -0.5
		if(x < camx + screenW() - 96) {
			routine = ruIntroCheer
			hspeed = 0.0
			phasing = false
			eventTimer = 160
		}
		if(gvWarning == 180) songPlay(musBossIntro)
	}

	function ruIntroCheer() {
		eventTimer--
		if(eventTimer < 100) anim = anCheer
		else anim = anIdle
		if(eventTimer == 100) playSound(sndGrowl, 0)
		if(eventTimer == 0) {
			eventTimer = 60
			routine = ruIdle
			if(gvPlayer) gvPlayer.canMove = true
			songPlay(musBoss)
		}
	}

	function ruIdle() {
		hspeed = 0.0
		anim = anIdle
		eventTimer--
		if(eventTimer == 0) {
			switch(eventStage) {
				case 0:
					eventStage++
					routine = ruJump
					eventTimer = 240
					break
				case 1:
					eventStage++
					routine = ruThrow
					eventTimer = 120
					anim = anThrow
					frame = anim[0]
					turnToPlayer()
					hasThrown = false
					break
				case 2:
					eventStage++
					routine = ruCharge
					turnToPlayer()
					break
				default:
					eventStage = 0
					eventTimer = 1
					break
			}
		}
	}

	function ruJump() {
		eventTimer--
		if(anim == anIdle) {
			anim = anJump
			frame = anim[0]
		}

		if(floor(frame) == anim[0] + 1 && anim == anJump) {
			vspeed = -4.0
			if(gvPlayer) {
				hspeed = (gvPlayer.x - x) / 64.0
			}
		}

		if(anim == anFall && !placeFree(x, y + 1)) {
			hspeed = 0.0
			vspeed = 0.0
			if(eventTimer > 0) {
				anim = anJump
				frame = anim[0]
				newActor(YetiShock, x, y + 32, ((40 - health).tofloat() / 20.0) + 1.0)
			}
			else {
				eventTimer = 60
				routine = ruIdle
			}
		}
	}

	function ruThrow() {
		eventTimer--

		if(anim == anThrow && frame >= anim[0] + 1 && !hasThrown) {
			local c = actor[newActor(SnowBounce, x, y - 16)]
			if(flip == 0) c.hspeed = 2.0
			else c.hspeed = -2.0
			hasThrown = true
		}

		if(eventTimer <= 0) {
			routine = ruIdle
			eventTimer = 60
		}
	}

	function ruCharge() {
		anim = anRun
		if(flip == 0) hspeed = 3.0
		else hspeed = -3.0

		if(!placeFree(x + hspeed, y)) {
			vspeed = -2.0
			hspeed = -hspeed / 3.0
			anim = anHurt
			frame = anim[0]
			routine = ruDizzy
			eventTimer = 240
		}
	}

	function ruDizzy() {
		canBeStomped = true
		eventTimer--
		if(anim == anHurt && !placeFree(x, y + 1)) {
			vspeed = 0.0
			hspeed = 0.0
			anim = anDizzy
		}
		if(eventTimer < 60) anim = anShake
		if(eventTimer <= 0) {
			routine = ruIdle
			eventTimer = 60
			canBeStomped = false
		}
	}

	function ruHurt() {
		anim = anHurt
		eventTimer--
		blinking = 12.0
		if(eventTimer <= 0) {
			eventTimer = 60
			routine = ruIdle
			canBeStomped = false
		}
		if(!placeFree(x, y + 1) && vspeed > 0) hspeed = 0.0
	}

	function ruDefeated() {
		eventTimer--
		phasing = true
		anim = anHurt
		gravity = 0.05
		if(eventTimer <= 0) {
			setFPS(60)
			if(gvPlayer) gvPlayer.canMove = true
			deleteActor(id)
		}
	}

	function hurtFire() {
		blinking = 12.0
		health--
	}

	function hurtStomp() {
		routine = ruHurt
		eventTimer = 30
		canBeStomped = false
		vspeed = -2.0
		if(gvPlayer) {
			gvPlayer.vspeed = -2.0
			if(flip == 0) hspeed = -1.0
			else hspeed = 1.0
		}
		health -= 4
	}

	function _typeof() { return "Boss" }
}

::YetiShock <- class extends Actor {
	shape = null
	timer = 0
	speed = 1.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 8, 16, 0, 0, -16)
		if(_arr != null) speed = _arr.tofloat()
	}

	function run() {
		timer++
		if(timer >= 240) deleteActor(id)

		//Damage hitbox
		if(gvPlayer) {
			shape.setPos(x + (timer * speed), y)
			if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 2
			shape.setPos(x - (timer * speed), y)
			if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 2
		}

		//Create effect
		if(timer % 10 == 0) {
			newActor(BigSpark, x + (timer * speed), y, 0)
			newActor(BigSpark, x - (timer * speed), y, 1)
		}
		drawSprite(sprSpark, getFrames(), x + (timer * speed) - camx, y - camy)
		drawSprite(sprSpark, getFrames(), x - (timer * speed) - camx, y - camy)
	}
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