/*=========*\
| TUX ACTOR |
\*=========*/

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
	slippery = false
	accel = 0.2

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
	anDie = [50, 51]

	mySprNormal = null
	mySprFire = null
	mySprIce = null
	mySprAir = null
	mySprEarth = null

	nowInWater = false

	//Elemental resistances
	damageMultN = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
	}
	damageMultF = {
		normal = 1.0
		fire = 0.5
		ice = 2.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
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
		cut = 1.0
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
		cut = 1.0
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
		cut = 0.5
		blast = 1.0
	}

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anStand = anStandN
		anim = anStand
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(!gvPlayer) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
		energy = stats.maxEnergy
		anFall = anFallN
		xprev = x
		yprev = y

		mySprNormal = sprTux
		mySprFire = sprTuxFire
		mySprIce = sprTuxIce
		mySprAir = sprTuxAir
		mySprEarth = sprTuxEarth
	}

	function physics() {}
	function animation() {}
	function routine() {}

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
		if(firetime > 0 && stats.weapon != "air" && (stats.weapon != "earth" || anim != anSlide)) {
			firetime--
		}

		if(firetime == 0 && energy < stats.maxEnergy) {
			energy++
			firetime = 60
		}


		if(stats.weapon == "normal") stats.maxEnergy = 0
		if(stats.weapon == "air") stats.maxEnergy = 4 + game.airBonus
		if(energy > stats.maxEnergy) energy = stats.maxEnergy

		/////////////
		// ON LAND //
		/////////////
		if((!inWater(x, y) || stats.weapon == "earth") && resTime <= 0) {
			swimming = false
			shapeStand.h = 12.0
			slippery = (anim == anDive || anim == anSlide || onIce())

			//Animation states
			switch(anim) {
				case anStand:
					if(stats.weapon == "ice" && floor(frame) == 0) frame += 0.01
					else if(stats.weapon == "ice" || stats.weapon == "fire") frame += 0.1
					else if(stats.weapon == "air") frame += 0.05
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
					else if(stats.weapon == "ice") frame += abs(rspeed) / 16
					else frame += abs(rspeed) / 8
					if(abs(rspeed) < 2 && anim != anSkid) anim = anWalk

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}

					break

				case anPush:
					break

				case anJumpU:
					if(frame < 1) frame += 0.1

					if(!placeFree(x, y + 1) || (onPlatform() && vspeed >= 0)) {
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

					if(floor(frame) > 1) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = 0.0
					}

					if(!freeLeft) flip = 0
					if(!freeRight) flip = 1
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > 1) {
						if(fabs(hspeed) <= 0.5 && stats.weapon != "earth") anim = anCrawl
						else anim = anSlide
						shape = shapeSlide
					}
					break

				case anSlide:
					if(stats.weapon == "earth") slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 24.0)
					frame = slideframe

					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
						if(stats.weapon == "fire") newActor(FlameTiny, x - (8 * (hspeed / fabs(hspeed))), y + 10)
						if(stats.weapon == "ice") newActor(Glimmer, x - (12 * (hspeed / fabs(hspeed))), y + 10)
					}
					break

				case anHurt:
					frame += 0.1
					if(floor(frame) > 1) {
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
					if(getcon("jump", "hold", true, playerNum) && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = 0.0
					break
			}

			if(anim == anStand && zoomies) frame += 0.1
			if(anim != null) frame = wrap(frame, 0, anim.len() - 1)

			//Sliding acceleration
			if(slippery) {
				if(!placeFree(x, y + 4) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && (stats.weapon == "ice" || (stats.weapon == "earth" && anim == anSlide))))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.25
					if(placeFree(x - 4, y + 2)) hspeed -= 0.25
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				if((!getcon("down", "hold", true, playerNum)  && stats.weapon != "air" && stats.weapon != "earth" && !getcon("shoot", "hold", true, playerNum))
				|| (fabs(hspeed) < 0.05 && !placeFree(x, y + 2) && stats.weapon != "earth")
				|| (fabs(hspeed) < 0.05 && (stats.weapon != "air" || stats.weapon == "earth") && !getcon("shoot", "hold", true, playerNum))
				|| ((stats.weapon == "earth" || stats.weapon == "air") && !getcon("shoot", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum))) {
					if(anim == anSlide || anim == anCrawl) {
						if(getcon("down", "hold", true, playerNum) || !placeFree(x, y - 8)) anim = anCrawl
						else anim = anWalk
					}
				}

				if(getcon("jump", "press", true, playerNum) || getcon("up", "press", true, playerNum)) if(!getcon("shoot", "hold", true, playerNum)) if(placeFree(x, y + 2) && placeFree(x, y - 2)) anim = anFall
			}

			if(anim != anClimb && anim != anWall) {
				if((getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum) && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!freeDown2 || anim == anClimb || onPlatform()) {
				canJump = 16
				if(stats.weapon == "air" && energy < stats.maxEnergy) energy += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(stats.weapon == "air" && energy < 1) energy += 0.02
			}
			if(canMove) {
				if(getcon("sneak", "hold", true, playerNum) || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed) mspeed = 1.0
				else if(getcon("run", "hold", true, playerNum) || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) {
					if(stats.weapon == "ice") mspeed = 3.5
					else mspeed = 3.0
					if(invincible) mspeed += 0.4
				}
				else mspeed = 2.0
				if(nowInWater) mspeed *= 0.8
				if(anim == anCrawl) mspeed = 1.0
				if(zoomies > 0) mspeed *= 2.0

				//Moving left and right
				if(zoomies > 0) accel = 0.4
				else accel = 0.2
				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed += accel / 2.0
					else hspeed += accel
				}
				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(onIce()) hspeed -= accel / 2.0
					else hspeed -= accel
				}

				//Change run animation speed
				if(getcon("right", "hold", true, playerNum) && rspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeRight || placeFree(x + 1, y - 2)) {
					rspeed += accel
					if(rspeed < hspeed) rspeed = hspeed
				}
				if(getcon("left", "hold", true, playerNum) && rspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeLeft || placeFree(x - 1, y - 2)) {
					rspeed -= accel
					if(rspeed > hspeed) rspeed = hspeed
				}
				if(rspeed > 0) rspeed -= 0.1
				if(rspeed < 0) rspeed += 0.1
				if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum)) rspeed = 0.0
				if(anim == anSlide) rspeed = hspeed

				//On a ladder
				if(anim == anClimb) {
					vspeed = 0

					//Ladder controls
					if(getcon("up", "hold", true, playerNum)) if(placeFree(x, y - 2)) {
						frame -= climbdir / 8
						y -= 2
					}

					if(getcon("down", "hold", true, playerNum)) if(placeFree(x, y + 2)) {
						frame += climbdir / 8
						y += 2
					}

					//Check if still on ladder
					local felloff = true
					if(atLadder()) felloff = false
					if(felloff) {
						anim = anFall
						frame = 0.0
						if(getcon("up", "hold", true, playerNum)) vspeed = -2.5
					}

					//Change direction
					if(getcon("right", "press", true, playerNum) && canMove) flip = 0
					if(getcon("left", "press", true, playerNum) && canMove) flip = 1

					//Ping-pong animation
				}

				//Get on ladder
				if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != anHurt && anim != anClimb && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
					if(atLadder()) {
						anim = anClimb
						frame = 0.0
						hspeed = 0
						vspeed = 0
						x = (x - (x % 16)) + 8
					}
				}

				//Jumping
				if(getcon("jump", "press", true, playerNum) || jumpBuffer > 0) {
					if(onPlatform() && !placeFree(x, y + 1) && getcon("down", "hold", true, playerNum)) {
						y++
						canJump = 32
						if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
					}
					else if(canJump > 0 && placeFree(x, y - 2)) {
						jumpBuffer = 0
						if(anim == anClimb) vspeed = -3
						else if(stats.weapon == "air" || nowInWater) vspeed = -5.0
						else vspeed = -5.8
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != anHurt && anim != anDive && (stats.weapon != "earth" || anim != anSlide)) {
							anim = anJumpU
							frame = 0.0
						}
						if(stats.weapon != "air") {
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
					else if(floor(energy) > 0 && stats.weapon == "air" && getcon("jump", "press", true, playerNum)) {
						if(vspeed > 0) vspeed = 0.0
						if(vspeed > -4) vspeed -= 3.0
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != anHurt && anim != anDive) {
							anim = anJumpU
							frame = 0.0
						}
						if(stats.weapon != "air") {
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
				if((anim == anFallN || anim == anFallW) && ((getcon("left", "hold", true, playerNum) && !freeLeft) || (getcon("right", "hold", true, playerNum) && !freeRight))) {
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

				if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release", true, playerNum) && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2.5
				}

				//Going into slide
				if((((!freeDown2 || onPlatform()) && getcon("down", "hold", true, playerNum)) || (getcon("shoot", "hold", true, playerNum) && stats.weapon == "earth")) && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall && anim != anCrawl) {
					if(placeFree(x + 2, y + 1) && !onPlatform() || hspeed >= 1.5) {
						anim = anDive
						frame = 0.0
						flip = 0
						popSound(sndSlide, 0)
					}
					else if(placeFree(x - 2, y + 1) && !onPlatform() || hspeed <= -1.5) {
						anim = anDive
						frame = 0.0
						flip = 1
						popSound(sndSlide, 0)
					}
					else {
						anim = anDive
						frame = 0.0
					}
				}

				if(anim == anCrawl) {
					if((!getcon("down", "hold", true, playerNum)) && placeFree(x, y - 6)) anim = anStand
					else {
						//Ping pong animation
						frame += (hspeed / 8.0)
						shape = shapeSlide
					}

					if((placeFree(x + 2, y + 1) || placeFree(x - 2, y + 1)) && !onPlatform()) anim = anSlide
				}
			}
			else rspeed = min(rspeed, abs(hspeed))

			//Movement
			if(!freeDown2 || onPlatform()) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!(mspeed > 2 && getcon("right", "hold", true, playerNum)) || anim == anCrawl || !canMove) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!(mspeed > 2 && getcon("left", "hold", true, playerNum)) || anim == anCrawl || !canMove) hspeed += friction
					}
				}
			}
			else if(anim != anSlide && anim != anDive) {
				if(hspeed > 0 && !getcon("right", "hold", true, playerNum)) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold", true, playerNum)) hspeed += friction / 3.0
			}

			if(fabs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && (stats.weapon != "air" || getcon("down", "hold", true, playerNum)) && !nowInWater)) && antigrav <= 0) vspeed += gravity
			else if(antigrav > 0) antigrav--
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

			//Landing while sliding
			if(anim == anSlide && !placeFree(x, y + 1) && vspeed >= 1 && placeFree(x + hspeed, y) && !onPlatform()) {
				if(flip) hspeed -= vspeed / 2.5
				else hspeed += vspeed / 2.5
				vspeed = 0
			}
			if(anim == anDive && vspeed >= 1 && !placeFree(x, y + 1) && stats.weapon == "earth") {
				hspeed *= 1.5
				vspeed = 0.0
			}

			//Max ground speed
			local speedLimit = 6.0
			if(!placeFree(x, y + 1)){
				if(stats.weapon == "ice") {
					if(anim == anSlide) speedLimit = 8.0
					else speedLimit = 8.0
				}
				else if(stats.weapon == "earth" && anim == anSlide) speedLimit = 8.0
				else {
					if(slippery) speedLimit = 7.0
				}
				if(hspeed > speedLimit) hspeed = max(speedLimit, hspeed * 0.9)
				if(hspeed < -speedLimit) hspeed = -max(speedLimit, hspeed * 0.9)
			}

			//Gravity cases
			if(stats.weapon == "air" || nowInWater) gravity = 0.12
			else gravity = 0.25
			if(anim == anClimb || anim == anWall) gravity = 0

			//Attacks
			if(canMove) switch(stats.weapon) {
				case "fire":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Fireball, x + fx, y, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						if(getcon("down", "hold", true, playerNum)) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
						if(anim == anCrawl) c.y += 8
					}
					break

				case "ice":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Iceball, x + fx, y, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						if(getcon("down", "hold", true, playerNum)) {
							c.vspeed = 2
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
						if(anim == anCrawl) c.y += 8
					}
					break

				case "air":
					if(getcon("shoot", "press", true, playerNum) && (anim == anJumpT || anim == anJumpU || anim == anFall) && anim != anHurt) {
						anim = anDive
						frame = 0.0
						playSound(sndSlide, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break

				case "earth":
					if(getcon("shoot", "press", true, playerNum) && (anim != anHurt)) {
						anim = anDive
						frame = 0.0
						playSound(sndSlide, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break
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
			if(stats.weapon == "air" && energy < 4) energy += 0.1
			shapeStand.h = 6.0
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

			frame = wrap(abs(frame), 0, anim.len() - 1)

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
				if(getcon("sneak", "hold", true, playerNum) || (abs(joyX(0)) <= js_max * 0.4 && abs(joyX(0)) > js_max * 0.1) || (abs(joyY(0)) <= js_max * 0.4 && abs(joyY(0)) > js_max * 0.1) && config.stickspeed) mspeed = 0.5
				else if(getcon("run", "hold", true, playerNum) || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) {
					if(stats.weapon == "ice") mspeed = 3.0
					else mspeed = 2.8
					if(invincible) mspeed += 0.4
				}
				else mspeed = 1.0
				if(zoomies > 0) mspeed *= 2.0

				if(zoomies > 0) accel = 0.2
				else accel = 0.1
				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += accel
				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= accel
				if(getcon("down", "hold", true, playerNum) && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += accel
				if(getcon("up", "hold", true, playerNum) && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= accel
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
			if(canMove) switch(stats.weapon) {
				case "fire":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local c = fireWeapon(Fireball, x, y, 1, id)
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold", true, playerNum)) {
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

				case "ice":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local c = fireWeapon(Iceball, x, y, 1, id)
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold", true, playerNum)) {
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
		if(canMove && getcon("swap", "press", true, playerNum)) swapitem()

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
				for(local i = 0; i < 8; i++) if(!placeFree(x, y + max(4, abs(hspeed))) && placeFree(x + hspeed, y + 1) && !swimming && vspeed >= 0 && !placeFree(x + hspeed, y + max(4, abs(hspeed)))) {
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
						if(slippery && !swimming && !placeFree(xprev, yprev + 2)) vspeed -= 2.0
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
		if(onDeath(x, y)) stats.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.weapon == "earth" && anim == anSlide && energy > 0) {
					energy--
					firetime = 120
					newActor(Spark, x, y)
				}
				else {
					if(stats.health > 0) stats.health -= hurt
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
		if(stats.health == 0) {
			die()
			return
		}

		//Draw
		if(!hidden) {
			switch(stats.weapon) {
				case "normal":
					sprite = mySprNormal
					if(anim == anStand && anStand != anStandN) anim = anStandN
					anStand = anStandN
					damageMult = damageMultN
					break

				case "fire":
					sprite = mySprFire
					if(anim == anStand && anStand != anStandF) anim = anStandF
					anStand = anStandF
					damageMult = damageMultF
					break

				case "ice":
					sprite = mySprIce
					if(anim == anStand && anStand != anStandI) anim = anStandI
					anStand = anStandI
					damageMult = damageMultI
					break

				case "air":
					sprite = mySprAir
					if(anim == anStand && anStand != anStandA) anim = anStandA
					anStand = anStandA
					damageMult = damageMultA
					break

				case "earth":
					sprite = mySprEarth
					if(anim == anStand && anStand != anStandE) anim = anStandE
					anStand = anStandE
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
			if(zoomies > 0 && getFrames() % 2 == 0) newActor(AfterImage, x, y, [sprite, anim[frame], 0, flip, 0, 1, 1])
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
		if(stats.canres) {
			stats.health = game.maxHealth
			blinking = 120
			hspeed = 0.0
			vspeed = 0.0
			if(y > gvMap.h) {
				invincible = 300
				resTime = 300
				vspeed = -4.0
			}
			stats.canres = false
		}
		else {
			deleteActor(id)
			if(playerNum == 1) gvPlayer = false
			if(playerNum == 2) gvPlayer2 = false
			newActor(PlayerDie, x, y, [sprite, anDie, playerNum])
			stats.health = 0
		}
	}

	function _typeof(){ return "Tux" }
}

::TuxDie <- class extends Actor {
	vspeed = -4.0
	timer = 150
	sprite = null
	playerNum = 0

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
				stats.weapon = "normal"
			}
		}
		drawSprite(sprite, wrap(getFrames() / 15, 50, 51), floor(x - camx), floor(y - camy))
	}

	function _typeof() { return "DeadPlayer" }
}

::Penny <- class extends Tux {
	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)

		mySprNormal = sprPenny
		mySprFire = sprPennyFire
		mySprIce = sprPennyIce
		mySprAir = sprPennyAir
		mySprEarth = sprPennyEarth
	}

	function _typeof() { return "Penny" }
}

/*
::TuxRacer <- class extends PhysActor {
	z = 0
	mspeed = 2

	anWalk = [8, 9, 10, 11, 12, 13, 14, 15]
	anSlide = [80, 81, 82]
	anHurt = [83]
	anim = null
	gravity = 0.0

	constructor(_x, _y, _arr = null){
		anim = anWalk
	}

	function run() {
		//Acceleration
		if(onIce(x, y)) mspeed = 4.0
		else if(!placeFree(x, y)) mspeed = 1.0
		else mspeed = 2.0

		if(vspeed > -mspeed) vspeed -= 0.05
		if(vspeed < -mspeed) vspeed += 0.1
		if(vspeed < 1 && getcon("down", "hold", true, playerNum)) vspeed += 0.05
		if(hspeed > -1 && getcon("left", "hold", true, playerNum)) hspeed -= 0.05
		if(hspeed < 1 && getcon("right", "hold", true, playerNum)) hspeed += 0.05

		//Animation
		local angle = 0
		local frame = 0

		switch(anim) {
			case anWalk:
				angle = 0
				frame = wrap(getFrames() / 16, 0, 8)
				break
			case anSlide:
				angle = pointAngle(0, 0, hspeed, vspeed)
				frame = 1 - getcon("left", "hold", true, playerNum).tointeger() + getcon("right", "hold", true, playerNum)
				break
			case anHurt:
				angle = pointAngle(0, 0, hspeed, vspeed) + 180
				frame = 0
				break
		}

		//Draw
		drawSpriteEx(sprTux, anim[frame])
	}

	function _typeof() { return "TuxRacer" }
}
*/