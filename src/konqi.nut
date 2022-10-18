/*===========*\
| KONQI ACTOR |
\*===========*/

::Konqi <- class extends Player {
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
	hurt = 0
	swimming = false
	endMode = false
	canStomp = true //If they can use jumping as an attack
	sprite = sprKonqi
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
	cooldown = 0
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0
	held = null
	accel = 0.2

	//Animations
	anim = [] //Animation frame delimiters: [start, end, speed]
	anStand = [0, 1, 2, 3]
	anWalk = [16, 17, 18, 19, 20, 21, 22, 23]
	anRun = [24, 25, 26, 27, 28, 29, 30, 31]
	anDive = [14, 15]
	anCrouch = [14, 15]
	anGetUp = [15, 14]
	anCrawl = [40, 41, 42, 43, 42, 41]
	anSlide = []
	anHurt = [6, 7]
	anJumpU = [32, 33]
	anJumpT = [34, 35]
	anFall = null
	anFallN = [36, 37]
	anClimb = [44, 45, 46, 47, 46, 45]
	anWall = [4, 5]
	anFallW = [4]
	anSwimF = [48, 49, 50, 51]
	anSwimUF = [48, 49, 50, 51]
	anSwimDF = [48, 49, 50, 51]
	anSwimU = [48, 49, 50, 51]
	anSwimD = [48, 49, 50, 51]
	anSkid = [4, 5]
	anPush = [6, 7]
	anStomp = [38, 39]
	anStatue = [52, 53, 54, 55]

	mySprNormal = null
	mySprFire = null
	mySprIce = null
	mySprAir = null
	mySprEarth = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anim = anStand
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(!gvPlayer) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
		energy = game.maxEnergy
		anFall = anFallN
		xprev = x
		yprev = y

		mySprNormal = sprKonqi
		mySprFire = sprKonqiFire
		mySprIce = sprKonqiIce
		mySprAir = sprKonqiAir
		mySprEarth = sprKonqiEarth
	}

	function physics() {}
	function routine() {}
	function animation() {}

	//Elemental resistances
	damageMultN = {
		normal = 1.0
		fire = 0.5
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
		blast = 1.0
	}
	damageMultF = {
		normal = 1.0
		fire = 0.0
		ice = 2.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
		blast = 1.0
	}
	damageMultI = {
		normal = 1.0
		fire = 2.0
		ice = 0.5
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
		blast = 1.0
	}
	damageMultA = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 2.0
		air = 0.5
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
		blast = 0.5
	}
	damageMultE = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 0.50
		air = 2.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.25
		blast = 1.0
	}

	function run() {
		base.run()

		//Side checks
		shapeSlide.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) {
			shape = shapeSlide
			if(anim == anStand || anim == anWalk || anim == anRun) anim = anCrawl
		}
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
		if(firetime > 0 && game.weapon != 3 && (game.weapon != 4 || anim != anStatue)) {
			firetime--
		}

		if(firetime == 0 && energy < game.maxEnergy) {
			energy++
			firetime = 60
		}


		if(game.weapon == 0) game.maxEnergy = 0
		if(game.weapon == 3) game.maxEnergy = 4 + game.airBonus
		if(energy > game.maxEnergy) energy = game.maxEnergy

		/////////////
		// ON LAND //
		/////////////
		if((!inWater(x, y) || game.weapon == 4) && resTime <= 0) {
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
						frame = 0.0
					}

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}
					break

				case anWalk:
					frame += abs(rspeed) / 8
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = anStand
					if(abs(rspeed) > 2.4) anim = anRun

					if(placeFree(x, y + 2) && !onPlatform()) {
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

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}

					break

				case anStomp:
					if(frame <= anim.len() - 1) frame += 0.2

				case anPush:
					break

				case anJumpU:
					if(frame < 0.0 + 1) frame += 0.1

					if(!freeDown || (onPlatform() && vspeed >= 0)) {
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
					if(!freeDown || (onPlatform() && vspeed >= 0)) {
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
					if(!freeDown || (onPlatform() && vspeed >= 0)) {
						anim = anStand
						frame = 0.0
					}
					break

				case anWall:
					frame += 0.3
					vspeed = 0

					if(floor(frame) > anim.len() - 1) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = 0.0
					}
					break

				case anCrouch:
					frame += 0.25

					if(floor(frame) > anim.len() - 1) {
						anim = anCrawl
						shape = shapeSlide
					}
					break

				case anGetUp:
					frame -= 0.25

					if(floor(frame) < 0) {
						anim = anStand
						shape = shapeStand
					}
					break

				case anSlide:
					if(game.weapon == 4) slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 16.0)
					frame = slideframe

					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
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
					anim = anJumpU
					frame = 0.0
					vspeed -= 1
					if(getcon("jump", "hold") && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = 0.0
					break

				case anStatue:
					if(frame < 3) frame += 0.25
					if(frame > 3) frame = 3.0
					break
			}

			if(anim == anStand && zoomies) frame += 0.1
			if(anim != anClimb) frame = wrap(abs(frame), 0.0, anim.len() - 1)

			//Sliding acceleration
			if(onIce()) {
				if(!placeFree(x, y + 4) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && game.weapon == 2))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.25
					if(placeFree(x - 4, y + 2)) hspeed -= 0.25
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				if(((!getcon("down", "hold") || fabs(hspeed) < 0.05) && !freeDown && game.weapon != 4) || (fabs(hspeed) < 0.05 && (game.weapon == 4 && !getcon("shoot", "hold"))) || (game.weapon == 4 && !getcon("shoot", "hold") && !getcon("down", "hold"))) if(anim == anSlide || anim == anDive) anim = anWalk
			}

			if(anim != anClimb && anim != anWall) {
				if((getcon("right", "hold") && !getcon("left", "hold") && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold") && !getcon("right", "hold") && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!freeDown2 || onPlatform() || anim == anClimb) {
				canJump = 16
				if(game.weapon == 3 && energy < game.maxEnergy) energy += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(game.weapon == 3 && energy < 1) energy += 0.02
			}
			if(canMove) {
				if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed || anim == anCrawl) mspeed = 1.0
				else if((getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) && anim != anCrawl) {
					if(game.weapon == 2) mspeed = 3.5
					else mspeed = 3.0
				}
				else mspeed = 2.0
				if(nowInWater) mspeed *= 0.8
				if(anim == anStomp || anim == anStatue) mspeed = 0.5
				if(anim == anStatue && !placeFree(x, y + 1)) mspeed = 0.0
				if(zoomies > 0) mspeed *= 2.0

				//Moving left and right
				if(zoomies > 0) accel = 0.4
				else accel = 0.2
				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed += accel / 2.0
					else hspeed += accel
				}
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed -= accel / 2.0
					else hspeed -= accel
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
						frame = 0.0
						if(getcon("up", "hold")) vspeed = -2.5
					}

					//Change direction
					if(getcon("right", "press") && canMove) flip = 0
					if(getcon("left", "press") && canMove) flip = 1

					//Ping-pong animation
				}

				//Get on ladder
				if(((getcon("down", "hold") && placeFree(x, y + 2)) || getcon("up", "hold")) && anim != anHurt && anim != anClimb && (vspeed >= 0 || getcon("down", "press") || getcon("up", "press"))) {
					if(atLadder()) {
						anim = anClimb
						frame = 0.0
						hspeed = 0
						vspeed = 0
						x = (x - (x % 16)) + 8
					}
				}

				//Jumping
				if(getcon("jump", "press") || jumpBuffer > 0) {
					if(onPlatform() && !placeFree(x, y + 1) && getcon("down", "hold")) {
						y++
						canJump = 32
						if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
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
					}
					else if(freeDown && anim != anClimb && !placeFree(x - 2, y) && anim != anWall && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40) {
						flip = 0
						anim = anWall
						frame = 0.0
						playSound(sndWallkick, 0)
					}
					else if(freeDown && anim != anClimb && !placeFree(x + 2, y) && anim != anWall && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40) {
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
				if((anim == anFallN || anim == anFallW) && ((getcon("left", "hold") && !freeLeft) || (getcon("right", "hold") && !freeRight))) {
					if(!freeLeft && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
						anFall = anFallW
						anim = anFallW
						flip = 0
					}
					if(!freeRight && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
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

				if(getcon("jump", "press") && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release") && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2.5
				}

				//Crawling
				if(getcon("down", "hold") && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall && anim != anStatue && (!freeDown2 || onPlatform()) && anim != anCrouch && anim != anCrawl && anim != anStomp) {
					anim = anCrouch
					frame = 0.0
					shape = shapeSlide
				}

				if(anim == anCrawl) {
					if(!getcon("down", "hold") && placeFree(x, y - 6)) anim = anStand
					else {
						//Ping pong animation
						frame += (hspeed / 8.0)
						shape = shapeSlide
					}
				}


			} else {
				if(hspeed < 1 && endMode) hspeed += 0.2
				if(endMode && placeFree(x + 2, y)) rspeed = hspeed
				else rspeed = 0
			}

			//Movement
			if(!freeDown2 || onPlatform()) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!(mspeed > 2 && getcon("right", "hold")) || anim == anCrawl || !canMove) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!(mspeed > 2 && getcon("left", "hold")) || anim == anCrawl || !canMove) hspeed += friction
					}
				}
			}
			else if(anim != anSlide) {
				if(hspeed > 0 && !getcon("right", "hold")) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold")) hspeed += friction / 3.0
			}

			if(fabs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && (game.weapon != 3 || getcon("down", "hold")) && !nowInWater) || (anim == anStomp && vspeed < 8)) && antigrav <= 0) vspeed += gravity
			else if(antigrav > 0) antigrav--
			if(!freeUp && vspeed < 0) vspeed = 0.0 //If Konqi bumped his head

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
				//If Konqi hits the ground while sliding
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
			if(canMove && (anim == anJumpT || anim == anJumpU || anim == anFall) && getcon("down", "press") && placeFree(x, y + 8)) {
				hspeed = 0.0
				vspeed = 4.0
				if(game.weapon == 4) {
					anim = anStatue
					popSound(sndSlide, 0)
				}
				else anim = anStomp
				frame = 0.0
			}
			if((!freeDown || vspeed < 0 || onPlatform()) && anim == anStomp) {
				anim = anJumpU
				vspeed = -2.0
				popSound(sndBump)
				fireWeapon(StompPoof, x + 8, y + 12, 1, id)
				fireWeapon(StompPoof, x - 8, y + 12, 1, id)
			}

			if((!freeDown || onPlatform()) && anim == anStatue && vspeed > 0.5) {
				vspeed = 0.0
				popSound(sndBump)
				fireWeapon(StompPoof, x + 8, y + 12, 1, id)
				fireWeapon(StompPoof, x - 8, y + 12, 1, id)
			}

			if(canMove) switch(game.weapon) {
				case 0:
					if(cooldown > 0) break
					if(getcon("shoot", "press")) {
						cooldown = 60
						playSoundChannel(sndFlame, 0, 0)
					}
					break
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(FireballK, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						c.vspeed = -0.5
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
					}
					break

				case 2:
					if(cooldown > 0) break
					if(getcon("shoot", "press")) {
						cooldown = 60
						playSoundChannel(sndFlame, 0, 0)
					}
					break

				case 3:
					if(cooldown > 0) break
					if(getcon("shoot", "press")) {
						cooldown = 60
						playSoundChannel(sndFlame, 0, 0)
					}
					break

				case 4:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(EarthballK, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						c.vspeed = -0.5
						playSound(sndFireball, 0)
						if(getcon("up", "hold")) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
					}
					if(getcon("shoot", "press") && (anim != anHurt) && getcon("down", "hold")) {
						anim = anStatue
						frame = 0.0
						hspeed = 0.0
						vspeed = 4.0
						playSoundChannel(sndSlide, 0, 0)
					}
					if((!getcon("shoot", "hold") && !getcon("down", "hold") || energy == 0) && anim == anStatue) {
						anim = anStand
						newActor(Poof, x, y - 8)
						newActor(Poof, x, y + 8)
					}
					break
			}

			if(cooldown > 0) cooldown--

			if(cooldown >= 50 && cooldown % 2 == 0) {
				local c = 0
				if(game.weapon != 2) c = fireWeapon(FlameBreath, x, y - 6, 1, id)
				else c = fireWeapon(IceBreath, x, y - 6, 1, id)
				if(flip == 0) {
					c.hspeed = 1.0 + randFloat(0.5)
					c.x += 8
					if(game.weapon == 2) c.hspeed += 1.8
				}
				else {
					c.hspeed = -1.5 - randFloat(0.5)
					c.x -= 8
					if(game.weapon == 2) c.hspeed -= 1.8
				}
				if(vspeed > 0) c.vspeed = (-cooldown.tofloat() + 53.0) / 8.0
				else c.vspeed = (cooldown.tofloat() - 53.0) / 8.0
				if(anim == anCrawl) c.y += 8
			}

			//Check solid ground position
			if(!placeFree(x, y + 1) && !onPlatform()) {
				groundx = x
				groundy = y
			}
		}
		//////////////
		// IN WATER //
		//////////////
		else {
			swimming = true
			if(game.weapon == 3 && energy < 4) energy += 0.1
			if(!wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			anFall = anFallN
			if(anim == anFallW) anim = anFallN

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

			frame = wrap(abs(frame), 0.0, anim.len() - 1)

			//Swich swim directions
			if(anim != anHurt) {
				if(fabs(hspeed) < 0.3 && fabs(vspeed) < 0.2) anim = anFall //To be replaced with regular swim sprites later
				if(fabs(hspeed) > 0.3) anim = anSwimF
				if(vspeed > 0.2) anim = anSwimD
				if(vspeed < -0.2) anim = anSwimU
				if(fabs(hspeed) > 0.3 && vspeed > 0.2) anim = anSwimDF
				if(fabs(hspeed) > 0.3 && vspeed < -0.2) anim = anSwimUF
			}

			//Movement
			if(canMove) {
				if(getcon("sneak", "hold") || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed) mspeed = 0.5
				else if(getcon("run", "hold") || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) {
					if(game.weapon == 2) mspeed = 2.2
					else mspeed = 2.0
				}
				else mspeed = 1.0
				if(zoomies > 0) mspeed *= 2.0

				if(zoomies > 0) accel = 0.2
				else accel = 0.1
				if(getcon("right", "hold") && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += accel
				if(getcon("left", "hold") && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= accel
				if(getcon("down", "hold") && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += accel
				if(getcon("up", "hold") && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= accel
			}

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

			//Attacks
			if(canMove) switch(game.weapon) {
				case 1:
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Fireball, x + fx, y - 4, 1, id)
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
					if(getcon("shoot", "press") && anim != anSlide && anim != anHurt && energy > 0 && !(!placeFree(x, y + 1) && getcon("down", "hold"))) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Iceball, x + fx, y, 1, id)
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
		xprev = x
		yprev = y

		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
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
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		if(!gvCanWrap) {
			if(x < 4) x = 4
			if(x > gvMap.w - 4) x = gvMap.w - 4
		} else x = wrap(x, 0, gvMap.w)

		if(anim == anSlide || anim == anCrawl) shape = shapeSlide
		else shape = shapeStand
		shapeStand.setPos(x, y)
		shapeSlide.setPos(x, y)
		if(y > gvMap.h + 16) {
			die()
			return
		}
		if(y < -100) y = -100.0

		switch(escapeMoPlat(1, 1)) {
			case 1:
				if(vspeed < 0) vspeed = 0
				break
			case 2:
				if(hspeed < 0) hspeed = 0
				break
			case -1:
				if(vspeed > 0) vspeed = 0
				break
			case -2:
				if(hspeed > 0) hspeed = 0
				break
		}

		//Set ice friction
		if(onIce()) friction = 0.01
		else friction = 0.1

		//Hurt
		if(onHazard(x, y)) hurt = 1 + game.difficulty
		if(onDeath(x, y)) game.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(game.weapon == 4 && anim == anStatue && energy > 0 && frame >= 3) {
					energy--
					firetime = 180
					blinking = 120
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

		//Draw
		if(!hidden) {
			switch(game.weapon) {
				case 0:
					sprite = mySprNormal
					damageMult = damageMultN
					break

				case 1:
					sprite = mySprFire
					damageMult = damageMultF
					break

				case 2:
					sprite = mySprIce
					damageMult = damageMultI
					break

				case 3:
					sprite = mySprAir
					damageMult = damageMultA
					break

				case 4:
					sprite = mySprEarth
					damageMult = damageMultE
					break
			}

			//Invincibility
			if(invincible > 0) invincible--
			if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

			if(anim != null) {
				frame = wrap(frame, 0, anim.len() - 1)
				if(blinking == 0 || anim == anHurt) drawSpriteExZ(0, sprite, anim[floor(frame)], x - camx, y - camy, 0, flip, 1, 1, 1)
				else drawSpriteExZ(0, sprite, anim[floor(frame)], x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
			}
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}

			//After image
			if((zoomies > 0 || anim == anStomp || (anim == anStatue && vspeed > 4)) && getFrames() % 2 == 0) newActor(AfterImage, x, y, [sprite, anim[frame], 0, flip, 0, 1, 1])
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
		if(resTime > 0) return
		if(game.canres) {
			game.health = game.maxHealth
			blinking = 120
			hspeed = 0.0
			vspeed = 0.0
			if(y > gvMap.h) {
				invincible = 300
				resTime = 300
				vspeed = -4.0
			}
			game.canres = false
		}
		else {
			deleteActor(id)
			gvPlayer = false
			newActor(KonqiDie, x, y, sprite)
			game.health = 0
		}
	}

	function swapitem() {
		if(game.subitem == 0) return
		local swap = game.subitem

		if(game.weapon == game.subitem) {
			if(game.maxEnergy < 4 - game.difficulty) {
				game.maxEnergy++
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
				newActor(FlowerFire, x + hspeed, y + vspeed)
				break
			case 2:
				newActor(FlowerIce, x + hspeed, y + vspeed)
				break
			case 3:
				newActor(AirFeather, x + hspeed, y + vspeed)
				break
			case 4:
				newActor(EarthShell, x + hspeed, y + vspeed)
				break
			case 5:
				if(game.health < game.maxHealth) {
					newActor(MuffinBlue, x + hspeed, y + vspeed)
					game.subitem = 0
				}
				break
			case 6:
				if(game.health < game.maxHealth) {
					newActor(MuffinRed, x + hspeed, y + vspeed)
					game.subitem = 0
				}
				break
			case 7:
				newActor(Starnyan, x + hspeed, y + vspeed)
				break
			case 8:
				popSound(sndGulp, 0)
				zoomies = 60 * 30
				game.subitem = 0
				break
		}
	}

	function _typeof(){ return "Konqi" }
}

::KonqiDie <- class extends Actor {
	vspeed = -4.0
	timer = 150
	sprite = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		stopMusic()
		playSound(sndDie, 0)
		sprite = _arr
	}

	function run() {
		vspeed += 0.1
		y += vspeed
		timer--
		if(timer == 0) {
			startPlay(gvMap.file, true, true)
			if(game.check == false) {
				gvIGT = 0
				game.weapon = 0
			}
		}

		drawSprite(sprite, wrap(getFrames() / 15, 12, 13), floor(x - camx), floor(y - camy))
	}

	function _typeof() { return "DeadPlayer" }
}

::Katie <- class extends Konqi {
	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)

		mySprNormal = sprKatie
		mySprFire = sprKatieFire
		mySprIce = sprKatieIce
		mySprAir = sprKatieAir
		mySprEarth = sprKatieEarth
	}

	function _typeof() { return "Katie" }
}