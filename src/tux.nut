/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	friction = 0.05
	gravity = 0.0
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 4 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	startx = 0.0
	starty = 0.0
	firetime = 0
	hurt = false
	swimming = false
	endmode = false
	canstomp = true //If they can use jumping as an attack
	sprite = sprTux
	invincible = 0
	shapeStand = 0
	shapeSlide = 0

	//Animations
	anim = [] //Animation frame delimiters: [start, end, speed]
	anStand = [0.0, 0.0]
	anWalk = [8.0, 15.0]
	anRun = [16.0, 23.0]
	anDive = [24.0, 25.0]
	anSlide = [26.0, 29.0]
	anHurt = [30.0, 31.0]
	anJumpU = [32.0, 33.0]
	anJumpT = [34.0, 35.0]
	anFall = [36.0, 37.0]
	anClimb = [44.0, 47.0]
	anWall = [48.0, 49.0]
	anSwimF = [52.0, 55.0]
	anSwimUF = [56.0, 59.0]
	anSwimDF = [60.0, 63.0]
	anSwimU = [64.0, 67.0]
	anSwimD = [68.0, 71.0]

	constructor(_x, _y) {
		base.constructor(_x, _y)
		anim = anStand
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(gvPlayer == 0) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
	}

	function run() {
		//Side checks
		local freeDown = placeFree(x, y + 1)
		local freeDown2 = placeFree(x, y + 2)
		local freeLeft = placeFree(x - 1, y)
		local freeRight = placeFree(x + 1, y)
		local freeUp = placeFree(x, y - 1)
		//Checks are done at the beginning and stored here so that they can be
		//quickly reused. Location checks will likely need to be done multiple
		//times per frame.

		/////////////
		// ON LAND //
		/////////////
		if(!inWater(x, y)) {
			swimming = false

			//Animation states
			switch(anim) {
				case anStand:
					frame = 0.0

					if(hspeed != 0) {
						anim = anWalk
						frame = anim[0]
					}

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anWalk:
					frame += abs(hspeed) / 8
					if(hspeed == 0) anim = anStand
					if(abs(hspeed) > 1.8) anim = anRun

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anRun:
					frame += abs(hspeed) / 8
					if(abs(hspeed) < 1.2) anim = anWalk

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anJumpU:
					if(frame < anim[0] + 1) frame += 0.1

					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}

					if(vspeed > 0) {
						anim = anJumpT
						frame = anim[0]
					}
					break

				case anJumpT:
					frame += 0.2
					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}

					if(frame > anim[1]) {
						anim = anFall
						frame = anim[0]
					}
					break

				case anFall:
					frame += 0.05
					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}
					break

				case anWall:
					frame += 0.2
					vspeed = 0

					if(floor(frame) > anim[1]) {
						vspeed = -3.2
						if(flip == 0) hspeed = 2
						else hspeed = -2
						anim = anJumpU
						frame = anim[0]
					}
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > anim[1]) {
						anim = anSlide
						frame = anim[0]
						shape = shapeSlide
					}
					break

				case anSlide:
					frame = getFrames() / 8
					if(game.weapon == 1) if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - abs(hspeed)) == 0 || abs(hspeed) > 8) newActor(FlameTiny, x, y + 10)
					break

				case anHurt:
					frame += 0.1
					if(floor(frame) > anim[1]) {
						anim = anStand
						frame = anim[0]
					}
					break

				case anSwimF:
					anim = anJumpT
					frame = anim[0]
					break

				case anSwimUF:
				case anSwimU:
					anim = anJumpU
					frame = anim[0]
					vspeed -= 1
					if(getcon("jump", "hold")) vspeed -= 1
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = anim[0]
					break
			}

			if(anim != anClimb) frame = wrap(frame, anim[0], anim[1])

			//Sliding acceleration
			if(anim == anDive || anim == anSlide) {
				if(!freeDown && abs(hspeed) < 6) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.1
					if(placeFree(x - 4, y + 2)) hspeed -= 0.1

					if(placeFree(x + 4, y + 4)) {
						hspeed += 0.1
						vspeed += 0.5
					}

					if(placeFree(x - 4, y + 4)) {
						hspeed -= 0.1
						vspeed += 0.5
					}
				}

				if(!getcon("down", "hold") || hspeed == 0) anim = anWalk
			}

			if(anim != anClimb && anim != anWall) {
				if(hspeed > 0.1) flip = 0
				if(hspeed < -0.1) flip = 1
			}

			//Controls
			if(!freeDown2 || anim == anClimb) canJump = 15
			else if(canJump > 0) canJump--
			if(canMove) {
				if(getcon("run", "hold")) mspeed = 2
				else if(getcon("sneak", "hold")) mspeed = 0.5
				else mspeed = 1

				//Moving left and right
				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb) hspeed += 0.1
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb) hspeed -= 0.1

				//On a ladder
				if(anim == anClimb) {
					vspeed = 0

					//Ladder controls
					if(getcon("up", "hold")) if(placeFree(x, y - 1)) {
						frame -= climbdir / 8
						y--
					}

					if(getcon("down", "hold")) if(placeFree(x, y + 1)) {
						frame += climbdir / 8
						y++
					}

					//Check if still on ladder
					local felloff = true
					if(actor.rawin("Ladder")) foreach(i in actor["Ladder"]) {
						if(hitTest(shape, i.shape)) {
							felloff = false
							break
						}
					}
					if(felloff) {
						anim = anFall
						frame = anim[0]
					}

					//Change direction
					if(getcon("right", "press")) flip = 0
					if(getcon("left", "press")) flip = 1

					//Ping-pong animation
					if(frame >= anim[1] + 0.4 || frame <= anim[0] + 0.4) {
						climbdir = -climbdir
						if(frame > anim[1] + 0.4) frame -= abs(climbdir / 8)
						if(frame < anim[0] + 0.4) frame += abs(climbdir / 8)
					}
				}

				//Get on ladder
				if((getcon("down", "hold") || getcon("up", "hold")) && anim != anHurt && anim != anClimb && actor.rawin("Ladder") && vspeed >= 0) {
					foreach(i in actor["Ladder"]) {
						if(hitTest(shape, i.shape)) {
							anim = anClimb
							frame = anim[0]
							hspeed = 0
							vspeed = 0
							x = i.x
						}
					}
				}

				//Jumping
				if(getcon("jump", "press") && canJump > 0) {
					vspeed = -3.8
					didJump = true
					canJump = 0
					if(anim != anHurt && anim != anDive) {
						anim = anJumpU
						frame = anim[0]
					}
					playSound(sndJump, 0)
				}

				if(getcon("jump", "release") && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2
				}

				//Wall jumping
				if(freeDown && getcon("jump", "hold"))
				{
					if(!placeFree(x - 2, y) && getcon("right", "press") && anim != anWall) {
						flip = 0
						anim = anWall
						frame = anim[0]

					}

					if(!placeFree(x + 2, y) && getcon("left", "press") && anim != anWall) {
						flip = 1
						anim = anWall
						frame = anim[0]
					}
				}

				//Going into slide
				if(!freeDown2 && getcon("down", "hold") && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt) {
					if((freeRight && freeDown) || hspeed >= 2) {
						anim = anDive
						frame = anim[0]
						flip = 0
						playSound(sndSlide, 0)
					}

					if((freeLeft && freeDown) || hspeed <= -2) {
						anim = anDive
						frame = anim[0]
						flip = 1
						playSound(sndSlide, 0)
					}
				}
			} else {
				if(hspeed < 0.75 && endmode) hspeed += 0.1
			}

			//Movement
			if(!freeDown2) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3
					if(hspeed < 0) hspeed += friction / 3
					if(abs(hspeed) < 1) {
						if(placeFree(x, y - 16)) {
							anim = anStand
							shape = shapeStand
						} else {
							if(getcon("left", "hold")) hspeed -= 0.1
							if(getcon("right", "hold")) hspeed += 0.1
						}
					}
				} else {
					if(hspeed > 0) hspeed -= friction
					if(hspeed < 0) hspeed += friction
				}
			}
			if(anim != anSlide) {
				if(placeFree(x, y - 8)) shape = shapeStand
				if(!placeFree(x, y)) shape = shapeSlide
			}

			if(abs(hspeed) < friction) hspeed = 0.0
			if(freeDown && vspeed < 3) vspeed += gravity
			if(!freeUp && vspeed < 0) vspeed = 0.0 //If Tux bumped his head
			if(!freeDown && vspeed >= 0) {
				//If Tux hits the ground while sliding
				if(anim == anSlide) {
					if(flip) hspeed -= vspeed / 5
					else hspeed += vspeed / 5
				} else vspeed = 0.0
			}

			//Gravity cases
			gravity = 0.11
			if(anim == anClimb || anim == anWall) gravity = 0

			//Attacks
			if(firetime > 0) firetime--
			switch(game.weapon) {
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && firetime == 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Fireball, x + fx, y - 4)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						firetime = 60
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) c.vspeed = -2
						if(getcon("down", "hold")) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
					}
					break

				case 2:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && firetime == 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Iceball, x + fx, y - 4)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						firetime = 60
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) c.vspeed = -2
						if(getcon("down", "hold")) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
					}
					break
			}

		}
		//////////////
		// IN WATER //
		//////////////
		else {
			swimming = true

			//Animation states
			switch(anim) {
				case anSwimF:
				case anSwimU:
				case anSwimD:
				case anSwimUF:
				case anSwimDF:
					frame += sqrt(abs(hspeed * hspeed) + abs(vspeed * vspeed)) / 12
					break
				case anHurt:
					frame += 0.2
					if(floor(frame) > anim[1]) {
						anim = anFall
						frame = anim[0]
					}
				case anFall:
					frame += 0.01
					break
			}

			frame = wrap(frame, anim[0], anim[1])

			//Swich swim directions
			if(anim != anHurt) {
				if(abs(hspeed) < 0.3 && abs(vspeed) < 0.2) anim = anFall //To be replaced with regular swim sprites later
				if(abs(hspeed) > 0.3) anim = anSwimF
				if(vspeed > 0.2) anim = anSwimD
				if(vspeed < -0.2) anim = anSwimU
				if(abs(hspeed) > 0.3 && vspeed > 0.2) anim = anSwimDF
				if(abs(hspeed) > 0.3 && vspeed < -0.2) anim = anSwimUF
			}

			//Movement
			if(canMove) {
				if(getcon("run", "hold")) mspeed = 2
				else if(getcon("sneak", "hold")) mspeed = 0.5
				else mspeed = 1

				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += 0.05
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= 0.05
				if(getcon("down", "hold") && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += 0.05
				if(getcon("up", "hold") && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= 0.05
			}

			//Friction
			if(hspeed > 0) hspeed -= friction / 2
			if(hspeed < 0) hspeed += friction / 2
			if(abs(hspeed) < friction / 2) hspeed = 0.0
			if(vspeed > 0) vspeed -= friction / 2
			if(vspeed < 0) vspeed += friction / 2
			if(abs(vspeed) < friction / 2) vspeed = 0.0

			//Change facing
			if(anim != anClimb && anim != anWall) {
				if(hspeed > 0.1) flip = 0
				if(hspeed < -0.1) flip = 1
			}
		}

		//Base movement
		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			//if(abs(vspeed) > 1) vspeed -= vspeed / abs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 2; i++) if(!placeFree(x, y + 2) && placeFree(x + hspeed, y + 1) && !swimming && vspeed >= 0) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= 4; i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						didstep = true
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && abs(hspeed) >= 1) hspeed -= (hspeed / abs(hspeed))
				else if(didstep == false && abs(hspeed) < 1) hspeed = 0
			}
		}

		if(gvMap.w > 320) {
			if(x < 4) x = 4

			if(x > gvMap.w - 4) x = gvMap.w - 4
		} else x = wrap(x, 0, gvMap.w)

		if(anim == anSlide) shape = shapeSlide
		else shape = shapeStand
		shapeStand.setPos(x, y)
		shapeSlide.setPos(x, y)
		if(y > gvMap.h + 16) die()

		//Hurt
		if(hurt) {
			hurt = false
			if(blinking == 0) {
				blinking = 120
				anim = anHurt
				frame = anim[0]
				if(game.health > 0) game.health--
				if(game.health == 0) die()
				playSound(sndHurt, 0)
			}
		}
		if(blinking > 0) blinking--

		//Draw
		switch(game.weapon) {
			case 0:
				sprite = sprTux
				break

			case 1:
				sprite = sprTuxFire
				break

			case 2:
				sprite = sprTuxIce
				break
		}

		//Invincibility
		if(invincible > 0) {
			invincible--
			if(invincible == 0) resumeMusic()
		}
		if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

		if(blinking == 0 || anim == anHurt) drawSpriteEx(sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSpriteEx(sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()
		}
	}

	function die() {
		deleteActor(id)
		gvPlayer = 0
		newActor(TuxDie, x, y)
		game.health = 0
	}

	function _typeof(){ return "Tux" }
}

::TuxDie <- class extends Actor {
	vspeed = -3.0
	timer = 300

	constructor(_x, _y) {
		base.constructor(_x, _y)
		playSound(sndDie, 0)
		game.weapon = 0
		stopMusic()
	}

	function run() {
		vspeed += 0.05
		y += vspeed
		timer--
		if(timer == 0) {
			startPlay(gvMap.file)
			deleteActor(id)
		}
		drawSprite(sprTux, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
	}
}