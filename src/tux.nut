::Tux <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 4 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	startx = 0.0
	starty = 0.0
	firetime = 0
	hurt = 0
	swimming = false
	sliding = false
	endMode = false
	canStomp = true //If they can use jumping as an attack
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
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0

	//Animations
	anStandN = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 76, 77, 78, 79, 78, 79, 78, 79, 78, 79, 78, 77, 76]
	anStandF = [0, 1, 2, 3]
	anStandI = [0, 1, 2, 3]
	anStandA = [0, 1, 2, 3]
	anStandE = [0, 1, 2, 3]
	anWalk = [8, 9, 10, 11, 12, 13, 14, 15]
	anRun = [16, 17, 18, 19, 20, 21, 22, 23]
	anDive = [24, 25]
	anSlide = [26, 27, 28, 29]
	anHurt = [30, 31]
	anJumpU = [32, 33]
	anJumpT = [34, 35]
	anFall = null
	anFallN = [36, 37]
	anFallW = [48]
	anSwimF = [52, 53, 54, 55]
	anSwimUF = [56, 57, 58, 59]
	anSwimDF = [60, 61, 62, 63]
	anSwimU = [64, 65, 66, 67]
	anSwimD = [68, 69, 70, 71]
	anSkid = [4, 5]
	anPush = [6, 7]
	anClimb = [44, 45, 46, 47, 46, 45]
	anWall = [48, 49]
	anCrawl = [72, 73, 74, 75, 74, 73]

	nowInWater = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeCrouch = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		energy = game.maxEnergy
		anFall = anFallN
		anStand = anStandN
		routine = ruNormal
		anim = anStand
	}

	function physics() {
		//Reset state variables
		swimming = false
		if(inWater(x, y) && game.weapon != 4) swimming = true
		sliding = false
		if(anim == anDive || anim == anSlide || onIce()) sliding = true

		nowInWater = inWater(x, y)

		//Side checks
		shapeCrouch.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) {
			shape = shapeCrouch
			if(anim == anStand || anim == anWalk || anim == anRun) anim = anCrawl
		}

		//////////////
		// IN WATER //
		//////////////
		if(swimming) {
			if(game.weapon == 3 && energy < 4) energy += 0.1
			shapeStand.h = 6.0
			if(!wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			anFall = anFallN
			if(anim == anFallW) anim = anFallN

			//Friction
			if(hspeed > 0) hspeed -= friction / 2
			if(hspeed < 0) hspeed += friction / 2
			if(fabs(hspeed) < friction / 2) hspeed = 0.0
			if(vspeed > 0) vspeed -= friction / 2
			if(vspeed < 0) vspeed += friction / 2
			if(fabs(vspeed) < friction / 2) vspeed = 0.0
			if(vspeed > 4) vspeed -= 0.2

			//Change facing
			if(anim != anClimb && anim != anWall) {
				if(hspeed > 0.1) flip = 0
				if(hspeed < -0.1) flip = 1
			}

			if(vspeed < 0) canJump = 0
		}

		///////////////
		// ON GROUND //
		///////////////
		else {
			shapeStand.h = 12.0

			//Sliding acceleration
			if(sliding) {
				if(!placeFree(x, y + 4) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && game.weapon == 2))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.25
					if(placeFree(x - 4, y + 2)) hspeed -= 0.25
					if(placeFree(x, y + 2))vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2
			}

			//Movement
			if(!placeFree(x, y + 2)) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!(mspeed > 2 && getcon("right", "hold")) || anim == anCrawl) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!(mspeed > 2 && getcon("left", "hold")) || anim == anCrawl) hspeed += friction
					}
				}
			}
			else if(anim != anSlide && anim != anDive) {
				if(hspeed > 0 && !getcon("right", "hold")) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold")) hspeed += friction / 3.0
			}

			if(fabs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && (game.weapon != 3 || getcon("down", "hold")) && !nowInWater)) && antigrav <= 0) vspeed += gravity
			else if(antigrav > 0) antigrav--
			if(!placeFree(x, y - 1) && vspeed < 0) vspeed = 0.0 //If Tux bumped his head

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

			if(anim == anSlide && !placeFree(x, y + 1) && vspeed >= 0 && placeFree(x + hspeed, y)) {
				//If Tux hits the ground while sliding
				if(flip) hspeed -= vspeed / 2.5
				else hspeed += vspeed / 2.5
				vspeed = 0
			}

			//Max ground speed
			if(!placeFree(x, y + 1)){
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

			//Check solid ground position
			if(!placeFree(x, y + 1) && !onPlatform()) {
				groundx = x
				groundy = y
			}

			//Set ice friction
			if(onIce()) friction = 0.01
			else friction = 0.1
		}

		if(x < 4) x = 4
		if(x > gvMap.w - 4) x = gvMap.w - 4

		if(anim == anSlide || anim == anCrawl) shape = shapeCrouch
		else shape = shapeStand
		shapeStand.setPos(x, y)
		shapeCrouch.setPos(x, y)
		if(y > gvMap.h + 16) {
			die()
			return
		}
		if(y < -100) y = -100.0

		//Hurt
		if(onHazard(x, y)) hurt = 2
		if(onDeath(x, y)) game.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(game.weapon == 4 && anim == anSlide && energy > 0) {
					energy--
					firetime = 120
					newActor(Spark, x, y)
				}
				else {
					if(game.health > 0) game.health -= hurt
					if(flip == 0) hspeed = -2.0
					else hspeed = 2.0
					anim = anHurt
					frame = 0.0
				}
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--
		if(game.health == 0) {
			die()
			return
		}

		base.physics()
	}

	function animation() {
		if(anim == null) return
		if(typeof anim != "array") return

		if(!swimming) {
			switch(anim) {
				case anStand:
					if(game.weapon == 2 && floor(frame) == 0) frame += 0.01
					else if(game.weapon == 2 || game.weapon == 1) frame += 0.1
					else if(game.weapon == 3) frame += 0.05
					else frame += 0.05

					if(abs(rspeed) > 0.1) {
						anim = anWalk
						frame = 0.0
					}

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}
					break

				case anWalk:
					frame += abs(rspeed) / 8
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = anStand
					if(abs(rspeed) > 2.4) anim = anRun

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
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
						frame = 0.0
					}

					break

				case anPush:
					break

				case anJumpU:
					if(frame < anim[0] + 1) frame += 0.1

					if(!placeFree(x, y + 1)) {
						anim = anStand
						frame = 0.0
					}

					if(vspeed > 0) {
						anim = anJumpT
						frame = 0.0
					}
					break

				case anJumpT:
					frame += 0.2
					if(!placeFree(x, y + 1)) {
						anim = anStand
						frame = 0.0
					}

					if(frame > anim.len() - 1) {
						anim = anFall
						frame = 0.0
					}
					break

				case anFall:
					frame += 0.1
					if(!placeFree(x, y + 1)) {
						anim = anStand
						frame = 0.0
					}
					break

				case anWall:
					frame += 0.3
					vspeed = 0

					if(floor(frame) > 1) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = 0.0
					}

					if(!placeFree(x - 1, y)) flip = 0
					if(!placeFree(x + 1, y)) flip = 1
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > anim.len() - 1) {
						if(fabs(hspeed) < 0.5 && game.weapon != 4) anim = anCrawl
						else anim = anSlide
						shape = shapeCrouch
					}
					break

				case anSlide:
					if(game.weapon == 4) slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 24.0)
					frame = slideframe

					if(!placeFree(x, y + 1) && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
						if(game.weapon == 1) newActor(FlameTiny, x - (8 * (hspeed / fabs(hspeed))), y + 10)
						if(game.weapon == 2) newActor(Glimmer, x - (12 * (hspeed / fabs(hspeed))), y + 10)
					}
					break

				case anHurt:
					frame += 0.1
					if(floor(frame) > anim.len() - 1) {
						anim = anStand
						frame = 0.0
					}
					break

				case anSwimF:
					anim = anJumpT
					frame = 0.0
					break

				case anSwimUF:
				case anSwimU:
					if(fabs(hspeed) > 1.5) anim = anSlide
					else anim = anJumpU
					frame = 0.0
					vspeed -= 1
					if(getcon("jump", "hold") && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = 0.0
					break
			}
		}

		//////////////
		// IN WATER //
		//////////////
		else {
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
					if(floor(frame) > anim.len() - 1) {
						anim = anFall
						frame = 0.0
					}
					break
				case anFall:
					frame += 0.01
					break
			}

			//Swich swim directions
			if(anim != anHurt) {
				if(fabs(hspeed) < 0.3 && fabs(vspeed) < 0.2) anim = anFall //To be replaced with regular swim sprites later
				if(fabs(hspeed) > 0.3) anim = anSwimF
				if(vspeed > 0.2) anim = anSwimD
				if(vspeed < -0.2) anim = anSwimU
				if(fabs(hspeed) > 0.3 && vspeed > 0.2) anim = anSwimDF
				if(fabs(hspeed) > 0.3 && vspeed < -0.2) anim = anSwimUF
			}
		}

		if(anim == null) return
		frame = wrap(abs(frame), 0, anim.len() - 1)

		//Draw
		if(!hidden) {
			switch(game.weapon) {
				case 0:
					sprite = sprTux
					anStand = anStandN
					break

				case 1:
					sprite = sprTuxFire
					anStand = anStandF
					break

				case 2:
					sprite = sprTuxIce
					anStand = anStandI
					break

				case 3:
					sprite = sprTuxAir
					anStand = anStandA
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


			if(blinking == 0 || anim == anHurt) drawSpriteExZ(0, sprite, anim[floor(frame)], x - camx, y - camy, 0, flip, 1, 1, 1)
			else drawSpriteExZ(0, sprite, anim[floor(frame)], x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
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

		drawLight(sprLightBasic, 0, x - camx, y - camy)

		hidden = false

		if(debug) drawText(font, x - camx - 8, y - 32 - camy, anim[2] + "\n" + frame.tostring())
	}

	function ruNormal() {
		if(!canMove) return

		if(sliding) {
			if(((!getcon("down", "hold") && !autocon.down || fabs(hspeed) < 0.05) && !placeFree(x, y + 1) && game.weapon != 4) || (fabs(hspeed) < 0.05 && (game.weapon == 4 && !getcon("shoot", "hold"))) || (game.weapon == 4 && !getcon("shoot", "hold") && !getcon("down", "hold") && !autocon.down)) if(anim == anSlide || anim == anCrawl) {
				if(getcon("down", "hold") || autocon.down|| !placeFree(x, y - 8) || autocon.down) anim = anCrawl
				else anim = anWalk
			}

			if(getcon("jump", "press") || getcon("up", "press")) if(!getcon("shoot", "hold")) if(placeFree(x, y + 2) && placeFree(x, y - 2)) anim = anFall
		}

		//////////////
		// IN WATER //
		//////////////
		if(swimming) {
			//Movement
			if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed) mspeed = 0.5
			else if(getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) {
				if(game.weapon == 2) mspeed = 3.0
				else mspeed = 2.8
				if(invincible) mspeed += 0.4
			}
			else mspeed = 1.0

			if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += 0.1
			if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= 0.1
			if(getcon("down", "hold") && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += 0.1
			if(getcon("up", "hold") && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= 0.1

						//Attacks
			if(canMove) switch(game.weapon) {
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
		
		///////////////
		// ON GROUND //
		///////////////
		else {
			//Jumping
			if(getcon("jump", "press") || jumpBuffer > 0) {
				if(onPlatform() && !placeFree(x, y + 2) && getcon("down", "hold")) {
					y++
					canJump = 32
				}
				else if(canJump > 0 && placeFree(x, y - 2)) {
					jumpBuffer = 0
					if(anim == anClimb) vspeed = -3
					else if(game.weapon == 3 || nowInWater) vspeed = -5.0
					else vspeed = -5.8
					didJump = true
					if(game.weapon != 3) canJump = 0
					if(anim != anHurt && anim != anDive && (game.weapon != 4 || anim != anSlide)) {
						anim = anJumpU
						frame = 0.0
					}
					if(game.weapon != 3) {
						stopSound(sndJump)
						playSound(sndJump, 0)
					}
					else {
						stopSound(sndFlap)
						playSound(sndFlap, 0)
					}
					canJump = 0
				}
				else if(placeFree(x, y + 2) && anim != anClimb && !placeFree(x - 2, y) && anim != anWall && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40) {
					flip = 0
					anim = anWall
					frame = 0.0
					playSound(sndWallkick, 0)
				}
				else if(placeFree(x, y + 2) && anim != anClimb && !placeFree(x + 2, y) && anim != anWall && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40) {
					flip = 1
					anim = anWall
					frame = 0.0
					playSound(sndWallkick, 0)
				}
				else if(floor(energy) > 0 && game.weapon == 3 && getcon("jump", "press")) {
					if(vspeed > 0) vspeed = 0.0
					if(vspeed > -4) vspeed -= 3.0
					didJump = true
					if(game.weapon != 3) canJump = 0
					if(anim != anHurt && anim != anDive) {
						anim = anJumpU
						frame = 0.0
					}
					if(game.weapon != 3) {
						stopSound(sndJump)
						playSound(sndJump, 0)
					}
					else {
						stopSound(sndFlap)
						playSound(sndFlap, 0)
					}
					energy--
				}
			}

			//Wall slide
			if((anim == anFallN || anim == anFallW) && ((getcon("left", "hold") && !placeFree(x - 1, y)) || (getcon("right", "hold") && !placeFree(x + 1, y)))) {
				if(!placeFree(x - 1, y) && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
					if(vspeed > 0.5) vspeed = 0.5
					if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
					anFall = anFallW
					anim = anFallW
					flip = 0
				}
				if(!placeFree(x + 1, y) && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
					if(vspeed > 0.5) vspeed = 0.5
					if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x + 4, y + 12)
					anFall = anFallW
					anim = anFallW
					flip = 1
				}
			} else {
				anFall = anFallN
				if(anim == anFallW) anim = anFallN
			}

			if(getcon("jump", "press") && jumpBuffer <= 0 && placeFree(x, y + 1)) jumpBuffer = 8
			if(jumpBuffer > 0) jumpBuffer--

			if(getcon("jump", "release") && vspeed < 0 && didJump)
			{
				didJump = false
				vspeed /= 2.5
			}

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
					frame = 0.0
					if(getcon("up", "hold")) vspeed = -2.5
				}

				//Change direction
				if(anim != anWall && anim != anFallW) {
					if(getcon("right", "press")) flip = 0
					if(getcon("left", "press")) flip = 1
				}
			}

			//Get on ladder
			if((getcon("down", "hold") || getcon("up", "hold")) && anim != anHurt && anim != anClimb && (vspeed >= 0 || getcon("down", "press") || getcon("up", "press"))) {
				if(atLadder()) {
					anim = anClimb
					frame = 0.0
					hspeed = 0
					vspeed = 0
					x = (x - (x % 16)) + 8
				}
			}

			//Climbing
			if(anim != anClimb && anim != anWall && anim != anFallW) {
				if((getcon("right", "hold") && !getcon("left", "hold") && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold") && !getcon("right", "hold") && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!placeFree(x, y + 2) || anim == anClimb) {
				canJump = 16
				if(game.weapon == 3 && energy < game.maxEnergy) energy += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(game.weapon == 3 && energy < 1) energy += 0.02
			}

			//Max speed
			if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed) mspeed = 1.0
			else if(getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) {
				if(game.weapon == 2) mspeed = 3.5
				else mspeed = 3.0
				if(invincible) mspeed += 0.4
			}
			else mspeed = 2.0
			if(nowInWater) mspeed *= 0.8
			if(anim == anCrawl) mspeed = 1.0

			//Change run animation speed
			if(getcon("right", "hold") && rspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(placeFree(x + 1, y) || placeFree(x + 1, y - 2)) {
				rspeed += 0.2
				if(rspeed < hspeed) rspeed = hspeed
			}
			if(getcon("left", "hold") && rspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(placeFree(x - 1, y) || placeFree(x - 1, y - 2)) {
				rspeed -= 0.2
				if(rspeed > hspeed) rspeed = hspeed
			}
			if(rspeed > 0) rspeed -= 0.1
			if(rspeed < 0) rspeed += 0.1
			if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold") && !getcon("left", "hold")) rspeed = 0.0
			if(anim == anSlide) rspeed = hspeed

			//Moving left and right
			if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
				if(onIce()) hspeed += 0.1
				else hspeed += 0.2
			}
			if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
				if(onIce()) hspeed -= 0.1
				else hspeed -= 0.2
			}

			//Going into slide
			if(((!placeFree(x, y + 2) && (getcon("down", "hold") || autocon.down)) || (getcon("shoot", "hold") && game.weapon == 4) || autocon.down) && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall && anim != anCrawl) {
				if(placeFree(x + 2, y + 1) || hspeed >= 1.5) {
					anim = anDive
					frame = 0.0
					flip = 0
					stopSound(sndSlide)
					playSound(sndSlide, 0)
				}
				else if(placeFree(x - 2, y + 1) || hspeed <= -1.5) {
					anim = anDive
					frame = 0.0
					flip = 1
					stopSound(sndSlide)
					playSound(sndSlide, 0)
				}
				else {
					anim = anDive
					frame = 0.0
				}
			}

			if(anim == anCrawl) {
				if((!getcon("down", "hold") && !autocon.down) && placeFree(x, y - 6)) anim = anStand
				else {
					//Ping pong animation
					frame += fabs(hspeed) / 8.0
					frame = wrap(fabs(frame), 0, anim.len() - 1)
					shape = shapeCrouch
				}

				if(placeFree(x + 2, y + 1) || placeFree(x - 2, y + 1)) anim = anSlide
			}

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
						if(anim == anCrawl) c.y += 8
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
						if(anim == anCrawl) c.y += 8
					}
					break

				case 3:
					if(getcon("shoot", "press") && (anim == anJumpT || anim == anJumpU || anim == anFall) && anim != anHurt) {
						anim = anDive
						frame = 0.0
						playSound(sndSlide, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break

				case 4:
					if(getcon("shoot", "press") && (anim != anHurt)) {
						anim = anDive
						frame = 0.0
						playSound(sndSlide, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break
			}
		}

		//Swap item
		if(canMove && getcon("swap", "press")) swapitem()

		//Recharge
		if(firetime > 0 && game.weapon != 3 && (game.weapon != 4 || anim != anSlide)) {
			firetime--
		}

		if(firetime == 0 && energy < game.maxEnergy) {
			energy++
			firetime = 60
		}

		if(game.weapon == 0) game.maxEnergy = 0
		if(game.weapon == 3) game.maxEnergy = 4 + game.airBonus
		if(energy > game.maxEnergy) energy = game.maxEnergy
	}

	function ruEnd() {
		hspeed += 0.2
		if(placeFree(x + 2, y)) rspeed = hspeed
		else rspeed = 0
	}

	function ruLocked() {}

	function die() {
		if(game.canres) {
			game.health = game.maxHealth
			blinking = 120
			if(y > gvMap.h) playerTeleport(groundx, groundy)
			game.canres = false
			hspeed = 0.0
			vspeed = 0.0
		}
		else {
			deleteActor(id)
			gvPlayer = false
			newActor(TuxDie, x, y)
			game.health = 0
		}
	}

	function _typeof(){ return "Tux" }
}

::TuxDie <- class extends Actor {
	vspeed = -4.0
	timer = 150

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		stopMusic()
		playSound(sndDie, 0)
	}

	function run() {
		vspeed += 0.1
		y += vspeed
		timer--
		if(timer == 0) {
			startPlay(gvMap.file)
			if(game.check == false) {
				gvIGT = 0
				game.weapon = 0
			}
		}
		switch(game.weapon) {
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

	function _typeof() { return "DeadPlayer" }
}