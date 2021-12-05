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
	tftime = -1 //Timer for transformation
	energy = 0.0
	hidden = false
	jumpBuffer = 0

	//Animations
	anim = [] //Animation frame delimiters: [start, end, speed]
	anStand = [0.0, 3.0]
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
	anSkid = [4.0, 5.0]

	constructor(_x, _y, _arr = null) {
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
		shapeSlide.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) shape = shapeSlide
		local freeDown = placeFree(x, y + 1)
		local freeDown2 = placeFree(x, y + 2)
		local freeLeft = placeFree(x - 1, y)
		local freeRight = placeFree(x + 1, y)
		local freeUp = placeFree(x, y - 1)
		//Checks are done at the beginning and stored here so that they can be
		//quickly reused. Location checks will likely need to be done multiple
		//times per frame.

		//Recharge
		if(firetime > 0 && game.weapon != 3) {
			firetime--
		}

		if(firetime == 0 && energy < game.maxenergy) {
			energy++
			firetime = 60
		}


		if(game.weapon == 0) game.maxenergy = 0
		if(game.weapon == 3) game.maxenergy = 4
		if(energy > game.maxenergy) energy = game.maxenergy

		/////////////
		// ON LAND //
		/////////////
		if(!inWater(x, y)) {
			swimming = false
			shapeStand.h = 12.0

			//Animation states
			switch(anim) {
				case anStand:
					if(game.weapon == 2 && floor(frame) == 0) frame += 0.01
					else if(game.weapon == 2 || game.weapon == 1) frame += 0.1
					else if(game.weapon == 3) frame += 0.05
					else frame += 0.03

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
					if(abs(hspeed) > 1.4) anim = anRun

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anRun:
				case anSkid:
					if(flip == 0 && hspeed < 0) {
						hspeed += 0.01
						anim = anSkid
					}
					else if(flip == 1 && hspeed > 0) {
						hspeed -= 0.01
						anim = anSkid
					}
					else anim = anRun

					if(game.weapon == 2) frame+= abs(hspeed) / 16
					else frame += abs(hspeed) / 8
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
					frame += 0.1
					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}
					break

				case anWall:
					frame += 0.15
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
					frame = getFrames() / 12
					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - abs(hspeed)) == 0 || abs(hspeed) > 8) {
						if(game.weapon == 1) newActor(FlameTiny, x - (8 * (hspeed / abs(hspeed))), y + 10)
						if(game.weapon == 2) newActor(Glimmer, x - (12 * (hspeed / abs(hspeed))), y + 10)
					}
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
					if(abs(hspeed) > 1.5) anim = anSlide
					else anim = anJumpU
					frame = anim[0]
					vspeed -= 1
					if(getcon("jump", "hold") && vspeed > -4) vspeed = -4
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
				if(!placeFree(x, y + 2) && (abs(hspeed) < 4 || (abs(hspeed) < 6 && game.weapon == 2))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.1
					if(placeFree(x - 4, y + 2)) hspeed -= 0.1

					if(placeFree(x + 4, y + 4)) {
						hspeed += 0.1
						vspeed += 0.5
						if(!placeFree(x - 2, y + 2) && hspeed < 0) hspeed += 0.02
					}

					if(placeFree(x - 4, y + 4)) {
						hspeed -= 0.1
						vspeed += 0.5
						if(!placeFree(x + 2, y + 2) && hspeed > 0) hspeed -= 0.02
					}
				}

				if((!getcon("down", "hold") && !freeDown) || abs(hspeed) < 0.01) anim = anWalk
			}

			if(anim != anClimb && anim != anWall) {
				if((getcon("right", "hold") && !getcon("left", "hold") && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold") && !getcon("right", "hold") && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!freeDown2 || anim == anClimb) {
				canJump = 16
				if(game.weapon == 3 && energy < 4) energy += 0.1
			}
			else {
				if(canJump > 0) canJump--
				if(game.weapon == 3 && energy < 1) energy += 0.01
			}
			if(canMove) {
				if(getcon("run", "hold") || abs(joyX(0)) >= js_max * 0.9) {
					if(game.weapon == 2) mspeed = 2.0
					else mspeed = 1.75
				}
				else if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1)) mspeed = 0.5
				else mspeed = 1

				//Moving left and right
				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) hspeed += 0.1
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) hspeed -= 0.1

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
					if(atLadder()) felloff = false
					if(felloff) {
						anim = anFall
						frame = anim[0]
					}

					//Change direction
					if(getcon("right", "press") && canMove) flip = 0
					if(getcon("left", "press") && canMove) flip = 1

					//Ping-pong animation
					if(frame >= anim[1] + 0.4 || frame <= anim[0] + 0.4) {
						climbdir = -climbdir
						if(frame > anim[1] + 0.4) frame -= abs(climbdir / 8)
						if(frame < anim[0] + 0.4) frame += abs(climbdir / 8)
					}
				}

				//Get on ladder
				if((getcon("down", "hold") || getcon("up", "hold")) && anim != anHurt && anim != anClimb && (vspeed >= 0 || getcon("down", "press") || getcon("up", "press"))) {
					if(atLadder()) {
						anim = anClimb
						frame = anim[0]
						hspeed = 0
						vspeed = 0
						x = (x - (x % 16)) + 7
					}
				}

				//Jumping
				if(getcon("jump", "press") || jumpBuffer > 0) {
					if(onPlatform() && !placeFree(x, y + 1) && getcon("down", "hold")) {
						y++
						canJump = 32
					}
					else if(canJump > 0) {
						jumpBuffer = 0
						if(game.weapon == 3) vspeed = -3
						else vspeed = -3.8
						didJump = true
						if(game.weapon != 3) canJump = 0
						if(anim != anHurt && anim != anDive) {
							anim = anJumpU
							frame = anim[0]
						}
						if(game.weapon != 3) playSound(sndJump, 0)
						else playSound(sndFlap, 0)
					}
					else if(freeDown && anim != anClimb && !placeFree(x - 2, y) && anim != anWall && hspeed <= 0) {
						flip = 0
						anim = anWall
						frame = anim[0]
					}
					else if(freeDown && anim != anClimb && !placeFree(x + 2, y) && anim != anWall && hspeed >= 0) {
						flip = 1
						anim = anWall
						frame = anim[0]
					}
					else if(floor(energy) > 0 && game.weapon == 3 && getcon("jump", "press")) {
						if(vspeed > 0) vspeed = 0.0
						if(vspeed > -4) vspeed -= 1.8
						didJump = true
						if(game.weapon != 3) canJump = 0
						if(anim != anHurt && anim != anDive) {
							anim = anJumpU
							frame = anim[0]
						}
						if(game.weapon != 3) playSound(sndJump, 0)
						else playSound(sndFlap, 0)
						energy--
					}
				}
				if(getcon("jump", "press") && jumpBuffer <= 0 && freeDown) jumpBuffer = 12
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release") && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2
				}

				//Going into slide
				if(!freeDown2 && getcon("down", "hold") && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt) {
					if(placeFree(x + 2, y + 1) || hspeed >= 1.5) {
						anim = anDive
						frame = anim[0]
						flip = 0
						playSound(sndSlide, 0)
					}

					if(placeFree(x - 2, y + 1) || hspeed <= -1.5) {
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
					if(abs(hspeed) == 0) {
						if(placeFree(x, y - 16)) {
							anim = anStand
							shape = shapeStand
						} else {
							if(getcon("left", "hold")) hspeed -= 0.1
							if(getcon("right", "hold")) hspeed += 0.1
						}
					}
				} else {
					if(hspeed > 0) {
						if(!getcon("right", "hold")) hspeed -= friction
						else hspeed -= friction / 4
					}
					if(hspeed < 0) {
						if(!getcon("left", "hold")) hspeed += friction
						else hspeed += friction / 4
					}
				}
			}
			else if(anim != anSlide && anim != anDive) {
				if(hspeed > 0 && !getcon("right", "hold")) hspeed -= friction / 3
				if(hspeed < 0 && !getcon("left", "hold")) hspeed += friction / 3
			}

			if(abs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 1.5 || (vspeed < 3 && (game.weapon != 3 || getcon("down", "hold"))))) vspeed += gravity
			if(!freeUp && vspeed < 0) vspeed = 0.0 //If Tux bumped his head
			if(!freeDown && vspeed >= 0) {
				//If Tux hits the ground while sliding
				if(anim == anSlide) {
					if(flip) hspeed -= vspeed / 5
					else hspeed += vspeed / 5

					if(game.weapon == 2) {
						if(hspeed > 6) hspeed = 6
						if(hspeed < -6) hspeed = -6
					}
					else {
						if(hspeed > 4) hspeed = 4
						if(hspeed < -4) hspeed = -4
					}
				} else vspeed = 0.0
			}

			//Gravity cases
			if(game.weapon == 3) gravity = 0.05
			else gravity = 0.11
			if(anim == anClimb || anim == anWall) gravity = 0

			//Attacks
			switch(game.weapon) {
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Fireball, x + fx, y - 4)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) c.vspeed = -2
						if(getcon("down", "hold")) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
					}
					break

				case 2:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Iceball, x + fx, y - 4)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) c.vspeed = -2
						if(getcon("down", "hold")) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
					}
					break

				case 3:
					if(getcon("shoot", "press") && (anim == anJumpT || anim == anJumpU || anim == anFall)) {
						anim = anDive
						frame = anim[0]
						playSound(sndSlide, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break
			}

		}
		//////////////
		// IN WATER //
		//////////////
		else {
			swimming = true
			if(game.weapon == 3 && energy < 4) energy += 0.1
			shapeStand.h = 6.0

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
				if(getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9)) {
					if(game.weapon == 2) mspeed = 2.0
					else mspeed = 1.75
				}
				else if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1)) mspeed = 0.5
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

			//Attacks
			switch(game.weapon) {
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Fireball, x + fx, y - 4)]
						if(!flip) c.hspeed = 1.5
						else c.hspeed = -1.5
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -1.0
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -1.5
							}
						}
						if(getcon("down", "hold")) {
							c.vspeed = 1.0
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 1.5
							}
						}

						c.hspeed += hspeed / 1.5
						c.vspeed += vspeed / 1.5

						energy--
						firetime = 60
					}
					break

				case 2:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Iceball, x + fx, y - 4)]
						if(!flip) c.hspeed = 1.5
						else c.hspeed = -1.5
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -1.0
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -1.5
							}
						}
						if(getcon("down", "hold")) {
							c.vspeed = 1.0
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 1.5
							}
						}

						c.hspeed += hspeed / 2
						c.vspeed += vspeed / 2

						energy--
						firetime = 60
					}
					break
			}
		}

		//Swap item
		if(canMove && getcon("swap", "press")) swapitem()

		//Base movement
		shape.setPos(x, y)

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
						if(i > 2) hspeed /= 2
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
		if(y > gvMap.h + 16) {
			die()
			return
		}
		if(y < -100) y = -100.0

		//Hurt
		if(onHazard(x, y)) hurt = true
		if(onDeath(x, y)) game.health = 0

		if(hurt) {
			hurt = false
			if(blinking == 0) {
				blinking = 120
				anim = anHurt
				frame = anim[0]
				if(game.health > 0) game.health--
				playSound(sndHurt, 0)
			}
		}
		if(blinking > 0) blinking--
		if(game.health == 0) {
			die()
			return
		}

		//Draw
		if(!hidden) {
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

				case 3:
					sprite = sprTuxAir
					break

				case 4:
					sprite = sprTuxEarth
					break
			}

			//Invincibility
			if(invincible > 0) {
				invincible--
				if(invincible == 0) songPlay(gvMusicName)
			}
			if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

			if(blinking == 0 || anim == anHurt) drawSpriteEx(sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, 1)
			else drawSpriteEx(sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}
		}

		//Transformation flash
		if(tftime != -1) {
			if(tftime < 4) {
				if(!hidden) drawSprite(sprTFflash, tftime, x - camx, y - camy)
				tftime += 0.25
			} else tftime = -1
		}

		hidden = false
	}

	function atLadder() {
		//Save current location and move
		local ns = Rec(x + shape.ox, y + shape.oy, shape.w, shape.h, shape.kind)
		local cx = floor(x / 16)
		local cy = floor(y / 16)

		//Check that the solid layer exists
		local wl = null //Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		//Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 29) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 1.0
				gvMap.shape.h = 8.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function die() {
		deleteActor(id)
		gvPlayer = 0
		newActor(TuxDie, x, y)
		game.health = 0
	}

	function swapitem() {
		if(game.subitem == 0) return
		local swap = game.subitem

		if(game.weapon == game.subitem) {
			if(game.maxenergy < 4 - game.difficulty) {
				game.maxenergy++
				game.subitem = 0
				tftime = 0
				playSound(sndHeal, 0)
			}
			return
		}

		if(swap < 5) {
			game.subitem = game.weapon
			game.weapon = 0
		}

		switch(swap) {
			case 1:
				newActor(FlowerFire, x, y)
				break
			case 2:
				newActor(FlowerIce, x, y)
				break
			case 3:
				newActor(AirFeather, x, y)
				break
			case 4:
				break
			case 5:
				if(game.health < game.maxHealth) {
					newActor(MuffinBlue, x, y)
					game.subitem = 0
				}
				break
			case 6:
				if(game.health < game.maxHealth) {
					newActor(MuffinRed, x, y)
					game.subitem = 0
				}
				break
			case 7:
				newActor(Starnyan, x, y)
				break
		}
	}

	function _typeof(){ return "Tux" }
}

::TuxDie <- class extends Actor {
	vspeed = -3.0
	timer = 300
	mywep = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		stopMusic()
		playSound(sndDie, 0)
		mywep = game.weapon
		if(game.lives == 0 || game.check == false) game.weapon = 0
	}

	function run() {
		vspeed += 0.05
		y += vspeed
		timer--
		if(timer == 0) {
			startPlay(gvMap.file)
			if(game.check == true || game.difficulty > 0) if(game.lives > 0) game.lives--
			if(game.lives == 0) game.check = false
		}
		switch(mywep) {
			case 0:
				drawSprite(sprTux, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
				break
			case 1:
				drawSprite(sprTuxFire, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
				break
			case 2:
				drawSprite(sprTuxIce, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
				break
			case 3:
				drawSprite(sprTuxAir, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
				break
		}
	}
}