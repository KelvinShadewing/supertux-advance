/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	friction = 0.1
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
	rspeed = 0.0 //Run animation speed
	slideframe = 0.0 //Because using just frame gets screwy for some reason
	wasInWater = false

	//Animations
	anim = [] //Animation frame delimiters: [start, end, speed]
	anStand = [0.0, 3.0, "stand"]
	anWalk = [8.0, 15.0, "walk"]
	anRun = [16.0, 23.0, "run"]
	anDive = [24.0, 25.0, "dive"]
	anSlide = [26.0, 29.0, "slide"]
	anHurt = [30.0, 31.0, "hurt"]
	anJumpU = [32.0, 33.0, "jumpU"]
	anJumpT = [34.0, 35.0, "jumpT"]
	anFall = [36.0, 37.0, "fall"]
	anClimb = [44.0, 47.0, "climb"]
	anWall = [48.0, 49.0, "wall"]
	anSwimF = [52.0, 55.0, "swim"]
	anSwimUF = [56.0, 59.0, "swim"]
	anSwimDF = [60.0, 63.0, "swim"]
	anSwimU = [64.0, 67.0, "swim"]
	anSwimD = [68.0, 71.0, "swim"]
	anSkid = [4.0, 5.0, "skid"]
	anPush = [6.0, 7.0, "push"]

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anim = anStand
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(!gvPlayer) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
		energy = game.maxenergy
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
		local nowInWater = inWater(x, y)
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
		if(!inWater(x, y) || game.weapon == 4) {
			swimming = false
			shapeStand.h = 12.0

			//Animation states
			switch(anim) {
				case anStand:
					if(game.weapon == 2 && floor(frame) == 0) frame += 0.01
					else if(game.weapon == 2 || game.weapon == 1) frame += 0.1
					else if(game.weapon == 3) frame += 0.05
					else frame += 0.05

					if(abs(rspeed) > 0.1) {
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
					frame += abs(rspeed) / 8
					if(abs(rspeed) <= 0.1 || abs(hspeed) <= 0.1) anim = anStand
					if(abs(rspeed) > 2.4) anim = anRun

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anRun:
				case anSkid:
					if(flip == 0 && hspeed < 0) {
						hspeed += 0.05
						anim = anSkid
					}
					else if(flip == 1 && hspeed > 0) {
						hspeed -= 0.05
						anim = anSkid
					}
					else anim = anRun

					if(anim == anSkid) frame += 0.2
					else if(game.weapon == 2) frame += abs(rspeed) / 16
					else frame += abs(rspeed) / 8
					if(abs(rspeed) < 2 && anim != anSkid) anim = anWalk

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}

					break

				case anPush:
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
					frame += 0.3
					vspeed = 0

					if(floor(frame) > anim[1]) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = anim[0]
					}
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > anim[1]) {
						anim = anSlide
						shape = shapeSlide
					}
					break

				case anSlide:
					if(game.weapon == 4) slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 16.0)
					frame = slideframe

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
					if(getcon("jump", "hold") && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = anim[0]
					break
			}

			if(anim != anClimb) frame = wrap(abs(frame), anim[0], anim[1])

			//Sliding acceleration
			if(anim == anDive || anim == anSlide || onIce()) {
				if(!placeFree(x, y + 4) && (abs(hspeed) < 8 || (abs(hspeed) < 12 && game.weapon == 2))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.25
					if(placeFree(x - 4, y + 2)) hspeed -= 0.25
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (abs(hspeed) < 8 || (abs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				if(((!getcon("down", "hold") || abs(hspeed) < 0.05) && !freeDown && game.weapon != 4) || (abs(hspeed) < 0.05 && (game.weapon == 4 && !getcon("shoot", "hold"))) || (game.weapon == 4 && !getcon("shoot", "hold") && !getcon("down", "hold"))) if(anim == anSlide || anim == anDive) anim = anWalk
			}

			if(anim != anClimb && anim != anWall) {
				if((getcon("right", "hold") && !getcon("left", "hold") && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold") && !getcon("right", "hold") && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!freeDown2 || anim == anClimb) {
				canJump = 16
				if(game.weapon == 3 && energy < 4) energy += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(game.weapon == 3 && energy < 1) energy += 0.02
			}
			if(canMove) {
				if(getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9)) {
					if(game.weapon == 2) mspeed = 3.5
					else mspeed = 3.0
				}
				else if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1)) mspeed = 1.0
				else mspeed = 2.0
				if(nowInWater) mspeed *= 0.8

				//Moving left and right
				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed += 0.1
					else hspeed += 0.2
				}
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed -= 0.1
					else hspeed -= 0.2
				}

				//Change run animation speed
				if(getcon("right", "hold") && rspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeRight || placeFree(x + 1, y - 2)) {
					rspeed += 0.2
					if(rspeed < hspeed) rspeed = hspeed
				}
				if(getcon("left", "hold") && rspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeLeft || placeFree(x - 1, y - 2)) {
					rspeed -= 0.2
					if(rspeed > hspeed) rspeed = hspeed
				}
				if(rspeed > 0) rspeed -= 0.1
				if(rspeed < 0) rspeed += 0.1
				if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold") && !getcon("left", "hold")) rspeed = 0.0
				if(anim == anSlide) rspeed = hspeed

				//On a ladder
				if(anim == anClimb) {
					vspeed = 0

					//Ladder controls
					if(getcon("up", "hold")) if(placeFree(x, y - 2)) {
						frame -= climbdir / 8
						y -= 2
					}

					if(getcon("down", "hold")) if(placeFree(x, y + 2)) {
						frame += climbdir / 8
						y += 2
					}

					//Check if still on ladder
					local felloff = true
					if(atLadder()) felloff = false
					if(felloff) {
						anim = anFall
						frame = anim[0]
						if(getcon("up", "hold")) vspeed = -2.5
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
						if(anim == anClimb) vspeed = -3
						else if(game.weapon == 3 || nowInWater) vspeed = -5.0
						else vspeed = -5.8
						didJump = true
						if(game.weapon != 3) canJump = 0
						if(anim != anHurt && anim != anDive && (game.weapon != 4 || anim != anSlide)) {
							anim = anJumpU
							frame = anim[0]
						}
						if(game.weapon != 3) playSoundChannel(sndJump, 0, 0)
						else playSoundChannel(sndFlap, 0, 0)
					}
					else if(freeDown && anim != anClimb && !placeFree(x - 2, y) && anim != anWall && hspeed <= 0 && tileGetSolid(x - 8, y) != 40) {
						flip = 0
						anim = anWall
						frame = anim[0]
						playSound(sndWallkick, 0)
					}
					else if(freeDown && anim != anClimb && !placeFree(x + 2, y) && anim != anWall && hspeed >= 0 && tileGetSolid(x + 8, y) != 40) {
						flip = 1
						anim = anWall
						frame = anim[0]
						playSound(sndWallkick, 0)
					}
					else if(floor(energy) > 0 && game.weapon == 3 && getcon("jump", "press")) {
						if(vspeed > 0) vspeed = 0.0
						if(vspeed > -4) vspeed -= 3.0
						didJump = true
						if(game.weapon != 3) canJump = 0
						if(anim != anHurt && anim != anDive) {
							anim = anJumpU
							frame = anim[0]
						}
						if(game.weapon != 3) playSoundChannel(sndJump, 0, 0)
						else playSoundChannel(sndFlap, 0, 0)
						energy--
					}
				}
				if(getcon("jump", "press") && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release") && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2.5
				}

				//Going into slide
				if(((!freeDown2 && getcon("down", "hold")) || (getcon("shoot", "hold") && game.weapon == 4)) && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall) {
					if(placeFree(x + 2, y + 1) || hspeed >= 1.5) {
						anim = anDive
						frame = anim[0]
						flip = 0
						playSoundChannel(sndSlide, 0, 0)
					}

					if(placeFree(x - 2, y + 1) || hspeed <= -1.5) {
						anim = anDive
						frame = anim[0]
						flip = 1
						playSoundChannel(sndSlide, 0, 0)
					}
				}
			} else {
				if(hspeed < 1 && endmode) hspeed += 0.2
				if(endmode && placeFree(x + 2, y)) rspeed = hspeed
				else rspeed = 0
			}

			//Movement
			if(!freeDown2) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!getcon("right", "hold")) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!getcon("left", "hold")) hspeed += friction
					}
				}
			}
			else if(anim != anSlide && anim != anDive) {
				if(hspeed > 0 && !getcon("right", "hold")) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold")) hspeed += friction / 3.0
			}

			if(abs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && (game.weapon != 3 || getcon("down", "hold")) && !nowInWater))) vspeed += gravity
			if(!freeUp && vspeed < 0) vspeed = 0.0 //If Tux bumped his head

			//Entering water
			if(nowInWater && !wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			if(!nowInWater && wasInWater) {
				wasInWater = false
				newActor(Splash, x, y)
			}


			if(anim == anSlide && !freeDown && vspeed >= 0 && placeFree(x + hspeed, y)) {
				//If Tux hits the ground while sliding
				if(flip) hspeed -= vspeed / 2.5
				else hspeed += vspeed / 2.5
				vspeed = 0
			}

			//Max ground speed
			if(!freeDown){
				if(game.weapon == 2) {
					if(hspeed > 8) hspeed = 8
					if(hspeed < -8) hspeed = -8
				}
				else {
					if(hspeed > 6) hspeed = 6
					if(hspeed < -6) hspeed = -6
				}
			}

			//Gravity cases
			if(game.weapon == 3 || nowInWater) gravity = 0.12
			else gravity = 0.25
			if(anim == anClimb || anim == anWall) gravity = 0

			//Attacks
			switch(game.weapon) {
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Fireball, x + fx, y - 4)]
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
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
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
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
					if(getcon("shoot", "press") && (anim == anJumpT || anim == anJumpU || anim == anFall) && anim != anHurt) {
						anim = anDive
						frame = anim[0]
						playSoundChannel(sndSlide, 0, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break

				case 4:
					if(getcon("shoot", "press") && (anim != anHurt)) {
						anim = anDive
						frame = anim[0]
						playSoundChannel(sndSlide, 0, 0)
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
			if(!wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}

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
					break
				case anFall:
					frame += 0.01
					break
			}

			frame = wrap(abs(frame), anim[0], anim[1])

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
					if(game.weapon == 2) mspeed = 3.0
					else mspeed = 2.8
				}
				else if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1)) mspeed = 2.0
				else mspeed = 1.0

				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += 0.1
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= 0.1
				if(getcon("down", "hold") && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += 0.1
				if(getcon("up", "hold") && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= 0.1
			}

			//Friction
			if(hspeed > 0) hspeed -= friction / 2
			if(hspeed < 0) hspeed += friction / 2
			if(abs(hspeed) < friction / 2) hspeed = 0.0
			if(vspeed > 0) vspeed -= friction / 2
			if(vspeed < 0) vspeed += friction / 2
			if(abs(vspeed) < friction / 2) vspeed = 0.0
			if(vspeed > 4) vspeed -= 0.2

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
						local c = actor[newActor(Fireball, x + fx, y)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold")) {
							c.vspeed = 3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 3
							}
						}

						c.hspeed += hspeed / 3
						c.vspeed += vspeed / 3

						energy--
						firetime = 60
					}
					break

				case 2:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = actor[newActor(Iceball, x + fx, y)]
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold")) {
							c.vspeed = 3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 3
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
			if(abs(vspeed) < 0.01) vspeed = 0
			//if(abs(vspeed) > 1) vspeed -= vspeed / abs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 4; i++) if(!placeFree(x, y + 4) && placeFree(x + hspeed, y + 1) && !swimming && vspeed >= 0 && !placeFree(x + hspeed, y + 4)) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= 8; i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						if(i > 2) {
							if(hspeed > 0) hspeed -= 0.2
							if(hspeed < 0) hspeed += 0.2
						}
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

		//Set ice friction
		if(onIce()) friction = 0.05
		else friction = 0.1

		//Hurt
		if(onHazard(x, y)) hurt = true
		if(onDeath(x, y)) game.health = 0

		if(hurt && invincible == 0) {
			hurt = false
			if(blinking == 0) {
				blinking = 120
				anim = anHurt
				frame = anim[0]
				if(game.health > 0) game.health--
				playSound(sndHurt, 0)
				if(flip == 0) hspeed = -2.0
				else hspeed = 2.0
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

			if(blinking == 0 || anim == anHurt) drawSpriteExZ(0, sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, 1)
			else drawSpriteExZ(0, sprite, floor(frame), x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}
		}

		//Transformation flash
		if(tftime != -1) {
			if(tftime < 4) {
				if(!hidden) drawSpriteZ(1, sprTFflash, tftime, x - camx, y - camy)
				tftime += 0.25
			} else tftime = -1
		}

		hidden = false

		if(debug) drawText(font, x - camx - 8, y - 32 - camy, anim[2] + "\n" + frame.tostring())
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
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 29 || wl.data[tile] - gvMap.solidfid == 50) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 1.0
				gvMap.shape.h = 12.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function die() {
		deleteActor(id)
		gvPlayer = false
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
				newActor(EarthShell, x, y)
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
	vspeed = -4.0
	timer = 150
	mywep = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		stopMusic()
		playSound(sndDie, 0)
		mywep = game.weapon
		if(game.lives == 0 || game.check == false) game.weapon = 0
	}

	function run() {
		vspeed += 0.1
		y += vspeed
		timer--
		if(timer == 0) {
			startPlay(gvMap.file)
			if(game.check == true || game.difficulty > 0) if(game.lives > 0) game.lives--
			if(game.lives == 0) game.check = false
			if(game.check == false) gvIGT = 0
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
			case 4:
				drawSprite(sprTuxEarth, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
				break
		}
	}
}